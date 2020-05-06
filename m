Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39B6C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 06:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9DD206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 06:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brLYWMkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEFGm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgEFGm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 02:42:59 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5D6C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 23:42:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t9so412560pjw.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 23:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zbx/TqIGNvdrYSH6AuZdiJa+O2TKwuirDQMeWpMnJ7s=;
        b=brLYWMkH+XcY+QVVdSZDbRoGAqSAQQLpUb/UG5WejJPl/+B9sCGMSjuOEo3N246F5R
         964SqGNSicxcUEaRo1Ad4ZqT5qV6jjeLqPNhpIllMFoFQ1yxDtcRtkixSxJHvPW0vh6x
         +lqmgQ+YpdlC4XGR68lrmUEVTTFW9pz+YVLJC1lZQBn1zVqZQXGYoKCuh/x3FMn6e3YB
         XKYlFabEfRZdZcIck56ZgBPFCX1mEIbvqUxswh7uelwO+7j/MtXMlW2HtB+AcXgvL1o7
         +drz6Y2oZmlhcuPiGnzGhWcEJrrO5Dz5Nm2j4F/2RHXInK69wbQdyas9PZtSLpxMlwjC
         LjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zbx/TqIGNvdrYSH6AuZdiJa+O2TKwuirDQMeWpMnJ7s=;
        b=ATTl+YC9YCG6wBmETijErapKFNOBssbcCJcdbWSNvE+nt6hZZosCoEYHSyuzW+AvmS
         322szJWfTPnLcxon2scXGM5iLX/qw+rYs+4lVL5Yzo6IZBPy0PvTwuGcL/b/EYeP+ezw
         fa3B5xo+v8ZHQoS0AdqLj0PXEaVpYMgTam0h4XB6l3QqtTQEgr32JdXy+PAte+x8ux/H
         PMP5RMJJgxRA+c8RUKy8FayW5OWAECmoxUjz10CrXo1cfxXutRruc7GuzPMJ26G1fLiK
         7Xvy16LnIK1z7dSZZ5MVGmSFAlbADxXtvvoRAUpMZn0nDCzIH35R89Yg/5n5R6Z+izVv
         SB1w==
X-Gm-Message-State: AGi0PuaJlbPQQZ+Um6kW/5jZ0hyeQJMyqlF89HjAuMprJmqEr3THC90a
        idkBdWUfY9kArJg0lDkXgUA=
X-Google-Smtp-Source: APiQypIENdEuyxd6I9EPQ9xeEgE38XGQ+ibtLJbXXowLmPU8dXG12kStgvQ9I8zj59mCtlMwbe+XqQ==
X-Received: by 2002:a17:902:b114:: with SMTP id q20mr5937064plr.120.1588747378438;
        Tue, 05 May 2020 23:42:58 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id gz14sm3812439pjb.42.2020.05.05.23.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 23:42:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/28] xfs: move log recovery buffer cancellation code to xfs_buf_item_recover.c
Date:   Wed, 06 May 2020 12:12:55 +0530
Message-ID: <9347340.evmPsU4ZMF@garuda>
In-Reply-To: <158864119836.182683.2865492755380039236.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864119836.182683.2865492755380039236.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:43:18 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the helpers that handle incore buffer cancellation records to
> xfs_buf_item_recover.c since they're not directly related to the main
> log recovery machinery.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c |  104 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c      |  102 ----------------------------------------
>  2 files changed, 104 insertions(+), 102 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 4ca6d47d6c95..99ec6ebbc7f4 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -23,6 +23,110 @@
>  #include "xfs_dir2.h"
>  #include "xfs_quota.h"
>  
> +/*
> + * This structure is used during recovery to record the buf log items which
> + * have been canceled and should not be replayed.
> + */
> +struct xfs_buf_cancel {
> +	xfs_daddr_t		bc_blkno;
> +	uint			bc_len;
> +	int			bc_refcount;
> +	struct list_head	bc_list;
> +};
> +
> +static struct xfs_buf_cancel *
> +xlog_find_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)
> +{
> +	struct list_head	*bucket;
> +	struct xfs_buf_cancel	*bcp;
> +
> +	if (!log->l_buf_cancel_table)
> +		return NULL;
> +
> +	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
> +	list_for_each_entry(bcp, bucket, bc_list) {
> +		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
> +			return bcp;
> +	}
> +
> +	return NULL;
> +}
> +
> +bool
> +xlog_add_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)

The users of xlog_add_buffer_cancelled() are within xfs_buf_item_recover.c and
hence this can be made static and the corresponding prototype declaration in
xfs_log_recover.h can be removed.

