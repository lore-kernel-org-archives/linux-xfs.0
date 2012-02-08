Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q18N72k6113566 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 17:07:02 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	X42EFuAjZdrFSBe9 for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 15:07:00 -0800 (PST)
Date: Thu, 9 Feb 2012 10:06:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V7
Message-ID: <20120208230658.GB7479@dastard>
References: <4F2FE66C.80303@oracle.com> <20120208050129.GE20305@dastard>
	<4F327434.10100@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F327434.10100@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Wed, Feb 08, 2012 at 09:10:12PM +0800, Jeff Liu wrote:
> Hi Dave,
> 
> Thanks for your review.
> On 02/08/2012 01:01 PM, Dave Chinner wrote:
> 
> > On Mon, Feb 06, 2012 at 10:40:44PM +0800, Jeff Liu wrote:
> >> Hello,
> >>
> >> There is one bug fix in this version, in xfs_seek_data()/xfs_seek_hole(), call xfs_bmapi_read() or
> >> xfs_bmap_first_unused() maybe failed, they should return ENXIO in this case.
> >> Thanks Mark for pointing this out!
> >>
> >>
> >> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > 
> > Can you post a final version with the real commit message attached?
> > 
> > The normal way of making comments like this about a patch posting is
> > to put the comments after the first "---" line, like the diffstat is
> > below....
> 
> > 
> > As it is,my comments are mainly about error handling and putting in
> > some comments to explain exactly why the code ended up this way....
> 
> Ok, the commit message will added in next post.
> 
> But I still have a concern about error handing as below.

.....
> >> +	for (;;) {
> >> +		struct xfs_bmbt_irec	map[2];
> >> +		int			nmap = 2;
> >> +		loff_t			seekoff;
> >> +
> >> +		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
> >> +				       XFS_BMAPI_ENTIRE);
> >> +		if (error) {
> >> +			error = ENXIO;
> >> +			goto out_unlock;
> >> +		}
> > 
> > I don't think that is correct. ENXIO means "offset beyond EOF", and
> > this will typically only return errors due to extent tree corruption
> > or filesystem shutdown. I'd just return the error as it stands.
> 
> Currently, both OCFS2 and Btrfs return ENXIO in case of their
> particular extent fetch routine failed.

That doesn't mean it is the best thing to do. The seek has not
succeeded and the current file position is now undefined. We did not
seek past the EOF - an extent lookup failure indicates we don't even
know where the EOF  or even the next hole or data area exists.

Hence the correct thing to do here is return a fatal error, not
something that the application can interpret as a successful
operation....

> So return other internal errors in XFS will introduce
> incompatibility IMHO.

Filesystems return different errors to the same syscall in lots of
places. Indeed, XFS will return EUCLEAN to just about any syscall
when the filesystem has been shut down to indicate a fatal error,
and that's not documented in a single syscall man page....

> But just as you pointed out, as well as ENXIO semantics defined at
> http://linux.die.net/man/2/lseek, return ENXIO is not proper to
> internal issue, and that might confuse user in such situation for
> return value check up.

Exactly, because it is valid for applications to be expecting ENXIO
when trying to find a specific data or hole location in a file (e.g.
is there any hole I can fill? EXNIO == no holes in the file)

> Maybe it's better to reach a consensus with other file systems with SEEK_DATA/SEEK_HOLE supports, I'd suggest
> either:
> 1) return the error as it stands in particular file system.
> or:
> 2) return EIO or another meaningful error number.
> look all those file systems need to fix up accordingly.

See above - filesystems are free to return errors according to the
problem that has occurred - it doesn't need to be defined in the man
page. XFS policy is to return EUCLEAN when a corruption is detected,
EIO when a read error has occurred, etc.  Other filesystems are free
to do treat these error conditions however they want, so I don't see
any particular need for standardisation here...

> >> +		/* No extents at given offset, must be beyond EOF */
> >> +		if (nmap == 0) {
> >> +			error = ENXIO;
> >> +			goto out_unlock;
> >> +		}
> > 
> > But we can't be beyond EOF - we've already checked that. Hence we
> > should *always* get a mapping back. To fail to get one back is a
> > sign of extent tree corruption, I think, so this should probably be
> > a XFS_WANT_CORRUPTED_GOTO() case....
> 
> checking "nmap == 0" also has another option, since there might have continuous hole extents in mapped file range,
> i.e, both map[0] and map[1] are holes(for now, I have not yet worked out a test case to verify this scenario).

If it lands in a hole, a hole mapping will be returned for the given
range.  IOWs, xfs_bmapi_read will always return a mapping of some
kind for a range that is within EOF. Hence nmap == 0 is an
indication of something gone very wrong...

> I still need some time to verify that.

Create a sparse file of a petabyte size, write a block in the first
1MB, then write a block in the last MB. The see what gets
returned....

> >> +		seekoff = XFS_FSB_TO_B(mp, fsbno);
> >> +
> >> +		if ((map[0].br_state == XFS_EXT_NORM &&
> >> +		     !isnullstartblock(map[0].br_startblock)) ||
> >> +		    map[0].br_startblock == DELAYSTARTBLOCK) {
> > 
> > So this skips holes and unwritten regions.
> > 
> >> +			offset = max_t(loff_t, seekoff,
> >> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
> >> +			break;
> >> +		} else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
> >> +			offset = max_t(loff_t, seekoff,
> >> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
> >> +			break;
> 
> Using "map[0].br_startblock != HOLESTARTBLOCK" to simplify the logic for offset calculation is cool!
> However, treat unwritten extent as data is temporarily for us, it will finally split up to an individual check when
> trying to add dirty data lookup. Given that, how about if we keep the current logic so that we don't need much
> code change in future, does it make sense? :)

We can change the code easily enough to discriminate between written
and unwritten extents once we work out how best to do that. So right
now I'd prefer simple code that documents the cases we support very
clearly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
