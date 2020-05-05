Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB04C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 05:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219B120721
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 05:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ozbAWsUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgEEFNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 01:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEFNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 01:13:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A75C061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 22:13:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r14so343757pfg.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pisyCFdmPOEdjip42q13csQGWaesagwgD7CnO8NC2g=;
        b=ozbAWsUVzuschMGwwqrxlW1oEXJWyO1CfgaggQXAUXQ9Ob0Cbz7MaesrURUhts++ps
         LEupB6HNpo04OHVsMQrTvHgqE/1A6ijhC04djE3BtGbTPGIYizHI/BS4A/yALeXYm5+D
         SE9Bk27AFSh3Jef+DqR32jJg9BtRPZ6aULUvwOVqj9frZQZlNsTLpgktfk3vmz10OX0F
         XilG9gNY4ro07HOAFy5prLEB3Tp1Y9EM9R+W/Rz84uv+EhaK3FHNshp32IMHKv6PjLgx
         MbTXV08yvZOxVIoCJvbEdv3ZMYQpiMmHG9BhansDHjpOUJBrt719pBrZAySJoxTCduyp
         THzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pisyCFdmPOEdjip42q13csQGWaesagwgD7CnO8NC2g=;
        b=abW1tgZiUMdbiPNtqDnFVeojcGHnG8CQcddhw9OsDyAgzROZYGjRnCICXUG5y9+yMc
         Scp/1G3yxLw8+tF4VUdG10ZgUgTASudFlUCF0Vju+EB6Qi9ecELICQNzU1xpfJseW1/d
         s+IG0aGlNg3+qhSDUK405JDD02IelibWmHsuHEyx7mWz711ZzW3Macv4EQqZS3Q8smWC
         qsjIykiOUWWoLfLB3SilDcu5x7HwV1p+I4XPDMoFTGBJU1rJdlKQPPxMh/bBSm4/dKF6
         FIivB9wAOZYtseXXoqX+y7Y2BImz78xKVLqcRkeb8Q7+JCTxJ8KfyJCNOYNhkq4/oCJC
         Qy7Q==
X-Gm-Message-State: AGi0Pubzc5xr7ozYGCGthz+FNBfh9De6hyBXnkkxzNKynKXoPEBAPOAu
        C6AIx6wBYEX9f+qsY8SNoEo=
X-Google-Smtp-Source: APiQypKFTw6cY4i5uP5cf271oACwp1BwmCRJw40p06KVonR2esG0EogEWNSRUMhlEGFYFu6BQcB3xw==
X-Received: by 2002:a62:6385:: with SMTP id x127mr1524905pfb.276.1588655583609;
        Mon, 04 May 2020 22:13:03 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id mj4sm653903pjb.0.2020.05.04.22.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 22:13:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/28] xfs: refactor log recovery dquot item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 10:43:00 +0530
Message-ID: <1886011.3tpDpypnGq@garuda>
In-Reply-To: <158864107657.182683.4148915999591482647.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864107657.182683.4148915999591482647.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:16 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log dquot item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.
>

