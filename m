Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D52C07E95
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 06:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47A2613E7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 06:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhGPGO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jul 2021 02:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbhGPGO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jul 2021 02:14:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B32C061762;
        Thu, 15 Jul 2021 23:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IdQtbe1ZGO08viiTNnFAMRph0+8sybGeAwYldlMNOdg=; b=WqH5p42DQdHnhc6uDGetJghJMu
        MbBPzLFCusAZZ39cKyn5TgCy4vMKiqdF0CaRdoCW3lx8Xqa+NrF7BxngD0pA+NuL7LjgbYQQSlUw6
        3UpEOKX4p9gQYMfyEy+JV3mvhwkfmyLTfoq6ITjDP+4JHMGiJeA/GhffY9lmsLrtmyC6PXFlWtOOJ
        OTGFlYePEWMhjSk4f4dnQhY0ajgVq7jz/4/ALzF3vdg+s3NHkkEB6wC66WsCn4qNfWkaOGkbi1+f8
        rtnz4uRPO5W9NkAd61LNWul/s731ZMz1Un9lHi8YEHJhbJUmwPSxGfw7Osc7wVoZxlR8EufQW/wwy
        ryQAJiSA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4H3s-004Ccs-8a; Fri, 16 Jul 2021 06:11:12 +0000
Date:   Fri, 16 Jul 2021 07:11:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jia He <justin.he@arm.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, nd@arm.com,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/13] iomap: simplify iomap_swapfile_fail() with
 '%pD' specifier
Message-ID: <YPEi9CvMoM5Bpq/i@infradead.org>
References: <20210715031533.9553-1-justin.he@arm.com>
 <20210715031533.9553-8-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715031533.9553-8-justin.he@arm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 11:15:27AM +0800, Jia He wrote:
> After the behavior of '%pD' is change to print the full path of file,
> iomap_swapfile_fail() can be simplified.
> 
> Given the space with proper length would be allocated in vprintk_store(),
> the kmalloc() is not required any more.
> 
> Besides, the previous number postfix of '%pD' in format string is
> pointless.

This also touched iomap_dio_actor, but the commit og only mentions
iomap_swapfile_fail.
