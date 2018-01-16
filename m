Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeAPVK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 16:10:26 -0500
Date: Tue, 16 Jan 2018 13:10:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/5] xfs: check sb_agblocks and sb_agblklog when
 validating superblock
Message-ID: <20180116211008.GV5602@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579464601.8694.5478076755339350941.stgit@magnolia>
 <20180115200313.GC5602@magnolia>
 <20180116124846.GA52295@bfoster.bfoster>
 <20180116173432.GQ5602@magnolia>
 <20180116180222.GC52829@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116180222.GC52829@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 01:02:22PM -0500, Brian Foster wrote:
> On Tue, Jan 16, 2018 at 09:34:32AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 16, 2018 at 07:48:46AM -0500, Brian Foster wrote:
> > > On Mon, Jan 15, 2018 at 12:03:13PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Currently, we don't check sb_agblocks or sb_agblklog when we validate
> > > > the superblock, which means that we can fuzz garbage values into those
> > > > values and the mount succeeds.  This leads to all sorts of UBSAN
> > > > warnings in xfs/350 since we can then coerce other parts of xfs into
> > > > shifting by ridiculously large values.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > v2: simplify ag min/max size definitions
> > > > ---
> > > >  fs/xfs/libxfs/xfs_fs.h |    7 +++++++
> > > >  fs/xfs/libxfs/xfs_sb.c |    3 +++
> > > >  2 files changed, 10 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index fc4386a..3ab1870 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > > @@ -233,6 +233,13 @@ typedef struct xfs_fsop_resblks {
> > > >  #define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
> > > >  #define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
> > > >  
> > > > +/*
> > > > + * Limits on sb_agblocks/sb_agblklog -- mkfs won't format AGs smaller than
> > > > + * 16MB or larger than 1TB.
> > > > + */
> > > > +#define XFS_AG_MIN_BYTES	(1ULL << 24)	/* 16 MB */
> > > > +#define XFS_AG_MAX_BYTES	(1ULL << 40)	/* 1 TB */
> > > > +
> > > 
> > > Dave's comment aside... just a nit: the definitions above use
> > > XFS_[MIN|MAX]_* naming rather than XFS_AG_*. It would be nice to be
> > > consistent there if we stick with these.
> > 
> > Since I was extracting the constants from xfs_multidisk.h I thought it
> > important to maintain the symbolic name to avoid breaking userspace.
> > I guess we /could/ just add XFS_MIN_AG_BYTES to libxfs and change
> > xfs_multidisk.h to do:
> > 
> 
> Oh, I missed that..
> 
> > #define XFS_AG_MIN_BYTES	(XFS_MIN_AG_BYTES)
> > 
> > Or just decide that we don't care since we never install that header to
> > /usr/include ?
> > 
> 
> I think elevating these into libxfs warrant using whatever
> sane/clean/consistent names fit in best from the perspective of libxfs.
> If this is an internal define in xfsprogs, perhaps we can just
> s/XFS_AG_MIN_BYTES/XFS_MIN_AG_BYTES/ there once this change trickles
> down? Looks like it's only used in a handful of places.

Ok fair enough, will do.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  /* keep the maximum size under 2^31 by a small amount */
> > > >  #define XFS_MAX_LOG_BYTES \
> > > >  	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index 08e44a0..bdb4f74 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -253,6 +253,9 @@ xfs_mount_validate_sb(
> > > >  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
> > > >  	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
> > > >  	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
> > > > +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_AG_MIN_BYTES	||
> > > > +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_AG_MAX_BYTES	||
> > > > +	    sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1	||
> > > >  	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
> > > >  	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
> > > >  	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
