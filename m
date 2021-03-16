Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD932C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D2F64F90
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhCPIsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCPIrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 04:47:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F01C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 01:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L6OLNZOZ6mJ4bxvPtf3jYlpRsy9aXD/wE/3eAZyU9+Y=; b=ItZi+1GK7qW3nEde2hlFP0Tj1j
        NGzf55fDwmPXk414AmDQq/mJFvr//jg/TlxTniq4nMbjbJz7LFkU7G73N/db1fgmPuX6Z1hlVri6w
        AmkSXkDIBCVze/fLY9SdM+s4Dg6Gy9rMTN6NdAfbgiGR7KGjbQIU1Udwn7FHxZZQnU25py7w7B4SS
        TSNfCZS6Ntrpj4UT0FcCwDSQMxmlFjgPmzYOM1rlP7PqlqxZgSg+RpJShzZcr30L9KrRqYdKIMw8p
        IJmS7OVcH3Is+jrKjduBUjatvhH6PDzvb2PXGBQL/romfz28vQFCJS/UB6P/MIaszyfm7EkdDVr/7
        4gY17oYQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM5MS-001gOW-G6; Tue, 16 Mar 2021 08:47:38 +0000
Date:   Tue, 16 Mar 2021 08:47:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/45] xfs: CIL checkpoint flushes caches unconditionally
Message-ID: <20210316084732.GE398013@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * Before we format and submit the first iclog, we have to ensure that
> +	 * the metadata writeback ordering cache flush is complete.
> +	 */
> +	wait_for_completion(&bdev_flush);

.. and this would be where we'd check bio.bi_status for an error ..

