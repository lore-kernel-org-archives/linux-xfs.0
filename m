Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBB4C4724C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 03:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CE6206D7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 03:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HJb5x5Ie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgEEDd3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 23:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 23:33:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09112C061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 20:33:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 207so421106pgc.6
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 20:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26/8kzQWl+S/LLxVh0eQpS7ObviU7spgX1jADHBlvDM=;
        b=HJb5x5IeQowRPspO82RD1IZ8yF+8iJ7LfNbzEGWiiPg38xeW99P5ubxSKzYE9x+h98
         YWi5nVPfWua8NSmVYwXlIjhzOIANGftCYq6s0jS5qL1wwBdnOmz+K41BrIDURorvCr/A
         t/z7w2OGhLGowsFO2rakGwD5TXg5dLF82Q2f3lLS8xa5XXvxYIM2xUo6zBkzhR/UPucM
         qC7L0UboMijsAEhUUHaeO2AE+jFlhVnnX7ur1zeCQxBjzaWiVpq++EOCz7cd55f0PtI8
         1PU7F6PpfxCP/bqs7mhYux5gbMq2PNNqyiMJSH+oJT7GINB+BSPe7maoUdpZRfLcZHFQ
         Gx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26/8kzQWl+S/LLxVh0eQpS7ObviU7spgX1jADHBlvDM=;
        b=ZrBkFqtrSgNAeMuuR/eNIDjgQm+RvWNMPOiyF4Noy4Zw95KU4KCBWfp5tt2/n3JBHq
         JRmXi8HGt8MBqOCm/twYtaUWfT27OiRDG9YYB2cCM1rwhPIRuwYefxH2POAPpSPMIkV6
         7slKredMZ9wWdJkD8IlAV402Ing19qPgAr1NLQeZvT3zSC+Te4eobRizJbOeUwdfU6he
         pPFab8VqJzbi6DBhLg7NbJAlwtLBOvStTflNXtsl4q1+e9I1DE7mv4l4DIcDxx76SAiN
         rynwwnAFp+rFcxDmqjP9c+iLsminVqzPbmFgW630F1eFlcPrJVwBvML1gPIvJ8XOuzrL
         mLAQ==
X-Gm-Message-State: AGi0PuYwCmQ5gwJv331kTqghw+9pgMdpRELhRdzNSyaIqoueQ/yxGG0I
        G/Kkx3qSq728A0beJgAQY8AnX5aqYxQ=
X-Google-Smtp-Source: APiQypLfgTxC34Z3fNLTaltQDWjQaqD/Y799cDNjs6Ruyzs0vIatF9usBLkCXNFs1IqBd92hh39CDg==
X-Received: by 2002:a63:340e:: with SMTP id b14mr1285752pga.290.1588649608374;
        Mon, 04 May 2020 20:33:28 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id f4sm434280pgd.0.2020.05.04.20.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 20:33:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/28] xfs: convert xfs_log_recover_item_t to struct xfs_log_recover_item
Date:   Tue, 05 May 2020 09:03:24 +0530
Message-ID: <1743750.cGs67GFofp@garuda>
In-Reply-To: <158864103888.182683.1949900429505759832.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864103888.182683.1949900429505759832.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:40:39 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the old typedefs.
>

