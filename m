Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A3DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 12:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiF2M5j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 08:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiF2M5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 08:57:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C29D37A3C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 05:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656507455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NI8li6i4Fa8od6Xwnv5YISnQaEXRgLZN/bKwtyutLW8=;
        b=Yoj2NUeph1kTm5+PZq5W3JV0xCVLm9u5+qnaYkfN4qtju+bjHvyLExbeE7acNdpxY/cNEW
        CRGlgpdSNCTDpjIIQntDmXI2ujJO42GYTMu7Km/2v8qLpvXmMFajYMxPK4EtX3kLnuSq0c
        dZ4vkQ/raAeNxOaUun1fUSqoTSSt5jg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-dQV36m-mPomUF3ud6xANQw-1; Wed, 29 Jun 2022 08:57:34 -0400
X-MC-Unique: dQV36m-mPomUF3ud6xANQw-1
Received: by mail-qv1-f69.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso15260239qvb.15
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 05:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NI8li6i4Fa8od6Xwnv5YISnQaEXRgLZN/bKwtyutLW8=;
        b=F9BHFmiGV9qWN288lrm7Yq9hjh8hCrkua5qlvLrV/faTUYsLmrS0slY1C9+y53VwL2
         s2WBXhelTcBHiZccp292/vVXMcbCEW+pZOwOAoA2jZL7HZ5/lm6KtcbEH1U/rXwEN7KS
         nNlKUbXfzZ36ZSWkvJbxsqjwvfPbd5gF7Uu2bZtGsOxO2/iLBYCBJWNI/F55l9WIFafZ
         nKqc/swKGzPiPDmQ8lslUX34JbCFXKoJnLEPoiz1v1jlyqXN5aMi/UI4wxpCTlUK1rm3
         j3ocfiyiE2wPvWG1+A3pgsthcsTLg8R0lTQNIcEbPy/ojkRF9rmUpQBu02ewCI/RHv2s
         OmiQ==
X-Gm-Message-State: AJIora/qU0kiDZBTDNrQ7E+f46Ylb5VSvm8Njnd9VCqz05bzpidouhYl
        Z19zVN+VLoTTypbFLPtCuBfio90z4HmNNKagYMKDTM/Z0Lp8oeBZfJLMHzX9ahy857oj61Xy3lw
        9L4sO/RqghU8tSnNUEOiL
X-Received: by 2002:a05:6214:ac1:b0:472:a974:59b9 with SMTP id g1-20020a0562140ac100b00472a97459b9mr966713qvi.130.1656507453507;
        Wed, 29 Jun 2022 05:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spkVv4gEXBYIpaGadRuLqknIV0kmMSAfF1s4zAypEPVpP875350aVTH3LbG8XV2+b0HyB/hw==
X-Received: by 2002:a05:6214:ac1:b0:472:a974:59b9 with SMTP id g1-20020a0562140ac100b00472a97459b9mr966685qvi.130.1656507453162;
        Wed, 29 Jun 2022 05:57:33 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id b12-20020ac86bcc000000b00304ef50af9fsm10484612qtt.2.2022.06.29.05.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 05:57:32 -0700 (PDT)
Date:   Wed, 29 Jun 2022 08:57:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-mm@kvack.org
Subject: Re: Multi-page folio issues in 5.19-rc4 (was [PATCH v3 25/25] xfs:
 Support large folios)
Message-ID: <YrxMOgIvKVe6u/uR@bfoster>
References: <YrO243DkbckLTfP7@magnolia>
 <Yrku31ws6OCxRGSQ@magnolia>
 <Yrm6YM2uS+qOoPcn@casper.infradead.org>
 <YrosM1+yvMYliw2l@magnolia>
 <20220628073120.GI227878@dread.disaster.area>
 <YrrlrMK/7pyZwZj2@casper.infradead.org>
 <Yrrmq4hmJPkf5V7s@casper.infradead.org>
 <Yrr/oBlf1Eig8uKS@casper.infradead.org>
 <20220628221757.GJ227878@dread.disaster.area>
 <YruNE72sW4Aizq8U@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YruNE72sW4Aizq8U@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 04:21:55PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 29, 2022 at 08:17:57AM +1000, Dave Chinner wrote:
