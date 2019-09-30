Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB42C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EFCB207FA
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbfI3VVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:21:21 -0400
Received: from sandeen.net ([63.231.237.45]:33658 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbfI3VVU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 17:21:20 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7F01411644
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 12:45:34 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to b94a69ac
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <cdfabb3d-55eb-399b-e3fe-020f9985adcf@sandeen.net>
Date:   Mon, 30 Sep 2019 12:45:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SCFSyjsrmsI0ewdY75WG1iwW2YsNzGVvf"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SCFSyjsrmsI0ewdY75WG1iwW2YsNzGVvf
Content-Type: multipart/mixed; boundary="zmZ1MHDX7i1EsAefQPyfdCmVjYw7zVouz";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <cdfabb3d-55eb-399b-e3fe-020f9985adcf@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to b94a69ac

--zmZ1MHDX7i1EsAefQPyfdCmVjYw7zVouz
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

The new head of the for-next branch is commit:

b94a69ac (HEAD -> for-next) misc: convert from XFS_IOC_FSINUMBERS to XFS_=
IOC_INUMBERS

New Commits:

Darrick J. Wong (17):
      [bb85ae74] xfs_spaceman: report health problems
      [991e5a84] xfs_scrub: remove unnecessary fd parameter from file scr=
ubbers
      [5ef3b66a] libfrog: share scrub headers
      [8dd3922c] libfrog: add online scrub/repair for superblock counters=

      [469f76cb] xfs_scrub: separate internal metadata scrub functions
      [cbaf1c9d] xfs_scrub: check summary counters
      [83630b7f] xfs_scrub: refactor queueing of subdir scan work item
      [4953e709] xfs_scrub: fix nr_dirs accounting problems
      [44012ab0] xfs_scrub: remove unnecessary wakeup wait in scan_fs_tre=
e
      [cad15696] libxfs: fix uncached buffer refcounting
      [3d943e22] libxfs: fix buffer refcounting in delwri_queue
      [7db2e3c1] libxfs: make xfs_buf_delwri_submit actually do something=

      [7b754805] mkfs: use libxfs to write out new AGs
      [04fa6912] man: add documentation for v5 bulkstat ioctl
      [085b39cc] man: add documentation for v5 inumbers ioctl
      [4cca629d] misc: convert xfrog_bulkstat functions to have v5 semant=
ics
      [b94a69ac] misc: convert from XFS_IOC_FSINUMBERS to XFS_IOC_INUMBER=
S

Jianhong Yin (1):
      [64e366d9] xfs_io: copy_range don't truncate dst_file, and add smar=
t length


Code Diffstat:

 fsr/xfs_fsr.c                   |  64 ++++-
 include/libxfs.h                |   1 +
 io/copy_file_range.c            |  42 ++-
 io/imap.c                       |  26 +-
 io/open.c                       |  56 ++--
 io/scrub.c                      |  89 ++-----
 io/swapext.c                    |   9 +-
 libfrog/Makefile                |   2 +
 libfrog/bulkstat.c              | 563 ++++++++++++++++++++++++++++++++++=
+++---
 libfrog/bulkstat.h              |  24 +-
 libfrog/fsgeom.c                |  16 ++
 libfrog/fsgeom.h                |  10 +
 libfrog/scrub.c                 | 146 +++++++++++
 libfrog/scrub.h                 |  36 +++
 libxfs/libxfs_api_defs.h        |   3 +
 libxfs/libxfs_io.h              |  29 +++
 libxfs/libxfs_priv.h            |   4 -
 libxfs/rdwr.c                   |  30 ++-
 libxfs/util.c                   |   1 +
 man/man2/ioctl_xfs_bulkstat.2   | 346 ++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2 |   6 +
 man/man2/ioctl_xfs_inumbers.2   | 128 +++++++++
 man/man8/xfs_io.8               |  12 +-
 man/man8/xfs_spaceman.8         |  28 ++
 mkfs/xfs_mkfs.c                 | 371 +++-----------------------
 quota/quot.c                    |  29 +--
 scrub/fscounters.c              |  21 +-
 scrub/inodes.c                  |  75 +++---
 scrub/inodes.h                  |   2 +-
 scrub/phase3.c                  |  16 +-
 scrub/phase4.c                  |  12 +
 scrub/phase5.c                  |   8 +-
 scrub/phase6.c                  |   2 +-
 scrub/phase7.c                  |  14 +
 scrub/repair.c                  |   3 +
 scrub/scrub.c                   | 278 ++++++++------------
 scrub/scrub.h                   |  18 +-
 scrub/unicrash.c                |   6 +-
 scrub/unicrash.h                |   4 +-
 scrub/vfs.c                     | 140 ++++++----
 spaceman/Makefile               |   2 +-
 spaceman/health.c               | 470 +++++++++++++++++++++++++++++++++
 spaceman/init.c                 |   1 +
 spaceman/space.h                |   1 +
 44 files changed, 2317 insertions(+), 827 deletions(-)
 create mode 100644 libfrog/scrub.c
 create mode 100644 libfrog/scrub.h
 create mode 100644 man/man2/ioctl_xfs_bulkstat.2
 create mode 100644 man/man2/ioctl_xfs_inumbers.2
 create mode 100644 spaceman/health.c


--zmZ1MHDX7i1EsAefQPyfdCmVjYw7zVouz--

--SCFSyjsrmsI0ewdY75WG1iwW2YsNzGVvf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl2SP0wACgkQIK4WkuE9
3uBTmQ//S5QNamOnVj8uZX/az+UjVCExlvps1h6NK736ZDMsEVLjA6QAVybolav6
FpXeB+mWwoSJHpGNZwidYb4Ss2Igs6qhHSgnEqzLd1icLFMZkoa0RD/sGfLcI8n9
8VBS7WfJC/nnIKv7dwVoPoroGRn7gcnxwEdlV0EPwOzyvMrr+iRH+KD5G7tcb1yA
ivgnDvU3AaqhM/uCshBpM3hlV6y9UaxKUdGXMjKCXyKneeAGBbh4ebqSUVx988wK
VZ8D2np3vWQwDHgjetpoZI0on+nrtUPrImfqw4d63EaXUpLIAixkyz++1+lO72KT
6qGP3tdNkxZd+IwRDh8GISq9y8ndgZ0BkIlF5DKvtRRP+rDLi21OO2Te5k8crRSm
EXz+xzLDZIJL0ACwXVBmyyzwYJN5GYpgg+87T3FJb3jvpfjsxIDXptdwl5PyMhc3
kxyDir+oRkOq1xfxNylKsz4DTTe4ApK74EuzfQvMPqZWGDaQ2/gSfwlo6V9vG/J+
SbxfsMG23Kij9ShzpnFBGM968R4P8C9/COiN31Eu8zP6D01d9tnh58iheKIhbfRE
NDxHFED+UeuO+sH2wlvvCN3EPYFJOQ41YkxpU0hoN0bGN7/Ilxpxxfygr6YE8L98
hx+OrRIz0GEr4MYz9rSBznFjSyheFly0f5KZIWQ2hHfrDoSveOk=
=MA/5
-----END PGP SIGNATURE-----

--SCFSyjsrmsI0ewdY75WG1iwW2YsNzGVvf--
