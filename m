Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18865EB64DA
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Jun 2023 16:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjFXQIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Jun 2023 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjFXQIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Jun 2023 12:08:37 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8CA1BC1
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 09:08:35 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-44350ef5831so51223137.2
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687622914; x=1690214914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3RMn8DD49Gz27bWXzIiBZ70P/ipOea1Akgeo0yKNDSA=;
        b=nup5tzSymaHpZxuuclS9RK3zvmjxO04eqYZVIGVxi4pyKTuWWWxbDtjgFO5ClrIbco
         W+Qz7wBo+x/6IAbedIL/nzxTQlWYvXT1c+An8WMYKrSwSR+Wu/IYVQxghKTf7BLMfoBD
         pWvNGuMSURM4kqTGDFsYr74UClX+VAtCv3+7rLBUj+Q8C6y6pCt9ZEQbxqM0WhtyVYkD
         kcu8eYGwTgAFHiMLQOzDjqqnnijUCu1op/70yKZw50YAJKv2EuO20r+xkubiUcvZM3l3
         1PPz2DRjFi4D4aZ1DEholsElOx9OLTBzwDYk/rbTHH0mra1RYeECxDXW5pcENV3I/Wu7
         fYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687622914; x=1690214914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3RMn8DD49Gz27bWXzIiBZ70P/ipOea1Akgeo0yKNDSA=;
        b=FPbN/xqraOFsmv/mAK3dEXEVTeHRaJfB+EgXhwIOVYW5sn98Rh9e/KxwH/0db/YC8U
         5FmjcWrYGRpc1p9/Rs+mPerHt0p/W72obIEoNNRXv36uLERHpTmXjyQmKWTOpb3Rp3PP
         sTiSMRF6R57LE5YwJFDSF/7MPGBuQ00Q9zzs+khvJRasW78I+B2axFCt2431XQVwO8jq
         iRzkwshfURDb+TgYrMkHihsl8OCWAbRJaBHteh/lcsU63oDfegMz3dUN1nc+XQUDh2nA
         eGYoERL6CHShN+Otbw645QsuKxfXdFii0BPluAoUloBjNQ9qD4EoLQmML03mQgOpAzoQ
         v4tg==
X-Gm-Message-State: AC+VfDzapd9TxHKEuH/ptTAWNKKKZItonB0KRPquhdYaUd0Tam5RoOg6
        TfUEGpSDu+sbrJkPAQY4uWK2f1VR+vH3GEfr+hxHd1Ad/6I=
X-Google-Smtp-Source: ACHHUZ74mid7wr3RHcs6KPRd0Z+9QwCytU5qGi16lNQ+P3VubKJLdHyy1ivzeamF8ynvyvKQWrxsL3Op2WpfnEeg4K0=
X-Received: by 2002:a67:e98e:0:b0:43b:1f8a:d581 with SMTP id
 b14-20020a67e98e000000b0043b1f8ad581mr13181248vso.31.1687622914466; Sat, 24
 Jun 2023 09:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net> <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
 <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
In-Reply-To: <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
From:   Fernando CMK <ferna.cmk@gmail.com>
Date:   Sat, 24 Jun 2023 13:08:23 -0300
Message-ID: <CAEBim7AguwTk4Rhin-btHM2iDtUQf4Vq5uRM_pmqGWt4OchE6Q@mail.gmail.com>
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Eric

sent you the dd output you requested on a separate email. Here's the
xfs_info output of image of the damaged fs, and also another xfs_info
on the same md raid device where I already did a mkfs.xfs again, so it
should be a similar FS on top of the same LV where the damaged FS used
to live.

New fs  on same LV on the same RAID5 MD array:
meta-data=3D/dev/mapper/raid5--8tb--1-usbraid5--2
isize=3D512    agcount=3D33, agsize=3D10649472 blks
        =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
        =3D                       crc=3D1        finobt=3D1, sparse=3D1, rm=
apbt=3D0
        =3D                       reflink=3D0    bigtime=3D0 inobtcount=3D0
data     =3D                       bsize=3D4096   blocks=3D340787200, imaxp=
ct=3D5
        =3D                       sunit=3D128    swidth=3D256 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D166400, version=
=3D2
        =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-count=
=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


meta-data=3Ddisk-dump-usbraid5-2   isize=3D512    agcount=3D42, agsize=3D81=
92000 blks
        =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
        =3D                       crc=3D1        finobt=3D1, sparse=3D0, rm=
apbt=3D0
        =3D                       reflink=3D0    bigtime=3D0 inobtcount=3D0
data     =3D                       bsize=3D4096   blocks=3D340787200, imaxp=
ct=3D25
        =3D                       sunit=3D128    swidth=3D4294897408 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D128000, version=
=3D2
        =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-count=
=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

On Sat, Jun 24, 2023 at 12:26=E2=80=AFAM Eric Sandeen <sandeen@sandeen.net>=
 wrote:
>
> On 6/23/23 6:26 PM, Fernando CMK wrote:
> > On Fri, Jun 23, 2023 at 6:14=E2=80=AFPM Eric Sandeen <sandeen@sandeen.n=
et> wrote:
> >>
> >> On 6/23/23 3:25 PM, Fernando CMK wrote:
> >>> Scenario
> >>>
> >>> opensuse 15.5, the fs was originally created on an earlier opensuse
> >>> release. The failed file system is on top of a mdadm raid 5, where
> >>> other xfs file systems were also created, but only this one is having
> >>> issues. The others are doing fine.
> >>>
> >>> xfs_repair and xfs_repair -L both fail:
> >>
> >> Full logs please, not the truncated version.
> >
> > Phase 1 - find and verify superblock...
> >         - reporting progress in intervals of 15 minutes
> > Phase 2 - using internal log
> >         - zero log...
> >         - 16:14:46: zeroing log - 128000 of 128000 blocks done
> >         - scan filesystem freespace and inode maps...
> > stripe width (17591899783168) is too large
> > Metadata corruption detected at 0x55f819658658, xfs_sb block 0xfa00000/=
0x1000
> > stripe width (17591899783168) is too large
>
> <repeated many times>
>
> It seems that the only problem w/ the filesystem detected by repair is a
> ridiculously large stripe width, and that's found on every superblock.
>
> dmesg (expectedly) finds the same error when mounting.
>
> Pretty weird, I've never seen this before. And, xfs_repair seems unable
> to fix this type of corruption.
>
> can you do:
>
> dd if=3D<filesystem device or image> bs=3D512 count=3D1 | hexdump -C
>
> and paste that here?
>
> I'd also like to see what xfs_ifo says about other filesystems on the md
> raid.
>
> -Eric
>
