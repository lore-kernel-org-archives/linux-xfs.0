Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39874 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdDKQe5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:34:57 -0400
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <58EB53CA.7030608@tlinx.org>
 <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
 <58EBC972.6040509@tlinx.org> <20170411145721.7d3676a1@harpe.intellique.com>
 <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
 <20170411181808.6d755674@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3c4777fb-f85e-b7fe-3232-500b3a0d2153@sandeen.net>
Date: Tue, 11 Apr 2017 11:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <20170411181808.6d755674@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2kgmcPKVxtT2WHgiK6TmrNioSJMfUPWlW"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: L A Walsh <xfs@tlinx.org>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2kgmcPKVxtT2WHgiK6TmrNioSJMfUPWlW
Content-Type: multipart/mixed; boundary="V7koBL5sPcDBKTPMMMuqJIRC8jAuWrESk";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: L A Walsh <xfs@tlinx.org>, linux-xfs@vger.kernel.org
Message-ID: <3c4777fb-f85e-b7fe-3232-500b3a0d2153@sandeen.net>
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <58EB53CA.7030608@tlinx.org>
 <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
 <58EBC972.6040509@tlinx.org> <20170411145721.7d3676a1@harpe.intellique.com>
 <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
 <20170411181808.6d755674@harpe.intellique.com>
In-Reply-To: <20170411181808.6d755674@harpe.intellique.com>

--V7koBL5sPcDBKTPMMMuqJIRC8jAuWrESk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 4/11/17 11:18 AM, Emmanuel Florac wrote:
> Le Tue, 11 Apr 2017 08:34:44 -0500
> Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:
>=20
>> Three, none of this has anything to do with the email that started
>> this thread.  Bad firmware turned Avi's SSD into a vat of goo, and
>> CRCs are not in any way related to his inability to recover his
>> filesystem.
>=20
> OK, but xfs_db finds and reads the sb OK, and it looks fine at first
> look; why does xfs_repair fail completely? I'm not actually certain
> that Avi's SSD is a "vat of goo"...=20

Well, the AGF printed out by the kernel on the mount attempt was
nowhere close to a valid AGF structure.

Ok, "vat of goo" may have been too strong, but there is at least
one core filesystem structure which are completely scrambled.

That's just the one that was obvious from the mount attempt; I was
assuming there were likely more areas of extreme damage, but that
was an assumption on my part.

Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Metadata =
CRC error detected at xfs_agfl_read_verify+0xcd/0x100 [xfs], xfs_agfl blo=
ck 0x2cb68e13
Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): Unmount a=
nd run xfs_repair
Apr 10 11:41:20 avi.cloudius-systems.com kernel: XFS (nvme0n1): First 64 =
bytes of corrupted metadata buffer:
Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75400: 23 40 =
8f 28 5b 50 3a b4 f8 54 1e 31 97 f4 fe ed  #@.([P:..T.1....
Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75410: 62 87 =
57 51 ee 9d 31 02 ec 2c 10 46 6c 93 db 09  b.WQ..1..,.Fl...
Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75420: ae 7a =
ea b3 91 49 7e d3 99 a4 25 49 11 c5 8b be  .z...I~...%I....
Apr 10 11:41:20 avi.cloudius-systems.com kernel: ffff9004a5b75430: e4 2e =
14 d4 8a f8 5f 98 66 d8 67 72 ec c9 1a d5  ......_.f.gr....=20

Again, don't fixate on the "CRC" error.  The above is /not/ an AGFL for t=
his filesystem.

typedef struct xfs_agfl {
        __be32          agfl_magicnum;
        __be32          agfl_seqno;
        uuid_t          agfl_uuid;
        __be64          agfl_lsn;
        __be32          agfl_crc;
        __be32          agfl_bno[];     /* actually XFS_AGFL_SIZE(mp) */
} __attribute__((packed)) xfs_agfl_t;

The magicnum is wrong.
The seqno is invalid.
The UUID data in agfl_uuid does not match this filesystem.

etc...

-Eric


--V7koBL5sPcDBKTPMMMuqJIRC8jAuWrESk--

--2kgmcPKVxtT2WHgiK6TmrNioSJMfUPWlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY7QWwAAoJECCuFpLhPd7g4EYQAI3Vnbd2wBdYq0zFtv1QjFyw
aVKKLfuNFy4ZHR7hEVdJ6BXjX31B12szXTuiessa1d9/l/DdNDRTPl6J6TJq+Kkb
M/LfcGPzhjixV0dg/QhrqzetfZ8Y/9VUl3cNSmxQwSTt55QFf4tBk/yzK/pcmPhr
tlWTJrz5Xb1cxLMzQxM0UVDsEx4fh/it5eJZ5o9Tiodi0a0P0HdtjnJscf2tEpSa
HYG/PQgggw0pZWkOs8u0ZQ2YKWDADlTXRNWe8cAlddnDGgMdRpZrEb05RnTGN4FH
XEkDwFaW236mJMPsZTHWLNPgtkdvYptg2I+BGa26rfXy8buMRpRexO10JJFdpAy5
Rjqf/JrOO5CzQ0D6lWvjx5u/2KxO7jVqIvwF0xf7d4tPafCgNQLiM9vY5hdyjwdN
uWSN8Aipj5tX1wgvJGmX0psMmaXU9EaEE1FAUeapFyoU6v1L32vTD9EC1vcN7LCC
5xrGw3pS5Ivg5ok60YPE5QrK8C2b5Ja5hPFdfGf+P8brhgRYqZmENxBkpC8/1Mpi
BMyO+i/nJz/J3UmgRbHrLd2aBvRhhDFoPO/zbqkaLmrEjezDvCCREmEIPQc2PeKi
jD7GFnWvjZczQOwS3ZuJ+nZBQxaUYGP5nFKWbcr7ffss0GQIysE0NSZAYkbeMScH
BNp1IC7uT+p/QQZJyXZH
=DXvw
-----END PGP SIGNATURE-----

--2kgmcPKVxtT2WHgiK6TmrNioSJMfUPWlW--
