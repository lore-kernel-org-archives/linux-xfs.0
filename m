Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28ADC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 07:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B609C20675
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 07:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZkHVfSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbgFVHz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbgFVHz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 03:55:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFDDC061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 00:55:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so8061926pfn.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 00:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ImlV+3v9n2Dm5CqXpeW5LzdbbMr+Z9p0UL4gvvMX/y0=;
        b=HZkHVfSKaQhzq0Ic7poMC1Mini8j77YxUgTS87PE9CzeWCixUnzhXNWLSeW1cFdNch
         68nl/hsby0z8XezvB9saleBost8eZe/+0EonxgrU1u0qoKTJpSOuDgpL0cvTUqyvE+Ns
         WOj6MA/X2xtY5POKCMEI/c4m+3TULePNmO2FIER+237KP2YQX3QgbptiI+D+7+j86A6z
         0IIPDu1lqOBcR7mvmXH4RRAShMO9+UFeoHC9dk5gOM2KXe4weqJ1+8cn7xwjEMlGPOZx
         CI3dmQPFgIeXHR03AwFsetXIGQAJvtSr2tSyVbJLk/1QCnnxkUHvzt/Z7uP0IO/fOE6R
         0hqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ImlV+3v9n2Dm5CqXpeW5LzdbbMr+Z9p0UL4gvvMX/y0=;
        b=szAwLsx+1FUtNtrdJLHtLHnfc37mwUklyPuXd+FzNVOFOsmUcXVW2cIxZJLnNZK2nl
         ITA4TjzDS/ieKDj7kpAe9tBtB9O+ADVfafqeCpjrTlcPEn1/slEio2KetSWO4E+qDpro
         kBAl66duVqmkNPqt3/OES0nJUf/Px4zuol7NzFwuTzdhiX8kvyU4gxKXzV8GvMXzznGF
         8efw/KRHCHFhmM0rSgIL/dH7/BMz6+LSCdEjA8Jx8gG3UNOOJkJo4QN1CbzK0j6Wm3Jo
         3c8BIcmU4R3q6340v/vXgJcYGtIlGfftsBYIFKVxVyIGmIzKWLxmfQ50+qljRMmke6lh
         pZcQ==
X-Gm-Message-State: AOAM530kSZDRIcIa9kvkISjUCjcjQAaYcu5vXk1b3AKJdaUqOZAHpFTG
        xgvynYLOYiiHWyQkxOegt6x4Hn9F
X-Google-Smtp-Source: ABdhPJzpV8+B6CeCpZa2bd540QHGt32xWhJzuNqu63tZans/nw0ZK5nwLVhrjCbEh6wuxRNnxpgEtw==
X-Received: by 2002:a63:ef4e:: with SMTP id c14mr4603566pgk.259.1592812526818;
        Mon, 22 Jun 2020 00:55:26 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id n65sm12916957pfn.17.2020.06.22.00.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:55:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: move the di_projid field to struct xfs_inode