Straight forward change.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |    4 ++--
>  fs/xfs/xfs_log_recover.c        |   26 ++++++++++++++------------
>  2 files changed, 16 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 3bf671637a91..148e0cb5d379 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -22,13 +22,13 @@
>  /*
>   * item headers are in ri_buf[0].  Additional buffers follow.
>   */
> -typedef struct xlog_recover_item {
> +struct xlog_recover_item {
>  	struct list_head	ri_list;
>  	int			ri_type;
>  	int			ri_cnt;	/* count of regions found */
>  	int			ri_total;	/* total regions */
>  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> -} xlog_recover_item_t;
> +};
>  
>  struct xlog_recover {
>  	struct hlist_node	r_list;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d0e2dd81de53..c2c06f70fb8a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1841,7 +1841,7 @@ xlog_recover_reorder_trans(
>  	struct xlog_recover	*trans,
>  	int			pass)
>  {
> -	xlog_recover_item_t	*item, *n;
> +	struct xlog_recover_item *item, *n;
>  	int			error = 0;
>  	LIST_HEAD(sort_list);
>  	LIST_HEAD(cancel_list);
> @@ -2056,7 +2056,7 @@ xlog_recover_buffer_pass1(
>  STATIC int
>  xlog_recover_do_inode_buffer(
>  	struct xfs_mount	*mp,
> -	xlog_recover_item_t	*item,
> +	struct xlog_recover_item *item,
>  	struct xfs_buf		*bp,
>  	xfs_buf_log_format_t	*buf_f)
>  {
> @@ -2561,7 +2561,7 @@ xlog_recover_validate_buf_type(
>  STATIC void
>  xlog_recover_do_reg_buffer(
>  	struct xfs_mount	*mp,
> -	xlog_recover_item_t	*item,
> +	struct xlog_recover_item *item,
>  	struct xfs_buf		*bp,
>  	xfs_buf_log_format_t	*buf_f,
>  	xfs_lsn_t		current_lsn)
> @@ -3759,7 +3759,7 @@ STATIC int
>  xlog_recover_do_icreate_pass2(
>  	struct xlog		*log,
>  	struct list_head	*buffer_list,
> -	xlog_recover_item_t	*item)
> +	struct xlog_recover_item *item)
>  {
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_icreate_log	*icl;
> @@ -4134,9 +4134,9 @@ STATIC void
>  xlog_recover_add_item(
>  	struct list_head	*head)
>  {
> -	xlog_recover_item_t	*item;
> +	struct xlog_recover_item *item;
>  
> -	item = kmem_zalloc(sizeof(xlog_recover_item_t), 0);
> +	item = kmem_zalloc(sizeof(struct xlog_recover_item), 0);
>  	INIT_LIST_HEAD(&item->ri_list);
>  	list_add_tail(&item->ri_list, head);
>  }
> @@ -4148,7 +4148,7 @@ xlog_recover_add_to_cont_trans(
>  	char			*dp,
>  	int			len)
>  {
> -	xlog_recover_item_t	*item;
> +	struct xlog_recover_item *item;
>  	char			*ptr, *old_ptr;
>  	int			old_len;
>  
> @@ -4171,7 +4171,8 @@ xlog_recover_add_to_cont_trans(
>  	}
>  
>  	/* take the tail entry */
> -	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
> +	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
> +			  ri_list);
>  
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
> @@ -4205,7 +4206,7 @@ xlog_recover_add_to_trans(
>  	int			len)
>  {
>  	struct xfs_inode_log_format	*in_f;			/* any will do */
> -	xlog_recover_item_t	*item;
> +	struct xlog_recover_item *item;
>  	char			*ptr;
>  
>  	if (!len)
> @@ -4241,13 +4242,14 @@ xlog_recover_add_to_trans(
>  	in_f = (struct xfs_inode_log_format *)ptr;
>  
>  	/* take the tail entry */
> -	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
> +	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
> +			  ri_list);
>  	if (item->ri_total != 0 &&
>  	     item->ri_total == item->ri_cnt) {
>  		/* tail item is in use, get a new one */
>  		xlog_recover_add_item(&trans->r_itemq);
>  		item = list_entry(trans->r_itemq.prev,
> -					xlog_recover_item_t, ri_list);
> +					struct xlog_recover_item, ri_list);
>  	}
>  
>  	if (item->ri_total == 0) {		/* first region to be added */
> @@ -4293,7 +4295,7 @@ STATIC void
>  xlog_recover_free_trans(
>  	struct xlog_recover	*trans)
>  {
> -	xlog_recover_item_t	*item, *n;
> +	struct xlog_recover_item *item, *n;
>  	int			i;
>  
>  	hlist_del_init(&trans->r_list);
> 
> 


-- 
chandan



