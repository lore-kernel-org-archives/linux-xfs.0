Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6635C07E9B
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 16:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42AB61A13
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 16:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhGFQEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 12:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhGFQEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jul 2021 12:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625587311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2yfndmR2iaMQIWMAd4edCOEQikxHqB5a5e0OL47C4zE=;
        b=SV3QLK4oFYPrOC8nXIRCiONAiTvRirmSj78VxjNpNRTIbps9UxoKl/yNDkJxjgtTlepiL8
        BauYhSRjN0Iw+pGZVltETQsljnSJEqlC7DrLcYszHgrFEX3Pvl7oYp0RwDjbYe4rjI5Y2d
        ujQVu7LeJ6MlmOLM9pVvYyP0BWQl49A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-V-M4IqozNHO8aniZx4-REQ-1; Tue, 06 Jul 2021 12:01:48 -0400
X-MC-Unique: V-M4IqozNHO8aniZx4-REQ-1
Received: by mail-wm1-f72.google.com with SMTP id m7-20020a05600c4f47b02901ff81a3bb59so2052189wmq.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 Jul 2021 09:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2yfndmR2iaMQIWMAd4edCOEQikxHqB5a5e0OL47C4zE=;
        b=aAXhwIQS3V8hRx9ThiXiscArt3/5F0z9b06cMwQbyt8flgRly+s9yZnGaZK2wUtaue
         1eqgQqkENqX4IwRBfYh3WCWOUcN2WY5yZhOM3J6I27nbu7gdRN4cR/YEtgI7q5+LWhLn
         McUukARzbCLKwjcA/h1+bK7OM+0ig26cfOHJYRksK8Bgq/S1HEPEbVEmOT6sjtopweS2
         aIfHfmitlMVwrWF0XCVkCMEFwUfP444EebBjW/td9FXG6S74vJp4XqqG7WpIKuZ1274t
         v9PSTZsQh+huoq0CQ7bYV5sDjEEhlYEkSOgAifyxacYLpdB2iJapmT1G5RkYD1nUiQ9A
         PG4A==
X-Gm-Message-State: AOAM5301A0NLRHw0beJHhZqRZNriY/3tMj/OyK8bzpAGjGro7GegLN4S
        ei6hwyYerWozSZe+b57DgV8Qhgd10UE/2/0OSncP5vIDygDreT4BssyTCM7JhTqhD8KQxkZVIr4
        Ym+8wQCTAvoJZ34NbyWEBbnd9EPiMtzorKExb
X-Received: by 2002:a1c:62c4:: with SMTP id w187mr4794439wmb.27.1625587306854;
        Tue, 06 Jul 2021 09:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf3SIjPzhBrTlg9BxLb8FhE5zoAaVaW0K9FFwNlBnAnkxzzGcrUqGlsbeH3InUge2TgjqNc6VPAXHKHt/Xe4Y=
X-Received: by 2002:a1c:62c4:: with SMTP id w187mr4794417wmb.27.1625587306675;
 Tue, 06 Jul 2021 09:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210705181824.2174165-1-agruenba@redhat.com> <20210705181824.2174165-2-agruenba@redhat.com>
 <YOPkNnQ34vRiVYs6@infradead.org>
In-Reply-To: <YOPkNnQ34vRiVYs6@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 6 Jul 2021 18:01:35 +0200
Message-ID: <CAHc6FU5j7T31OknUk+_WejRw_1s9NCuq=59YExAHY2iWHCgZZA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] iomap: Don't create iomap_page objects for inline files
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 6, 2021 at 7:07 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 05, 2021 at 08:18:23PM +0200, Andreas Gruenbacher wrote:
> > In iomap_readpage_actor, don't create iop objects for inline inodes.
> > Otherwise, iomap_read_inline_data will set PageUptodate without setting
> > iop->uptodate, and iomap_page_release will eventually complain.
> >
> > To prevent this kind of bug from occurring in the future, make sure the
> > page doesn't have private data attached in iomap_read_inline_data.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>
> As mentioned last round I'd prefer to simply not create the iomap_page
> at all in the readpage/readpages path.

I've tried that by replacing the iomap_page_create with to_iomap_page
in iomap_readpage_actor and with that, I'm getting a
VM_BUG_ON_PAGE(!PageLocked(page)) in iomap_read_end_io -> unlock_page
with generic/029. So there's obviously more to it than just not
creating the iomap_page in iomap_readpage_actor.

Getting rid of the iomap_page_create in iomap_readpage_actor
completely isn't a necessary part of the bug fix. So can we focus on
the bug fix for now, and worry about the improvement later?

> Also this patch needs to go after the current patch 2 to be bisection clean.

Yes, makes sense.

Thanks,
Andreas

