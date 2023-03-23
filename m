Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75160C74A5B
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Mar 2023 19:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCWTA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjCWTAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2023 15:00:55 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF8932CE4
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2023 12:00:47 -0700 (PDT)
Date:   Thu, 23 Mar 2023 19:00:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1679598043; x=1679857243;
        bh=jA0LZCb44/uhgBYD+dXp1PVffKyuyQVStOB3zyU0N6U=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=jZ7Gze5we38t39u7OL2ZbJ06njTmgx1SjxV2AoZHuXPOXzfuGXz3FL8euvsbbDf2I
         kGqAKiFH8N6iN2J+SVHRCLy8+M8Xzlv5mBm4GbfUgA+ysnUZ8PL6Dzph1MvXuvyHiW
         ArE2fHelBoVU27KNCYk+AI/lOvnj1eKGUtu2GYYvbon1Et8IpKlZ1KYA6BRleONR3C
         tif4FO+kZE/10YYlEJXQ3lIu39HQlthRdOQvQDWpWWwq2R6i9x5jjgVZ5/5gPTyjqY
         3KY/O5HiMOwLze9x45Pxbi0/AqXWB1dqOywGwwZnVde5nLBaCLU9qzZS/NQ0vpJYNw
         AjhY1KWmPjjjQ==
To:     Eric Sandeen <sandeen@sandeen.net>
From:   Johnatan Hallman <johnatan-ftm@protonmail.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: FS (dm-0): device supports 4096 byte sectors (not 512)
Message-ID: <LFK3n9vuD50k0XOFPlxBpqoqZvSp70fNnymLOjCly1olnwRPwhbK0EspfTZAtWgUrju2yOCId64YGDXbVhbe7wz2AZNAOU5_hBTmlHBlhJM=@protonmail.com>
In-Reply-To: <85a9bb82-864e-5532-9252-f8055baeb790@sandeen.net>
References: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com> <85a9bb82-864e-5532-9252-f8055baeb790@sandeen.net>
Feedback-ID: 44492887:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

It's a single luks encrypted disk, nothing complex is going on. I don't get=
 it either how that changed.=20

NAME                MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                   8:0    0   3.7T  0 disk =20
`-test              254:1    0   3.7T  0 crypt=20

There is no problem with the encryption it can be opened.=20

test=09(254:1)

I have tried to open it like this, same story:

cryptsetup --verbose -b 512 luksOpen /dev/sda test

------- Original Message -------
On Thursday, March 23rd, 2023 at 4:39 PM, Eric Sandeen <sandeen@sandeen.net=
> wrote:


> On 3/23/23 5:45 AM, Johnatan Hallman wrote:
>=20
> > Hello List,
> >=20
> > I get this error when I try to mount an XFS partition.
> > Fortunately there is no critical data on it as it is just a backup but =
I would still like to mount it if it's possible.
> >=20
> > I have tried with various Linux distros with kernels ranging from 5.6 t=
o 6.1 it's the same result.
> >=20
> > xfs_info /dev/mapper/test
> > meta-data=3D/dev/mapper/test isize=3D256 agcount=3D32, agsize=3D3052355=
9 blks
> > =3D sectsz=3D512 attr=3D2, projid32bit=3D0
> > =3D crc=3D0 finobt=3D0, sparse=3D0, rmapbt=3D0
> > =3D reflink=3D0 bigtime=3D0 inobtcount=3D0 nrext64=3D0
> > data =3D bsize=3D4096 blocks=3D976753869, imaxpct=3D5
> > =3D sunit=3D0 swidth=3D0 blks
> > naming =3Dversion 2 bsize=3D4096 ascii-ci=3D0, ftype=3D0
> > log =3Dinternal log bsize=3D4096 blocks=3D476930, version=3D2
> > =3D sectsz=3D512 sunit=3D0 blks, lazy-count=3D1
> > realtime =3Dnone extsz=3D4096 blocks=3D0, rtextents=3D0
> >=20
> > mount -t xfs -o ro /dev/mapper/test /mnt/
> > mount: /mnt: mount(2) system call failed: Function not implemented.
> > dmesg(1) may have more information after failed mount system call.
>=20
>=20
> So I assume dmesg contained the error in $SUBJECT:
>=20
> FS (dm-0): device supports 4096 byte sectors (not 512)
>=20
> It seems that the filesystem was created with 512-byte sectors - at that =
time, the device
> must have supported them. Perhaps something about the devicemapper target=
 changed from
> a 512 device to a 4k device? I'm not sure what might cause that to happen=
, but IMHO
> it should never happen... did the dm device recently get reconfigured?
>=20
> As a last resort, I think you could dd the filesystem (all 3T) to a file,=
 and use a
> loopback mount to access the files.
>=20
> Alternatively, I wonder if we could relax the sector size check for a rea=
d-only
> mount (that does not require log replay) - I'm not sure about that though=
.
>=20
> -Eric
