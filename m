Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3D0C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0651565018
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCEI0F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCEIZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:25:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7E9C061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BRjtKFL3tH2MScva27AMIw151rPirVQa/39b6xwCWWE=; b=eiXX3rivQo9FmvWHyMkoPIOtLM
        ZFObm/I0kWh6ImyZrTzoLSuQsB1rb5A2D1wFitFgaKb6hONIZaHXb/i27ILjD2MSwGFsckua5wP8g
        SupmAryqSg369jO0WPjmyhcBUsU3REq3MOODFyJOVaNZbUWuD8ZKVK+IeI3ignf3aXtXdUpHIz2J0
        v7YJfuw/ACiN8vJZnyHSK3GugijzM8RIt5Fq+6YwzodX3qrOWaDZmHyKqpSQtqa1eWJpyLRnf4a2z
        36rrdGOWb+ptVgf431ONw/Cx7tWUyUord9D2UJYhN8A4i5209a8x28ZAObsqd35O5/LxTNah6uyG6
        +1A6GP6g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5m0-00Apoi-NA; Fri, 05 Mar 2021 08:25:30 +0000
Date:   Fri, 5 Mar 2021 08:25:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: bail out of scrub immediately if scan incomplete
Message-ID: <20210305082524.GC2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472413358.3421582.1775111400550224556.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472413358.3421582.1775111400550224556.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a scrubber cannot complete its check and signals an incomplete check,
> we must bail out immediately without updating health status, trying a
> repair, etc. because our scan is incomplete and we therefore do not know
> much more.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
