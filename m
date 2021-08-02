Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D73C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 349D360EBC
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhHBWQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:16:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhHBWQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 18:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627942588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bREK9zy4MDrqGtjS0pSsWU8oAG+CWsA5oDR3x7mbPSI=;
        b=QB/bDxDlvPg82l9xKBMWv2y22OoPWiNxXqvSEZCrFkFLrBT01Dq3ajsP8vcL6lEXo8mT0+
        aN+0Qr6IGVcyKts+rrSKq+7iBfhRlZwJHoksTyBG41pMSj6cra4rQrD9AgI8CjAD4Bsjgv
        NozMghUXzzxk5XqA8ibkrNYWq1QQws4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-vm2Ofz8kNaewFTj_WTMqfw-1; Mon, 02 Aug 2021 18:16:27 -0400
X-MC-Unique: vm2Ofz8kNaewFTj_WTMqfw-1
Received: by mail-wm1-f71.google.com with SMTP id a18-20020a05600c2252b02902531dcdc68fso191030wmm.6
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 15:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bREK9zy4MDrqGtjS0pSsWU8oAG+CWsA5oDR3x7mbPSI=;
        b=tAE2wDvejbhbqC9SW3cFdF3Xs4GlIK/GZIkqgLViQtt/W6yt3oDw1CIZm5slsjgoLK
         UMF7uibvYWi5AjzWLA38d7oG1XKAiMGAEMyvXfDEWPx4ExRh4W4vmc1YPBoe6PSLIKGH
         abQLZg8wQQbYCPhJfq49+8CBS4aY63fdGLzDnJztlpezuwn/B+U+DJHRyB+8V5mnQsq2
         iqKBy0r+K0Gf/tyC9OR1pO38CpGOhF7nmRW04+BKhRiSP4frI3pe1vPZ0CglnB8TU6U1
         KEPg9k8P6SYKG8aWEV+mV2eZNBrM9xhOxpt+4BjSoCaiZW6E7qf34eVmGL5sIPv7gt1X
         Crqg==
X-Gm-Message-State: AOAM530HgqaGwuQd5XNCym07C0lI28l7oOiw559Qv2fS0SbWJZbaNsZw
        N2+4m7xoxBZGscKdG8zeTebxOopQ7WyPDb69+CQfcUChmPZbbInT+vJEvpAXO/DdgFrblzvLT/4
        kAEMe9P1isj054URFRT2oLRnd+9Oa+zaST1pp
X-Received: by 2002:adf:f584:: with SMTP id f4mr19665666wro.211.1627942586403;
        Mon, 02 Aug 2021 15:16:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0I9UcTRdpE8V808zLwZ0ppUehGsLFatZfcJjH0DRbpsdYTHYnfj1IfGIBU85XZ6MC679Jrj8bqU6dL6tCw10=
X-Received: by 2002:adf:f584:: with SMTP id f4mr19665658wro.211.1627942586272;
 Mon, 02 Aug 2021 15:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210801120058.839839-1-agruenba@redhat.com> <20210802221339.GH3601466@magnolia>
In-Reply-To: <20210802221339.GH3601466@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 3 Aug 2021 00:16:15 +0200
Message-ID: <CAHc6FU66B9VJFu6tPvDMJZYPbgGoytf3zR1yxRfg92Zw1=vaCQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: Fix some typos and bad grammar
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 3, 2021 at 12:13 AM Darrick J. Wong <djwong@kernel.org> wrote:
> On Sun, Aug 01, 2021 at 02:00:58PM +0200, Andreas Gruenbacher wrote:
> > Fix some typos and bad grammar in buffered-io.c to make the comments
> > easier to read.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>
> Looks good to me, though I'm less enthused about the parts of the diff
> that combine words into contractions.

Feel free to adjust as you see fit.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks,
Andreas

