Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360CAC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E842164E22
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhA1Syp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhA1Swy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 13:52:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E769664E21;
        Thu, 28 Jan 2021 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611859930;
        bh=MSiglyUk3xY31peVXYrFPqCJ6s6AUb78qcbgjyKatCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MqalZdymTx5ueMIhSjPmZgQkiUF/O6sKYhXq3az9HDp6rSyYQr+nOIhyKZG1pJBl7
         zcKoZT894A4e7vdsceF+wgYq3eA4RCw8GY0SYBY3PWUIfvMJ0niO5xA1KfcuRhPVwt
         nYjDLMPF++zqi1qDE2XHjEHou535P0S2bQwNW272Xm1fgu0EeIBN8Xh/hI4Lm9rWq0
         NPrqtbxsOSF3CRUDBFuMgn7VFiv7WWMQqQWDt6vBWS4xarnDSpFUY4MLJdh7qCAvaX
         /rX8plBFS4uWY7Ytj3Cv8KFX7cvBBvv+QXuUVZp/ZCF6iGU+9/Wwe8DD8cFTDxLrQ1
         wDPqZ2oL4Swng==
Date:   Thu, 28 Jan 2021 10:52:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/13] xfs: reserve data and rt quota at the same time
Message-ID: <20210128185209.GX7698@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369834.1523592.7003018155732921879.stgit@magnolia>
 <20210128181021.GE2619139@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128181021.GE2619139@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 01:10:21PM -0500, Brian Foster wrote:
