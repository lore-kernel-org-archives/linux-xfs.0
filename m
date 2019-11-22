Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61921C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 374022071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMkpBJVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKVQ15 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:27:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49968 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbfKVQ15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574440076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cChLqfsW2klcb26T9YvZQJuM5m0KkRklRSHQ2KcdB4k=;
        b=gMkpBJVU5a073CbsDP9RXrWRQhYkBEhRLz/9/ugpcP01z3+SLEWyJcx1EtVoj/qRIMQnQ6
        PT/SCoNpEUvhHuxO/Y7SuFEt/VnNyfdB+aHCAzM5VTLh1wELh5PBMU9V3Mw6cegKzuMGxU
        /zBm5TbRjOLYYTfO/n7XOFHe5QO/dM8=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-4atNe6GjPuS4cVXGKq9r5Q-1; Fri, 22 Nov 2019 11:27:54 -0500
Received: by mail-vk1-f199.google.com with SMTP id f73so3108832vka.4
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 08:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7n3Ilt7RsiqmF09Rk5o812EuPWZToBn3tPTB8g3a1c0=;
        b=lYmikVBuDZjrOp9dABCnlPEVxd3YrpZHxbko9wAg504jmQ3Cg3YQJ7DUlyUhX3Cl2z
         7JTGMC/pwquLbiyRN4cSIC5xj8SZf2jZuEzCZ5AHUIopEhfiKE7BkeX+1J90QRGGWVcd
         3kguEU6Nmjaa+kdQkWzpwTB9ho+2AFCoS+vI8EkDY/VNTXNmEhDCevqnv/Kd1UTu3n7M
         3rILi+CHpHWPSlnpWuDXcLV6feFp2v9vdZNSE7DSBjW0XOOb4yy9jdDrHUjGI/Oab2zS
         cZsW7Ft9DGczBaIRqGJ6O7rCwwqV0cmOaodXcCOLnarDIvCyrbvg91+mkury+eYiZWuR
         5Atg==
X-Gm-Message-State: APjAAAVBEWey3N0CgxHyezmV8Ba7gyGVVIJsOyW102QxwBzrLv1P/phM
        zR8KRWwG8VT0LYWueeYIgyIyTuFVbVHfqwVs5Xz6HlOOtF4JhdVT9/stAuAGNlc59CQlrfGacUi
        yAlf21Q8rLvoSgFBagUtbsgXpSDOQWDrY3jQG
X-Received: by 2002:a05:6102:5c7:: with SMTP id v7mr10414190vsf.85.1574440074008;
        Fri, 22 Nov 2019 08:27:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqyr+NXEN/+4FZRYHPwqMzEM/JIcl2TPqvS4rt1T0IG9nE6qI+UYM+Ne1mJg26any6qehlSz6cMjxNiSA8ylQTw=
X-Received: by 2002:a05:6102:5c7:: with SMTP id v7mr10414165vsf.85.1574440073682;
 Fri, 22 Nov 2019 08:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20191121214445.282160-1-preichl@redhat.com> <20191121214445.282160-3-preichl@redhat.com>
 <20191121215917.GA6219@magnolia>
In-Reply-To: <20191121215917.GA6219@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 22 Nov 2019 17:27:42 +0100
Message-ID: <CAJc7PzXhL0moF8bCkNNnSWrA7R6EUi6Anz3An-nuFSP5yD=PmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: 4atNe6GjPuS4cVXGKq9r5Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 10:59 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index a02d6f66..07b8bd78 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >       const uint64_t  step            =3D (uint64_t)2<<30;
> >       /* Sector size is 512 bytes */
> >       const uint64_t  count           =3D nsectors << 9;
> > +     uint64_t        prev_done       =3D (uint64_t) ~0;
> >
> >       fd =3D libxfs_device_to_fd(dev);
> >       if (fd <=3D 0)
> > @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >
> >       while (offset < count) {
> >               uint64_t        tmp_step =3D step;
> > +             uint64_t        done =3D offset * 100 / count;
> >
> >               if ((offset + step) > count)
> >                       tmp_step =3D count - offset;
> > @@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >                       return;
> >
> >               offset +=3D tmp_step;
> > +
> > +             if (prev_done !=3D done) {
>
> Hmm... so this prints the status message every increase percentage
> point, right?

Not at all, the 'least change' it prints is one percent but that's the
maximum granularity i.e. I tested with 10 GB file and the output was:

Discarding:  0% done
Discarding: 20% done
Discarding: 40% done
Discarding: 60% done
Discarding: 80% done
Discarding is done.

So ATM there could be up to 102 lines - please propose a different idea.


>
> > +                     prev_done =3D done;
> > +                     fprintf(stderr, _("Discarding: %2lu%% done\n"), d=
one);
>
> This isn't an error, so why output to stderr?
My bad, sorry.

>
> FWIW if it's a tty you might consider ending that string with \r so the
> status messages don't scroll off the screen.  Or possibly only reporting
> status if stdout is a tty?

Do I get it right that you propose to not flow the terminal with
dozens of lines which just update the percentage but instead keep
updating the same line? If so, I do like that.

>
> --D
>
> > +             }
> >       }
> > +     fprintf(stderr, _("Discarding is done.\n"));
> >  }
> >
> >  static __attribute__((noreturn)) void
> > --
> > 2.23.0
> >
>

