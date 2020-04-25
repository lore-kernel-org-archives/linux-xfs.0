Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAD1C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF2B20714
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FFTNH2Q4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgDYSTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYST3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:19:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0232C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4SmjeEW3z60SM7z9Sm9rCikgPYAHFoeQR112jOI3S0Y=; b=FFTNH2Q4UuttuiqDvWVEWYl8lM
        zKdSECtP2MtRz0H+CnEbEzPVr9kPXAw993AhU3cxHf+wVYxFMZQsgsnbQi79xbKy5oq996kX5AFPY
        nZn7l3UWlcdmA6zIv21ieE4OYkOxokbrnn9NkZPHBAkh0D+psa/Gc6puJE9yiXgNugMdFdKJlrRKt
        pBy39F84bvs5P2lALZAqjWQ5VIDuopcYi2LxXO8utgcZDJ1h+7tXK/nTbv/+IAL5T0GXpXNWOc4jA
        lTFXBuXsiVvwrmz3RWgtYUsxW+xNlPd8ZlTu/WSO17fFnn/ajVZn8aNfrELfvmXl1+Y5JqBK0ApRs
        9gg17ZmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPOj-0006he-KK; Sat, 25 Apr 2020 18:19:29 +0000
Date:   Sat, 25 Apr 2020 11:19:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/19] xfs: refactor log recovery item dispatch for pass2
 readhead functions
Message-ID: <20200425181929.GB16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752118180.2140829.13805128567366066982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752118180.2140829.13805128567366066982.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:21PM -0700, Darrick J. Wong wrote:
>  typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
>  		struct xlog_recover_item *item);
> +typedef void (*xlog_recover_ra_pass2_fn)(struct xlog *log,
> +		struct xlog_recover_item *item);

Same comment for this one - or the other two following.

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
> +struct xfs_buf_cancel *xlog_peek_buffer_cancelled(struct xlog *log,
> +		xfs_daddr_t blkno, uint len, unsigned short flags);

None of the callers moved in this patch even needs the xfs_buf_cancel
structure, it just uses the return value as a boolean.  I think they
all should be switched to use xlog_check_buffer_cancelled instead, which
means that struct xfs_buf_cancel and xlog_peek_buffer_cancelled can stay
private in xfs_log_recovery.c (and later xfs_buf_item.c).

> +STATIC void
> +xlog_recover_buffer_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> +	struct xfs_mount		*mp = log->l_mp;
> +
> +	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
> +			buf_f->blf_len, buf_f->blf_flags)) {
> +		return;
> +	}
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
> +				buf_f->blf_len, NULL);

Why not:

	if (!xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
			buf_f->blf_len, buf_f->blf_flags)) {
		xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
				buf_f->blf_len, NULL);
	}

> +STATIC void
> +xlog_recover_dquot_ra_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_disk_dquot	*recddq;
> +	struct xfs_dq_logformat	*dq_f;
> +	uint			type;
> +	int			len;
> +
> +
> +	if (mp->m_qflags == 0)

Double empty line above.

> +	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
> +		return;
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
> +			  &xfs_dquot_buf_ra_ops);

Same comment as above, no real need for the early return here.

> +	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
> +		return;
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
> +				ilfp->ilf_len, &xfs_inode_buf_ra_ops);

Here again.

> -	unsigned short			flags)
> +	unsigned short		flags)

Spurious whitespace change.

>  		case XLOG_RECOVER_PASS2:
> -			xlog_recover_ra_pass2(log, item);
> +			if (item->ri_type && item->ri_type->ra_pass2_fn)
> +				item->ri_type->ra_pass2_fn(log, item);

Shouldn't we ensure eatly on that we always have a valid ->ri_type?
