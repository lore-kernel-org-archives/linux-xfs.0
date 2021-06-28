Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3230C11F64
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 21:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E00B61CFA
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 21:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhF1VbU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 17:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237971AbhF1VbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jun 2021 17:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624915729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cJ767vfrh4IXdfvFNAN+IwQrIGxYG6OsAHfRcAZ7fBg=;
        b=VN+P0I5NahzyIzJzHE+DeQBhhWHCRVpLQhJ569guw/G3Irqsv1h/lueH51cFGL5+5x8irE
        gtW7NX6yQBcso8Q8i5Ube1L58h8VPH1mVGVZsC8n5i0s7/leZai+TeUr+JjQl//VwpRVDJ
        lb5xagsaSacj1KM0xaLhttVnfO5s1x8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-4Pk9lgj-OdG_MmG9FabRwQ-1; Mon, 28 Jun 2021 17:28:16 -0400
X-MC-Unique: 4Pk9lgj-OdG_MmG9FabRwQ-1
Received: by mail-wm1-f70.google.com with SMTP id k8-20020a05600c1c88b02901b7134fb829so2393626wms.5
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 14:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJ767vfrh4IXdfvFNAN+IwQrIGxYG6OsAHfRcAZ7fBg=;
        b=noiufx1C6qWyD2oo+XfvAlH7XUhzkMbhmSPuFkTE846lVYsP94RaATIyR7sXInarRb
         5U7t+eBilS6sYWJuTdl/knNSCyddF2hGgN+DvdTIVXD685GfanpomtQj8MNDCO0+uoVn
         KPRcEdtNJO0v2UTPX9J7Vvox9ydCLh0VrfMZ+1wgzkMohogtCyuawS6L++0FrR7fyldt
         qci4Rck9/vlEDstjseN7s8Pb3dRSxZRMpomf/OoDe4u5Ff4lewF6A3o5mDmh88V86Xbs
         K+ayMSVu+phvlVAux2MF9wbusncghDhvUal0j81W5+0qEpN3RX2L1s8dHheHWLiL81dV
         +JTQ==
X-Gm-Message-State: AOAM533tBZjwC3VQHkpnpBKKe8msGs3uOP72Vn7WU1afCmkDZKiThPGk
        ZyGIuPxWwlEhV2GDXRqjEesuP8JbDXt+DVl75UbPgS2swpz2rKjYG8ScPJvhpLjw5fQOI1Zln4p
        gJnlR+oBXuJ/UDbVG9QVk05Xn4rKj8qAxjiMr
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr28513961wrx.289.1624915695209;
        Mon, 28 Jun 2021 14:28:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziXT1hg1vICxPlVCGN6ewQfxaaiJ7z4+Orc+ZtFBtB0qT203Z7V708+3eTxQuHdvZEwWWyDocdducb1VXOQNw=
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr28513946wrx.289.1624915695043;
 Mon, 28 Jun 2021 14:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172727.1894503-1-agruenba@redhat.com> <YNoJPZ4NWiqok/by@casper.infradead.org>
 <YNoLTl602RrckQND@infradead.org>
In-Reply-To: <YNoLTl602RrckQND@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 28 Jun 2021 23:28:03 +0200
Message-ID: <CAHc6FU7Aa2ja+UDV84O=xt5hzSE7b9JkhtECzX8DRxxP=W0AXQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] iomap: small block problems
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 28, 2021 at 8:07 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 28, 2021 at 06:39:09PM +0100, Matthew Wilcox wrote:
> > Not hugely happy with either of these options, tbh.  I'd rather we apply
> > a patch akin to this one (plucked from the folio tree), so won't apply:
>
> > so permit pages without an iop to enter writeback and create an iop
> > *then*.  Would that solve your problem?
>
> It is the right thing to do, especially when combined with a feature
> patch to not bother to create the iomap_page structure on small
> block size file systems when the extent covers the whole page.
>
> >
> > > (3) We're not yet using iomap_page_mkwrite, so iomap_page objects don't
> > > get created on .page_mkwrite, either.  Part of the reason is that
> > > iomap_page_mkwrite locks the page and then calls into the filesystem for
> > > uninlining and for allocating backing blocks.  This conflicts with the
> > > gfs2 locking order: on gfs2, transactions must be started before locking
> > > any pages.  We can fix that by calling iomap_page_create from
> > > gfs2_page_mkwrite, or by doing the uninlining and allocations before
> > > calling iomap_page_mkwrite.  I've implemented option 2 for now; see
> > > here:
> >
> > I think this might also solve this problem?
>
> We'll still need to create the iomap_page structure for page_mkwrite
> if there is an extent boundary inside the page.

Yes, but the iop wouldn't need to be allocated in page_mkwrite; that
would be taken care of by iomap_writepage / iomap_writepages as in the
patch suggested by Matthew, right?

Thanks,
Andreas

