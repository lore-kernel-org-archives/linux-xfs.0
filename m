Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EC4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C779164DF5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhA1SOA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231819AbhA1SLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611857427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XdSSW+SOa9wurhYviBfuT1W/HuIPRD+ZUTWwVv4U1t4=;
        b=hWhgi27vIdCgpvQW3ja2T2wqOglPX28JPj/S+2724V9I67caauvQSAMygTlz2/nIJW8b9R
        BHFRvacXBQKnjUF4kuEmKWBcImrW791e9qWlUqnDL1nVZIxl4ZfYBgwMQSviqWo74Tni7m
        QS+BdtLBlG6tghth9oUXC4eQSeLrDts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-6y4wC4YSOverVnvSO4aF9Q-1; Thu, 28 Jan 2021 13:10:25 -0500
X-MC-Unique: 6y4wC4YSOverVnvSO4aF9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C193190A7A5;
        Thu, 28 Jan 2021 18:10:24 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 931DC16D5E;
        Thu, 28 Jan 2021 18:10:23 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:10:21 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/13] xfs: reserve data and rt quota at the same time
Message-ID: <20210128181021.GE2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369834.1523592.7003018155732921879.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181369834.1523592.7003018155732921879.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Modify xfs_trans_reserve_quota_nblks so that we can reserve data and
> realtime blocks from the dquot at the same time.  This change has the
> theoretical side effect that for allocations to realtime files we will
> reserve from the dquot both the number of rtblocks being allocated and
> the number of bmbt blocks that might be needed to add the mapping.
> However, since the mount code disables quota if it finds a realtime
> device, this should not result in any behavior changes.
> 
> This also replaces the flags argument with a force? boolean since we

s/?//

> don't need to distinguish between data and rt quota reservations any
> more, and the only other flag being passed in was FORCE_RES.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    6 +-----
>  fs/xfs/libxfs/xfs_bmap.c |    4 +---
>  fs/xfs/xfs_bmap_util.c   |   20 +++++++++-----------
>  fs/xfs/xfs_iomap.c       |   26 +++++++++++++-------------
>  fs/xfs/xfs_quota.h       |   10 +++++-----
>  fs/xfs/xfs_reflink.c     |    6 ++----
>  fs/xfs/xfs_trans_dquot.c |   42 ++++++++++++++++++++++++++++--------------
>  7 files changed, 59 insertions(+), 55 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f0a8f3377281..d54d9f02d3dd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
...
> @@ -792,18 +792,17 @@ xfs_alloc_file_space(
>  		if (unlikely(rt)) {
>  			resrtextents = qblocks = resblks;

This looks like the last usage of qblocks in the function.

>  			resrtextents /= mp->m_sb.sb_rextsize;
> -			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> -			quota_flag = XFS_QMOPT_RES_RTBLKS;
> +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> +			rblocks = resblks;
>  		} else {
> -			resrtextents = 0;
> -			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
> -			quota_flag = XFS_QMOPT_RES_REGBLKS;
> +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
> +			rblocks = 0;
>  		}
>  
>  		/*
>  		 * Allocate and setup the transaction.
>  		 */
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks,
>  				resrtextents, 0, &tp);
>  
>  		/*
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index de0e371ba4dd..ef29d44c656a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
...
> @@ -235,18 +235,19 @@ xfs_iomap_write_direct(
>  	if (IS_DAX(VFS_I(ip))) {
>  		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
>  		if (imap->br_state == XFS_EXT_UNWRITTEN) {
> +			force = true;
>  			tflags |= XFS_TRANS_RESERVE;
> -			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
> +			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;

I'm a little confused what this hunk of logic is for in the first place,
but doesn't this also adjust down the quota where it previously only
affected the transaction reservation? Is that intentional?

Brian

>  		}
>  	}
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks, resrtextents,
>  			tflags, &tp);
>  	if (error)
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> +	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -559,8 +560,7 @@ xfs_iomap_write_unwritten(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
> +		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, true);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 72f4cfc49048..efd04f84d9b4 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -81,8 +81,8 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
>  		uint, int64_t);
>  extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
>  extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
> -extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
> -		struct xfs_inode *, int64_t, long, uint);
> +int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
> +		int64_t dblocks, int64_t rblocks, bool force);
>  extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
>  		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
> @@ -114,8 +114,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
>  static inline int
>  xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
>  {
> -	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0,
> -			XFS_QMOPT_RES_REGBLKS);
> +	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0, false);
>  }
>  #else
>  static inline int
> @@ -134,7 +133,8 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
>  #define xfs_trans_apply_dquot_deltas(tp)
>  #define xfs_trans_unreserve_and_mod_dquots(tp)
>  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
> -		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
> +		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
> +		bool force)
>  {
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 15435229bc1f..0778b5810c26 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -398,8 +398,7 @@ xfs_reflink_allocate_cow(
>  		goto convert;
>  	}
>  
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -			XFS_QMOPT_RES_REGBLKS);
> +	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1090,8 +1089,7 @@ xfs_reflink_remap_extent(
>  	if (!smap_real && dmap_written)
>  		qres += dmap->br_blockcount;
>  	if (qres > 0) {
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
> -				XFS_QMOPT_RES_REGBLKS);
> +		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
>  		if (error)
>  			goto out_cancel;
>  	}
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 22aa875b84f7..a1a72b7900c5 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -780,28 +780,42 @@ int
>  xfs_trans_reserve_quota_nblks(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
> -	int64_t			nblks,
> -	long			ninos,
> -	uint			flags)
> +	int64_t			dblocks,
> +	int64_t			rblocks,
> +	bool			force)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	unsigned int		qflags = 0;
> +	int			error;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
>  	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
> -
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
> -	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
> -
> -	/*
> -	 * Reserve nblks against these dquots, with trans as the mediator.
> -	 */
> -	return xfs_trans_reserve_quota_bydquots(tp, mp,
> -						ip->i_udquot, ip->i_gdquot,
> -						ip->i_pdquot,
> -						nblks, ninos, flags);
> +
> +	if (force)
> +		qflags |= XFS_QMOPT_FORCE_RES;
> +
> +	/* Reserve data device quota against the inode's dquots. */
> +	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> +			ip->i_gdquot, ip->i_pdquot, dblocks, 0,
> +			XFS_QMOPT_RES_REGBLKS | qflags);
> +	if (error)
> +		return error;
> +
> +	/* Do the same but for realtime blocks. */
> +	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> +			ip->i_gdquot, ip->i_pdquot, rblocks, 0,
> +			XFS_QMOPT_RES_RTBLKS | qflags);
> +	if (error) {
> +		xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> +				ip->i_gdquot, ip->i_pdquot, -dblocks, 0,
> +				XFS_QMOPT_RES_REGBLKS);
> +		return error;
> +	}
> +
> +	return 0;
>  }
>  
>  /* Change the quota reservations for an inode creation activity. */
> 