Other than that trivial issue everything else looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> +{
> +	struct xfs_buf_cancel	*bcp;
> +
> +	/*
> +	 * If we find an existing cancel record, this indicates that the buffer
> +	 * was cancelled multiple times.  To ensure that during pass 2 we keep
> +	 * the record in the table until we reach its last occurrence in the
> +	 * log, a reference count is kept to tell how many times we expect to
> +	 * see this record during the second pass.
> +	 */
> +	bcp = xlog_find_buffer_cancelled(log, blkno, len);
> +	if (bcp) {
> +		bcp->bc_refcount++;
> +		return false;
> +	}
> +
> +	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> +	bcp->bc_blkno = blkno;
> +	bcp->bc_len = len;
> +	bcp->bc_refcount = 1;
> +	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
> +	return true;
> +}
> +
> +/*
> + * Check if there is and entry for blkno, len in the buffer cancel record table.
> + */
> +bool
> +xlog_is_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)
> +{
> +	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
> +}
> +
> +/*
> + * Check if there is and entry for blkno, len in the buffer cancel record table,
> + * and decremented the reference count on it if there is one.
> + *
> + * Remove the cancel record once the refcount hits zero, so that if the same
> + * buffer is re-used again after its last cancellation we actually replay the
> + * changes made at that point.
> + */
> +bool
> +xlog_put_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)
> +{
> +	struct xfs_buf_cancel	*bcp;
> +
> +	bcp = xlog_find_buffer_cancelled(log, blkno, len);
> +	if (!bcp) {
> +		ASSERT(0);
> +		return false;
> +	}
> +
> +	if (--bcp->bc_refcount == 0) {
> +		list_del(&bcp->bc_list);
> +		kmem_free(bcp);
> +	}
> +	return true;
> +}
> +
> +/* log buffer item recovery */
> +
>  STATIC enum xlog_recover_reorder
>  xlog_recover_buf_reorder(
>  	struct xlog_recover_item	*item)
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a49435db3be0..0c8a1f4bf4ad 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -55,17 +55,6 @@ STATIC int
>  xlog_do_recovery_pass(
>          struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
>  
> -/*
> - * This structure is used during recovery to record the buf log items which
> - * have been canceled and should not be replayed.
> - */
> -struct xfs_buf_cancel {
> -	xfs_daddr_t		bc_blkno;
> -	uint			bc_len;
> -	int			bc_refcount;
> -	struct list_head	bc_list;
> -};
> -
>  /*
>   * Sector aligned buffer routines for buffer create/read/write/access
>   */
> @@ -1981,97 +1970,6 @@ xlog_recover_reorder_trans(
>  	return error;
>  }
>  
> -static struct xfs_buf_cancel *
> -xlog_find_buffer_cancelled(
> -	struct xlog		*log,
> -	xfs_daddr_t		blkno,
> -	uint			len)
> -{
> -	struct list_head	*bucket;
> -	struct xfs_buf_cancel	*bcp;
> -
> -	if (!log->l_buf_cancel_table)
> -		return NULL;
> -
> -	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
> -	list_for_each_entry(bcp, bucket, bc_list) {
> -		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
> -			return bcp;
> -	}
> -
> -	return NULL;
> -}
> -
> -bool
> -xlog_add_buffer_cancelled(
> -	struct xlog		*log,
> -	xfs_daddr_t		blkno,
> -	uint			len)
> -{
> -	struct xfs_buf_cancel	*bcp;
> -
> -	/*
> -	 * If we find an existing cancel record, this indicates that the buffer
> -	 * was cancelled multiple times.  To ensure that during pass 2 we keep
> -	 * the record in the table until we reach its last occurrence in the
> -	 * log, a reference count is kept to tell how many times we expect to
> -	 * see this record during the second pass.
> -	 */
> -	bcp = xlog_find_buffer_cancelled(log, blkno, len);
> -	if (bcp) {
> -		bcp->bc_refcount++;
> -		return false;
> -	}
> -
> -	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> -	bcp->bc_blkno = blkno;
> -	bcp->bc_len = len;
> -	bcp->bc_refcount = 1;
> -	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
> -	return true;
> -}
> -
> -/*
> - * Check if there is and entry for blkno, len in the buffer cancel record table.
> - */
> -bool
> -xlog_is_buffer_cancelled(
> -	struct xlog		*log,
> -	xfs_daddr_t		blkno,
> -	uint			len)
> -{
> -	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
> -}
> -
> -/*
> - * Check if there is and entry for blkno, len in the buffer cancel record table,
> - * and decremented the reference count on it if there is one.
> - *
> - * Remove the cancel record once the refcount hits zero, so that if the same
> - * buffer is re-used again after its last cancellation we actually replay the
> - * changes made at that point.
> - */
> -bool
> -xlog_put_buffer_cancelled(
> -	struct xlog		*log,
> -	xfs_daddr_t		blkno,
> -	uint			len)
> -{
> -	struct xfs_buf_cancel	*bcp;
> -
> -	bcp = xlog_find_buffer_cancelled(log, blkno, len);
> -	if (!bcp) {
> -		ASSERT(0);
> -		return false;
> -	}
> -
> -	if (--bcp->bc_refcount == 0) {
> -		list_del(&bcp->bc_list);
> -		kmem_free(bcp);
> -	}
> -	return true;
> -}
> -
>  void
>  xlog_buf_readahead(
>  	struct xlog		*log,
> 
> 


-- 
chandan



