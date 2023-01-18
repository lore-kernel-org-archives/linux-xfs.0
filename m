Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB24C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 16:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjARQ10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjARQ0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 11:26:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DF74F843
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 08:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674059087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H4gPDbXgRwcEu9eRFB58g+gXi6AVjus+QHhs3v57+Uw=;
        b=RFkJUvHMDuQchLyf9vNPTzTv5UVaDoKxoCJTZppqYkj2s0qUgfuEbJgv/ZmdNdzwzNxnjq
        50CrQEY3XS1c8udSuRqqwLtRa32gFxHXyTokNsJvGaBpJQz/OVV8QgGk6gmZ2SVpbtCg9q
        ZPTWjWKOkbiYib+xcsWK7fLLSQIxJRQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-8dVKQ8v9O9OtWVaCBDyO7g-1; Wed, 18 Jan 2023 11:24:45 -0500
X-MC-Unique: 8dVKQ8v9O9OtWVaCBDyO7g-1
Received: by mail-pf1-f199.google.com with SMTP id b196-20020a621bcd000000b0058a63dc105eso11772977pfb.6
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 08:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4gPDbXgRwcEu9eRFB58g+gXi6AVjus+QHhs3v57+Uw=;
        b=NMIczTza/xsDU12Hz/NlBstf9YgBiLni/iaGpbIt9leXJz1JRAYzKyUnvUG8FQgamo
         ELnOY/GKKj9xFNMtrrfZyLM2pBqJdM0vS0FuQhf96ryfFwBppDDzWedMy56aDf7G1HN+
         0fqAHdG+PhROcT+DKiz87WrIDptKoy1bBuXaCDWvhc0wCStQOpn4ZO+QuLopSs5oY0OI
         FWZTlzvZHaM0BokHyvixc41rSLJk/gzO7iTVds49Z11LRWXYbXeBSPepkwfvCXonj0py
         fHpB0bfyUBfTvvHv8xaScJ8NQb6AQW2waKe7Rb5QW0Ztsa4Hjqodu+e1VXP3skxZHRTd
         oJ8Q==
X-Gm-Message-State: AFqh2kr4wchEmr9NoAwyqb+MZeCKQG5KXCSaWkm0zL/3kHhaYEtSzzM2
        EQXWzt/QbO8pLw3PHU6ptqgldyr1OYKxZgEgAlvz1NReKLX1f4XuVLx6zSdf/6gOO9rwTIJjrLv
        wv7nSvuq2JDgTKp8p51af1Exy2mQxDD6See12
X-Received: by 2002:a63:5849:0:b0:478:eb77:b104 with SMTP id i9-20020a635849000000b00478eb77b104mr618316pgm.236.1674059084728;
        Wed, 18 Jan 2023 08:24:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtvkaGNY8lVgDyNm0tuarLhfWyFgPfPp/0vXS/hCHoGVIWXwNRYT3XKDintDuiBfiXwyin720mSswN72fFwbPw=
X-Received: by 2002:a63:5849:0:b0:478:eb77:b104 with SMTP id
 i9-20020a635849000000b00478eb77b104mr618307pgm.236.1674059084379; Wed, 18 Jan
 2023 08:24:44 -0800 (PST)
MIME-Version: 1.0
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-8-hch@lst.de>
 <Y8gXodKIUneO+XQb@casper.infradead.org>
In-Reply-To: <Y8gXodKIUneO+XQb@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 18 Jan 2023 17:24:32 +0100
Message-ID: <CAHc6FU7Exz2kr+x7jvK1mi5ENOVCOXruP7qKSdPsyhSwmfMhDA@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH 7/9] gfs2: handle a NULL folio in gfs2_jhead_process_page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[Christoph's email ended up in my spam folder; I hope that was a
one-time-only occurrence.]

On Wed, Jan 18, 2023 at 5:00 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Wed, Jan 18, 2023 at 10:43:27AM +0100, Christoph Hellwig wrote:
> > filemap_get_folio can return NULL, so exit early for that case.
>
> I'm not sure it can return NULL in this specific case.  As I understand
> this code, we're scanning the journal looking for the log head.  We've
> just submitted the bio to read this page.  I suppose memory pressure
> could theoretically push the page out, but if it does, we're doing the
> wrong thing by just returning here; we need to retry reading the page.
>
> Assuming we're not willing to do the work to add that case, I think I'd
> rather see the crash in folio_wait_locked() than get data corruption
> from failing to find the head of the log.
>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/gfs2/lops.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> > index 1902413d5d123e..51d4b610127cdb 100644
> > --- a/fs/gfs2/lops.c
> > +++ b/fs/gfs2/lops.c
> > @@ -472,6 +472,8 @@ static void gfs2_jhead_process_page(struct gfs2_jdesc *jd, unsigned long index,
> >       struct folio *folio;
> >
> >       folio = filemap_get_folio(jd->jd_inode->i_mapping, index);
> > +     if (!folio)
> > +             return;

We're actually still holding a reference to the folio from the
find_or_create_page() in gfs2_find_jhead() here, so we know that
memory pressure can't push the page out and filemap_get_folio() won't
return NULL.

> >
> >       folio_wait_locked(folio);
> >       if (folio_test_error(folio))
> > --
> > 2.39.0
> >
>

Thanks,
Andreas

