Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35215 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750741AbdHQFPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 01:15:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 80077209FB
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 01:15:08 -0400 (EDT)
Received: from oryx (c-73-202-12-204.hsd1.ca.comcast.net [73.202.12.204])
        by mail.messagingengine.com (Postfix) with ESMTPA id F080324B24
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 01:15:07 -0400 (EDT)
Message-ID: <1502946903.3034.25.camel@sub-pop.net>
Subject: xfs_repair fails: mismatched UUID?
From: Link Dupont <link@sub-pop.net>
Date: Wed, 16 Aug 2017 22:15:03 -0700
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-kEoHQ+iAv9zN94hteA7d"
Mime-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--=-kEoHQ+iAv9zN94hteA7d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I have a JMicron USB RAID enclosure that is exhibiting read failures.

> [59996.137762] sd 5:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE
> [59996.137786] sd 5:0:0:0: [sdd] tag#0 Sense Key : Aborted Command [curre=
nt]=20
> [59996.137792] sd 5:0:0:0: [sdd] tag#0 Add. Sense: No additional sense
> information
> [59996.137798] sd 5:0:0:0: [sdd] tag#0 CDB: Read(16) 88 00 00 00 00 00 a6=
 42
> 1d d8 00 00 00 08 00 00
> [59996.137804] blk_update_request: I/O error, dev sdd, sector 2789350872
> [59996.137816] Buffer I/O error on dev sdd, logical block 348668859, asyn=
c
> page read
>=20

I ran ddrescue to block copy the device to another external USB drive. This
appears to have been successful (though not without errors). The new drive =
shows
an identical UUID to the original.

> # xfs_admin -u /dev/sdc1
> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
> # xfs_admin -u /dev/sdd1
> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e

I'm still unable to mount the file-system on sdc1.

> # mount /dev/sdc1 mnt
> mount: /root/mnt: mount(2) system call failed: Structure needs cleaning.

I ran xfs_repair.

> # xfs_repair /dev/sdc1
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> * ERROR: mismatched uuid in log
> *            SB : 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
> *            log: 00000001-0038-8e56-0000-000100388e2e
> ERROR: The filesystem has valuable metadata changes in a log which needs =
to
> be replayed.  Mount the filesystem to replay the log, and unmount it befo=
re
> re-running xfs_repair.  If you are unable to mount the filesystem, then u=
se
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mou=
nt
> of the filesystem before doing this.
>=20

I tried xfs_repair with -L to destroy the log. The file-system does clean, =
but
when it mounts, there's nothing present; no files or directories. Not even =
an
lost+found.

I /can/ successfully mount the drive with the norecovery option, though
directory and file names are mangled (unsurprisingly). As I poke around on =
the
filesystem, I get certain block read errors:

> 37473-[ 4120.910844] XFS (sdc1): metadata I/O error: block 0x115a33400
> ("xfs_trans_read_buf_map") error 117 numblks 32
> 37586:[ 4120.910850] XFS (sdc1): xfs_imap_to_bp: xfs_trans_read_buf() ret=
urned
> error -117.
> 37671-[ 4120.911231] XFS (sdc1): Metadata corruption detected at
> xfs_inode_buf_verify+0x73/0xf0 [xfs], xfs_inode block 0x115a33400
> 37796-[ 4120.911234] XFS (sdc1): Unmount and run xfs_repair
> 37850-[ 4120.911235] XFS (sdc1): First 64 bytes of corrupted metadata buf=
fer:
>=20

Many files are corrupt (I get the "Structure needs cleaning" error when I
attempt to cat the files). I found a past thread[1] that provided some usef=
ul
tips. I looked at sb 0 and sb 1 and compared the two. They were identical e=
xcept
for the versionnum. I tried replicating the sb 1 versionnum value to sb 0, =
but
the log still won't replay.

All of this has been performed on my ddrescue clone (not the original devic=
e).
And with kernel 4.12.5 and xfsprogs 4.10.0.

I understand corrupt blocks and the data lost incurred from that. I can pok=
e
around and try to recover what I can when mounted in 'norecovery'. What I a=
m
perplexed by is the total loss of file-system info when xfs_repair -L is ru=
n;
not even a lost+found?

Thanks!

Link

1: https://www.spinics.net/lists/xfs/msg38754.html

--=-kEoHQ+iAv9zN94hteA7d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEqa+yVxzJn+17d/PuSGi9TERQ3rwFAlmVJlcACgkQSGi9TERQ
3ry9xwf/bfy1Ra9a6yTLpcliYSDj8rNwFU8EaN+ohqXGk47Ag3sXAbUv0uyuU2uQ
J573GfU7h84MkOqM4N4/f773YA6DIJsltCcxNyoLyOpB0fXyjK7I+R0WNJ4Ol+MZ
Dh2RgLb7Oe0Yva/1OlqcF4csG+JENv+F/A8A5+eAM5Xi2XV/fzpunmdQo2R9okxJ
vIRnQwZVYT71fXe0E21NiIJMn1qHbW19RRrOMNIeaOaZeJ1lqeFe9TK6UPKWoflk
1fJfhre8vV/jXVPjidyguxKc7X5Rtvnk/Jp9sF1Pz4g0yBmz9yqHNL/6BwjqU2j/
oHIQAB/mA1v9UAaa/azrR2tJZC+bZQ==
=wQ/+
-----END PGP SIGNATURE-----

--=-kEoHQ+iAv9zN94hteA7d--

