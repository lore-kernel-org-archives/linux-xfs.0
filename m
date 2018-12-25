Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from w1.tutanota.de ([81.3.6.162]:55110 "EHLO w1.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbeLYXJY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Dec 2018 18:09:24 -0500
Received: from w2.tutanota.de (unknown [192.168.1.163])
        by w1.tutanota.de (Postfix) with ESMTP id 3AB25FA0926
        for <linux-xfs@vger.kernel.org>; Tue, 25 Dec 2018 23:09:22 +0000 (UTC)
Date: Wed, 26 Dec 2018 00:09:21 +0100 (CET)
From: Jan <bug-reporter@tuta.io>
Message-ID: <LUbcIN3--3-1@tuta.io>
Subject: 'stripe width' inconsistency
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux Xfs <linux-xfs@vger.kernel.org>

Hello!

I hope I came to the right place here. If not, I'd appreciate a pointer to =
a more appropriate one.

Recently, I ran into problems mounting one of my XFS file systems. It's bee=
n a while since I used that HDD but I'm almost certain there were no proble=
ms. 'xfs_repair' complains about 'bad stripe width in superblock' but 'xfs_=
db' has no problems parsing the filesystem. It reports (among other informa=
tion)

> unit =3D 8
> width =3D 65535
[...]
> crc =3D 0xe9e260b (correct)

and can also output directory/file information properly. The values for 'un=
it' and 'width' do seem strange but are the defaults chosen by 'mkfs.xfs'. =
I double checked that by running 'mkfs.xfs -Nf' on the device which yields

> data=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=3D976688597, imaxpct=3D5
>=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sunit=3D8=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 swidth=3D65535 blks

In case this is relevant: The filesystem is created on top of a LUKS contai=
ner on an external USB disk. 'blockdev --getss --getpbsz --getiomin --getio=
opt /dev/mapper/XFS' reports

> 4096
> 4096
> 32768
> 268431360

and 'fdisk -l /dev/sdb'

> Device=C2=A0=C2=A0=C2=A0=C2=A0 Start=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
End=C2=A0=C2=A0 Sectors=C2=A0 Size Type
> /dev/sdb1=C2=A0 65535 976754636 976689102=C2=A0 3,7T Linux filesystem

I'm running a 64-bit Debian Testing, so my xfsprogs are version 4.15.1 and =
the kernel is 4.18. If any further information is required/helpful,=C2=A0I'=
ll gladly provide it. Is there any way to "repair" the XFS or at the very l=
east (mount it to) copy its files?

Regards, Jan
