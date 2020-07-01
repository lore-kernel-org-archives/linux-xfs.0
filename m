Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2C8C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8102074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTevyzxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgGAIe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgGAIe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B5C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o1so3062940plk.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RgXNYAMbUcs6zcmuuY2dAcn1cXMq8q6QuLV/FYUqj2c=;
        b=jTevyzxFbWUzx4dNWy20B6iR0prNpQ0w3LYDc+IRXAT4FydSpQm3rFQr29JlIqebhf
         CCdXLOwq8U1NtJo63gIlB7293GjOeDsnf7AKfcsQc69Bt92okHGhr+2FQRCh3yAJNei8
         KQVBqoSzUPU5nFsGzOLU3XzCGHRm0yo7nKM9BnA5+vykPkbKIHQLl15OHXe2bCkzmPst
         wUWgU1vjCCK8AUxQafhow8NeuXFQle2591RB5VG3OQRF63R9BgiUB/+13MNRnlE6TY6J
         ayeNiflT3Jx3UaiwTn0ixSO/q8tYotdjUG8PniJAgBrst83qSpWNRv7csHOe/KxFyPxl
         c2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RgXNYAMbUcs6zcmuuY2dAcn1cXMq8q6QuLV/FYUqj2c=;
        b=fIgmST8RZ4ZgjXs2mKVPIqiscKzbTWoqqIFIhQaM2IdkJcVk76Iblrax9WGYahv7if
         eSQGw/EloraZLT6t9ek6FT4C9HHKDUW2qXQtuW2a4hSiqnOeDWHTqc1ePhYRcmYsgnBN
         6kaINbJt+exCMknOoCVu7u45xmY8m/mNLyrLVa13Mo/xzLO69/rwtG86JKqiLyLbuAIS
         UykEp6Nprn2+nuy4YRI/mMOUK3WU+0HZTNrd4fk0TqYWfEnBcXXxMI8BB1bVTmm4va5b
         YkmrHG/XKSPxZj7yo2+pqlin/mPu+LroXXeiAI5zH4O0ZOnp42wFyYMqP3Rplx1spX0T
         0D8A==
X-Gm-Message-State: AOAM531cJK1Bryjl8LxFz4KJFDwsp0LoOo2g6STSEM76DV38g8nZuLhZ
        n8Kn7obtCcsSUzmH8W++MfWLBNk8
X-Google-Smtp-Source: ABdhPJygn0uVO2qz3lqb3y93a0gZJOTwhvFgLoTrfep5RclX+5glpeHoobCF5N3QaD+YV8Y51K47Qg==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr21129901pls.111.1593592468693;
        Wed, 01 Jul 2020 01:34:28 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id f14sm4371297pjq.36.2020.07.01.01.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:28 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: remove qcore from incore dquots
Date:   Wed, 01 Jul 2020 14:04:08 +0530
Message-ID: <2024498.XmgOc4ZnYF@garuda>
In-Reply-To: <159353178119.2864738.14352743945962585449.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353178119.2864738.14352743945962585449.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:01 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've stopped using qcore entirely, drop it from the incore
> dquot.
>

The changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/quota.c |    4 ----
>  fs/xfs/xfs_dquot.c   |   29 +++++++++--------------------
>  fs/xfs/xfs_dquot.h   |    1 -
>  3 files changed, 9 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 2fc2625feca0..f4aad5b00188 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -79,7 +79,6 @@ xchk_quota_item(
>  	struct xchk_quota_info	*sqi = priv;
>  	struct xfs_scrub	*sc = sqi->sc;
>  	struct xfs_mount	*mp = sc->mp;
> -	struct xfs_disk_dquot	*d = &dq->q_core;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	xfs_fileoff_t		offset;
>  	xfs_ino_t		fs_icount;
> @@ -98,9 +97,6 @@ xchk_quota_item(
>  
>  	sqi->last_id = dq->q_id;
>  
> -	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
> -		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> -
>  	/*
>  	 * Warn if the hard limits are larger than the fs.
>  	 * Administrators can do this, though in production this seems
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7434ee57ec43..2d6b50760962 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -529,7 +529,6 @@ xfs_dquot_from_disk(
>  	}
>  
>  	/* copy everything from disk dquot to the incore dquot */
> -	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
>  	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
>  	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
>  	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> @@ -568,8 +567,13 @@ xfs_dquot_to_disk(
>  	struct xfs_disk_dquot	*ddqp,
>  	struct xfs_dquot	*dqp)
>  {
> -	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> +	ddqp->d_version = XFS_DQUOT_VERSION;
>  	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
> +	ddqp->d_id = cpu_to_be32(dqp->q_id);
> +	ddqp->d_pad0 = 0;
> +	ddqp->d_pad = 0;
> +
>  	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
>  	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
>  	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
> @@ -1180,7 +1184,6 @@ xfs_qm_dqflush(
>  	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
>  	struct xfs_buf		*bp;
>  	struct xfs_dqblk	*dqb;
> -	struct xfs_disk_dquot	*ddqp;
>  	xfs_failaddr_t		fa;
>  	int			error;
>  
> @@ -1204,22 +1207,6 @@ xfs_qm_dqflush(
>  	if (error)
>  		goto out_abort;
>  
> -	/*
> -	 * Calculate the location of the dquot inside the buffer.
> -	 */
> -	dqb = bp->b_addr + dqp->q_bufoffset;
> -	ddqp = &dqb->dd_diskdq;
> -
> -	/* sanity check the in-core structure before we flush */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
> -	if (fa) {
> -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> -				dqp->q_id, fa);
> -		xfs_buf_relse(bp);
> -		error = -EFSCORRUPTED;
> -		goto out_abort;
> -	}
> -
>  	fa = xfs_qm_dqflush_check(dqp);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> @@ -1229,7 +1216,9 @@ xfs_qm_dqflush(
>  		goto out_abort;
>  	}
>  
> -	xfs_dquot_to_disk(ddqp, dqp);
> +	/* Flush the incore dquot to the ondisk buffer. */
> +	dqb = bp->b_addr + dqp->q_bufoffset;
> +	xfs_dquot_to_disk(&dqb->dd_diskdq, dqp);
>  
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 414bae537b1d..62b0fc6e0133 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -71,7 +71,6 @@ struct xfs_dquot {
>  	struct xfs_dquot_res	q_ino;	/* inodes */
>  	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
>  
> -	struct xfs_disk_dquot	q_core;
>  	struct xfs_dq_logitem	q_logitem;
>  
>  	xfs_qcnt_t		q_prealloc_lo_wmark;
> 
> 


-- 
chandan



