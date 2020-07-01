Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D967C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 21:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC5C2067D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 21:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgGAVfe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:35:34 -0400
Received: from ms.lwn.net ([45.79.88.28]:57246 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgGAVfe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Jul 2020 17:35:34 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id CBFB52D3;
        Wed,  1 Jul 2020 21:35:33 +0000 (UTC)
Date:   Wed, 1 Jul 2020 15:35:32 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-doc@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [willy@infradead.org: Re: [PATCH 6/6] mm: Add memalloc_nowait]
Message-ID: <20200701153532.63d49389@lwn.net>
In-Reply-To: <20200701041316.GA7193@casper.infradead.org>
References: <20200701041316.GA7193@casper.infradead.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 1 Jul 2020 05:13:16 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> > > -It turned out though that above approach has led to
> > > -abuses when the restricted gfp mask is used "just in case" without a
> > > -deeper consideration which leads to problems because an excessive use
> > > -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> > > -reclaim issues.  
> > 
> > I believe this is an important part because it shows that new people
> > coming to the existing code shouldn't take it as correct and rather
> > question it. Also having a clear indication that overuse is causing real
> > problems that might be not immediately visible to subsystems outside of
> > MM.  
> 
> It seemed to say a lot of the same things as this paragraph:
> 
> +You may notice that quite a few allocations in the existing code specify
> +``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to prevent
> +recursion deadlocks caused by direct memory reclaim calling back into
> +the FS or IO paths and blocking on already held resources. Since 4.12
> +the preferred way to address this issue is to use the new scope APIs
> +described below.
> 
> Since this is in core-api/ rather than vm/, I felt that discussion of
> the problems that it causes to the mm was a bit too much detail for the
> people who would be reading this document.  Maybe I could move that
> information into a new Documentation/vm/reclaim.rst file?
> 
> Let's see if Our Grumpy Editor has time to give us his advice on this.

So I don't have time to really dig into the context here...but I can try.

Certainly there needs to be enough information to get people to think
about using those flags, even if they are copypasting other code that
does.  I'd be inclined to err on the side of including too much
information rather than too little.  Of course, you could make the
reclaim.rst file, then cross-link it if the result seems better.

In other words, do all of the above :)

jon
