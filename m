Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E477C54EBC
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 19:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjAHTla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 14:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjAHTla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 14:41:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3405B85E
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 11:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673206844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33qTT0r6wAZ1WTwwlWCp7SkxG6n6RS0yiwUpFiSj+fQ=;
        b=B3vDuFqzYFB518eYF3YTNmkgBdBUc5A5wg0WMtaQ7c3zqkHLRCjfCx4C538P5NgGXVvI+v
        lCNgHWbY4f178R+5/4N2dbFr6JKvpvVIWI5aYJNHjCkSovCY7asMdXxI1ZhrMc/ugnl9di
        t8VK8hLOl+7pUD62Wwx/yblY3PX3L2s=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-ZsKZHPzRP8eKd8BL0zDBUg-1; Sun, 08 Jan 2023 14:40:42 -0500
X-MC-Unique: ZsKZHPzRP8eKd8BL0zDBUg-1
Received: by mail-pl1-f200.google.com with SMTP id k18-20020a170902c41200b001896d523dc8so5047576plk.19
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2023 11:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=33qTT0r6wAZ1WTwwlWCp7SkxG6n6RS0yiwUpFiSj+fQ=;
        b=O9DxUExyQyPyhOX2Vs4WaQ0/kaKVCPNRYkicgTk9kHgh+IYSTc3IiKJarwpI20yqjN
         g2eMB0kz89tWPTRtYM5pWcgLY0s7UQYsnUflTXETu/pGImKUAoqw23wsmJODRUgFeDj+
         QnVscDZXXb0+r9Z9lIPGYq4cQDAodnvvwTQOJcAWw4mr7s9h0QpCibYj4QfgO+vEzyU2
         NOxb78yic5rBCRc5CFSIIceGkujWfInj/5EoTIZgNo5lhk+s6v68yKvAqs/+ocgWx4Kx
         vhAPY6aNlKB00pwboHzjFqxdPGckAYiknQ+GaiS7ymy4yl5ZOo/KSf9ntBhgmVQhhDeg
         qnyg==
X-Gm-Message-State: AFqh2kp8J1y7/diFlCi7Whm5iFTcpWmt8fBxHpv3RVhgnxO7UT3g6k7L
        tXsm4Oa1saaFdJyDITr+aJF/qah8VfRk+Rog8aYzKwW4DHxI1EHWFlyeW/tSnfPVBOj41/bjFIE
        xMwcKKvFFpLc8d8lCFZXYYI1D8BB4KoXT5DEL
X-Received: by 2002:a63:5d1b:0:b0:495:fb5f:439d with SMTP id r27-20020a635d1b000000b00495fb5f439dmr3366900pgb.68.1673206841654;
        Sun, 08 Jan 2023 11:40:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu1lJQZfWW6xV/PSksmTNaQzyZoMTAsvtqnDEI+7F2q3BfsEW4wdkPdTNM+CpyXNcR3EqzkjBqi270j/f370sU=
X-Received: by 2002:a63:5d1b:0:b0:495:fb5f:439d with SMTP id
 r27-20020a635d1b000000b00495fb5f439dmr3366894pgb.68.1673206841425; Sun, 08
 Jan 2023 11:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20221231150919.659533-1-agruenba@redhat.com> <20221231150919.659533-6-agruenba@redhat.com>
 <Y7r9gnn2q3PnQ030@infradead.org>
In-Reply-To: <Y7r9gnn2q3PnQ030@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Sun, 8 Jan 2023 20:40:29 +0100
Message-ID: <CAHc6FU6UF3CZWqdDoDieFgKZk6_PiJfmBi5jWFTRoNgk9D8-5Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/9] iomap/gfs2: Get page in page_prepare handler
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 8, 2023 at 6:29 PM Christoph Hellwig <hch@infradead.org> wrote:
> > +     if (page_ops && page_ops->page_prepare)
> > +             folio = page_ops->page_prepare(iter, pos, len);
> > +     else
> > +             folio = iomap_get_folio(iter, pos);
> > +     if (IS_ERR(folio))
> >               return PTR_ERR(folio);
>
> I'd love to have a iomap_get_folio helper for this sequence so that
> we match iomap_put_folio.  That would require renaming the current
> iomap_get_folio to __iomap_get_folio.

That's the wrong way around though. iomap_get_folio() is exported to
filesystems, so if at all, we should rename iomap_put_folio() which is
a static function only used in the iomap code.

I'll post an update.

Thanks,
Andreas

