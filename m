Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout01-q02.e.movistar.es ([86.109.101.142]:45279 "EHLO
        relayout01-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbfGJS2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 14:28:04 -0400
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <4160fe6c-329c-1e80-c6ed-804a967157f6@telefonica.net>
Date: Wed, 10 Jul 2019 20:21:45 +0200
MIME-Version: 1.0
In-Reply-To: <15810023599.20190710180230@a-j.ru>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrey Zhunev <a-j@a-j.ru>, Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK
Content-Type: multipart/mixed; boundary="G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Andrey Zhunev <a-j@a-j.ru>,
 Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <4160fe6c-329c-1e80-c6ed-804a967157f6@telefonica.net>
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
In-Reply-To: <15810023599.20190710180230@a-j.ru>

--G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 10/07/2019 17.02, Andrey Zhunev wrote:

> Ooops, I forgot to paste the error message from dmesg.
> Here it is:
>=20
> Jul 10 11:48:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x180000=
 SErr 0x0 action 0x0
> Jul 10 11:48:05 mgmt kernel: ata1.00: irq_stat 0x40000008
> Jul 10 11:48:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED=

> Jul 10 11:48:05 mgmt kernel: ata1.00: cmd 60/00:98:28:ac:3e/01:00:03:00=
:00/40 tag 19 ncq 131072 in#012         res 41/40:00:08:ad:3e/00:00:03:00=
:00/40 Emask 0x409 (media error) <F>
> Jul 10 11:48:05 mgmt kernel: ata1.00: status: { DRDY ERR }
> Jul 10 11:48:05 mgmt kernel: ata1.00: error: { UNC }
> Jul 10 11:48:05 mgmt kernel: ata1.00: configured for UDMA/133
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 FAILED Result: ho=
stbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Sense Key : Mediu=
m Error [current] [descriptor]
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrec=
overed read error - auto reallocate failed
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 CDB: Read(16) 88 =
00 00 00 00 00 03 3e ac 28 00 00 01 00 00 00
> Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, se=
ctor 54439176
> Jul 10 11:48:05 mgmt kernel: ata1: EH complete
>=20
> There are several of these.
> At the moment ddrescue reports 22 read errors (with 35% of the data
> copied to a new storage). If I remember correctly, the LVM with my
> root partition is at the end of the drive. This means more errors will
> likely come... :(=20
>=20
> The way I interpret the dmesg message, that's just a read error.

"auto realocate failed" is important. Might indicate the realocation
area is full :-?

> I'm
> not sure, but maybe a complete wipe of the drive will even overwrite /
> clear these unreadable sectors.
> Well, that's something to be checked after the copy process finishes.

Run the SMART long test after you have made a copy, and watch specially
for the Current_Pending_Sector, Offline_Uncorrectable, and
Reallocated_Sector_Ct values. Then overwrite the entire disk with zeroes
and repeat the test. If the bad sector number increases, dump the disk.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2--

--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXSYsuQAKCRC1MxgcbY1H
1UmEAJ4jIJDJiuFGukJ0rZ6mOMZEL0r6nQCfe4qk37Ldb1moFONRZLWHjjc2gm4=
=mxf9
-----END PGP SIGNATURE-----

--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK--
