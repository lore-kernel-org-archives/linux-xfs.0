Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16990C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 13:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBDD661165
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 13:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbhGTNDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 09:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbhGTNBq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jul 2021 09:01:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D0FC061766;
        Tue, 20 Jul 2021 06:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OfI1vnDc1H0t4U88laI6nUzBnD4CbimXKJG78NpNHT0=; b=ddO3GVG1F07pyTh9iTeThIoi5N
        zyKd3oBX/Gk9M3vLRcN50HC+URpOmwdpakMhe2ZA0o1ad8fk5KUrPfqMcJqMzZ4wNHJJk3oh7067F
        QXlALcXHdH9t1ZM7+H3Z/VMmQ3fTb6aPS3kN7HSaI+YTgTYQ4j33lxfEToz5BmjFZwX3lKy3UmY1f
        yHUhebbg32uWw/Klghs33HluJe6lY9kCWZz5P7nuzqid1dE/ZYW2R7Ag63780We7bJWwb/4Cgmxef
        eJcOeN+xTLn5hX80EQHQ50HYgML7TfEZD/ski3Q5Exr96H8NHYgKVoU9VZMc4f7H+M8pFskqvER+m
        IhJCbUtA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5q05-0089sW-Bt; Tue, 20 Jul 2021 13:41:44 +0000
Date:   Tue, 20 Jul 2021 14:41:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: simplify iomap_readpage_actor
Message-ID: <YPbSjdkg19Vs5kzu@casper.infradead.org>
References: <20210720084320.184877-1-hch@lst.de>
 <YPbBLCphExqjig1O@casper.infradead.org>
 <20210720132644.GA11913@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720132644.GA11913@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 20, 2021 at 03:26:44PM +0200, Christoph Hellwig wrote:
> I think we can do this version, but I haven't tested it yet:

I see no problems with this version.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

