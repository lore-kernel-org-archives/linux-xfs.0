Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39754 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729974AbfAUQmb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 11:42:31 -0500
Subject: Re: Unable to fix metadata corruption with xfs_repair
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
Date: Mon, 21 Jan 2019 10:42:28 -0600
MIME-Version: 1.0
In-Reply-To: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8imnlO4NYoGwdakwM5P2fAs1680edIaZv"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Julien Lutran <julien.lutran@corp.ovh.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8imnlO4NYoGwdakwM5P2fAs1680edIaZv
Content-Type: multipart/mixed; boundary="alN9VneWyMAJNIhCY2zbUUoch4XovJWWu";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Julien Lutran <julien.lutran@corp.ovh.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
Subject: Re: Unable to fix metadata corruption with xfs_repair
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
In-Reply-To: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>

--alN9VneWyMAJNIhCY2zbUUoch4XovJWWu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 1/21/19 9:36 AM, Julien Lutran wrote:
> Hello,
>=20
> I=E2=80=99m experiencing an issue with metadata corruption while trying=
 to fix several corrupted xfs filesystems.
> Here=E2=80=99s an excerpt of the kernel messages when the disk is mount=
ed :
>=20
> [=E2=80=A6]
> Jan 21 15:44:16 rescue kernel: XFS (sdb): Metadata corruption detected =
at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
> Jan 21 15:44:16 rescue kernel: XFS (sdb): Unmount and run xfs_repair
> Jan 21 15:44:16 rescue kernel: XFS (sdb): First 64 bytes of corrupted m=
etadata buffer:
> Jan 21 15:44:16 rescue kernel: XFS (sdb): metadata I/O error: block 0x3=
00160 ("xfs_trans_read_buf_map") error 117 numblks 16
> Jan 21 15:44:16 rescue kernel: XFS (sdb): xfs_imap_to_bp: xfs_trans_rea=
d_buf() returned error -117.
>=20
> I tried to run a xfs_repair (see attached log) but it ends up the same =
way : metadata error on block 0x300160
> Is there a way to fix this corruption ?
>=20
> Linux kernel version is 4.14.17 but I encountered the exact same issue =
in several other hosts running an older kernel.
> Xfsprogs version is 4.19.0
>=20
>=20
> Best regards,
> Julien Lutran

Hi Julien -

Your log file says:

"Start xfs_repair with cmdline: xfs_repair -L -m 8047 /dev/sdb"

1) Why did you use -L, would the log not replay?
2) Why use -m?  Does that affect the outcome at all?
3) You could give the for-next branch in git a try, just in case, but oth=
erwise
4) Please provide a compressed xfs_metadump for me to look at, off list, =
and
   I'll see what I can find.

Thanks,
-Eric
=20


--alN9VneWyMAJNIhCY2zbUUoch4XovJWWu--

--8imnlO4NYoGwdakwM5P2fAs1680edIaZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlxF9nUACgkQIK4WkuE9
3uAv7g//WgaRprL+IvKc1av3jwfSdhe9mDKoM+YaIJjMgDjhw5Lno0w5RaDWp5z/
Pn8YYwu1xa1//i03nRVD6k4RpWqZR1VQYRcbYNwneNf67HESm7H5o0VQuAkRnSky
OP2hS8Uqj139Gs0UGs39+KqO8ysOZzMMU0pHJ7Z5uw6UaqyPU690XF+FHKhxZfOu
+1HaFS/NZPBXyIrcS8ZiwnUDelQgj0xZ2Qd0YSvB9ElEJAlMO3wDXI00rqly0Lz1
+2PiofsTjfdb/Ox7dHrGkQXFNRUtM3NFRm9i6ICrKZfiJfg+Ny8R04eVQ/ujV+aq
ASKyGMtA//FbWxAYxxRD1NOvBOSH9FENX1R2qvwMiGVGlsCmXcBYF9l/lXrJKLSH
9DMVCiH9cACtfe2YOI2Hf4T3c+PLvhMYZ4YR02RC6kdC/RWlLppnilxjEBJZUpdv
3NiIPU5Ae/oF2cS+vReqwyk/fkwVM6VUmkqdVSs7eEXayWW+jaIpM42MRQHTEGSV
NMjiS8wGM2/TZnbhV74HMzMYE0yGXpN7CJ9dutoTi6qHko1z7XdKF9l/6ilSpe2V
OpnIHUoUtEIWQISwqP6b5k4+QmLy/6drlgo0il1z/FpQwzN0Q1hkO8kE/BlqdB9J
ztcNAkj4Iha13fUjinzGOvuqN1G+EeBQTyCOIzdsIOOe/ybqS44=
=hxFG
-----END PGP SIGNATURE-----

--8imnlO4NYoGwdakwM5P2fAs1680edIaZv--
