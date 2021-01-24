Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34939C433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0411922D0A
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbhAXJxA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbhAXJw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:52:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C90C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yUczSYsRQd8vf98lVJKWF45njOyGyHBUIPYE4omXoiY=; b=iOSP+n6ZkuuXNvGG8KZtEC8Gow
        Fh7sCQJYJDhrobzt73VvKuqF6aNDRA5h3yKTweeUUbWHLJNeyYhvY33yCVyLhWsgOOAwFbpZQEU1J
        EqZdtpZUEicNp4joJM5YMPv4L/jbfe5kKt+GpNTfD3XYmCjie71JduqnjHvPcYRqbfwgwzIsgEkdB
        6DRVn/67i0vp+a3gUFIAU3YH7MZOjKJkEBYjniboTDsVBit9wYd+wlJ5bMN6sCGuR71weGQ4uz8aI
        lPfphQRhGEj2cbg6Q69YKyueZU13HwMfjpwBP//qUAr3iiYTzw8WkCmnwRn5+JvpuT5tGHKo9c22G
        5TrevwdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3c3i-002pOx-SI; Sun, 24 Jan 2021 09:52:00 +0000
Date:   Sun, 24 Jan 2021 09:51:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: use unbounded workqueues for parallel work
Message-ID: <20210124095150.GF670331@infradead.org>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799399.2173328.8759691345812968430.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142799399.2173328.8759691345812968430.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:53:14AM -0800, Darrick J. Wong wrote:
> -	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
> -			current->pid);
> +	pctl->wq = alloc_workqueue("%s-%d", WQ_UNBOUND | WQ_SYSFS | WQ_FREEZABLE,
> +			nr_threads, tag, current->pid);

This adds an overly long line.


But more importantly I think xfs.txt needs to grow a section that we now
can tune XFS parameters through the workqueue sysfs files, especially as
right now I have no idea how to find those based on an actual device or
XFS mount I need to adjust the parameters for.
