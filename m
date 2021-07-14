Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57066C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366FB613A9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhGNGMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbhGNGMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:12:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D9C0613DD
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OvVi5buIzwyaukTtAWhdYR2q2Hqk1h2N4w/Dj/3PkYE=; b=KcSQKeAoSiGURQ47nHF3IxY1XT
        e8EZJdtcoIDuWhqkyrf6YE+Z1ieW9Yp1oVLUvfOmYyV0SaBbd+kk2cIIFtngIKrAzu3/OlMWkjDxD
        JAxPBgfGfV5VoPLofB82B5XBIpCkTGY2gKWXGabEnGMb/jUc0JUP2UmWhHk1LIPvKX5g63jmYEXm5
        tvKAlAKtOJIia4VIiWnoWJ+gI4oyspQY+/37jYXReaC1VGdT8ggod2LVYfF5VovG6il5E4JhIfStB
        zOxgwIwlCcH/xYkBxbMRklRKVJziNRR5/ZTiF2vOUX/4ihMZUgLA/c5eFbmiAlyLwS9zIIy7qZ+Fu
        YNfJ8ATw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Y52-001uZ5-QC; Wed, 14 Jul 2021 06:09:22 +0000
Date:   Wed, 14 Jul 2021 07:09:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to
 xlog_is_shutdown()
Message-ID: <YO5/iKPqF4C/ywyb@infradead.org>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:19:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Make it less shouty and a static inline before adding more calls
> through the log code.
> 
> Also convert internal log code that uses XFS_FORCED_SHUTDOWN(mount)
> to use xlog_is_shutdown(log) as well.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
