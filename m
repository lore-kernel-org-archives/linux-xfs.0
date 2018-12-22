Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f176.google.com ([209.85.160.176]:38403 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387803AbeLVAtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 19:49:55 -0500
Received: by mail-qt1-f176.google.com with SMTP id p17so7767824qtl.5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Dec 2018 16:49:54 -0800 (PST)
Received: from lud1.home ([189.115.213.104])
        by smtp.gmail.com with ESMTPSA id n26sm5050371qkg.74.2018.12.21.16.49.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Dec 2018 16:49:53 -0800 (PST)
Date: Fri, 21 Dec 2018 22:49:50 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: Re: Same size drive has less usable space
Message-ID: <20181221224950.45950329@lud1.home>
In-Reply-To: <20181221175737.1a6022b8@harpe.intellique.com>
References: <20181220131305.2a84b717@lud1.home>
        <20181221175737.1a6022b8@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, 21 Dec 2018 17:57:37 +0100, Emmanuel Florac wrote:

> Le Thu, 20 Dec 2018 13:13:05 -0200
> Luciano ES =C3=A9crivait:
>=20
> > I guess at least part of the problem is CRC enabled in the second=20
> > one. So, is there anything I can do to make all the data fit in the=20
> > new drive? =20
>=20
> Your new drive is using 4K blocks, while the old one uses 512b blocks.
> That's why they can't match.
**************************

What 512b? There is no 512 in the old drive.

$ xfs_info /xx
meta-data=3D/dev/sda1     isize=3D256    agcount=3D8, agsize=3D30506944 blks
         =3D              sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D              crc=3D0        finobt=3D0 spinodes=3D0 rmapbt=3D0
         =3D              reflink=3D0
data     =3D              bsize=3D4096   blocks=3D244055552, imaxpct=3D25
         =3D              sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2     bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal      bsize=3D4096   blocks=3D119167, version=3D2
         =3D              sectsz=3D4096  sunit=3D1 blks, lazy-count=3D1
realtime =3Dnone          extsz=3D4096   blocks=3D0, rtextents=3D0


$ xfs_info /xxbkp
meta-data=3D/dev/sdb1     isize=3D512    agcount=3D8, agsize=3D61013888 blks
         =3D              sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D              crc=3D1        finobt=3D1 spinodes=3D1 rmapbt=3D0
         =3D              reflink=3D0
data     =3D              bsize=3D2048   blocks=3D488111104, imaxpct=3D25
         =3D              sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2     bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal      bsize=3D2048   blocks=3D238335, version=3D2
         =3D              sectsz=3D512   sunit=3D0 blks, lazy-count=3D1
realtime =3Dnone          extsz=3D4096   blocks=3D0, rtextents=3D0

--=20
Luciano ES
>>
