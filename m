Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB6AC83001
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 05:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C67120784
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 05:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWozocA5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgD3FxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 01:53:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53AC035494
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 22:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=imz2ubu/S8AxJIUi/QPRLW2wMncAWwD/1D3J8MUwkQ0=; b=jWozocA5FWuTmYEDfRQ0Qc6WUM
        QNvE4DmrONqvSQC9LzDPQj1zHZ/cfGjehW7dgRzCYw+7da2T34K6UhbDKMHsdQ2HyhDbcOf6dXI8k
        c7+MqH5A556NZbedHOJxizu1TF7LeCVHhO8jxwOsc/igD9EUQlTBT4sBIjQUjvvetZMoNUMjKSLCf
        c0BfComZrCDy0JMeyb/JXMho7xn/d9xSnfwLK5Mhoag2J7xMUuF9Kas06vOCySl0HVJKtErBfhw8T
        AKsLfPUcezEzi4ggsw3W4wp+aZK35kkGIygs1eFvOyUF5x1+EZqDBoMUFyLFnthpICTM9BnYqIwZq
        cM6fXzLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jU28D-0002Ta-IW; Thu, 30 Apr 2020 05:53:09 +0000
Date:   Wed, 29 Apr 2020 22:53:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/21] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200430055309.GA29110@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820766135.467894.13993542565087629835.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158820766135.467894.13993542565087629835.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:47:41PM -0700, Darrick J. Wong wrote:
> +extern const struct xlog_recover_item_type xlog_icreate_item_type;
> +extern const struct xlog_recover_item_type xlog_buf_item_type;
> +extern const struct xlog_recover_item_type xlog_inode_item_type;
> +extern const struct xlog_recover_item_type xlog_dquot_item_type;
> +extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
> +extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
> +extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
> +extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
> +extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_refcount_done_item_type;

I'd prefer if we didn't have to expose these structures, but had a
xlog_register_recovery_item helper that just adds them to a list or
array.

>  typedef struct xlog_recover_item {
>  	struct list_head	ri_list;
> -	int			ri_type;
>  	int			ri_cnt;	/* count of regions found */
>  	int			ri_total;	/* total regions */
>  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> +	const struct xlog_recover_item_type *ri_type;
>  } xlog_recover_item_t;

Btw, killing the xlog_recover_item_t typedef might be a worthwhile prep
patch.

> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -17,7 +17,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  
> -
>  kmem_zone_t	*xfs_buf_item_zone;
>  
>  static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)

Spurious whitespace change in a file not otherwise touched.

>  
> @@ -107,3 +109,14 @@ xfs_icreate_log(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
>  }
> +
> +static enum xlog_recover_reorder
> +xlog_icreate_reorder(
> +		struct xlog_recover_item *item)
> +{
> +	return XLOG_REORDER_BUFFER_LIST;
> +}

It might be worth to throw in a comment why icreate items got to
the buffer list.

> +		return 0;
> +#ifdef CONFIG_XFS_QUOTA
> +	case XFS_LI_DQUOT:
> +		item->ri_type = &xlog_dquot_item_type;
> +		return 0;
> +	case XFS_LI_QUOTAOFF:
> +		item->ri_type = &xlog_quotaoff_item_type;
> +		return 0;
> +#endif /* CONFIG_XFS_QUOTA */
> +	default:
> +		return -EFSCORRUPTED;
> +	}
> +}

Quote recovery support currently is unconditionalẏ  Making it
conditional on CONFIG_XFS_QUOTA means a kernel without that config
will now fail to recover a file system with quota updates in the log.