Dquot item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot_item_recover.c |  109 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c        |  112 ---------------------------------------
>  2 files changed, 109 insertions(+), 112 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index ebc44c1bc2b1..07ff943972a3 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -53,9 +53,118 @@ xlog_recover_dquot_ra_pass2(
>  			&xfs_dquot_buf_ra_ops);
>  }
>  
> +/*
> + * Recover a dquot record
> + */
> +STATIC int
> +xlog_recover_dquot_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			current_lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_buf			*bp;
> +	struct xfs_disk_dquot		*ddq, *recddq;
> +	struct xfs_dq_logformat		*dq_f;
> +	xfs_failaddr_t			fa;
> +	int				error;
> +	uint				type;
> +
> +	/*
> +	 * Filesystems are required to send in quota flags at mount time.
> +	 */
> +	if (mp->m_qflags == 0)
> +		return 0;
> +
> +	recddq = item->ri_buf[1].i_addr;
> +	if (recddq == NULL) {
> +		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
> +		return -EFSCORRUPTED;
> +	}
> +	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
> +		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
> +			item->ri_buf[1].i_len, __func__);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/*
> +	 * This type of quotas was turned off, so ignore this record.
> +	 */
> +	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> +	ASSERT(type);
> +	if (log->l_quotaoffs_flag & type)
> +		return 0;
> +
> +	/*
> +	 * At this point we know that quota was _not_ turned off.
> +	 * Since the mount flags are not indicating to us otherwise, this
> +	 * must mean that quota is on, and the dquot needs to be replayed.
> +	 * Remember that we may not have fully recovered the superblock yet,
> +	 * so we can't do the usual trick of looking at the SB quota bits.
> +	 *
> +	 * The other possibility, of course, is that the quota subsystem was
> +	 * removed since the last mount - ENOSYS.
> +	 */
> +	dq_f = item->ri_buf[0].i_addr;
> +	ASSERT(dq_f);
> +	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> +	if (fa) {
> +		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
> +				dq_f->qlf_id, fa);
> +		return -EFSCORRUPTED;
> +	}
> +	ASSERT(dq_f->qlf_len == 1);
> +
> +	/*
> +	 * At this point we are assuming that the dquots have been allocated
> +	 * and hence the buffer has valid dquots stamped in it. It should,
> +	 * therefore, pass verifier validation. If the dquot is bad, then the
> +	 * we'll return an error here, so we don't need to specifically check
> +	 * the dquot in the buffer after the verifier has run.
> +	 */
> +	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
> +				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
> +				   &xfs_dquot_buf_ops);
> +	if (error)
> +		return error;
> +
> +	ASSERT(bp);
> +	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
> +
> +	/*
> +	 * If the dquot has an LSN in it, recover the dquot only if it's less
> +	 * than the lsn of the transaction we are replaying.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> +		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
> +
> +		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> +			goto out_release;
> +		}
> +	}
> +
> +	memcpy(ddq, recddq, item->ri_buf[1].i_len);
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
> +				 XFS_DQUOT_CRC_OFF);
> +	}
> +
> +	ASSERT(dq_f->qlf_size == 2);
> +	ASSERT(bp->b_mount == mp);
> +	bp->b_iodone = xlog_recover_iodone;
> +	xfs_buf_delwri_queue(bp, buffer_list);
> +
> +out_release:
> +	xfs_buf_relse(bp);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_dquot_item_ops = {
>  	.item_type		= XFS_LI_DQUOT,
>  	.ra_pass2		= xlog_recover_dquot_ra_pass2,
> +	.commit_pass2		= xlog_recover_dquot_commit_pass2,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cb5902550e8c..ea2a53b614c7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,115 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * Recover a dquot record
> - */
> -STATIC int
> -xlog_recover_dquot_pass2(
> -	struct xlog			*log,
> -	struct list_head		*buffer_list,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			current_lsn)
> -{
> -	xfs_mount_t		*mp = log->l_mp;
> -	xfs_buf_t		*bp;
> -	struct xfs_disk_dquot	*ddq, *recddq;
> -	xfs_failaddr_t		fa;
> -	int			error;
> -	xfs_dq_logformat_t	*dq_f;
> -	uint			type;
> -
> -
> -	/*
> -	 * Filesystems are required to send in quota flags at mount time.
> -	 */
> -	if (mp->m_qflags == 0)
> -		return 0;
> -
> -	recddq = item->ri_buf[1].i_addr;
> -	if (recddq == NULL) {
> -		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
> -		return -EFSCORRUPTED;
> -	}
> -	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
> -		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
> -			item->ri_buf[1].i_len, __func__);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	/*
> -	 * This type of quotas was turned off, so ignore this record.
> -	 */
> -	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> -	ASSERT(type);
> -	if (log->l_quotaoffs_flag & type)
> -		return 0;
> -
> -	/*
> -	 * At this point we know that quota was _not_ turned off.
> -	 * Since the mount flags are not indicating to us otherwise, this
> -	 * must mean that quota is on, and the dquot needs to be replayed.
> -	 * Remember that we may not have fully recovered the superblock yet,
> -	 * so we can't do the usual trick of looking at the SB quota bits.
> -	 *
> -	 * The other possibility, of course, is that the quota subsystem was
> -	 * removed since the last mount - ENOSYS.
> -	 */
> -	dq_f = item->ri_buf[0].i_addr;
> -	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> -	if (fa) {
> -		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
> -				dq_f->qlf_id, fa);
> -		return -EFSCORRUPTED;
> -	}
> -	ASSERT(dq_f->qlf_len == 1);
> -
> -	/*
> -	 * At this point we are assuming that the dquots have been allocated
> -	 * and hence the buffer has valid dquots stamped in it. It should,
> -	 * therefore, pass verifier validation. If the dquot is bad, then the
> -	 * we'll return an error here, so we don't need to specifically check
> -	 * the dquot in the buffer after the verifier has run.
> -	 */
> -	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
> -				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
> -				   &xfs_dquot_buf_ops);
> -	if (error)
> -		return error;
> -
> -	ASSERT(bp);
> -	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
> -
> -	/*
> -	 * If the dquot has an LSN in it, recover the dquot only if it's less
> -	 * than the lsn of the transaction we are replaying.
> -	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> -		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
> -
> -		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> -			goto out_release;
> -		}
> -	}
> -
> -	memcpy(ddq, recddq, item->ri_buf[1].i_len);
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
> -				 XFS_DQUOT_CRC_OFF);
> -	}
> -
> -	ASSERT(dq_f->qlf_size == 2);
> -	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> -	xfs_buf_delwri_queue(bp, buffer_list);
> -
> -out_release:
> -	xfs_buf_relse(bp);
> -	return 0;
> -}
> -
>  /*
>   * This routine is called to create an in-core extent free intent
>   * item from the efi format structure which was logged on disk.
> @@ -2730,9 +2621,6 @@ xlog_recover_commit_pass2(
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
>  		return xlog_recover_bud_pass2(log, item);
> -	case XFS_LI_DQUOT:
> -		return xlog_recover_dquot_pass2(log, buffer_list, item,
> -						trans->r_lsn);
>  	case XFS_LI_ICREATE:
>  		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
>  	case XFS_LI_QUOTAOFF:
> 
> 


-- 
chandan



