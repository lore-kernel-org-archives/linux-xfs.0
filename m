Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937F3C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 706DF2070A
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RhR7w+18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgEWLfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 07:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgEWLfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 07:35:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673EDC061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 04:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=diX8MKdks28DOTlgm0koYCql8N3EeV6C6voCpfuDFWc=; b=RhR7w+189J7vWxAXrC+BmwbhQ4
        BEO72VYewxiFPUw31CIqfgAYw3vGILca4ygix3QZ2CEW9jwHB43mO36AjZrjozoBAfv6o379P7bzz
        8FqiSlZZK0qua5SmlRbu5yo0Dia4RAKeWHMiucGKzohUOwEPWRmsSSVoZldBIsmfmRHCV3vWe5isc
        gDJ3xehUEpGrRiSNqcj4UmxiBpl/xEUDlaBHPKgL+EJLdlTF2Xegw9f1fbeyH6Pp1kZcTV8dYkh4E
        ur47FllrxbNmcl3EftJOwp8iAXrUgbKxLHCmRRilyFhH83EY9qwcYEt6IEPuhaDE2giyhYP9XjfMB
        /4MJiLbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcSQz-0006AL-A2; Sat, 23 May 2020 11:35:21 +0000
Date:   Sat, 23 May 2020 04:35:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] xfs: factor xfs_iflush_done
Message-ID: <20200523113521.GB1421@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-24-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:28PM +1000, Dave Chinner wrote:
> +xfs_iflush_ail_updates(
> +	struct xfs_ail		*ailp,
> +	struct list_head	*list)
>  {
> +	struct xfs_log_item	*lip;
> +	xfs_lsn_t		tail_lsn = 0;
>  
> +	spin_lock(&ailp->ail_lock);
> +	list_for_each_entry(lip, list, li_bio_list) {
> +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +		xfs_lsn_t	lsn;
>  
> +		if (iip->ili_flush_lsn != lip->li_lsn) {
> +			xfs_clear_li_failed(lip);
>  			continue;
>  		}
>  
> +		lsn = xfs_ail_delete_one(ailp, lip);
> +		if (!tail_lsn && lsn)
> +			tail_lsn = lsn;

iip is only used once, this could be shortened by using INODE_ITEM()
directly in the if expession:

	if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn) {

> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +		if (!iip->ili_last_fields)
> +			continue;

Please add an empty line after the variable declaration.
