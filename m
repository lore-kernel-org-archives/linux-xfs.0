Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4D8C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 04:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA0932376F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 04:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgLQEBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 23:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgLQEBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 23:01:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA79AC061794;
        Wed, 16 Dec 2020 20:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p5fb08C0DCBQWhSyoUlxYsa0SwQs8McabZN4Z0axm3U=; b=XiBh72ED9+K8bE59EDrVEXjQJu
        qIfZUDq6hJkumIIEpIHRg0voEtQynJ17re2x9bSCVY2i/vlsdfVDXb30Y8LXrNFJ9scswpt67nptt
        9D81eP/etthk63EIvn7q6ECqFwegc6+mbNxwUbSW/qHzT58QuggfpvmQTAJFtd8ZtC6xyoGafSTWI
        0NYLL3J0pamDEoqZsqZg8ssl6/9sHx5/GUo/BAfWV/2lE+8l8mikwTNDBZBc/eEUg73p4CwsYenru
        ZEE/S1rv25yYyDZSzgMyTgzhkEG0W5FDoVjegel4yNlPV5/9zmiBUKVegsyR3ROus9kdMoSDp/Swq
        JWcUeN8Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpkSr-0003IO-Dp; Thu, 17 Dec 2020 04:00:29 +0000
Date:   Thu, 17 Dec 2020 04:00:29 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, darrick.wong@oracle.com,
        hch@infradead.org, mhocko@kernel.org, akpm@linux-foundation.org,
        dhowells@redhat.com, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v13 1/4] mm: Add become_kswapd and restore_kswapd
Message-ID: <20201217040029.GC15600@casper.infradead.org>
References: <20201217011157.92549-1-laoar.shao@gmail.com>
 <20201217011157.92549-2-laoar.shao@gmail.com>
 <20201217030609.GP632069@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217030609.GP632069@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 17, 2020 at 02:06:09PM +1100, Dave Chinner wrote:
> On Thu, Dec 17, 2020 at 09:11:54AM +0800, Yafang Shao wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Since XFS needs to pretend to be kswapd in some of its worker threads,
> > create methods to save & restore kswapd state.  Don't bother restoring
> > kswapd state in kswapd -- the only time we reach this code is when we're
> > exiting and the task_struct is about to be destroyed anyway.
...
> > @@ -3932,8 +3920,6 @@ static int kswapd(void *p)
> >  			goto kswapd_try_sleep;
> >  	}
> >  
> > -	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
> > -
> 
> Missing a restore_kswapd()?

Deliberately.