> On Wed, Jan 27, 2021 at 10:01:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Modify xfs_trans_reserve_quota_nblks so that we can reserve data and
> > realtime blocks from the dquot at the same time.  This change has the
> > theoretical side effect that for allocations to realtime files we will
> > reserve from the dquot both the number of rtblocks being allocated and
> > the number of bmbt blocks that might be needed to add the mapping.
> > However, since the mount code disables quota if it finds a realtime
> > device, this should not result in any behavior changes.
> > 
> > This also replaces the flags argument with a force? boolean since we
> 
> s/?//
> 
> > don't need to distinguish between data and rt quota reservations any
> > more, and the only other flag being passed in was FORCE_RES.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c |    6 +-----
> >  fs/xfs/libxfs/xfs_bmap.c |    4 +---
> >  fs/xfs/xfs_bmap_util.c   |   20 +++++++++-----------
> >  fs/xfs/xfs_iomap.c       |   26 +++++++++++++-------------
> >  fs/xfs/xfs_quota.h       |   10 +++++-----
> >  fs/xfs/xfs_reflink.c     |    6 ++----
> >  fs/xfs/xfs_trans_dquot.c |   42 ++++++++++++++++++++++++++++--------------
> >  7 files changed, 59 insertions(+), 55 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index f0a8f3377281..d54d9f02d3dd 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> ...
> > @@ -792,18 +792,17 @@ xfs_alloc_file_space(
> >  		if (unlikely(rt)) {
> >  			resrtextents = qblocks = resblks;
> 
> This looks like the last usage of qblocks in the function.

Oops, yes, that can go away.  Fixed.

> >  			resrtextents /= mp->m_sb.sb_rextsize;
> > -			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > -			quota_flag = XFS_QMOPT_RES_RTBLKS;
> > +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > +			rblocks = resblks;
> >  		} else {
> > -			resrtextents = 0;
> > -			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
> > -			quota_flag = XFS_QMOPT_RES_REGBLKS;
> > +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
> > +			rblocks = 0;
> >  		}
> >  
> >  		/*
> >  		 * Allocate and setup the transaction.
> >  		 */
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
> > +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks,
> >  				resrtextents, 0, &tp);
> >  
> >  		/*
> ...
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index de0e371ba4dd..ef29d44c656a 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> ...
> > @@ -235,18 +235,19 @@ xfs_iomap_write_direct(
> >  	if (IS_DAX(VFS_I(ip))) {
> >  		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> >  		if (imap->br_state == XFS_EXT_UNWRITTEN) {
> > +			force = true;
> >  			tflags |= XFS_TRANS_RESERVE;
> > -			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
> > +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
> 
> I'm a little confused what this hunk of logic is for in the first place,

I think this was to prevent racing write faults to an unwritten extent
in an S_DAX file from clobbering each other.  Looking at the dax write
fault path (__xfs_filemap_fault), we only take MMAPLOCK_SHARED, so the
only way we can serialize the storage zeroing that must be done with
unwritten extent conversion is when we take the ILOCK to do the
conversion, aka BMAPI_ZERO.

xfs_direct_write_iomap_begin accomplishes this by (ab|re)using the
"allocation" path to do the extent conversion.  The space is already
allocated, so we only have to reserve enough free space/quota to handle
the bmbt split.

> but doesn't this also adjust down the quota where it previously only
> affected the transaction reservation? Is that intentional?

So yes, it does adjust down the quota reservation for this one case, but
I don't think we needed it in the first place.  Still, I'll cut out this
part and make it a separate fix patch so that the conversion is more
straightforward.  Thanks for pointing that out.

--D

> Brian
> 
> >  		}
> >  	}
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks, resrtextents,
> >  			tflags, &tp);
> >  	if (error)
> >  		return error;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  
> > -	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> > +	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -559,8 +560,7 @@ xfs_iomap_write_unwritten(
> >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  		xfs_trans_ijoin(tp, ip, 0);
> >  
> > -		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> > -				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
> > +		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, true);
> >  		if (error)
> >  			goto error_on_bmapi_transaction;
> >  
> > diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> > index 72f4cfc49048..efd04f84d9b4 100644
> > --- a/fs/xfs/xfs_quota.h
> > +++ b/fs/xfs/xfs_quota.h
> > @@ -81,8 +81,8 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
> >  		uint, int64_t);
> >  extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
> >  extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
> > -extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
> > -		struct xfs_inode *, int64_t, long, uint);
> > +int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
> > +		int64_t dblocks, int64_t rblocks, bool force);
> >  extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
> >  		struct xfs_mount *, struct xfs_dquot *,
> >  		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
> > @@ -114,8 +114,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
> >  static inline int
> >  xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
> >  {
> > -	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0,
> > -			XFS_QMOPT_RES_REGBLKS);
> > +	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0, false);
> >  }
> >  #else
> >  static inline int
> > @@ -134,7 +133,8 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
> >  #define xfs_trans_apply_dquot_deltas(tp)
> >  #define xfs_trans_unreserve_and_mod_dquots(tp)
> >  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
> > -		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
> > +		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
> > +		bool force)
> >  {
> >  	return 0;
> >  }
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 15435229bc1f..0778b5810c26 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -398,8 +398,7 @@ xfs_reflink_allocate_cow(
> >  		goto convert;
> >  	}
> >  
> > -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> > -			XFS_QMOPT_RES_REGBLKS);
> > +	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -1090,8 +1089,7 @@ xfs_reflink_remap_extent(
> >  	if (!smap_real && dmap_written)
> >  		qres += dmap->br_blockcount;
> >  	if (qres > 0) {
> > -		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
> > -				XFS_QMOPT_RES_REGBLKS);
> > +		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
> >  		if (error)
> >  			goto out_cancel;
> >  	}
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 22aa875b84f7..a1a72b7900c5 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -780,28 +780,42 @@ int
> >  xfs_trans_reserve_quota_nblks(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_inode	*ip,
> > -	int64_t			nblks,
> > -	long			ninos,
> > -	uint			flags)
> > +	int64_t			dblocks,
> > +	int64_t			rblocks,
> > +	bool			force)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	unsigned int		qflags = 0;
> > +	int			error;
> >  
> >  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  
> >  	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
> > -
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
> > -	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
> > -
> > -	/*
> > -	 * Reserve nblks against these dquots, with trans as the mediator.
> > -	 */
> > -	return xfs_trans_reserve_quota_bydquots(tp, mp,
> > -						ip->i_udquot, ip->i_gdquot,
> > -						ip->i_pdquot,
> > -						nblks, ninos, flags);
> > +
> > +	if (force)
> > +		qflags |= XFS_QMOPT_FORCE_RES;
> > +
> > +	/* Reserve data device quota against the inode's dquots. */
> > +	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> > +			ip->i_gdquot, ip->i_pdquot, dblocks, 0,
> > +			XFS_QMOPT_RES_REGBLKS | qflags);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Do the same but for realtime blocks. */
> > +	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> > +			ip->i_gdquot, ip->i_pdquot, rblocks, 0,
> > +			XFS_QMOPT_RES_RTBLKS | qflags);
> > +	if (error) {
> > +		xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> > +				ip->i_gdquot, ip->i_pdquot, -dblocks, 0,
> > +				XFS_QMOPT_RES_REGBLKS);
> > +		return error;
> > +	}
> > +
> > +	return 0;
> >  }
> >  
> >  /* Change the quota reservations for an inode creation activity. */
> > 
> 
