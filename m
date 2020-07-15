Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5156C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C153B20672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i4Cc0/Yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGORcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgGORcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:32:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC7AC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HAi+Lu+60IOJ09D/1NpCEpmKK36KLIW5D4T9kwd8wEg=; b=i4Cc0/YyL8rWZi1BhNMC3UXJNY
        VuMX+RMcbYEJCAX7463+ZJ8XCMX0lhm66KffUvK95szOzIgdwgdDQFsp3za5rXc+4aZdm6FItrvdV
        kay0uGwwsEX+rB5XyaSDGBqOI/+3r7jqq+Jq8O2AeJV/Po72enCcw6AW4vIH13tUwgNn5BHwEMH49
        NY7xeS49Z2kPLyPIiNIIyZl1oo5OXKgHCGtdWmuLdGQtaka7SoiFxrlX2CEf0wngVwEEsGwqnQB9D
        poWCzZ/apbW3Lk01D8L1jpN+ICY6lFS4ICBiMfjYBj1B2YglSRW6aAtWNqGgKURLS1szCD6CrQ+ip
        +UtxQQGg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlGT-0002wG-4u; Wed, 15 Jul 2020 17:32:17 +0000
Date:   Wed, 15 Jul 2020 18:32:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200715173217.GA11239@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
 <20200710222132.GC2005@dread.disaster.area>
 <20200713091610.kooniclgd3curv73@eorzea>
 <20200713161718.GW7606@magnolia>
 <20200715150659.crao7yuq3hkh3tmq@eorzea>
 <20200715153721.GC3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715153721.GC3151642@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 08:37:21AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2020 at 05:06:59PM +0200, Carlos Maiolino wrote:
> > > > No problem in splitting this change into 2 patches, 1 by unconditionally use
> > > > __GFP_NOFAIL, and another changing the behavior to use NOFAIL only inside a
> > > > transaction.
> > > > 
> > > > Regarding the PF_FSTRANS flag, I opted by PF_MEMALLOC_NOFS after reading the
> > > > commit which removed PF_FSTRANS initially (didn't mean to ignore your suggestion
> > > > Dave, my apologies if I sounded like that), but I actually didn't find any commit
> > > > re-adding PF_FSTRANS back. I searched most trees but couldn't find any commit
> > > > re-adding it back, could you guys please point me out where is the commit adding
> > > > it back?
> > > 
> > > I suspect Dave is referring to:
> > > 
> > > "xfs: reintroduce PF_FSTRANS for transaction reservation recursion
> > > protection" by Yang Shao.
> > > 
> > > AFAICT it hasn't cleared akpm yet, so it's not in his quiltpile, and as
> > > he doesn't use git there won't be a commit until it ends up in
> > > mainline...
> > > 
> > 
> > Thanks, I think I'll wait until it hits the mainline before trying to push this
> > series then.
> 
> FWIW I could be persuaded to take that one via one of the xfs/iomap
> trees if the author puts out a revised patch.

Let's just defer that part of the patch.  It really shouldn't be mixed
with an API cleanup as it is significant behavior change.
