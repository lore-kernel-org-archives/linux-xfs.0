Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAF4C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABC4212CC
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZtJDKO1H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbgDAPms (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:42:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732705AbgDAPms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 11:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7w1gu0h3WVKpI8vXX0cRdx6WO7OoJ49pCp7LSb7NL/s=; b=ZtJDKO1HQ56O6VZ48ID4BxMC6W
        r9uTyhAp8ks+KSMUTrKfYBQLeWhDRasTErGM3JQhCULRQvuspQ2agUEx9ACXbvAF3LoMny6qep2gE
        tPNrJe1jFc77ywz28G9avTE3emKPHbPVqADIgqIWNuB3nMQq9lEeSyttTfcq1Mjk26azimJIyeX6U
        yaKr3QNexhD+WtMDOdDkzhtc84yjbDWPuhBGJTlK+VHygSoJbN8IE+KsFo3oMv017+LAorVeSrJzu
        18aLho2nN8yXSN8aTUaoghJ649udOuLIEFcSXRJHbOvCPmmNexrpuJbCHCj8EdSZZwfTNvMaMY+kF
        D4gTJVKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJfVw-0007Ts-GA; Wed, 01 Apr 2020 15:42:48 +0000
Date:   Wed, 1 Apr 2020 08:42:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Add iomap_iter API
Message-ID: <20200401154248.GA2813@infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
 <20200401152522.20737-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401152522.20737-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +loff_t iomap_iter(struct iomap_iter *iter, loff_t written)
> +{
> +	const struct iomap_ops *ops = iter->ops;
> +	struct iomap *iomap = &iter->iomap;
> +	struct iomap *srcmap = &iter->srcmap;

I think it makes sense to only have members in the iter structure
that this function modifies.  That is, just pass inode, ops and flags
as explicit parameters.

OTOH the len argument / return value seems like something that would
seems useful in the iter structure.  That would require renaming the
current len to something like total_len..

> +/* Magic value for first call to iterator */
> +#define IOMAP_FIRST_CALL	LLONG_MIN

Can we find a way to make a a zero initialized field the indicatator
of the first call?  That way we don't need any knowledge of magic
values in the callers.  And also don't need any special initializer
value, but just leave it to the caller to initialize .pos and
.total_len, and be done with it.

