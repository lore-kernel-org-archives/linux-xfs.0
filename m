Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1563C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7421610A5
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDBHNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBHNh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:13:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490DFC0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RpEWpQ0WPNXU3ChmJ9BQlLKS6SiQKypqeNJm5HCK4Y8=; b=m8KWy7mNgpfWRGI935usoAa6Fq
        gAMqvHin5X9ce9VXsZTq2ONAfXWqWzAFE3OJKA34qQckU0NdzNq8yfzt1pNszTUKkh51ts+V9o7uB
        vuMxAaz1dwTVDNH40UEe7ibpH6JOoAEv9pi1nAIhDGC4FUFnRyhfuSzo7DYdE7F109xPGgGf0ypqH
        5dJeEOPQh5dG28sWXllX1RXqc0h3Uh5NfltBYR6OODpzpe9ov08vo85rQx4FyMNSRf1bKkb9JJhqN
        usgGU/IRv4GOhdKMOVHgOz9zr9ezY/Mq13pIL0JowmWCwcpugxDdiyb5KvGrzntssFMUhK9nH27v7
        cVOOE8oA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDzl-007KCs-If; Fri, 02 Apr 2021 07:13:32 +0000
Date:   Fri, 2 Apr 2021 08:13:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Message-ID: <20210402071329.GJ1739516@infradead.org>
References: <20210331162617.17604-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331162617.17604-2-ailiop@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 06:26:17PM +0200, Anthony Iliopoulos wrote:
> Use of the flag has had no effect since kernel commit 288699fecaff
> ("xfs: drop dmapi hooks") which removed all dmapi related code, so we
> can remove it.
> 
> Given that there are no other flags that need to be specified for the
> bmap call, convert once instance of it from getbmapx to plain getbmap.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

I'm not sure dorpping this as long as xfsdump still has all kinds of
other DMAPI related code..
