Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6B7C433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31CE265014
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEI1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEI0k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:26:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F04C061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D53njxXuqKj6tiDW1HYS+taIWFx9LA/zSphyI8xA/kA=; b=Dwo8R8D+YCuW6eFeL9EN09J0b8
        rLXAhQgN5zKN8CA2Ib3Ir3Wayh0HiLr/QGR+RqEk7xtt1iEJIi8DJ1n4CUJRWi7EmmZh2Pqz5gkX7
        9kZtTkiN2NLi4amB0fehX4NxsXrDPsTAFyBEg4ZqmFu4wBQrkrzYKAAKWlj+wDxcWO4fXZTH849VK
        EP137c+gJADStBvRJclHOyG2JBIo7y27rWgfR737g9eH3S1gJb01zA9DWrwcjZuxVPM1kh3/0AWwR
        4FQqcZBjGEQ8Chv6Xb8Zjr/rXsVhHWCZd4JwnJUYCQ/NS/L8ywG2cQjjzGFu0FB22UgqgPaOfxhPK
        dR10Wpjg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5mw-00AprK-7g; Fri, 05 Mar 2021 08:26:29 +0000
Date:   Fri, 5 Mar 2021 08:26:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: mark a data structure sick if there are
 cross-referencing errors
Message-ID: <20210305082622.GD2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472413910.3421582.5713995044590901701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472413910.3421582.5713995044590901701.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If scrub observes cross-referencing errors while scanning a data
> structure, mark the data structure sick.  There's /something/
> inconsistent, even if we can't really tell what it is.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
