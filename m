Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F85C11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 12:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E9B61607
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 12:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhF3Mcg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 08:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234426AbhF3Mcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 08:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625056207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQZ34p00W47EK/M00vu4N1h6gunJeEQ5RDsJI1DSqqg=;
        b=PQYg6WwCwLIUgJ943ElHUVaRIE1A4ryge7Qr8Vj2aadYCVvGG5RFKAUsaPl/8k/Yby3PKI
        Jt/YExo96AMkQiV9Ix2Ooru9pjgAyTkMKo6xbNnm9ZRNqpllszU7H+r1QQSDbN+l4OExT7
        VblfF5X3Gy2g3M6d8oA6Cg6YrX/44vU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-GUiqqNQlPfKb3bPcxcJciQ-1; Wed, 30 Jun 2021 08:30:05 -0400
X-MC-Unique: GUiqqNQlPfKb3bPcxcJciQ-1
Received: by mail-wr1-f70.google.com with SMTP id l12-20020a5d410c0000b029012b4f055c9bso672628wrp.4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 05:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQZ34p00W47EK/M00vu4N1h6gunJeEQ5RDsJI1DSqqg=;
        b=QoFvOhadYRaAKVVzg/c1B54wI53GZYr3SIwVpYWfNwufDhiLmh5gwY9B4zsnltvbsg
         nfMVfboWDhEI6Y7zfLXGnTriFgF18YRCYaa7zST3skzJDfAkjno+Z4bKkd+lWFYF5Yoi
         KVY36YurVmnnI9H0rmVPHu7bL2YdB8vI5BaF1xKgvgsgKA53DLTpUFKSWOgrP+kc+drc
         XWpWbqcW6JQ75bmJucnHBLy5XJbi10B3EP6hTimtXyuV1+dT9w1D2KGhER44EjdD8cxD
         nNTgrgMZxwXc+/+/EeQoOO16E2ZPIrKRpu4k3ioRcP6OVow9/56Finutr7MhX0nvOJT6
         Z+Gg==
X-Gm-Message-State: AOAM533A6VojHJU8I89fjmxeBGTLE52w/zw+DD9zNpukVC5b5a6Txj7T
        mKx59xF8RyWdaqkK4KpSF1qaeYYlN7BANYwG3TYZdwHzapmUs4fz9u8g2HjKqETNOZx/ofcB7Ae
        pWtr/nzGxMDl11AM5l1K79qF8YTDy9e8nJlb/
X-Received: by 2002:a5d:64a1:: with SMTP id m1mr38417845wrp.377.1625056204780;
        Wed, 30 Jun 2021 05:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiKZD8yv7AFvQByvy6FrFUeDUZiI9d4+EOWLz8GJb+ib2SSR1Xzbba+opGBb3gRXer0OrDHoNpt28PzPvCzZU=
X-Received: by 2002:a5d:64a1:: with SMTP id m1mr38417829wrp.377.1625056204627;
 Wed, 30 Jun 2021 05:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172727.1894503-1-agruenba@redhat.com> <YNoJPZ4NWiqok/by@casper.infradead.org>
 <YNoLTl602RrckQND@infradead.org> <YNpGW2KNMF9f77bk@casper.infradead.org> <YNqvzNd+7+YtXfQj@infradead.org>
In-Reply-To: <YNqvzNd+7+YtXfQj@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 30 Jun 2021 14:29:53 +0200
Message-ID: <CAHc6FU7+Q0D_pnjUbLXseeHfVQZ2nHTKMzH+0ppLh9cpX-UaPg@mail.gmail.com>
Subject: Re: [PATCH 0/2] iomap: small block problems
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

On Tue, Jun 29, 2021 at 7:47 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 28, 2021 at 10:59:55PM +0100, Matthew Wilcox wrote:
> > > > so permit pages without an iop to enter writeback and create an iop
> > > > *then*.  Would that solve your problem?
> > >
> > > It is the right thing to do, especially when combined with a feature
> > > patch to not bother to create the iomap_page structure on small
> > > block size file systems when the extent covers the whole page.
> >
> > We don't know the extent layout at the point where *this* patch creates
> > iomap_pages during writeback.  I imagine we can delay creating one until
> > we find out what our destination layout will be?
>
> Hmm.  Actually ->page_mkwrite is always is always called on an uptodate
> page and we even assert that.  I should have remembered the whole page
> fault path better.
>
> So yeah, I think we should take patch 1 from Andreas, then a non-folio
> version of your patch as a start.

will you pick up those two patches and push them to Linus? They both
seem pretty safe.

Thanks,
Andreas

