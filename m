Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 1.mo301.mail-out.ovh.net ([137.74.110.64]:51254 "EHLO
        1.mo301.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfAWJdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 04:33:15 -0500
Received: from dag002ex3.OVH.local (gw1.corp.ovh.com [51.255.55.226])
        by mo301.mail-out.ovh.net (Postfix) with ESMTPS id 7B7D169846
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 10:33:11 +0100 (CET)
From: Julien Lutran <julien.lutran@corp.ovh.com>
Subject: Re: Unable to fix metadata corruption with xfs_repair
Date: Wed, 23 Jan 2019 09:33:11 +0000
Message-ID: <93726D32-BDA1-42C1-973F-8161538D947B@corp.ovh.com>
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
 <20190121203133.GK6173@dastard>
In-Reply-To: <20190121203133.GK6173@dastard>
Content-Language: en-US
Content-Type: multipart/signed;
        boundary="Apple-Mail=_E8C001E6-06A1-41D4-964C-01B13438AF44";
        protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

--Apple-Mail=_E8C001E6-06A1-41D4-964C-01B13438AF44
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello,

> On 21 Jan 2019, at 21:31, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Mon, Jan 21, 2019 at 03:36:11PM +0000, Julien Lutran wrote:
>> Hello,
>>=20
>> I=E2=80=99m experiencing an issue with metadata corruption while =
trying to fix several corrupted xfs filesystems.
>> Here=E2=80=99s an excerpt of the kernel messages when the disk is =
mounted :
>=20
> =
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
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
>=20
> What's in the 64 bytes of the corrupted metadata buffer output?
> i.e. you trimmed away the bit of the error message that we actually
> need to see what went wrong. Can you paste the uneditted log of the
> error, including the output from mount time from the filesystem?

Sorry, my bad. Here=E2=80=99s the full log :

Jan 23 09:43:36 rescue kernel: XFS (sdb): Metadata corruption detected =
at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
Jan 23 09:43:36 rescue kernel: XFS (sdb): Unmount and run xfs_repair
Jan 23 09:43:36 rescue kernel: XFS (sdb): First 64 bytes of corrupted =
metadata buffer:
Jan 23 09:43:36 rescue kernel: ffff998f8f33b000: 49 4e 41 ed 02 01 00 00 =
00 00 03 e7 00 00 03 e7  INA.............
Jan 23 09:43:36 rescue kernel: ffff998f8f33b010: 00 00 00 02 00 00 00 00 =
00 00 00 00 00 00 00 01  ................
Jan 23 09:43:36 rescue kernel: ffff998f8f33b020: 59 c8 26 66 34 15 44 a6 =
59 c8 26 68 04 66 94 c0  Y.&f4.D.Y.&h.f..
Jan 23 09:43:36 rescue kernel: ffff998f8f33b030: 59 c8 26 68 04 66 94 c0 =
00 00 00 00 00 00 00 2f  Y.&h.f........./
Jan 23 09:43:36 rescue kernel: XFS (sdb): metadata I/O error: block =
0x300160 ("xfs_trans_read_buf_map") error 117 numblks 16
Jan 23 09:43:36 rescue kernel: XFS (sdb): xfs_imap_to_bp: =
xfs_trans_read_buf() returned error -117.

>=20
>> I tried to run a xfs_repair (see attached log) but it ends up the =
same way : metadata error on block 0x300160
>> Is there a way to fix this corruption ?
>=20
> Likely a repair bug - the inode cluster has been trashed for some
> reason and it's not fixing it properly so it's refusing to write
> back corrupt inode metadata.
>=20
> I really need to see what was in the first 64 bytes of that buffer
> and xfs_info output to determine if we have a corrupt cluster, a
> corrupt filessystem block, or the hardware has returned a compeltely
> zeroed sector....
>=20
> Cheers,
>=20
> Dave.
> --
> Dave Chinner
> david@fromorbit.com


--Apple-Mail=_E8C001E6-06A1-41D4-964C-01B13438AF44
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIzBAEBCgAdFiEEHWtkGxqIdLStc9rVXqwUC54mmJYFAlxINNQACgkQXqwUC54m
mJbJkBAAoE0Hs+6+Z9F594oAnNWeWuooh6djplQA4M4eT0k5NaWLPaYRMJ6Mpwd1
METlLpPdxc8fERkW1mya4D6rQ+7qR/4P4/scd6RdEfa2AVG1gweNnATyWOHxiSwE
mautnZg1ri1aaUsSt+HcOFf+WQy3vSUttSgHgzrEznydD1HygcNNMvZL98J2LyeW
604fdJO8eyIHvWgXMaEEoG1NF1FenzB67D3W9FgiZmznRiZDBrI82F5oj4Nkj1eN
NkO56SyovIiXR7tPep6USceMq5iwgJ1WUgD2cQsb/wH77Zh85zKCgmzHVQaApswr
28RyfOryIGk5bH/LeZJDzvpfozJM9OEj+PudOMg98PRIGfcBupB0ga+jhzEn3d9f
0B451nnVm1qzIbUS8F1XYnRY4MTmwI/TIlS1KiW8hfPN++uru5Xg8OhMydKW9gYi
ZXFmh40Q2lOzMN6Pk679LDI8H97fJHfx7TuHfHH6bu7VTycLYDzifdvML7AOnMdO
sifnY8FdeqIPrWXJIdewK7U5B95DPJZTG8MvZjQLtMxpqQyyobDcd6X06/NCq+0z
vwUpGpzTk8fA0xr14B75Yjy7dsK/Zti4H6rVAQV6UH68s4SO5EWOJOfk66pL38x6
hgTkHSUlcb90/XMZ81pHvwLfhH/2KRmroipcNzcGvyG5RGHjQpM=
=69o1
-----END PGP SIGNATURE-----

--Apple-Mail=_E8C001E6-06A1-41D4-964C-01B13438AF44--
