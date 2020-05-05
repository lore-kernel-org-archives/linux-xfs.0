Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F117C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 04:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D999F20721
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 04:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGebfRfC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgEEEkk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 00:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEEkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 00:40:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BBDC061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 21:40:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so326289plr.4
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 21:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4AIs72e6biKjQelIp/OXTtTdqODAZhYH2Q+r60CU+pk=;
        b=HGebfRfCQAJNJT8vnHmWYX+VDxoqQmzywMXi4oKtOrGUk3Z74krJPoBNB3rvsyfHuF
         5pfgFWQKaEffYsHxI/PsakS1UBIiBFXhcbrtVjpQta/hM38M9txYpOzWlRJlWreiLqop
         ZmtDQ064X/LbYTyH5BtQqslK2hdG5yNurhyyvAT4f/Ps+HD0qYlfQlR4jUpj4WvKrIZK
         JGveVgxUt65xXjrjqac+kKYAGTwi+ps9lOlJdnbt8TmFNo5H/SgelZ6/ayea+DM7wxfI
         vNTr4IFkr3Lkucc/UtDhNT3ZHH9iryG0t8Wl3gugAB8w2p1zaqx7wdhGxCbqNO/K4UEA
         Gbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4AIs72e6biKjQelIp/OXTtTdqODAZhYH2Q+r60CU+pk=;
        b=F2Kbctr6JWUjJpWBSVWY8REvyzAMyLyp2TL01KYS+bXOfKaoDO71O2nNB9C0bsLTs9
         56Tjsd+h0oRMxPxctYrAS47E1sUgXR+OWWfBo4Tek0TW0pA+1cIfLb7p6U99pBrduEza
         lm2WGUcSCaOJzpXn8WbuuNDDDatyALwsrrHme4WuEJCnO4tf+244uigTQssVS8jLMIQH
         kvIzqkxOv2KoXFsDodChFrV8tnCWYQb6niKxpmFsObOzRIMDC59eeNQbe0aktbl28u/h
         IYx/ZmTEAxwFXpqYW0KjrHN+BB8ecdw0VLrMjYoxUH9EzJKBJESdro8fSRQDHathCAfi
         AyGg==
X-Gm-Message-State: AGi0PuZE+MFC+y7FF1A9MFgWCPfmqsawiwddWk+fFHsiiDCMz12R0UfM
        RrWHdAVRmrhy08JCgaMYHew=
X-Google-Smtp-Source: APiQypIg+5Q/shVyoVcrPgLbDL6vsLotUR9V17kaC/YBrlXLxmJdKHQDaYl2pbT3ELX13BKmQAln5g==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr626447pjt.62.1588653639005;
        Mon, 04 May 2020 21:40:39 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id j7sm584180pjy.9.2020.05.04.21.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 21:40:38 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/28] xfs: refactor log recovery item dispatch for pass1 commit functions
Date:   Tue, 05 May 2020 10:10:35 +0530
Message-ID: <1800837.l7pIkSRvfW@garuda>
In-Reply-To: <158864105772.182683.2888229701435255975.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864105772.182683.2888229701435255975.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:40:57 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the pass1 commit code into the per-item source code files and use
> the dispatch function to call them.
>

