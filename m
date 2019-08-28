Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49976C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 21:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193882189D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 21:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G84NP4C0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfH1Vae (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 17:30:34 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:35260 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfH1Vae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 17:30:34 -0400
Received: by mail-qk1-f181.google.com with SMTP id r21so1141640qke.2;
        Wed, 28 Aug 2019 14:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h8CddNDq+sWitVQNFlGow6uiUgUVcdVRsNWpPmMOE8I=;
        b=G84NP4C0D2dEHqJ4eMcdP3bxmRBvrog+sdCPEdepNhOjWeuHVZyRFgWK2dRmUrwqyL
         Q9mbWraB1kI+q6bKyCJM0AW9R85Xu8LhIWJSBSUhlqhBOGHqELJcVIMbtbHvE14yvPyv
         bSwx9liDknmni1GaQ9vqdBhTUuOzpAofwVUlKADJy4ch00xRTOdOhklWtKZQezLQOKTW
         jEcXxd2bS9qywZR1mItfzEq/8Y5lQx68kPQ0h+d0fExSRcWs9n4CFEQnEi4tJ4y9nw/U
         PY6W+2+lKu2tvpnln3Qt0xr08EhjCwRr8CdddCgc5vuwi5nd6gya3+yGGTVy/1IV3gVZ
         WmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h8CddNDq+sWitVQNFlGow6uiUgUVcdVRsNWpPmMOE8I=;
        b=eDNMB2RrZLuqJW2fRm8BP3sbK8jPZoQHvS0XEQ8xyREPx/zp7IKWbOZSGnoXnWgRfo
         5tJrGxHB4hHmtO2DQs27JH48ep1uXjypKriVBPd6co3JAiTIsOH0bjil035t8RvMbp+u
         ap8EezCjSXUDVhKSb6xgcQj7yckldGXBsvuxgSCiNZFEyRYUiHWb3Uy71Y5orXezCpRS
         b3dpSXQY6JxzoOpwD5g9sXcdi6M57Hdm9osKkwd1J3tPN/iFZayOjsHPh5ZpwqvM7aO+
         t3Y9YXye7ObfnHwKknQ0KnWZedu5hhXdycu9jv1Flx+or16oixDDR6sdwS/YBzqlwlzu
         onGw==
X-Gm-Message-State: APjAAAUNDbjZRlF9YICJYGLrUdTK4/Ira6JYCURMogvcdMh03wezk/eF
        e+Q87C4BwYsCYYuoUcjDyFesXDJtUeHZjQZ6PXcTK4yB
X-Google-Smtp-Source: APXvYqzIAh6MPDGlLbLGTnT1BtX6OTU9+XQ9/4S67cpN9umljKN+wdP0vnF+elzK1FwQD2Uy4piYSnOW3zsgqLYkjxo=
X-Received: by 2002:a05:620a:13c5:: with SMTP id g5mr6072262qkl.433.1567027833123;
 Wed, 28 Aug 2019 14:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190828064749.GA165571@LGEARND20B15> <20190828151411.GC1037350@magnolia>
In-Reply-To: <20190828151411.GC1037350@magnolia>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Thu, 29 Aug 2019 06:30:43 +0900
Message-ID: <CADLLry50iDrEfDrL3kZP_gku6jnO23qi5VVyuFY3g2BubWg0ww@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout mount-operation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear Mr. Darrick J. Wong

Thanks for reviewing patch. BTW, I have a question for you.

Do I have to update the patch again with 'a space before the brace'?
Or could I just wait for the patch to be imported?

It would be thankful if you give me a feedback.

BR,
Guillermo Austin Kim

2019=EB=85=84 8=EC=9B=94 29=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 12:14, =
Darrick J. Wong <darrick.wong@oracle.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> > If the CONFIG_BUG is enabled, BUG() is executed and then system is cras=
hed.
> > However, the bailout for mount is no longer proceeding.
> >
> > For this reason, using WARN_ON rather than BUG() could prevent this sit=
uation.
> > ---
> >  fs/xfs/xfs_mount.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 322da69..10fe000 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> >                       goto out_hash_destroy;
> >
> >               spin_lock(&mp->m_perag_lock);
> > -             if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > -                     BUG();
> > +             if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, p=
ag))){
>
> Need a space before the brace.
>
> Will fix on import,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
> >                       spin_unlock(&mp->m_perag_lock);
> >                       radix_tree_preload_end();
> >                       error =3D -EEXIST;
> > --
> > 2.6.2
> >
