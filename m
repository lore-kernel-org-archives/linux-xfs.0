Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5655DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiB1V0u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiB1V0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:26:48 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C89D1216B0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:26:08 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BD203116E2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 15:25:08 -0600 (CST)
Message-ID: <af22dca6-a98f-810f-dc2b-f04eaf12b9c1@sandeen.net>
Date:   Mon, 28 Feb 2022 15:26:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 1c08f0ae
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HlwG4YDU8CKF204KY4yLgI0E"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HlwG4YDU8CKF204KY4yLgI0E
Content-Type: multipart/mixed; boundary="------------Vg3qsF8a9O62TfjrJ0dfGZpu";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <af22dca6-a98f-810f-dc2b-f04eaf12b9c1@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 1c08f0ae

--------------Vg3qsF8a9O62TfjrJ0dfGZpu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

These are most of of Darrick's 5.15 fixes - I know there are still some
of his patches outstanding, as well as some from me and others. Just tryi=
ng
to keep pushing forward. That said, feel free to remind me if there's som=
ething
you hope to see in 5.15.0.

Thanks,
-Eric

The new head of the master branch is commit:

1c08f0ae mkfs: enable inobtcount and bigtime by default

New Commits:

Darrick J. Wong (14):
      [3aef6357] libxcmd: use emacs mode for command history editing
      [f98b7a26] libxfs: shut down filesystem if we xfs_trans_cancel with=
 deferred work items
      [4bac42ba] libxfs: don't leave dangling perag references from xfs_b=
uf
      [9b72515a] libfrog: always use the kernel GETFSMAP definitions
      [ca14a570] misc: add a crc32c self test to mkfs and repair
      [e9ff33f6] xfs_db: fix nbits parameter in fa_ino[48] functions
      [10eea710] xfs_repair: explicitly cast resource usage counts in do_=
warn
      [7aed36f9] xfs_repair: use format specifier for directory inode num=
bers in do_warn
      [0f53ef95] xfs_repair: fix indentation problems in upgrade_filesyst=
em
      [68fb1399] xfs_repair: update secondary superblocks after changing =
features
      [99c78777] mkfs: prevent corruption of passed-in suboption string v=
alues
      [fbdda8fa] mkfs: add configuration files for the last few LTS kerne=
ls
      [a0074fb0] mkfs: document sample configuration file location
      [1c08f0ae] mkfs: enable inobtcount and bigtime by default

Dave Chinner (1):
      [57e4d02c] libxfs-apply: support filterdiff >=3D 0.4.2 only


Code Diffstat:

 db/faddr.c                             |   6 +-
 db/input.c                             |   1 +
 include/builddefs.in                   |   2 +
 include/linux.h                        | 105 ---------------------------=
-----
 io/Makefile                            |   5 +-
 io/crc32cselftest.c                    |   2 +-
 io/fsmap.c                             |   1 +
 libfrog/crc32.c                        |   2 +-
 libfrog/crc32cselftest.h               |  21 ++++---
 libxcmd/input.c                        |   1 +
 libxfs/libxfs_api_defs.h               |   2 +
 libxfs/rdwr.c                          |  23 ++++---
 libxfs/trans.c                         |  19 +++++-
 man/man8/Makefile                      |   7 +++
 man/man8/{mkfs.xfs.8 =3D> mkfs.xfs.8.in} |   8 +++
 man/man8/xfs_repair.8                  |   4 ++
 mkfs/Makefile                          |  10 ++-
 mkfs/lts_4.19.conf                     |  13 ++++
 mkfs/lts_5.10.conf                     |  13 ++++
 mkfs/lts_5.15.conf                     |  13 ++++
 mkfs/lts_5.4.conf                      |  13 ++++
 mkfs/xfs_mkfs.c                        |  27 +++++++-
 repair/dir2.c                          |   2 +-
 repair/globals.c                       |   1 +
 repair/globals.h                       |   1 +
 repair/init.c                          |   5 ++
 repair/phase2.c                        |  38 ++++++------
 repair/quotacheck.c                    |   9 ++-
 repair/xfs_repair.c                    |  15 +++++
 scrub/Makefile                         |   7 +--
 scrub/phase6.c                         |   1 +
 scrub/phase7.c                         |   1 +
 scrub/spacemap.c                       |   1 +
 spaceman/Makefile                      |   5 +-
 spaceman/freesp.c                      |   1 +
 tools/libxfs-apply                     |  42 ++++++-------
 36 files changed, 237 insertions(+), 190 deletions(-)
 rename man/man8/{mkfs.xfs.8 =3D> mkfs.xfs.8.in} (99%)
 create mode 100644 mkfs/lts_4.19.conf
 create mode 100644 mkfs/lts_5.10.conf
 create mode 100644 mkfs/lts_5.15.conf
 create mode 100644 mkfs/lts_5.4.conf

--------------Vg3qsF8a9O62TfjrJ0dfGZpu--

--------------HlwG4YDU8CKF204KY4yLgI0E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmIdPe4FAwAAAAAACgkQIK4WkuE93uDn
HBAAn2PAMztDfk5zmhntpQ2QCY8msFZCZ55J9fHidDdo/OBMXoKrLonoCzcJs3RYfyUNB/7VAX0+
Yt/LftpyspQQVu/ozyFn2ENd5Yk7GwZdRU0rR1bMh7GPpqD7un4gUG/IHi5+6ft5xu1E9nvVE7Mg
r+g2yrKS67NcWUO7TVZo5nfZt5qwiGH62DW3+ZGRWUIb7QRztNKSC4iypR9X5QLWmsk4xKscxJVw
HWRgMueluKEza0nOyKE+/n0D02vHMK3s1WgTu/pK7O8PJzP8xGYzpAiFjzQvwVWTyz3v/0W4K6Q8
TWCrGVXp5eXYG3ZhexP+qRfcLUS8l4WKsTqUI1uUSZTusjLgiZQIE3mEBdQlBby8utCC9SC2ExaQ
dTAyoINN4U73QQ393BcJ6pI4iKPQj4UVwuFYItFl7MSb2Msl5hRd+A4v9TIq+hRQybGkHVoWx3Ju
RvkpmFFoGUwuULfPWSCLOBGyckOzcScGFkdZ3Y97Mpg5XhRU/R3NrSw8POM6SqGf9QBwAz7ae1qJ
aiwcCH9He3+zoFPFCskRm/k16JY8Eh9+0O1H5N+nBBenpSuZxloDG/bIKd2o1WWhkvDYTAZYoxgr
4acyLJOQWrDGsBaU105oegvmb8yXkesgZybDgsG7j4Kge5tKVAjotP9sy1wIZHQU24XDn+qZjRHN
95g=
=6smN
-----END PGP SIGNATURE-----

--------------HlwG4YDU8CKF204KY4yLgI0E--
