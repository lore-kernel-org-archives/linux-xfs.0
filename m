Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D531C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 359652074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0UATuD9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgGAIe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgGAIe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF4CC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so10735054pjf.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aC8e0sVkZEqjWwDfsm6fVs/jnLbT5vUlCEWiipxI8sM=;
        b=k0UATuD9yfSr5bKwHTX2sQwnAv1/6q8yB+2OJH541vubMHyKX03eA1tdTtx0ObBAvp
         PHLkXLXWzwNZdm7QrhjQrAdoavCoqsy+avmiyruno6KbfSKcfeW7lPzUJ4BMcB0oIYMX
         Lx+G3uzq6FNzzCuGiVDKq6SiPuEAwYTfVxkdamgWwWv8kJpJ2ripDeqISNOR/UC1GfBS
         zNToLVOMiIGUX/p0aKepwHVddWrjR4HUhvcdLS0xeGs0W8brQsuH6Igv22GmQ2UACVZR
         6Tn1Jn3OlVbPJF+hElyXjW77UwIvnmbSMu5+1mW9P1qnvp6ijoww4x/ttytev5N4ipaM
         Cb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aC8e0sVkZEqjWwDfsm6fVs/jnLbT5vUlCEWiipxI8sM=;
        b=KSGcjsxD76bbNFCDDWU11GF3qse0hwk1M1u6MrFtfnpoCAGoIk6N1cIuGg2laMnMO2
         I48G2oL3STrJ/s8h3YkZf71q35blT5xuV79s2US2K/mWWTjOnjSv43m19tkujngcjqWT
         0AVxNqQUMaNOyMFCzfof9IaR/ffOrIhL7ZmiL8hZzflflQAgKq/YqNa5trR7XRzJlFAc
         krP8dEgEHNLg25wpataxso1deYMYXOf6jbs4MkRqXUnUvmAbKC36JKh9i7gCCG5sRTi7
         q194diM7i0IrmhvBDMz+hsWsDho4xbceYWMwpOyULm5esxJZAGLuMp+lEpP3RyhPLo/O
         f1Rw==
X-Gm-Message-State: AOAM530jJ8iguvaMhsQgVd2OzqHrjodafhCmamdXtxTuhK15SoLSrT3j
        n9rvd98YAh0I7QF3Gl3oieaEZnlk
X-Google-Smtp-Source: ABdhPJzC7V5KvqHxxYld7BetrnjoYErJy9909rZoaeJ8X8wVjTPcXTvwswsLzUcI2bVrhqgpElC1pQ==
X-Received: by 2002:a17:90a:df11:: with SMTP id gp17mr24907630pjb.188.1593592465833;
        Wed, 01 Jul 2020 01:34:25 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id v186sm5237175pfv.141.2020.07.01.01.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Date:   Wed, 01 Jul 2020 14:04:17 +0530
Message-ID: <3195745.yPKIM3DLQA@garuda>
In-Reply-To: <159353173676.2864738.5361850443664572160.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353173676.2864738.5361850443664572160.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:12:16 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the incore dq_flags to figure out the dquot type.  This is the first
> step towards removing xfs_disk_dquot from the incore dquot.
>

The changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
>  fs/xfs/scrub/quota.c           |    4 ----
>  fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_dquot.h             |    2 ++
>  fs/xfs/xfs_dquot_item.c        |    6 ++++--
>  fs/xfs/xfs_qm.c                |    4 ++--
>  fs/xfs/xfs_qm.h                |    2 +-
>  fs/xfs/xfs_qm_syscalls.c       |    9 +++------
>  8 files changed, 45 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 56d9dd787e7b..459023b0a304 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
>  
>  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
>  
> +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> +
>  #define XFS_DQ_FLAGS \
>  	{ XFS_DQ_USER,		"USER" }, \
>  	{ XFS_DQ_PROJ,		"PROJ" }, \
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 905a34558361..710659d3fa28 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -108,10 +108,6 @@ xchk_quota_item(
>  
>  	sqi->last_id = id;
>  
> -	/* Did we get the dquot type we wanted? */
> -	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
> -		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> -
>  	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 46c8ca83c04d..59d1bce34a98 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -561,6 +561,16 @@ xfs_dquot_from_disk(
>  	return 0;
>  }
>  
> +/* Copy the in-core quota fields into the on-disk buffer. */
> +void
> +xfs_dquot_to_disk(
> +	struct xfs_disk_dquot	*ddqp,
> +	struct xfs_dquot	*dqp)
> +{
> +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
> +}
> +
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
>  static int
>  xfs_qm_dqread_alloc(
> @@ -1108,6 +1118,17 @@ xfs_qm_dqflush_done(
>  	xfs_dqfunlock(dqp);
>  }
>  
> +/* Check incore dquot for errors before we flush. */
> +static xfs_failaddr_t
> +xfs_qm_dqflush_check(
> +	struct xfs_dquot	*dqp)
> +{
> +	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
> +		return __this_address;
> +
> +	return NULL;
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> @@ -1166,8 +1187,16 @@ xfs_qm_dqflush(
>  		goto out_abort;
>  	}
>  
> -	/* This is the only portion of data that needs to persist */
> -	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	fa = xfs_qm_dqflush_check(dqp);
> +	if (fa) {
> +		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> +				be32_to_cpu(dqp->q_core.d_id), fa);
> +		xfs_buf_relse(bp);
> +		error = -EFSCORRUPTED;
> +		goto out_abort;
> +	}
> +
> +	xfs_dquot_to_disk(ddqp, dqp);
>  
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 71e36c85e20b..1b1a4261a580 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -144,6 +144,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  	return false;
>  }
>  
> +void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
> +
>  #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
>  #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
>  #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 349c92d26570..ff0ab65cf413 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -45,6 +45,7 @@ xfs_qm_dquot_logitem_format(
>  	struct xfs_log_item	*lip,
>  	struct xfs_log_vec	*lv)
>  {
> +	struct xfs_disk_dquot	ddq;
>  	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
>  	struct xfs_log_iovec	*vecp = NULL;
>  	struct xfs_dq_logformat	*qlf;
> @@ -58,8 +59,9 @@ xfs_qm_dquot_logitem_format(
>  	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
>  	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
> -			&qlip->qli_dquot->q_core,
> +	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
>  			sizeof(struct xfs_disk_dquot));
>  }
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 938023dd8ce5..632025c2f00b 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -161,7 +161,7 @@ xfs_qm_dqpurge(
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
>  
> -	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  	qi->qi_dquots--;
>  
> @@ -1598,7 +1598,7 @@ xfs_qm_dqfree_one(
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
>  	mutex_lock(&qi->qi_tree_lock);
> -	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  
>  	qi->qi_dquots--;
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 7b0e771fcbce..43b4650cdcdf 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -85,7 +85,7 @@ xfs_dquot_tree(
>  	struct xfs_quotainfo	*qi,
>  	int			type)
>  {
> -	switch (type) {
> +	switch (type & XFS_DQ_ALLTYPES) {
>  	case XFS_DQ_USER:
>  		return &qi->qi_uquota_tree;
>  	case XFS_DQ_GROUP:
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 7effd7a28136..8cbb65f01bf1 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -644,12 +644,9 @@ xfs_qm_scall_getquota_fill_qc(
>  	 * gets turned off. No need to confuse the user level code,
>  	 * so return zeroes in that case.
>  	 */
> -	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_USER) ||
> -	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_GROUP) ||
> -	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_PROJ)) {
> +	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_USER)) ||
> +	    (!XFS_IS_GQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_GROUP)) ||
> +	    (!XFS_IS_PQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_PROJ))) {
>  		dst->d_spc_timer = 0;
>  		dst->d_ino_timer = 0;
>  		dst->d_rt_spc_timer = 0;
> 
> 


-- 
chandan



