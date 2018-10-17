Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbeJRC2M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Oct 2018 22:28:12 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5547754F
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 13:30:51 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to e51fde0
Message-ID: <a8691453-4a28-1b0d-5c61-5576ee3f94f2@sandeen.net>
Date: Wed, 17 Oct 2018 13:31:10 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PPY5Ku1dbR0Nck5cYkOtcaa886PmNEASq"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PPY5Ku1dbR0Nck5cYkOtcaa886PmNEASq
Content-Type: multipart/mixed; boundary="CTU9laZ5C1SIcXaZiu24TgYa8emanWENU";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <a8691453-4a28-1b0d-5c61-5576ee3f94f2@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to e51fde0

--CTU9laZ5C1SIcXaZiu24TgYa8emanWENU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

(This time for realz, if I'm missing something, I'm probably really
missing it.)

The new head of the for-next branch is commit:

e51fde0 xfsprogs: enable sparse checking with make C=3D2

New Commits:

Eric Sandeen (20):
      [b657185] xfsprogs: don't include all xfs headers just for crc32
      [6a40ccc] xfs_db: convert single-bit bitfields to bools
      [8e1338f] xfsprogs: minor endian annotation fixes
      [2bba5a0] xfsprogs: avoid redefinition of NBBY
      [4a87b33] xfsprogs: include headers for extern variables
      [4e00636] libxfs: add several zone extern declarations to libxfs_pr=
iv.h
      [1281240] libxfs: silence static warnings about platform_* function=
s
      [011f253] xfs_io: include io.h to silence static function warnings
      [7ed3b9b] libxfs: silence sparse static function warnings in util.c=

      [37717cc] avl64: export avl64_firstino / avl64_firstino from avl64.=
h
      [28e36fc] xfsprogs: misc static function warning fixes
      [4add9d5] xfsprogs: don't shadow global libxfs_init x variable
      [86715cc] xfs_io: rename global buffer variable
      [4a706e0] xfs_logprint: fix shadow var in xlog_print_trans_buffer
      [925638b] xfs_repair: fix 'bno' shadow vars in scan.c
      [4ace28d] xfs_scrub: remove shadow var from run_scrub_phases()
      [8ab6f7e] xfs_metadump: remove shadow variable
      [440cb37] libfrog: change project entity variable scope to local/st=
atic.
      [d4739a5] xfsprogs: enable sparse checking with make C=3D1
      [e51fde0] xfsprogs: enable sparse checking with make C=3D2


Code Diffstat:

 Makefile                   | 14 ++++++++++++
 copy/xfs_copy.c            |  2 +-
 db/check.c                 | 19 ++++++++--------
 db/crc.c                   |  7 +++---
 db/fuzz.c                  |  1 +
 db/hash.c                  |  1 +
 db/io.h                    |  8 +++----
 db/logformat.c             |  1 +
 db/metadump.c              | 13 ++++++-----
 db/symlink.c               |  2 +-
 db/text.c                  |  1 +
 db/write.c                 |  4 ++--
 doc/sparse.txt             | 12 +++++++---
 include/avl64.h            |  6 +++++
 include/buildrules         | 19 ++++++++++++++++
 include/platform_defs.h.in |  2 ++
 io/getrusage.c             |  1 +
 io/io.h                    |  4 ++--
 io/log_writes.c            |  1 +
 io/mmap.c                  |  6 ++---
 io/pread.c                 | 56 +++++++++++++++++++++++-----------------=
------
 io/pwrite.c                | 28 +++++++++++------------
 libfrog/crc32.c            |  6 ++++-
 libfrog/linux.c            |  1 +
 libfrog/projects.c         | 12 +++++-----
 libxfs/init.c              |  9 --------
 libxfs/init.h              |  3 +++
 libxfs/libxfs_priv.h       |  7 ++++++
 libxfs/rdwr.c              |  2 --
 libxfs/util.c              |  1 +
 logprint/log_misc.c        | 48 ++++++++++++++++++++-------------------
 repair/phase2.c            |  2 --
 repair/rmap.c              |  3 ++-
 repair/scan.c              | 22 +++++++++---------
 repair/scan.h              |  2 ++
 scrub/xfs_scrub.c          |  9 ++++----
 scrub/xfs_scrub.h          |  2 ++
 37 files changed, 201 insertions(+), 136 deletions(-)


--CTU9laZ5C1SIcXaZiu24TgYa8emanWENU--

--PPY5Ku1dbR0Nck5cYkOtcaa886PmNEASq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlvHf/MACgkQIK4WkuE9
3uCU5RAAo5cJXDb//Qz5FN8bD8wfCPizf5ypPIYUqIOhyeC5gvuziJNmhE054wNa
/2886KfB2RPJB4Cj07HIjrTQagFl2J1d7TW/VgZd7e9pY4cByjxy74xd/tqD7vUq
wyTlM29gGoY82pTkKWkkOJguKqSNaCixiSbvDuicdKetEi/Yu/HFuFfBuNTQMDnI
ZTG7ivDTJi8r/poc1yOz2WniH5fZO0Wca/mWBbnG2IavwxXjhm4Ovr9Amb74S+eH
KBxcKozRsEOSoxYPuVYlc9MmrzORzQAw3dveIVcb7aqayfhrrrCoSPBcfkneOcuj
KAMcCE9HUmcCrsSGkal+jKls3RqrsXxDLPVtqQm3cBZcqKnHv4kJy0xf7W/w2sGI
opH141PziyKJHg4u/Y9gww8wdrvT35mfviA2mK+3dYK6SD2isSg/DjzkY3F+oZ/D
rGiTd5tTE3+uCDfVNLe/BCnBFucfsCX/s+nFLdfSbMDYQkPHEDbDGY/SsiwDokrO
8y52e9BHQ4tI8H7oyqdg3c+f9kJHixQNkRTOQCBlBzQoWRxcPQ/ddGhLIeL3CKlp
FUHKLc+3u1l9S7FZg8ccQpavIKb6wxeXQe8D7jeN6PMf+Nvb6NqpqjjinlMwaPfH
kcM1VvuZ9dICZWgtvDiTrlqntM79i6LP0Doase+b9m23GRdfxxU=
=3Kdb
-----END PGP SIGNATURE-----

--PPY5Ku1dbR0Nck5cYkOtcaa886PmNEASq--
