Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:21332 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdAaUKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 15:10:40 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0VKANhk016380
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 20:10:23 GMT
Date: Tue, 31 Jan 2017 12:09:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/7] xfs: filter out obviously bad btree pointers
Message-ID: <20170131200918.GH9134@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582220244.12293.9617058284483534384.stgit@birch.djwong.org>
 <eabf5bb2-124e-5af9-5dbb-380bc85d8b13@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eabf5bb2-124e-5af9-5dbb-380bc85d8b13@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 30, 2017 at 10:39:05PM -0600, Eric Sandeen wrote:
> On 1/30/17 6:23 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't let anybody load an obviously bad btree pointer.  Since the values
> > come from disk, we must return an error, not just ASSERT.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c  |    4 +---
> >  fs/xfs/libxfs/xfs_btree.c |    3 ++-
> >  fs/xfs/libxfs/xfs_btree.h |    2 +-
> >  3 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index bfc00de..443cb10 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -1291,9 +1291,7 @@ xfs_bmap_read_extents(
> >  	ASSERT(level > 0);
> >  	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
> >  	bno = be64_to_cpu(*pp);
> > -	ASSERT(bno != NULLFSBLOCK);
> > -	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
> > -	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
> > +
> 
> fwiw there's an assignment of bno = NULLFSBLOCK just before here,
> which is never used and overwritten in this hunk.
> Could probably clean that up here too.

Yes, that could go too.

> >  	/*
> >  	 * Go down the tree until leaf level is reached, following the first
> >  	 * pointer (leftmost) at each level.
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 21e6a6a..2849d3f 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -810,7 +810,8 @@ xfs_btree_read_bufl(
> >  	xfs_daddr_t		d;		/* real disk block address */
> >  	int			error;
> >  
> > -	ASSERT(fsbno != NULLFSBLOCK);
> > +	if (!XFS_FSB_SANITY_CHECK(mp, fsbno))
> > +		return -EFSCORRUPTED;
> 
> This does away with the NULLFSBLOCK checks though, right?
> 
> #define NULLFSBLOCK     ((xfs_fsblock_t)-1)
> 
> which is also used as an in-memory condition, so I'm not sure
> it should be added to XFS_FSB_SANITY_CHECK.

[reiterating our irc conversation]

It shouldn't, since XFS_FSB_TO_AGNO(mp, NULLFSBLOCK) ought to produce
NULLAGNUMBER, which will still fail the check.

> IOWs some asserts about it are really code flow asserts, though
> it also shouldn't be read from disk.

xfs_btree_read_bufl is called by xfs_bmap_check_leaf_extents, which is
the verifier of the on-disk data.

--D

> >  	d = XFS_FSB_TO_DADDR(mp, fsbno);
> >  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
> >  				   mp->m_bsize, lock, &bp, ops);
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index b69b947..33a8f86 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -456,7 +456,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
> >  #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
> >  
> >  #define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
> > -	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
> > +	(fsb && XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
> >  		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
> >  
> >  /*
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
