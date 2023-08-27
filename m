Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD76C71153
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Aug 2023 01:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjH0BKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Aug 2023 21:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjH0BJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Aug 2023 21:09:52 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F090139
        for <linux-xfs@vger.kernel.org>; Sat, 26 Aug 2023 18:09:51 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-34ca1bcb48fso8141015ab.2
        for <linux-xfs@vger.kernel.org>; Sat, 26 Aug 2023 18:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693098590; x=1693703390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNzf/kPKblCk/sBSSnEminSaBnSS+1DbUtPdDGpFQ4o=;
        b=h8dsekPiALkeRTePqP58rwYnC+34rt+ujQCTnn/gcZeODHDUmxUk1NKqEAq8fiNJXs
         a28hHgQhGgknMy9xdUvM36l0P6wGyc1iaY3ulkGNdk5z35PWxxvTnisLtZlNDUp3mR9X
         JCL64gVf102qmLcVQ7bjDoQkuLTvn5f02DmX5/2sgmiiWQ6EgAKOavF5jB87MIwGn3Rm
         yqutCfi5uvWn1/sTQOQ460ysQVyq52BJpNAOuEW0l0Bq4FIU+CUDlrR0AZMd+UYdv5A9
         04Vy7s73jbzqLiJkxnJ7MovaEC8csq3S4PYdk7x9k2xsZiHaCGCGjSS5kOkD7AAg6/a3
         5sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693098590; x=1693703390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNzf/kPKblCk/sBSSnEminSaBnSS+1DbUtPdDGpFQ4o=;
        b=c8P41ajESrAAQYUtzzP23C9NPAwBz3XC8f/pAzTDZBKBTO3orQfYh0zlBK1DMl03Jz
         tjwXcjccbuAMbqfVllwtwzMvB/6BLP0h6B42V2iH/vcvQdR1ZyNgWW4w8rb7QdfIYKqt
         tnZsamz2nA87QzbaqPdFViWs9IETF+pQewEmoQqlS3G+saZ/5ZaEknXxN83PnWbzut5u
         KzEsuqoiQ3QSMn77N5R8tHJevmauISX7mYfZ+TWomqIS8+auwtCypYCxibW7ipjqfpGn
         7kMOg8UewEGDYzL8BEjA695sMMMn3V4oSXirattZbjxCHurIWDCE8kQgKtjCaNr8GFJB
         /PFQ==
X-Gm-Message-State: AOJu0YyXH/3tLKOHsqIsCgqRMYJwS+FUmuocK7JxB6n9EKNYXJuWayxH
        RQ8yNAWwsrDrKAI3lmxGxTYujBHylgCsTqtmjoLq62BdVkU=
X-Google-Smtp-Source: AGHT+IHjIhU/y6Ku7W24lJPERgmBfF+4EZ0TnUlPAnuSEBdNRcLOq9+oCosi0j2CFvDtaYT3hjrTMl1z0kWtm3bm7q8=
X-Received: by 2002:a05:6e02:1607:b0:348:f1c6:b978 with SMTP id
 t7-20020a056e02160700b00348f1c6b978mr16286901ilu.0.1693098589875; Sat, 26 Aug
 2023 18:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area> <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
 <ZOl2IHacyqSUFgfi@dread.disaster.area>
In-Reply-To: <ZOl2IHacyqSUFgfi@dread.disaster.area>
From:   Shawn <neutronsharc@gmail.com>
Date:   Sat, 26 Aug 2023 18:09:13 -0700
Message-ID: <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_io shows "extsize" as 0.   The data bsize is always 4096.  What's
the implication of a 0 extsize?

$ sudo xfs_io -c 'stat' /mnt/S48BNW0K700192T/
fd.path =3D "/mnt/S48BNW0K700192T/"
fd.flags =3D non-sync,non-direct,read-write
stat.ino =3D 64
stat.type =3D directory
stat.size =3D 81
stat.blocks =3D 0
fsxattr.xflags =3D 0x0 [--------------]
fsxattr.projid =3D 0
fsxattr.extsize =3D 0    <=3D=3D=3D=3D  0
fsxattr.nextents =3D 0
fsxattr.naextents =3D 0
dioattr.mem =3D 0x200
dioattr.miniosz =3D 512
dioattr.maxiosz =3D 2147483136

On Fri, Aug 25, 2023 at 8:48=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Mon, Aug 21, 2023 at 12:01:27PM -0700, Shawn wrote:
> > Hello Dave,
> > Thank you for your detailed reply.  That fallocate() thing makes a lot =
of sense.
> >
> > I want to figure out the default extent size in my evn.  But
> > "xfs_info" doesn't seem to output it? (See below output)
>
> extent size hints are an inode property, not a filesystem geometry
> property.  xfs_info only queries the later, it knows nothing about
> the former.
>
> # xfs_io -c 'stat' </path/to/mnt>
>
> will tell you what the default extent size hint that will be
> inherited by newly created sub-directories and files
> (fsxattr.extsize).
>
> >
> > Also, I want to use this cmd to set the default extent size hint, is
> > this correct?
> > $ sudo mkfs.xfs -d extszinherit=3D256    <=3D=3D the data block is 4KB,=
  so
> > 256 is 1MB.
>
> Yes.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