Date:   Mon, 22 Jun 2020 13:25:23 +0530
Message-ID: <4272243.osSWmPdsuN@garuda>
In-Reply-To: <20200620071102.462554-3-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-3-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:49 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the projid
> field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_bmap_util.c        | 2 +-
>  fs/xfs/xfs_dquot.c            | 2 +-
>  fs/xfs/xfs_icache.c           | 4 ++--
>  fs/xfs/xfs_inode.c            | 6 +++---
>  fs/xfs/xfs_inode.h            | 3 ++-
>  fs/xfs/xfs_inode_item.c       | 4 ++--
>  fs/xfs/xfs_ioctl.c            | 8 ++++----
>  fs/xfs/xfs_iops.c             | 2 +-
>  fs/xfs/xfs_itable.c           | 2 +-
>  fs/xfs/xfs_qm.c               | 8 ++++----
>  fs/xfs/xfs_qm_bhv.c           | 2 +-
>  13 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6f84ea85fdd837..b064cb8072c84a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -218,10 +218,10 @@ xfs_inode_from_disk(
>  	 */
>  	if (unlikely(from->di_version == 1)) {
>  		set_nlink(inode, be16_to_cpu(from->di_onlink));
> -		to->di_projid = 0;
> +		ip->i_projid = 0;
>  	} else {
>  		set_nlink(inode, be32_to_cpu(from->di_nlink));
> -		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> +		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
>  					be16_to_cpu(from->di_projid_lo);
>  	}
>  
> @@ -290,8 +290,8 @@ xfs_inode_to_disk(
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
>  	to->di_gid = cpu_to_be32(i_gid_read(inode));
> -	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
> -	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
> +	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
> +	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 865ac493c72a24..b826d81b356956 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	uint32_t	di_projid;	/* owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f37f5cc4b19ffe..e42553884c23cf 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1217,7 +1217,7 @@ xfs_swap_extents_check_format(
>  	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
>  	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
>  	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
> -	     ip->i_d.di_projid != tip->i_d.di_projid))
> +	     ip->i_projid != tip->i_projid))
>  		return -EINVAL;
>  
>  	/* Should never get a local format */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8db..912b978a6a72d5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -868,7 +868,7 @@ xfs_qm_id_for_quotatype(
>  	case XFS_DQ_GROUP:
>  		return i_gid_read(VFS_I(ip));
>  	case XFS_DQ_PROJ:
> -		return ip->i_d.di_projid;
> +		return ip->i_projid;
>  	}
>  	ASSERT(0);
>  	return 0;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 660e7abd4e8b76..a3bbd6e4bb6fc8 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1439,7 +1439,7 @@ xfs_inode_match_id(
>  		return false;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    ip->i_d.di_projid != eofb->eof_prid)
> +	    ip->i_projid != eofb->eof_prid)
>  		return false;
>  
>  	return true;
> @@ -1463,7 +1463,7 @@ xfs_inode_match_id_union(
>  		return true;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    ip->i_d.di_projid == eofb->eof_prid)
> +	    ip->i_projid == eofb->eof_prid)
>  		return true;
>  
>  	return false;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 88a9e496480216..40e4d3ed29a798 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -806,7 +806,7 @@ xfs_ialloc(
>  	set_nlink(inode, nlink);
>  	inode->i_uid = current_fsuid();
>  	inode->i_rdev = rdev;
> -	ip->i_d.di_projid = prid;
> +	ip->i_projid = prid;
>  
>  	if (pip && XFS_INHERIT_GID(pip)) {
>  		inode->i_gid = VFS_I(pip)->i_gid;
> @@ -1398,7 +1398,7 @@ xfs_link(
>  	 * the tree quota mechanism could be circumvented.
>  	 */
>  	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
> +		     tdp->i_projid != sip->i_projid)) {
>  		error = -EXDEV;
>  		goto error_return;
>  	}
> @@ -3264,7 +3264,7 @@ xfs_rename(
>  	 * tree quota mechanism would be circumvented.
>  	 */
>  	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
> +		     target_dp->i_projid != src_ip->i_projid)) {
>  		error = -EXDEV;
>  		goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index dadcf19458960d..51ea9d53407863 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -54,6 +54,7 @@ typedef struct xfs_inode {
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
> +	uint32_t		i_projid;	/* owner's project id */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> @@ -175,7 +176,7 @@ static inline prid_t
>  xfs_get_initial_prid(struct xfs_inode *dp)
>  {
>  	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
> -		return dp->i_d.di_projid;
> +		return dp->i_projid;
>  
>  	return XFS_PROJID_DEFAULT;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ba47bf65b772be..e546b4b58ce2e0 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = i_uid_read(inode);
>  	to->di_gid = i_gid_read(inode);
> -	to->di_projid_lo = from->di_projid & 0xffff;
> -	to->di_projid_hi = from->di_projid >> 16;
> +	to->di_projid_lo = ip->i_projid & 0xffff;
> +	to->di_projid_hi = ip->i_projid >> 16;
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a40f88cf3ab786..d93f4fc40fd99e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1110,7 +1110,7 @@ xfs_fill_fsxattr(
>  	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_projid = ip->i_d.di_projid;
> +	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
>  	else
> @@ -1518,7 +1518,7 @@ xfs_ioctl_setattr(
>  	}
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> -	    ip->i_d.di_projid != fa->fsx_projid) {
> +	    ip->i_projid != fa->fsx_projid) {
>  		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
>  				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
>  		if (code)	/* out of quota */
> @@ -1555,12 +1555,12 @@ xfs_ioctl_setattr(
>  		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  	/* Change the ownerships and register project quota modifications */
> -	if (ip->i_d.di_projid != fa->fsx_projid) {
> +	if (ip->i_projid != fa->fsx_projid) {
>  		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
>  			olddquot = xfs_qm_vop_chown(tp, ip,
>  						&ip->i_pdquot, pdqp);
>  		}
> -		ip->i_d.di_projid = fa->fsx_projid;
> +		ip->i_projid = fa->fsx_projid;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d66528fa365707..5440f555c9cc2c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -696,7 +696,7 @@ xfs_setattr_nonsize(
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> -		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
> +		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_projid,
>  					   qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 16ca97a7ff00fb..97b3b794dd4ada 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_projectid = ip->i_d.di_projid;
> +	buf->bs_projectid = ip->i_projid;
>  	buf->bs_ino = ino;
>  	buf->bs_uid = i_uid_read(inode);
>  	buf->bs_gid = i_gid_read(inode);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d6cd833173447a..ea22dcf868b474 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -346,7 +346,7 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
> +		error = xfs_qm_dqattach_one(ip, ip->i_projid, XFS_DQ_PROJ,
>  				doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
> @@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> -		if (ip->i_d.di_projid != prid) {
> +		if (ip->i_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
>  					true, &pq);
> @@ -1844,7 +1844,7 @@ xfs_qm_vop_chown_reserve(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> -	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
> +	    ip->i_projid != be32_to_cpu(pdqp->q_core.d_id)) {
>  		pdq_delblks = pdqp;
>  		if (delblks) {
>  			ASSERT(ip->i_pdquot);
> @@ -1942,7 +1942,7 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(ip->i_pdquot == NULL);
> -		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
> +		ASSERT(ip->i_projid == be32_to_cpu(pdqp->q_core.d_id));
>  
>  		ip->i_pdquot = xfs_qm_dqhold(pdqp);
>  		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa418919f7f..b616ad772a6df8 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -60,7 +60,7 @@ xfs_qm_statvfs(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_dquot	*dqp;
>  
> -	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
> +	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQ_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
>  		xfs_qm_dqput(dqp);
>  	}
> 


-- 
chandan



