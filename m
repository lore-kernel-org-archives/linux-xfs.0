Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 1.mo301.mail-out.ovh.net ([137.74.110.64]:54843 "EHLO
        1.mo301.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfAXNHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 08:07:40 -0500
From: Julien Lutran <julien.lutran@corp.ovh.com>
Subject: Re: Unable to fix metadata corruption with xfs_repair
Date: Thu, 24 Jan 2019 13:07:36 +0000
Message-ID: <D4E40E64-5AD6-4657-9989-50201111541D@corp.ovh.com>
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
 <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
In-Reply-To: <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
Content-Language: en-US
Content-Type: multipart/signed;
        boundary="Apple-Mail=_71C5AFFE-A763-45DC-85BB-D8322D5EB877";
        protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

--Apple-Mail=_71C5AFFE-A763-45DC-85BB-D8322D5EB877
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Here=E2=80=99s the xfs_metadump (1.35 GB) : =
https://dl.plik.ovh/file/kyXGCIy5luJe7ZKi/ZvUMwvCqUVPiQ2Oe/sdb.metadump.xz=



Julien

> On 21 Jan 2019, at 17:42, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>=20
>=20
> On 1/21/19 9:36 AM, Julien Lutran wrote:
>> Hello,
>>=20
>> I=E2=80=99m experiencing an issue with metadata corruption while =
trying to fix several corrupted xfs filesystems.
>> Here=E2=80=99s an excerpt of the kernel messages when the disk is =
mounted :
>>=20
>> [=E2=80=A6]
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): Metadata corruption =
detected at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): Unmount and run xfs_repair
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): First 64 bytes of corrupted =
metadata buffer:
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): metadata I/O error: block =
0x300160 ("xfs_trans_read_buf_map") error 117 numblks 16
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): xfs_imap_to_bp: =
xfs_trans_read_buf() returned error -117.
>>=20
>> I tried to run a xfs_repair (see attached log) but it ends up the =
same way : metadata error on block 0x300160
>> Is there a way to fix this corruption ?
>>=20
>> Linux kernel version is 4.14.17 but I encountered the exact same =
issue in several other hosts running an older kernel.
>> Xfsprogs version is 4.19.0
>>=20
>>=20
>> Best regards,
>> Julien Lutran
>=20
> Hi Julien -
>=20
> Your log file says:
>=20
> "Start xfs_repair with cmdline: xfs_repair -L -m 8047 /dev/sdb"
>=20
> 1) Why did you use -L, would the log not replay?
> 2) Why use -m?  Does that affect the outcome at all?
> 3) You could give the for-next branch in git a try, just in case, but =
otherwise
> 4) Please provide a compressed xfs_metadump for me to look at, off =
list, and
>   I'll see what I can find.
>=20
> Thanks,
> -Eric


--Apple-Mail=_71C5AFFE-A763-45DC-85BB-D8322D5EB877
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIzBAEBCgAdFiEEHWtkGxqIdLStc9rVXqwUC54mmJYFAlxJuJYACgkQXqwUC54m
mJa8FQ//bQQS5nwdMMglRkjY9rIUX+9FPu4s0OoAVTf6hfSIFJLsiJrQZwV3Swfd
/pQfTOFO5E5+QSTQeXqEozeZAzv3PJy9OIN1Vgkl1yyFw0b+sakWPebd8on731t7
C9K19brwXy2sNN/7qjAAz+dInX14qW1EWI6D5c/aywxVaFuND3qXGhZVgLR8F7v8
syjvz3vA9+HDDj+4QPhcxVDfG4c+vyrTs4Z8fFB1s4HSuHp5qvDddvbOeh8iAsr0
eeYCvkejk50/KaotKMZ07vEaPpEn5BOJW/vS4+0qz8zjUcOedMrr1xFib5sl5+bW
umaofE2EjplReGx4FLitjS3zWgIlC8RHeNyN5DrJZp7hl5BhwmJYKm2Gzr8hr4w4
ztg0eY4bB7Su9+nNLbJ3zCJ4tj3pzB5ZJOwtI+fRAs22qqsKDkSmlrWt8mHLN8XW
mRaYR0mJILJjbjRaISopXRHBI6e2qiEFzZI4pEdhHJL0NzQpPYp1YkFAYkoOQJKC
hQJQfz37bE9bqrsvyIXgctRiAa3EwEE3nOdykiMR3Hj/9BjI3GgCkG+KjdhijLw0
V3Htw0ufnOnaGaLJE6vaxAgrHs5ZO0OFiRAazVWiqozZ0N/+tYTY/7j3BUWvQRVe
VRYgmPAJLWHg4fq+EvduwmGeJjDxdzvJdABXLA1Oi+OZOCrAxtc=
=jW7k
-----END PGP SIGNATURE-----

--Apple-Mail=_71C5AFFE-A763-45DC-85BB-D8322D5EB877--