> > On Tue, Jun 28, 2022 at 02:18:24PM +0100, Matthew Wilcox wrote:
> > > On Tue, Jun 28, 2022 at 12:31:55PM +0100, Matthew Wilcox wrote:
> > > > On Tue, Jun 28, 2022 at 12:27:40PM +0100, Matthew Wilcox wrote:
> > > > > On Tue, Jun 28, 2022 at 05:31:20PM +1000, Dave Chinner wrote:
> > > > > > So using this technique, I've discovered that there's a dirty page
> > > > > > accounting leak that eventually results in fsx hanging in
> > > > > > balance_dirty_pages().
> > > > > 
> > > > > Alas, I think this is only an accounting error, and not related to
> > > > > the problem(s) that Darrick & Zorro are seeing.  I think what you're
> > > > > seeing is dirty pages being dropped at truncation without the
> > > > > appropriate accounting.  ie this should be the fix:
> > > > 
> > > > Argh, try one that actually compiles.
> > > 
> > > ... that one's going to underflow the accounting.  Maybe I shouldn't
> > > be writing code at 6am?
> > > 
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index f7248002dad9..4eec6ee83e44 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -18,6 +18,7 @@
> > >  #include <linux/shrinker.h>
> > >  #include <linux/mm_inline.h>
> > >  #include <linux/swapops.h>
> > > +#include <linux/backing-dev.h>
> > >  #include <linux/dax.h>
> > >  #include <linux/khugepaged.h>
> > >  #include <linux/freezer.h>
> > > @@ -2439,11 +2440,15 @@ static void __split_huge_page(struct page *page, struct list_head *list,
> > >  		__split_huge_page_tail(head, i, lruvec, list);
> > >  		/* Some pages can be beyond EOF: drop them from page cache */
> > >  		if (head[i].index >= end) {
> > > -			ClearPageDirty(head + i);
> > > -			__delete_from_page_cache(head + i, NULL);
> > > +			struct folio *tail = page_folio(head + i);
> > > +
> > >  			if (shmem_mapping(head->mapping))
> > >  				shmem_uncharge(head->mapping->host, 1);
> > > -			put_page(head + i);
> > > +			else if (folio_test_clear_dirty(tail))
> > > +				folio_account_cleaned(tail,
> > > +					inode_to_wb(folio->mapping->host));
> > > +			__filemap_remove_folio(tail, NULL);
> > > +			folio_put(tail);
> > >  		} else if (!PageAnon(page)) {
> > >  			__xa_store(&head->mapping->i_pages, head[i].index,
> > >  					head + i, 0);
> > > 
> > 
> > Yup, that fixes the leak.
> > 
> > Tested-by: Dave Chinner <dchinner@redhat.com>
> 
> Four hours of generic/522 running is long enough to conclude that this
> is likely the fix for my problem and migrate long soak testing to my
> main g/522 rig and:
> 
> Tested-by: Darrick J. Wong <djwong@kernel.org>
> 

Just based on Willy's earlier comment.. what I would probably be a
little careful/curious about here is whether the accounting fix leads to
an indirect behavior change that does impact reproducibility of the
corruption problem. For example, does artificially escalated dirty page
tracking lead to increased reclaim/writeback activity than might
otherwise occur, and thus contend with the fs workload? Clearly it has
some impact based on Dave's balance_dirty_pages() problem reproducer,
but I don't know if it extends beyond that off the top of my head. That
might make some sense if the workload is fsx, since that doesn't
typically stress cache/memory usage the way a large fsstress workload or
something might.

So for example, interesting questions might be... Do your corruption
events happen to correspond with dirty page accounting crossing some
threshold based on available memory in your test environment? Does
reducing available memory affect reproducibility? Etc.

Brian

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

