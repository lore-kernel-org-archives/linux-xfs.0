Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994CEC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C3461106
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDBGrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhDBGrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:47:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9517BC0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pvdlFks6od+GDSIyiAcS4kfzG3nVLsc7TAfVamiANVg=; b=YUKhGvmenWvpOosvuPUisvwenY
        UwpmY8SxqkSpBL+mlO0TaAuqvbHCHFIkVgs0ym8lfBrFFZ7yvHaCxMDuyeaWYPoC6qHVyKHx5NU7p
        3ujQBvRrwuVYB3HVkzwP6504pGpEka6Sf/Umm0TJkm/gYTLQ+euRP1dNAHLmZg+5wgkGNe4/YP4sR
        GwxjXvcideYZZVY5ak96nb9z9HqnK6wmG69kGQDnj03TSePkIEZ7S7AJnSjrKSv0bYJwUnMbSEUFf
        0E2nGSYAh5kaVkMJK2eFUw5H7AYpE/vqHZfXas9TF6fE1BGxBWPjZshsIqyfQ8bF4fVU/7Bpu9qSQ
        SCV5caRw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDaX-007IpQ-RB; Fri, 02 Apr 2021 06:47:28 +0000
Date:   Fri, 2 Apr 2021 07:47:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] design: document changes for the bigtime feature
Message-ID: <20210402064725.GD1739516@infradead.org>
References: <161672690975.721010.3851165011742824524.stgit@magnolia>
 <161672692218.721010.7004865825251110891.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161672692218.721010.7004865825251110891.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:48:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Document the changes to the ondisk format when we enable the bigtime
> feature.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