Buf and Quotaoff items need to be processed during pass1's commit phase. This
is correctly done in this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |    4 ++
>  fs/xfs/xfs_buf_item_recover.c   |   27 ++++++++++
>  fs/xfs/xfs_dquot_item_recover.c |   28 +++++++++++
>  fs/xfs/xfs_log_recover.c        |  101 +++++----------------------------------
>  4 files changed, 71 insertions(+), 89 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index ff80871138bb..384b70d58993 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -34,6 +34,9 @@ struct xlog_recover_item_ops {
>  
>  	/* Start readahead for pass2, if provided. */
>  	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
> +
> +	/* Do whatever work we need to do for pass1, if provided. */
> +	int (*commit_pass1)(struct xlog *log, struct xlog_recover_item *item);
>  };
>  
>  extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
> @@ -97,5 +100,6 @@ struct xlog_recover {
>  
>  void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
>  		const struct xfs_buf_ops *ops);
> +bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index a1327196b690..802f2206516d 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -42,8 +42,35 @@ xlog_recover_buf_ra_pass2(
>  	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
>  }
>  
> +/*
> + * Build up the table of buf cancel records so that we don't replay cancelled
> + * data in the second pass.
> + */
> +static int
> +xlog_recover_buf_commit_pass1(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
> +
> +	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
> +		xfs_err(log->l_mp, "bad buffer log item size (%d)",
> +				item->ri_buf[0].i_len);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (!(bf->blf_flags & XFS_BLF_CANCEL))
> +		trace_xfs_log_recover_buf_not_cancel(log, bf);
> +	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
> +		trace_xfs_log_recover_buf_cancel_add(log, bf);
> +	else
> +		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_buf_item_ops = {
>  	.item_type		= XFS_LI_BUF,
>  	.reorder		= xlog_recover_buf_reorder,
>  	.ra_pass2		= xlog_recover_buf_ra_pass2,
> +	.commit_pass1		= xlog_recover_buf_commit_pass1,
>  };
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 215274173b70..ebc44c1bc2b1 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -58,6 +58,34 @@ const struct xlog_recover_item_ops xlog_dquot_item_ops = {
>  	.ra_pass2		= xlog_recover_dquot_ra_pass2,
>  };
>  
> +/*
> + * Recover QUOTAOFF records. We simply make a note of it in the xlog
> + * structure, so that we know not to do any dquot item or dquot buffer recovery,
> + * of that type.
> + */
> +STATIC int
> +xlog_recover_quotaoff_commit_pass1(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[0].i_addr;
> +	ASSERT(qoff_f);
> +
> +	/*
> +	 * The logitem format's flag tells us if this was user quotaoff,
> +	 * group/project quotaoff or both.
> +	 */
> +	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> +		log->l_quotaoffs_flag |= XFS_DQ_USER;
> +	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> +		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
> +	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> +		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
> +
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
>  	.item_type		= XFS_LI_QUOTAOFF,
> +	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ea566747d8e1..b3627ebf870e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1953,7 +1953,7 @@ xlog_find_buffer_cancelled(
>  	return NULL;
>  }
>  
> -static bool
> +bool
>  xlog_add_buffer_cancelled(
>  	struct xlog		*log,
>  	xfs_daddr_t		blkno,
> @@ -2034,32 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * Build up the table of buf cancel records so that we don't replay cancelled
> - * data in the second pass.
> - */
> -static int
> -xlog_recover_buffer_pass1(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
> -
> -	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
> -		xfs_err(log->l_mp, "bad buffer log item size (%d)",
> -				item->ri_buf[0].i_len);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	if (!(bf->blf_flags & XFS_BLF_CANCEL))
> -		trace_xfs_log_recover_buf_not_cancel(log, bf);
> -	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
> -		trace_xfs_log_recover_buf_cancel_add(log, bf);
> -	else
> -		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
> -	return 0;
> -}
> -
>  /*
>   * Perform recovery for a buffer full of inodes.  In these buffers, the only
>   * data which should be recovered is that which corresponds to the
> @@ -3197,33 +3171,6 @@ xlog_recover_inode_pass2(
>  	return error;
>  }
>  
> -/*
> - * Recover QUOTAOFF records. We simply make a note of it in the xlog
> - * structure, so that we know not to do any dquot item or dquot buffer recovery,
> - * of that type.
> - */
> -STATIC int
> -xlog_recover_quotaoff_pass1(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
> -	ASSERT(qoff_f);
> -
> -	/*
> -	 * The logitem format's flag tells us if this was user quotaoff,
> -	 * group/project quotaoff or both.
> -	 */
> -	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DQ_USER;
> -	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
> -	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
> -
> -	return 0;
> -}
> -
>  /*
>   * Recover a dquot record
>   */
> @@ -3890,40 +3837,6 @@ xlog_recover_do_icreate_pass2(
>  				     length, be32_to_cpu(icl->icl_gen));
>  }
>  
> -STATIC int
> -xlog_recover_commit_pass1(
> -	struct xlog			*log,
> -	struct xlog_recover		*trans,
> -	struct xlog_recover_item	*item)
> -{
> -	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
> -
> -	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_BUF:
> -		return xlog_recover_buffer_pass1(log, item);
> -	case XFS_LI_QUOTAOFF:
> -		return xlog_recover_quotaoff_pass1(log, item);
> -	case XFS_LI_INODE:
> -	case XFS_LI_EFI:
> -	case XFS_LI_EFD:
> -	case XFS_LI_DQUOT:
> -	case XFS_LI_ICREATE:
> -	case XFS_LI_RUI:
> -	case XFS_LI_RUD:
> -	case XFS_LI_CUI:
> -	case XFS_LI_CUD:
> -	case XFS_LI_BUI:
> -	case XFS_LI_BUD:
> -		/* nothing to do in pass 1 */
> -		return 0;
> -	default:
> -		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> -			__func__, ITEM_TYPE(item));
> -		ASSERT(0);
> -		return -EFSCORRUPTED;
> -	}
> -}
> -
>  STATIC int
>  xlog_recover_commit_pass2(
>  	struct xlog			*log,
> @@ -4021,9 +3934,19 @@ xlog_recover_commit_trans(
>  		return error;
>  
>  	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
> +		trace_xfs_log_recover_item_recover(log, trans, item, pass);
> +
> +		if (!item->ri_ops) {
> +			xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> +				__func__, ITEM_TYPE(item));
> +			ASSERT(0);
> +			return -EFSCORRUPTED;
> +		}
> +
>  		switch (pass) {
>  		case XLOG_RECOVER_PASS1:
> -			error = xlog_recover_commit_pass1(log, trans, item);
> +			if (item->ri_ops->commit_pass1)
> +				error = item->ri_ops->commit_pass1(log, item);
>  			break;
>  		case XLOG_RECOVER_PASS2:
>  			if (item->ri_ops->ra_pass2)
> 
> 


-- 
chandan



