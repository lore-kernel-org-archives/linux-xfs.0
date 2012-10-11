Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BMQcA4249476 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 17:26:38 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KZOtKr4SDK2LJS0Q for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 15:28:10 -0700 (PDT)
Date: Fri, 12 Oct 2012 09:28:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/19] xfs: verify superblocks as they are read from disk
Message-ID: <20121011222808.GK2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-5-git-send-email-david@fromorbit.com>
	<20121011214139.GD6346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011214139.GD6346@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 05:41:39PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 09, 2012 at 02:50:55PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a superblock verify callback function and pass it into the
> > buffer read functions. Remove the now redundant verification code
> > that is currently in use.
> > 
> > Adding verification shows that secondary superblocks never have
> > their "sb_inprogress" flag cleared by mkfs.xfs, so when validating
> > the secondary superblocks during a grow operation we have to avoid
> > checking this field. Even if we fix mkfs, we will still have to
> > ignore this field for verification purposes unless a version of mkfs
> > that does not have this bug was used.
> 
> > @@ -304,9 +304,8 @@ STATIC int
> >  xfs_mount_validate_sb(
> >  	xfs_mount_t	*mp,
> >  	xfs_sb_t	*sbp,
> > -	int		flags)
> > +	bool		check_inprogress)
> >  {
> > -	int		loud = !(flags & XFS_MFSI_QUIET);
> 
> I don't think removing this is a good idea.  The quiet flag is used
> to silence all filesystem warnings when the kernel is blindly trying
> all filesystem types when searching for the correct root fs type.
> 
> If we always print warnings here people will get annoying messages
> when that happens for a non-XFS rootfs that we're asked to verify.
> 
> I'd rather make check_inprogress another flag here.

It's a little more complex than that - I'd like to have the warnings
emitted on every superblock read (primary or secondary), but only
some of them come through the mount path. e.g. we re-read the
superblock during the log recovery sequence, so even if it is a
silent mount, I want to know that log recovery corrupted the
superblock and what it corrupted....

Indeed, if the kernel is trying random filesystem mounts on a block
device, then we'll fail the magic number check and abort
immediately, so I think that's really the only message we need "loud"
protection on. If you agree that's all we'll need to check, then I
can write a couple of simple wrappers that do:

xfs_sb_read_verify()
{
	/* validate contents of superblock loudly */
}

xfs_sb_quiet_read_verify()
{

	if (!magic num mismatch) {
		/* XFS filesystem, be loud now */
		xfs_sb_read_verify();
		return;
	}
	/* quitely fail now */
	xfs_buf_ioerror(bp, EFSCORRUPTED);
	....
}

Would that solve the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
