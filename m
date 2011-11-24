Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAO92S3V008143 for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 03:02:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 016BB2737A4
	for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 01:02:26 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3U96yoGvJ5LEv1ps for <xfs@oss.sgi.com>;
	Thu, 24 Nov 2011 01:02:26 -0800 (PST)
Date: Thu, 24 Nov 2011 04:02:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE to XFS V2
Message-ID: <20111124090220.GA643@infradead.org>
References: <4ECB5B21.7080508@oracle.com> <20111123094049.GA5465@infradead.org>
	<20111124032331.GO2386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111124032331.GO2386@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Thu, Nov 24, 2011 at 02:23:31PM +1100, Dave Chinner wrote:
> > > +		if (map[0].br_startblock == HOLESTARTBLOCK) {
> > > +			if (map[1].br_startblock == HOLESTARTBLOCK) {
> > > +				fsbno = map[1].br_startoff +
> > > +					map[1].br_blockcount;
> > 
> > I don't think this code is reachable - xfs_bmapi will never produce
> > multiple consecutive HOLESTARTBLOCK extents.
> 
> If the hole would overflow br_blockcount (32 bits of FSB units, 16TB
> by default), then we should get multiple consecutive hole records
> returned.

Right, the XFS_FILBLKS_MIN in xfs_bmapi_read will limit it, and we'll
it the same case again in the loop.  So yes, we'll need it; and we
should have a test to verify this case.

> > This also means that we never have to loop here until we add dirty
> > unwritten probing - if the second extent doesn't contain data there
> > won't be any other data extent in this file beyound our offset.
> 
> I think that's incorrect. A data extent is limited in length by the
> on disk format (21 bits of FSB, 8GB in 4k block fs), so if you've
> got more than 8GB of data or the file is fragmented after the
> current extent then we can still get back multiple data extents
> before we find the next hole.

Indeed.  Add fragmented file to what we need to test in QA..

> > 
> > I think just checking for br_state == XFS_EXT_NORM should be fine here,
> > as unwritten extents can be delayed allocated.
> 
> Can they? I'm pretty sure delalloc and unwritten are mutually
> exclusive states for an extent.

Yes, they _can't_.  That was a typo, the rest of the setentence wouldn't
make sense if that was allowed.

> > > +	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > > +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> > > +	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > > +		return XFS_ERROR(EINVAL);
> > 
> > I'd recommend moving this check into xfs_file_llseek and even do it
> > for the normal lseek requests - it's another sanity check for corrupted
> > filesystems which makes sense everywhere.  I also think the return value
> > should be EFSCORRUPTED.
> >
> > Also XFS_DINODE_FMT_LOCAL isn't valid for regular files (yet) so it
> > shouldn't be tested for.
> 
> I don't think it is necessary at all - the low level bmap functions
> already do these checks.

Indeed, although xfs_bmap_first_unused also allows XFS_DINODE_FMT_LOCAL
format, but I think that is fine.

> > > +	lock = xfs_ilock_map_shared(ip);
> > > +
> > > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > > +		error = EIO;
> > > +		goto out_lock;
> > > +	}
> > 
> > The shutdown check probably should go into the common lseek code and
> > done for all cases.
> 
> I think the low level functions also do this check so it's not
> explicitly needed here, anyway.

xfs_bmapi_read does it, xfs_bmap_first_unused lacks it.  And returning
an error ASAP on a normal lseek for the normal lseek cases also makes
a lot of sense.

> > 
> > > +
> > > +	XFS_STATS_INC(xs_blk_mapr);
> > 
> > I don't think this counter should be incremented here.
> 
> It's done in the lower layer functions, so shouldn't be here.

It is for xfs_bmapi_read, it isn't for xfs_bmap_first_unused, and then
again it really shouldn't either - it's a counter for xfs_bmapi_read
calls.

> > Now that just the locking and the xfs_iread_extents call is left in
> > this function I'd suggest to remove it and instead add duplicates
> > of the locking and xfs_iread_extents into xfs_seek_hole and
> > xfs_seek_data.
> 
> Actually, it just turns into "lock, call seek/data fucntion, unlock",
> so it can probaly go away entirely.

That's what I tried to imply with the above comment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
