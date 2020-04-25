Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF32C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F0EC2072B
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ftFmUq+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDYSNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbgDYSNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:13:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78800C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=XlAzvKGjpP+3g724ItBGTL/PGICMIkq6feqcJEIZVfg=; b=ftFmUq+O3krhanyAj9FbRvwZeu
        I1obqYxwyrFz+VkvMJa3MOdH7hza5QTWKArvQomfxyn7OQ5crWY3+5LuvtiAd2oTRADmDHK0i5gDV
        UTSjxGEy5f5ZqHnCcRLTK73acxk3oqQwv2mjlQjljC4h6jHT7WbSTP7+jOY0HrxzmtonUWv7oCqc1
        GdLjuvvSi5ZBFpocn56tHAShtUInbynGfJMEXx4FJ6cLY2e+EuX7BhSgHIrqs2LadtinJFN4WAiZZ
        YWF2Q14NlBfN3OWXnUUiieLNcPy/hSGlOBLSPzFkhEwO2F25q+tTIKMiipKiMXRtdKKe+xYhpZxSo
        rACs4Qeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPIZ-0002kd-3I; Sat, 25 Apr 2020 18:13:07 +0000
Date:   Sat, 25 Apr 2020 11:13:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/19] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200425181307.GA16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752117554.2140829.4901314701479350791.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158752117554.2140829.4901314701479350791.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +
> +/* Sorting hat for log items as they're read in. */
> +enum xlog_recover_reorder {
> +	XLOG_REORDER_UNKNOWN,
> +	XLOG_REORDER_BUFFER_LIST,
> +	XLOG_REORDER_CANCEL_LIST,
> +	XLOG_REORDER_INODE_BUFFER_LIST,
> +	XLOG_REORDER_INODE_LIST,

XLOG_REORDER_INODE_LIST seems a bit misnamed as it really is the
"misc" or "no reorder" list.  I guess the naming comes from the
local inode_list variable, but maybe we need to fix that as well?

> +typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
> +		struct xlog_recover_item *item);

This typedef doesn't actually seem to help with anything (neither
with just thіs patch nor the final tree).

> +
> +struct xlog_recover_item_type {
> +	/*
> +	 * These two items decide how to sort recovered log items during
> +	 * recovery.  If reorder_fn is non-NULL it will be called; otherwise,
> +	 * reorder will be used to decide.  See the comment above
> +	 * xlog_recover_reorder_trans for more details about what the values
> +	 * mean.
> +	 */
> +	enum xlog_recover_reorder	reorder;
> +	xlog_recover_reorder_fn		reorder_fn;

I'd just use reorder_fn and skip the simple field.  Just one way to do
things even if it adds a tiny amount of boilerplate code.

> +	case XFS_LI_INODE:
> +		return &xlog_inode_item_type;
> +	case XFS_LI_DQUOT:
> +		return &xlog_dquot_item_type;
> +	case XFS_LI_QUOTAOFF:
> +		return &xlog_quotaoff_item_type;
> +	case XFS_LI_IUNLINK:
> +		/* Not implemented? */

Not implemented!  I think we need a prep patch to remove this first.

> @@ -1851,41 +1890,34 @@ xlog_recover_reorder_trans(
>  
>  	list_splice_init(&trans->r_itemq, &sort_list);
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> -		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
> +		enum xlog_recover_reorder	fate = XLOG_REORDER_UNKNOWN;
> +
> +		item->ri_type = xlog_item_for_type(ITEM_TYPE(item));

I wonder if just passing the whole item to xlog_item_for_type would
make more sense.  It would then need a different name, of course.

> +		if (item->ri_type) {
> +			if (item->ri_type->reorder_fn)
> +				fate = item->ri_type->reorder_fn(item);
> +			else
> +				fate = item->ri_type->reorder;
> +		}

I think for the !item->ri_type we should immediately jump to what
currently is the XLOG_REORDER_UNKNOWN case, and thus avoid even
adding XLOG_REORDER_UNKNOWN to the enum.  The added benefit is that
any item without a reorder_fn could then be treated as on what
currently is the inode_list, but needs a btter name.
