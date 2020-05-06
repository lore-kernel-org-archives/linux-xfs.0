Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B22C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6277620936
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GvRm1pIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEFPDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgEFPDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:03:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8967FC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H7gFft82/wiobGo9xbIwalWMgeoHzLtlqBF+HQITpxg=; b=GvRm1pIPeuMqeHCJKJgRLe9XU9
        5vf0XCuxlCdRa3GJBK416PzzJB0VsI3OVLcUfOxnL2kcsjd3dht5Mpfx39h3wn8WR+4QUpWCQTS1H
        eD/inhV/Cge9YZT1lDmRj88fkHggo2H3WX8UNB5PO9tYOsf24ZT5JC7LnIkY+C4YcJvkBWeJRBDDA
        tCurDZavvWFZH/FU/39rkn6HO5SAY7e7hIyQI6uVkqaS8snd4ABFs3ndiMDBzgrHoL4aE4lWM6FUR
        qZk3XfsIKqAHjmwJl6KLYEQMuY2ZGbOEgh4Q2uhFiXfGDwtN5D2blhI+hntOVPUDRlXSDp0zk7UcM
        uOrQAZ/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLa0-0001ea-7i; Wed, 06 May 2020 15:03:24 +0000
Date:   Wed, 6 May 2020 08:03:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/28] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200506150324.GE7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864104502.182683.672673211897001126.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864104502.182683.672673211897001126.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:45PM -0700, Darrick J. Wong wrote:
> +const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
> +	.item_type		= XFS_LI_BUI,
> +};
> +
> +const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
> +	.item_type		= XFS_LI_BUD,
> +};

Pretty much everything else in this file seems to use bui/bud names.
The same also applies to the four other intent/done pairs and their
shortnames.  Not really a major thing, but it might be worth fixing
to fit the flow.

> +STATIC enum xlog_recover_reorder
> +xlog_recover_buf_reorder(
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> +
> +	if (buf_f->blf_flags & XFS_BLF_CANCEL)
> +		return XLOG_REORDER_CANCEL_LIST;
> +	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> +		return XLOG_REORDER_INODE_BUFFER_LIST;
> +	return XLOG_REORDER_BUFFER_LIST;
> +}

While you split this out a comment explaining the reordering would
be nice here.

Otherwise this looks great:

Reviewed-by: Christoph Hellwig <hch@lst.de>
