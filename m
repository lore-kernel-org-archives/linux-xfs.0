Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25571C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 14:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9846142C
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 14:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbhEGOmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 May 2021 10:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbhEGOmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 May 2021 10:42:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851FDC061574;
        Fri,  7 May 2021 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vx06W0nngKfU8tIsu9g8fiUjk7fO4Zx6zOu8s1ypHe8=; b=Onpma/FHwNu6HH6pq1fWEeb7wc
        m9Yv1Gr8JLQGtU2aQh9HbOFhu1tCtqy41/FqOyXO6JLQ7UenXt0wTYll5oIIUwSCx+z2zv8DFeyxF
        8KmHkWlFWbBX7QxShZ+n46NX72st/qdSs0hNS/z8CG/E9eH9bicNVIW8SDZhgEAnsFg18oimDI1Mu
        I/rfkIx+wzOgYI/LR8sTxbbnajnn0gMXIj3AiIKDt0lGepvWV9gk6Fv+7yLoodo6mZitGDjxT1gnE
        ZHZ70FucyC9yLQHKyYk41lK/ah58mchElTAIQYSFbcQ7qt/n+mkc7TjsOo8h9qcw1fqOPi/XAxht3
        55adjKYg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lf1eh-003Fy6-3t; Fri, 07 May 2021 14:40:44 +0000
Date:   Fri, 7 May 2021 15:40:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: kick extra large ioends to completion
 workqueue
Message-ID: <YJVRZ1Bg1gan2BrW@casper.infradead.org>
References: <20201002153357.56409-3-bfoster@redhat.com>
 <20201005152102.15797-1-bfoster@redhat.com>
 <20201006035537.GD49524@magnolia>
 <20201006124440.GA50358@bfoster>
 <20210506193158.GD8582@magnolia>
 <YJVJZzld5ucxnlAH@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJVJZzld5ucxnlAH@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 07, 2021 at 10:06:31AM -0400, Brian Foster wrote:
> > <nod> So I guess I'm saying that my resistance to /this/ part of the
> > changes is melting away.  For a 2GB+ write IO, I guess the extra overhead
> > of poking a workqueue can be amortized over the sheer number of pages.
> 
> I think the main question is what is a suitable size threshold to kick
> an ioend over to the workqueue? Looking back, I think this patch just
> picked 256k randomly to propose the idea. ISTM there could be a
> potentially large window from the point where I/O latency starts to
> dominate (over the extra context switch for wq processing) and where the
> softlockup warning thing will eventually trigger due to having too many
> pages. I think that means we could probably use a more conservative
> value, I'm just not sure what value should be (10MB, 100MB, 1GB?). If
> you have a reproducer it might be interesting to experiment with that.

To my mind, there are four main types of I/Os.

1. Small, dependent reads -- maybe reading a B-tree block so we can get
the next pointer.  Those need latency above all.

2. Readahead.  Tend to be large I/Os and latency is not a concern

3. Page writeback which tend to be large and can afford the extra latency.

4. Log writes.  These tend to be small, and I'm not sure what increasing
their latency would do.  Probably bad.

I like 256kB as a threshold.  I think I could get behind anything from
128kB to 1MB.  I don't think playing with it is going to be really
interesting because most IOs are going to be far below or far above
that threshold.

