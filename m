Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825A9C49ED9
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 19:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C6D2084D
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 19:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfIJTjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 15:39:32 -0400
Received: from sandeen.net ([63.231.237.45]:54918 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbfIJTjc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Sep 2019 15:39:32 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1388678D0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2019 14:39:31 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ac8b6c38
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <e54b0572-0823-9d2a-1063-ee074125a61d@sandeen.net>
Date:   Tue, 10 Sep 2019 14:39:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NCD67HS23mvBNOqtTMeyFLQ7ALaKd8QRb"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NCD67HS23mvBNOqtTMeyFLQ7ALaKd8QRb
Content-Type: multipart/mixed; boundary="Gqhg96YbcERrdoMRDeoML5XcyvWIxMJJU";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e54b0572-0823-9d2a-1063-ee074125a61d@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ac8b6c38

--Gqhg96YbcERrdoMRDeoML5XcyvWIxMJJU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

I'm still working on the patch backlog so if your patch isn't here,
it should still be picked up.  If there's something more than a couple
weeks old feel to send me a ping or reminder.

The new head of the for-next branch is commit:

ac8b6c38 (HEAD -> for-next, origin/for-next, korg/for-next) xfs_repair: a=
dd AG btree rmaps into the filesystem after syncing sb

New Commits (djwong edition!):

Darrick J. Wong (34):
      [c7498b69] xfsprogs: update spdx tags in LICENSES/
      [9612817d] libfrog: refactor online geometry queries
      [3f9efb2e] libfrog: introduce xfs_fd to wrap an fd to a file on an =
xfs filesystem
      [5b5c7336] libfrog: store more inode and block geometry in struct x=
fs_fd
      [a749451c] libfrog: create online fs geometry converters
      [f31b5e12] libfrog: refactor open-coded bulkstat calls
      [248af7cb] libfrog: create xfd_open function
      [621f3374] libfrog: refactor open-coded INUMBERS calls
      [7478c2e3] libxfs: move topology declarations into separate header
      [b4a09f89] libfrog: move avl64.h to libfrog/
      [a58400ed] libfrog: move bitmap.h to libfrog/
      [25e98e81] libfrog: move convert.h to libfrog/
      [fee68490] libfrog: move fsgeom.h to libfrog/
      [14051909] libfrog: move ptvar.h to libfrog/
      [8bf7924e] libfrog: move radix-tree.h to libfrog/
      [56598728] libfrog: move workqueue.h to libfrog/
      [63153a95] libfrog: move crc32c.h to libfrog/
      [42b4c8e8] libfrog: move path.h to libfrog/
      [59f1f2a6] libfrog: move workqueue.h to libfrog/
      [660b5d96] libfrog: move libfrog.h to libfrog/util.h
      [10cfd61e] xfs_spaceman: remove typedef usage
      [8990666e] xfs_spaceman: remove unnecessary test in openfile()
      [a509ad57] xfs_spaceman: embed struct xfs_fd in struct fileio
      [b3803ff1] xfs_spaceman: convert open-coded unit conversions to hel=
pers
      [30abbc26] man: document the new v5 fs geometry ioctl structures
      [88537f07] man: document new fs summary counter scrub command
      [e2fd97fc] man: document the new allocation group geometry ioctl
      [666b4f18] man: document the new health reporting fields in various=
 ioctls
      [3491bee4] xfs_db: remove db/convert.h
      [cb1e69c5] xfs_db: add a function to compute btree geometry
      [f28e184b] xfs_db: use precomputed inode geometry values
      [41baceb7] xfs_repair: use precomputed inode geometry values
      [904a5020] xfs_repair: reduce the amount of "clearing reflink flag"=
 messages
      [ac8b6c38] xfs_repair: add AG btree rmaps into the filesystem after=
 syncing sb


Code Diffstat:

 LICENSES/GPL-2.0                        |   6 +
 Makefile                                |   1 +
 db/Makefile                             |   4 +-
 db/btheight.c                           | 308 ++++++++++++++++++++++++++=
++++++
 db/command.c                            |   2 +-
 db/command.h                            |   2 +
 db/convert.c                            |   1 -
 db/convert.h                            |   7 -
 db/info.c                               |   2 +-
 db/inode.c                              |   8 +-
 fsr/xfs_fsr.c                           | 141 +++++----------
 growfs/xfs_growfs.c                     |  32 ++--
 include/Makefile                        |   3 -
 include/builddefs.in                    |   3 +-
 include/fsgeom.h                        |  11 --
 include/input.h                         |   4 +-
 include/libxcmd.h                       |  31 ----
 include/libxfs.h                        |   2 +-
 io/bmap.c                               |   7 +-
 io/cowextsize.c                         |   2 +-
 io/crc32cselftest.c                     |   4 +-
 io/encrypt.c                            |   2 +-
 io/fsmap.c                              |   7 +-
 io/imap.c                               |  34 ++--
 io/io.h                                 |   2 +-
 io/label.c                              |   2 +-
 io/open.c                               | 112 ++++++------
 io/parent.c                             |   2 +-
 io/scrub.c                              |   2 +-
 io/stat.c                               |   8 +-
 io/swapext.c                            |  21 +--
 libfrog/Makefile                        |  16 +-
 {include =3D> libfrog}/avl64.h            |   6 +-
 {include =3D> libfrog}/bitmap.h           |   6 +-
 libfrog/bulkstat.c                      |  79 ++++++++
 libfrog/bulkstat.h                      |  20 +++
 {include =3D> libfrog}/convert.h          |   6 +-
 {include =3D> libfrog}/crc32c.h           |   6 +-
 {include =3D> libfrog}/crc32cselftest.h   |   6 +-
 libfrog/fsgeom.c                        |  92 ++++++++++
 libfrog/fsgeom.h                        | 187 +++++++++++++++++++
 libfrog/paths.c                         |   4 +-
 include/path.h =3D> libfrog/paths.h       |   6 +-
 libfrog/projects.c                      |   2 +-
 include/project.h =3D> libfrog/projects.h |   6 +-
 {include =3D> libfrog}/ptvar.h            |   6 +-
 {include =3D> libfrog}/radix-tree.h       |   6 +-
 libfrog/topology.c                      |   1 +
 libfrog/topology.h                      |  39 ++++
 libfrog/util.c                          |   2 +-
 include/libfrog.h =3D> libfrog/util.h     |   6 +-
 {include =3D> libfrog}/workqueue.h        |   6 +-
 libxfs/libxfs_api_defs.h                |   2 +
 libxfs/libxfs_priv.h                    |   4 +-
 libxfs/xfs_fs.h                         |   4 +-
 man/man2/ioctl_xfs_ag_geometry.2        | 130 ++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2         |  52 +++++-
 man/man2/ioctl_xfs_fsop_geometry.2      |  62 +++++++
 man/man2/ioctl_xfs_scrub_metadata.2     |   5 +
 man/man3/xfsctl.3                       |   6 +
 mkfs/xfs_mkfs.c                         |   6 +-
 quota/free.c                            |  10 +-
 quota/init.c                            |   2 +-
 quota/quot.c                            |  35 ++--
 quota/quota.h                           |   4 +-
 repair/dino_chunks.c                    |  22 +--
 repair/dinode.c                         |  13 +-
 repair/globals.c                        |   1 -
 repair/globals.h                        |   1 -
 repair/incore_ext.c                     |   2 +-
 repair/phase5.c                         |  24 ++-
 repair/prefetch.c                       |  22 ++-
 repair/rmap.c                           |  36 +++-
 repair/sb.c                             |   3 +-
 repair/threads.h                        |   2 +-
 repair/xfs_repair.c                     |  12 +-
 rtcp/Makefile                           |   3 +
 rtcp/xfs_rtcp.c                         |   9 +-
 scrub/common.c                          |   2 +-
 scrub/common.h                          |   2 +
 scrub/counter.c                         |   2 +-
 scrub/disk.c                            |   4 +-
 scrub/filemap.c                         |   2 +-
 scrub/fscounters.c                      |  46 +++--
 scrub/inodes.c                          |  66 +++----
 scrub/phase1.c                          |  64 +++----
 scrub/phase2.c                          |   6 +-
 scrub/phase3.c                          |  14 +-
 scrub/phase4.c                          |  12 +-
 scrub/phase5.c                          |  10 +-
 scrub/phase6.c                          |  15 +-
 scrub/phase7.c                          |  12 +-
 scrub/progress.c                        |   2 +-
 scrub/read_verify.c                     |   6 +-
 scrub/repair.c                          |   6 +-
 scrub/scrub.c                           |  14 +-
 scrub/spacemap.c                        |  16 +-
 scrub/unicrash.c                        |   2 +-
 scrub/vfs.c                             |   6 +-
 scrub/xfs_scrub.c                       |   2 +-
 scrub/xfs_scrub.h                       |  11 +-
 spaceman/file.c                         |  64 +++----
 spaceman/freesp.c                       |  49 +++--
 spaceman/info.c                         |  32 +---
 spaceman/init.c                         |  13 +-
 spaceman/prealloc.c                     |  17 +-
 spaceman/space.h                        |  17 +-
 spaceman/trim.c                         |  43 ++---
 108 files changed, 1595 insertions(+), 715 deletions(-)
 create mode 100644 db/btheight.c
 delete mode 100644 db/convert.h
 delete mode 100644 include/fsgeom.h
 rename {include =3D> libfrog}/avl64.h (96%)
 rename {include =3D> libfrog}/bitmap.h (87%)
 create mode 100644 libfrog/bulkstat.c
 create mode 100644 libfrog/bulkstat.h
 rename {include =3D> libfrog}/convert.h (87%)
 rename {include =3D> libfrog}/crc32c.h (68%)
 rename {include =3D> libfrog}/crc32cselftest.h (99%)
 create mode 100644 libfrog/fsgeom.h
 rename include/path.h =3D> libfrog/paths.h (95%)
 rename include/project.h =3D> libfrog/projects.h (90%)
 rename {include =3D> libfrog}/ptvar.h (83%)
 rename {include =3D> libfrog}/radix-tree.h (94%)
 create mode 100644 libfrog/topology.h
 rename include/libfrog.h =3D> libfrog/util.h (65%)
 rename {include =3D> libfrog}/workqueue.h (89%)
 create mode 100644 man/man2/ioctl_xfs_ag_geometry.2


--Gqhg96YbcERrdoMRDeoML5XcyvWIxMJJU--

--NCD67HS23mvBNOqtTMeyFLQ7ALaKd8QRb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl13+/IACgkQIK4WkuE9
3uBczBAAm2//doDIAZCcDSrRSBenO3DUJ7W0/X4E0A+2nTuY4KtsmiqG25np1PAZ
l2qn0KKuayXVQz6GpLsRSPjHMy8c7HU18FIuKwuIIIn8bAX7MtS3PYxZQPC96s27
ln7Az6NL9KZZMsSmJj8yHpIQoT2Zty9nDaHyjsfUswdnKp5zVAu/fUFQQ3EbrREI
MUANAE1JrwtEbUQaB1DGi4kkFkVFIkN0OFaQb32KtY3v6PU+HjELnLJcKGTl9PHS
jw0M32ZxFiXQtRTB59N+SC1DaOf5NQL+bJbyKoZCVsobvj61jfFJTaf+ga9Wxu6B
ANej+6pVyFapG4DbpyboxCaUgXWLoMGCTv6uGKdKOQ5dz6dkHlj8BPFp7nlVnazM
ufjASG4A5vtoPgbFzl/qSyT9HyqjkkSf/Kg8wlcIZHypAtKHgrdE5CLhLXavEc7/
gnLky0njcWzRtnSglczy2uRXCwK6b8pQhRuYiv9fdutUwkpF2uIr8pfZK0iWZQwP
104ZTUFMC42Vwoggtj3G7qJRKdSWGsH8DAThLYc6vF38JSr/IFtQq8hqqKRbL53T
HrtAtB5k2guoLhuXxUWsnkYRRENCG1JnpEzCclet85b/RMNRVCd5kOinfjEW38hE
Nntq7TQQyUkOyZcM76xYd4NDU3YpBiXBIbiimrHxLF8NOZDEfK4=
=sX+N
-----END PGP SIGNATURE-----

--NCD67HS23mvBNOqtTMeyFLQ7ALaKd8QRb--
