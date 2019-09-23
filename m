Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A241EC4CECF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 19:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F0EC20673
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 19:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uhn0xoHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfIWThp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 15:37:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45825 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfIWThp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 15:37:45 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so4221037iot.12
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 12:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7jfcE/kmcpFH+pAaVnF4vnUEckyQJ8mw+mJcuv5+6ss=;
        b=uhn0xoHaxrx/4ubmlWh2J21YINRXN9V+2tEdReTtNgvSwHC35ogaMDec/bMyes3g2a
         /0fFBysMFByIo0cciUrc/5wDmKuzObHP2Vkw1CsKvSqgllk6sPoe3vzcJbeluU6FtsqL
         +sy7Giwar5iuUi8ZHnRPoULS27ht8KIw3YkcKrhy2CLJ477+ufhSEo0dPdZCSxQR/yt2
         bN64uA4nLsJG4EAHo9hsPQaOsIzCAJBKq/CYou8GSq0qIu6idBmWm5GnsGCv9YhdzfBp
         GoSW4l91Zg4cvVYnC7Zznwy6GsILQSL+zFHFV30trVBjiCsZOXm6HKwQlryEWLqHKydg
         F/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7jfcE/kmcpFH+pAaVnF4vnUEckyQJ8mw+mJcuv5+6ss=;
        b=jKTSXS6f2H0V+8Ayn+V3lWLQHpcGwBCt/UYYzlM02mAbLr89hhP1Pqnn7n0CQCSLjr
         jxiq4dV6jVcI+VcSq/DqoIEYxHyppA5z9PS39TRPb5H29PxCJl8qmbaom7OPI44YCFQ8
         LyHlUmGCM3KFvTjmM5Idu02MlgSIxEke/P9meS5nyuX5vGiibI67q9GPsLFTxgLH13O0
         4PZmicYvPqJTPDH6jumrjnjeddHgA5kozmUzWeFx6Idhy2Z+V2rG1btxXtJIZDrEpRIK
         eANdEkTCGPj73XtPxE3tYG1eN5w/A+xK5fuET0wIAiBj/pcZcnSxXhjkJ5Ypd++h9raQ
         rdng==
X-Gm-Message-State: APjAAAUyxCdYYHluOD/38MU5+/104v6/dXlxWr95hQf3wpCd+O+Q7DRg
        4UXn6nhHGGPdRtIvEce3xtu1YL5VQSiJxN0J0Ho=
X-Google-Smtp-Source: APXvYqxY5Weo5ngbs1lpmIeynDoXz/8zSMrTq/G4rKWADpaPB8sNu07Htpn+urswJAoRy7jyLHXGijpe/6ZnW1N0MJs=
X-Received: by 2002:a02:c65a:: with SMTP id k26mr1264319jan.56.1569267464326;
 Mon, 23 Sep 2019 12:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <7097d965-1676-a70e-56c7-b6cf048057f5@gmail.com>
 <03eac8a7-a442-d6cf-45ab-67500052cc69@sandeen.net> <4cd713f1-7f09-5556-8da4-b21cbb053983@gmail.com>
In-Reply-To: <4cd713f1-7f09-5556-8da4-b21cbb053983@gmail.com>
From:   Stefan Ring <stefanrin@gmail.com>
Date:   Mon, 23 Sep 2019 21:37:33 +0200
Message-ID: <CAAxjCEyYve+yEbuvCuGQjs0bUP3-50oFL0iy8DDGWmiaP6ds2A@mail.gmail.com>
Subject: Re: xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err == 2' failed.
To:     =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 22, 2019 at 9:25 PM Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:
>
> On 16/09/2019 23:35, Eric Sandeen wrote:
> > On 9/15/19 7:44 AM, Arkadiusz Mi=C5=9Bkiewicz wrote:
> >>
> >> Hello.
> >>
> >> xfsprogs 5.2.1 and:
> >>
> >> disconnected dir inode 9185193405, moving to lost+found
> >> disconnected dir inode 9185193417, moving to lost+found
> >> disconnected dir inode 9185194001, moving to lost+found
> >> disconnected dir inode 9185194004, moving to lost+found
> >> disconnected dir inode 9185194010, moving to lost+found
> >> disconnected dir inode 9185194012, moving to lost+found
> >> disconnected dir inode 9185194018, moving to lost+found
> >> disconnected dir inode 9185194027, moving to lost+found
> >> disconnected dir inode 9185205370, moving to lost+found
> >> disconnected dir inode 9185209007, moving to lost+found
> >> corrupt dinode 9185209007, (btree extents).
> >> Metadata corruption detected at 0x449621, inode 0x2237b2aaf
> >> libxfs_iread_extents
> >> xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err =3D=3D 2' fail=
ed.
> >> Aborted
> >
> >>
> >>
> >> # grep -A1 -B1 9185209007 log
> >> entry ".." at block 0 offset 80 in directory inode 9185141346 referenc=
es
> >> non-existent inode 6454491396
> >> entry ".." at block 0 offset 80 in directory inode 9185209007 referenc=
es
> >> free inode 62881485764
> >> entry ".." at block 0 offset 80 in directory inode 9185220220 referenc=
es
> >> free inode 6454492606
> >> --
> >> rebuilding directory inode 9185141346
> >> entry ".." in directory inode 9185209007 points to free inode
> >> 62881485764, marking entry to be junked
> >> rebuilding directory inode 9185209007
> >> name create failed in ino 9185209007 (117), filesystem may be out of s=
pace
> >
> > 117 is EUCLEAN/EFSCORRUPTED even though we were in the process of rebui=
lding it. :(
> >
> > so this is probably why a subsequent attempt to move it to lost+found f=
ailed as well?
> >
> > Is this a metadumpable filesystem...?
>
>
> It's one of my big fses but metadump can't deal with it:
>
> > [...]
> > Copied 103433024 of 165039360 inodes (24 of 39 AGs)        Unknown dire=
ctory buffer type!
> > Copied 104001280 of 165039360 inodes (24 of 39 AGs)        Unknown dire=
ctory buffer type!
> > Copied 105465088 of 165039360 inodes (24 of 39 AGs)        Unknown dire=
ctory buffer type!
> > Copied 107092608 of 165039360 inodes (25 of 39 AGs)        Metadata cor=
ruption detected at 0x473455, xfs_dir3_leaf1 block 0xc8471ce78/0x1000
> > Segmentation fault (core dumped)

You could still try to dump without data zeroing (metadump -a), if
this is acceptable to you.
