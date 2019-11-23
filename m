Return-Path: <SRS0=qbJ3=ZP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261FBC432C0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 15:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBDB620719
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 15:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWHRM3DV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWPop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Nov 2019 10:44:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23646 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726487AbfKWPop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Nov 2019 10:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574523882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPFAghcYbna2bMfM2yGUunf+0djP+EOJOuzlM9T+GLw=;
        b=cWHRM3DVuU2vwdLg1Jb9mEMlCQnNnt32+ET9NPqPuo7KTNaWYeXQqGbMiYNa9sGY+AmgE6
        QGRj+tcrOJ/4Pi6+RE1D8+X148LYofjsRTXnX1UKhSoNJ2XgNPKDl5xjJwe79p/S/24FM+
        xq0tYIZlUitIr8TnnHq2kB9185iYnP8=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-4VblXYz4PP6rySlL67gPoA-1; Sat, 23 Nov 2019 10:44:41 -0500
Received: by mail-ot1-f72.google.com with SMTP id w9so5536648otj.22
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2019 07:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Eaya7lya9rjpvjEVudL4FxcKqZPc2xj7JrOzsCyBZ0=;
        b=CL8+7mRXUJUB/CyZrF0+NGgFo0ocbMD9zBxLRu5IPF/HrUfwASROh/afOXj0KgRqhk
         hc+VfHJx2EiI/5efRi9oGnNGGZ15pk0gjKXpo4QqPHfTEeoyoBKSLUuEB/7x/+qvZZkL
         RLtIJWLK7Z/MuXNQ+tIvZd18xz6t0Y0nkc6rYbjQrTdga4ujqa7hSB3lkQDD9W5kSnO0
         Nq5MvuJH556sTFOqMKsxCie1LET07VyUlDRA0g6XMsNlFebhxq/Ofk4Jz/6NCYo4fszl
         PXstZbLttIdfPqmcRvUlKhi4E4RBy+CyRiKNlib4NWjAfWaEUmd/iFvL/TU11XkTWZIJ
         DB0A==
X-Gm-Message-State: APjAAAUTBXaNWHe3v1vmXd+jqAyvq/oTsd+PWxEXVU7LRoLPrUA4r3hC
        7hTa00sajAnDDVJ6izFsolUM+riez4yY8XFVZ8ZPvzbcUFCzlqjtyLWOniGgEcB9+HDFUFAZNlu
        zmjSjO9iAXvBDwv9Ae1G4gzoVpYePF2xAJ/uz
X-Received: by 2002:a9d:7384:: with SMTP id j4mr4567073otk.94.1574523880487;
        Sat, 23 Nov 2019 07:44:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/VY6IWgFUf68k0qtHLKcYy5of13ZDjXR2prYxQde8XDzGv2N8PBkIHZNBQzLktCn+0y7ZwjndQ2X6EuJRGpU=
X-Received: by 2002:a9d:7384:: with SMTP id j4mr4567058otk.94.1574523880049;
 Sat, 23 Nov 2019 07:44:40 -0800 (PST)
MIME-Version: 1.0
References: <20191122213122.13327-1-jpittman@redhat.com> <CAJc7PzWPv5UHMWb+twW6g8tWLCFX_6aRTaH6F3bXLsRmZxaZvQ@mail.gmail.com>
In-Reply-To: <CAJc7PzWPv5UHMWb+twW6g8tWLCFX_6aRTaH6F3bXLsRmZxaZvQ@mail.gmail.com>
From:   John Pittman <jpittman@redhat.com>
Date:   Sat, 23 Nov 2019 10:44:29 -0500
Message-ID: <CA+RJvhy6Dmr=fgCDhub3hcOr1m3gvanXshXCE4HPQzjS7eLF=Q@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: add missing carriage returns in libxfs/rdwr.c
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
X-MC-Unique: 4VblXYz4PP6rySlL67gPoA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

You're exactly right Pavel; thanks for the clarification. Sending v2 now.

On Sat, Nov 23, 2019 at 2:08 AM Pavel Reichl <preichl@redhat.com> wrote:
>
> On Fri, Nov 22, 2019 at 10:31 PM John Pittman <jpittman@redhat.com> wrote=
:
> >
> > In libxfs/rdwr.c, there are several fprintf() calls that are
> > missing trailing carriage returns. This translates to the
> > following CLI prompt being on the same line as the message.
> > Add missing carriage returns, alleviating the issue.
> >
> > Fixes: 0a7942b38215 ("libxfs: don't discard dirty buffers")
> > Signed-off-by: John Pittman <jpittman@redhat.com>
> > ---
> >  libxfs/rdwr.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 7080cd9c..3f69192d 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -651,7 +651,7 @@ __libxfs_getbufr(int blen)
> >         pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
> >         bp->b_ops =3D NULL;
> >         if (bp->b_flags & LIBXFS_B_DIRTY)
> > -               fprintf(stderr, "found dirty buffer (bulk) on free list=
!");
> > +               fprintf(stderr, "found dirty buffer (bulk) on free list=
!\n");
> >
> >         return bp;
> >  }
> > @@ -1224,7 +1224,7 @@ libxfs_brelse(
> >                 return;
> >         if (bp->b_flags & LIBXFS_B_DIRTY)
> >                 fprintf(stderr,
> > -                       "releasing dirty buffer to free list!");
> > +                       "releasing dirty buffer to free list!\n");
> >
> >         pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
> >         list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> > @@ -1245,7 +1245,7 @@ libxfs_bulkrelse(
> >         list_for_each_entry(bp, list, b_node.cn_mru) {
> >                 if (bp->b_flags & LIBXFS_B_DIRTY)
> >                         fprintf(stderr,
> > -                               "releasing dirty buffer (bulk) to free =
list!");
> > +                               "releasing dirty buffer (bulk) to free =
list!\n");
> >                 count++;
> >         }
> >
> > --
> > 2.17.2
> >
>
> Hello John,
>
> it seems to me that you are confusing carriage return (CR, \r) and
> line feed (LF, \n) in the commit description. Could you check that
> out, please? Otherwise it looks good to me.
>
> Thanks.
>
> Pave Reichl
>

