Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC97C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 17:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiLPRQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 12:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiLPRQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2022 12:16:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919782A969
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 09:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671210957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMxxbypNViBdI4yIgrSC4IXd1P5dO6tqxf8uJ4BBzw8=;
        b=hvZALtjRA6pYnbDarAOcKYmL3WB9TX/xmoRa4VKPjH5HxwUbpqCsV8sIO4C2sdLT+quRho
        Z5H2gdlvCJz8h0L0pzQUIxV9dHAaQpMotjj2piooyCf8dbtSaBuFl19htS4JCnhHNzDyuv
        RWRS2I5SusBMXLj43CJm3Inx0b6Hl+E=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-vnuEq7c_OqGw7rNpwNLW3A-1; Fri, 16 Dec 2022 12:15:56 -0500
X-MC-Unique: vnuEq7c_OqGw7rNpwNLW3A-1
Received: by mail-yb1-f197.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso3335012ybp.20
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 09:15:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FMxxbypNViBdI4yIgrSC4IXd1P5dO6tqxf8uJ4BBzw8=;
        b=XhwrtQYQEKB7S02fYzcyrNZPQbiXaHsjn90nwN2HQ1kYgWHohTlaXw3knFYoehJpji
         vGhMDBXTd2m7FhMLW7/+nOPPxTBgk8dtBB5To0F+cMkSZGQ+W/u0DczdXGrSwJQQfn7l
         HX45yGi6tc4htNhFbbQE+HDyT2ccnz/igcJn9Ls+dm+xJX6rBDpilwCeQZEGBiUXqXf0
         Zo/NKnXRA3o2cdRZZmlzPkP9nNkcbd5yS8XrH3mYSypL24IqDjqXENH56VndRQYF5ybj
         /dJWRGVmi+rQleM/kHmNWuX2nxFM2WUnXBmPJJgK//SxAoOhJiq5GAVGyqgfANDja/xG
         s51Q==
X-Gm-Message-State: ANoB5plaiqI6CbY+mS/2kdMUJPOW2dftCKHwjaIBRLVfoiPCQNr2w7KF
        wlEP4lHVbDxrhPX3x1WDRvY/2JOeBHxPhZ2fg62UD8BFOT8u8rH9fBZZ+UNtOJ/Q63TeeIMxMzo
        fEJvS57BqmhjkEChYADCKNOSRwxDc+uK3aW90
X-Received: by 2002:a81:8407:0:b0:3e2:c77b:2563 with SMTP id u7-20020a818407000000b003e2c77b2563mr27749513ywf.54.1671210955579;
        Fri, 16 Dec 2022 09:15:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5sSx3su6laK9Kl+Wo+aUvlhEYchIP7sOq3J3e9vBxi/aJmFLAxjsr1EmGJ4JGxvgXw8z2oIHThFHswEOSM94k=
X-Received: by 2002:a81:8407:0:b0:3e2:c77b:2563 with SMTP id
 u7-20020a818407000000b003e2c77b2563mr27749506ywf.54.1671210955331; Fri, 16
 Dec 2022 09:15:55 -0800 (PST)
MIME-Version: 1.0
References: <20221216150626.670312-1-agruenba@redhat.com> <20221216150626.670312-6-agruenba@redhat.com>
 <Y5ydHlw4orl/gP3a@casper.infradead.org>
In-Reply-To: <Y5ydHlw4orl/gP3a@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 16 Dec 2022 18:15:44 +0100
Message-ID: <CAHc6FU7Svp7XG8T5X4kak8Gz2kB2_OK1b5xbtn6uKrEnb6=3TQ@mail.gmail.com>
Subject: Re: [RFC v3 5/7] iomap: Get page in page_prepare handler
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2022 at 5:30 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Fri, Dec 16, 2022 at 04:06:24PM +0100, Andreas Gruenbacher wrote:
> > +     if (page_ops && page_ops->page_prepare)
> > +             folio = page_ops->page_prepare(iter, pos, len);
> > +     else
> > +             folio = iomap_folio_prepare(iter, pos);
> > +     if (IS_ERR_OR_NULL(folio)) {
> > +             if (!folio)
> > +                     return (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
> > +             return PTR_ERR(folio);
>
> Wouldn't it be cleaner if iomap_folio_prepare() always
> returned an ERR_PTR on failure?

Yes indeed, thanks.

Andreas

