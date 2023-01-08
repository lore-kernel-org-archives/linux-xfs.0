Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31555C54EBD
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 18:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjAHSu6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 13:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbjAHSu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 13:50:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7C7EE36
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 10:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673203817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9jQNIllhSt00CU4g1E2gZlTxdbv8nF9P6i3eiXT6SBw=;
        b=XdbSqzr3GdmF/ToOeGu2j4LKnwJtwdF9SjdK9G5g80KO+pFkCmjU/Inyzhq6tJd8mZRb7R
        l0BjkpN55D46WGfE+vP9TiZYGdTlJNlstVWjyyfs6vtRL2RpeuBBZKI4n7n9jJD2Oj3IpJ
        pbnIsqsjlP1OHhARr+hjHLwCzFsyQTs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-wxp7QmzUOYauaoenUeqANw-1; Sun, 08 Jan 2023 13:50:14 -0500
X-MC-Unique: wxp7QmzUOYauaoenUeqANw-1
Received: by mail-pg1-f198.google.com with SMTP id g32-20020a635660000000b00478c21b8095so2949462pgm.10
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2023 10:50:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9jQNIllhSt00CU4g1E2gZlTxdbv8nF9P6i3eiXT6SBw=;
        b=iaIra2D547UpghqQoFObuoh0/a45wAO0zGM3IBhSmhs5TEWk8ofKSTTSk6oyfUGOuC
         7Hd76dBqpilqQ7MB6q0OsnQsW/sw/8zJjPjDObZYmR4bXnr+gA5k/ENwzoBChfa5KBJN
         0Pq7YRlPUPL1ckgQoN7UB/2Sff5t3V3ur10LbAF7QlTOSGTiLoMq67GH+lq9u3JETRoV
         iwVTxh/bi/KLnguSeK3hZpUCRJQkvYCBaPjgLwd4vLfuNWI0pUDGo3IoUiI73ytKvPMy
         RvhcRTzrP/d/X9PYrAAUGTV04lueUxrUydSVjuFGpVQ4R5P2g/m2IahrXX1FH0DbeTxj
         fvxg==
X-Gm-Message-State: AFqh2komY6TKaKOkyem4IV5UOoB/lgidQmitM73NuRbb7ydd8VIt4WLp
        MMfBfGfwbW2ENMNO/s6PM5l5/CfMKrOuUezIX1k0iV3TCUq3uya1raAJ4CQ00yLdQMAh3Xfkmph
        6b167sNRH+WNLJPBDohPXw4ZSYzqyiBh5g83f
X-Received: by 2002:a17:902:e548:b0:18f:8f1e:992f with SMTP id n8-20020a170902e54800b0018f8f1e992fmr4306614plf.64.1673203813796;
        Sun, 08 Jan 2023 10:50:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXstvvxTztVEE9wBUChZcquZg0V0o2leHuc2i1QtYb1NeSt2hpOsgP2alVmFjwEvRquoy8ThwzDAX538fmXv+p0=
X-Received: by 2002:a17:902:e548:b0:18f:8f1e:992f with SMTP id
 n8-20020a170902e54800b0018f8f1e992fmr4306613plf.64.1673203813573; Sun, 08 Jan
 2023 10:50:13 -0800 (PST)
MIME-Version: 1.0
References: <20221231150919.659533-1-agruenba@redhat.com> <20221231150919.659533-8-agruenba@redhat.com>
 <Y7W9Dfub1WeTvG8G@magnolia> <Y7XOoZNxZCpjCJLH@casper.infradead.org> <Y7r+NkbfDqat9uHA@infradead.org>
In-Reply-To: <Y7r+NkbfDqat9uHA@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Sun, 8 Jan 2023 19:50:01 +0100
Message-ID: <CAHc6FU40OYCpRjnitmKn6s9LOZCy4O=4XobHdcUeFc=k=x5cGg@mail.gmail.com>
Subject: Re: [PATCH v5 7/9] iomap/xfs: Eliminate the iomap_valid handler
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 8, 2023 at 6:32 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jan 04, 2023 at 07:08:17PM +0000, Matthew Wilcox wrote:
> > On Wed, Jan 04, 2023 at 09:53:17AM -0800, Darrick J. Wong wrote:
> > > I wonder if this should be reworked a bit to reduce indenting:
> > >
> > >     if (PTR_ERR(folio) == -ESTALE) {
> >
> > FYI this is a bad habit to be in.  The compiler can optimise
> >
> >       if (folio == ERR_PTR(-ESTALE))
> >
> > better than it can optimise the other way around.
>
> Yes.  I think doing the recording that Darrick suggested combined
> with this style would be best:
>
>         if (folio == ERR_PTR(-ESTALE)) {
>                 iter->iomap.flags |= IOMAP_F_STALE;
>                 return 0;
>         }
>         if (IS_ERR(folio))
>                 return PTR_ERR(folio);

Again, I've implemented this as a nested if because the -ESTALE case
should be pretty rare, and if we unnest, we end up with an additional
check on the main code path. To be specific, the "before" code here on
my current system is this:

------------------------------------
        if (IS_ERR(folio)) {
    22ad:       48 81 fd 00 f0 ff ff    cmp    $0xfffffffffffff000,%rbp
    22b4:       0f 87 bf 03 00 00       ja     2679 <iomap_write_begin+0x499>
                        return 0;
                }
                return PTR_ERR(folio);
        }
[...]
    2679:       89 e8                   mov    %ebp,%eax
                if (folio == ERR_PTR(-ESTALE)) {
    267b:       48 83 fd 8c             cmp    $0xffffffffffffff8c,%rbp
    267f:       0f 85 b7 fc ff ff       jne    233c <iomap_write_begin+0x15c>
                        iter->iomap.flags |= IOMAP_F_STALE;
    2685:       66 81 4b 42 00 02       orw    $0x200,0x42(%rbx)
                        return 0;
    268b:       e9 aa fc ff ff          jmp    233a <iomap_write_begin+0x15a>
------------------------------------

While the "after" code is this:

------------------------------------
        if (folio == ERR_PTR(-ESTALE)) {
    22ad:       48 83 fd 8c             cmp    $0xffffffffffffff8c,%rbp
    22b1:       0f 84 bc 00 00 00       je     2373 <iomap_write_begin+0x193>
                iter->iomap.flags |= IOMAP_F_STALE;
                return 0;
        }
        if (IS_ERR(folio))
                return PTR_ERR(folio);
    22b7:       89 e8                   mov    %ebp,%eax
        if (IS_ERR(folio))
    22b9:       48 81 fd 00 f0 ff ff    cmp    $0xfffffffffffff000,%rbp
    22c0:       0f 87 82 00 00 00       ja     2348 <iomap_write_begin+0x168>
------------------------------------

The compiler isn't smart enough to re-nest the ifs by recognizing that
folio == ERR_PTR(-ESTALE) is a subset of IS_ERR(folio).

So do you still insist on that un-nesting even though it produces worse code?

Thanks,
Andreas

