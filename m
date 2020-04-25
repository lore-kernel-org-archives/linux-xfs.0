Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92002C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A87206ED
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GhfiK7eL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgDYSeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:34:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBABC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zm04Nz9jnZ91Z2cw7n2/vsOuGwXhYPs8Ojl7Rf8txdY=; b=GhfiK7eLnc3NemsN37Qy6pLdww
        eWcnkROaQwdGfIzp3vx3RomGDCQv2iD1t7WcJI0hZY1oIx/3ajslHk/a/vJI0yrghpzWeXgLqxXQf
        7CxMAAdlS5NuG2UhLRRC08CM/e0JlkSpCK6rfMAkYIREt6yX+PW4O1XGijT4nPsrgGX1w1Get5wHG
        mYbNl1mF/nduwCA3gxDnDAwXp3GilwRvrsemGzdPXpqcYrHRRgFPALXTyTMDmw+FYeC+TEe1DPTkd
        wAwHQxlANgaA+iwXsTwtFsF4GjJdoBdEKMuigJ7vTXhTRrZjjjFSFX5bjAlZSaV1B8ZqdC+Pjrm9R
        N4cysp4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPcw-0000pJ-Ab; Sat, 25 Apr 2020 18:34:10 +0000
Date:   Sat, 25 Apr 2020 11:34:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/19] xfs: refactor releasing finished intents during
 log recovery
Message-ID: <20200425183410.GG16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752125867.2140829.718007064092831514.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752125867.2140829.718007064092831514.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +STATIC bool
> +xlog_release_bui(
> +	struct xlog		*log,
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
> +	struct xfs_ail		*ailp = log->l_ailp;
> +
> +	if (buip->bui_format.bui_id == intent_id) {
> +		/*
> +		 * Drop the BUD reference to the BUI. This
> +		 * removes the BUI from the AIL and frees it.
> +		 */
> +		spin_unlock(&ailp->ail_lock);
> +		xfs_bui_release(buip);
> +		spin_lock(&ailp->ail_lock);
> +		return true;
> +	}
> +
> +	return false;

Early returns for the no match case would seem a little more clear for
all the callbacks.  Also the boilerplate comments in all the callback
seem rather pointless.  If you think they have enough value I'd
consolidate that information once in the xlog_recover_release_intent
description.

> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == intent_type && fn(log, lip, intent_id))
> +			break;
> +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> +	}

What about:

	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip;
	     lip = xfs_trans_ail_cursor_next(ailp, &cur) {
		if (lip->li_type != intent_type)
			continue;
		if (fn(log, lip, intent_id))
			break;
	}
