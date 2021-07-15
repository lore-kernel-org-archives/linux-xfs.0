Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC24C07E96
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FD8611AB
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhGOGMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 02:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGOGMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 02:12:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E83C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 23:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8V9IAbUVfIeZwLinMhixkH18b/D+VvjwDYpeBLxt4m8=; b=AW9RsU40uM5WsDboqCPF2ckeld
        ipFlwO/pcQsvL47mgKg0rjXjb/d3EayH3fhTBZwNLe1w/0hQCsWg8jruUPr3wMZYPuZgXA8nh55vj
        Wi1fZltkGNqVhLObBHGhsNSUwVfMV3zoHCgNONHI3NLt7loC4L367sz2kpo6PVZM0sdD9htCHvVWN
        OvOjTMY52tvuf+oE6PmLptUX5d7gWUyrDd52EeTp8EZ6JsOQ7iKvScjQ2j8bn/trn/UhniF3KXW7N
        P7jrN6E4hZNUf5pgjXxrwBz/Kp0OXuPaqNEMpo7MUBLzqIeUXcw/ThXPHeIR95bwuF5nrJFPYlKpU
        PHra9W+g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uYD-0032xe-LM; Thu, 15 Jul 2021 06:09:08 +0000
Date:   Thu, 15 Jul 2021 07:08:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: detect misaligned rtinherit directory extent size
 hints
Message-ID: <YO/Q8U4IQqwrmRYv@infradead.org>
References: <20210714213542.GK22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714213542.GK22402@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:35:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we encounter a directory that has been configured to pass on an
> extent size hint to a new realtime file and the hint isn't an integer
> multiple of the rt extent size, we should flag the hint for
> administrative review because that is a misconfiguration (that other
> parts of the kernel will fix automatically).

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
