Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0F1CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E36992067D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfKDUxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:53:10 -0500
Received: from sandeen.net ([63.231.237.45]:58122 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbfKDUxK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 15:53:10 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D93F717272
        for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2019 14:52:03 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 7e8275f8
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <1d841799-1ce6-1902-7968-6c5c66c545f0@sandeen.net>
Date:   Mon, 4 Nov 2019 14:53:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pDRnP8NTdSHZ1jxdYGV5W4dkmRVzEwTgS"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pDRnP8NTdSHZ1jxdYGV5W4dkmRVzEwTgS
Content-Type: multipart/mixed; boundary="CGELveDVEyNC4Ji49DszBpYp0dmMkU3XU"

--CGELveDVEyNC4Ji49DszBpYp0dmMkU3XU
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

My plan is to finish up Darrick's last few series and tag this
beast, unless anyone reminds me of other outstanding patches
I've missed.

The new head of the for-next branch is commit:

7e8275f8 (HEAD -> for-next, origin/for-next, korg/for-next) xfs_growfs: a=
llow mounted device node as argument

New Commits:

Darrick J. Wong (30):
      [d9b8ae44] xfs_spaceman: always report sick metadata, checked or no=
t
      [4546e66d] xfs_db: btheight should check geometry more carefully
      [ca427fe8] xfs_scrub: report repair activities on stdout, not stder=
r
      [b8302b7f] xfs_scrub: don't allow zero or negative error injection =
interval
      [a57cc320] libfrog: fix workqueue_add error out
      [af06261f] xfs_repair: print better information when metadata updat=
es fail
      [eb20c4ca] libxfs: fix typo in message about write verifier
      [5770b2f0] mkfs: fix incorrect error message
      [aeff0641] libfrog/xfs_scrub: improve iteration function documentat=
ion
      [663e02a0] xfs_scrub: separate media error reporting for attribute =
forks
      [ed953d26] xfs_scrub: improve reporting of file data media errors
      [f1f5fd3a] xfs_scrub: better reporting of metadata media errors
      [02d0069e] xfs_scrub: improve reporting of file metadata media erro=
rs
      [909c6a54] xfs_scrub: don't report media errors on unwritten extent=
s
      [c9b349bd] xfs_scrub: reduce fsmap activity for media errors
      [0f402dd8] xfs_scrub: request fewer bmaps when we can
      [eacea707] xfs_scrub: fix media verification thread pool size calcu=
lations
      [d530e589] libfrog: clean up platform_nproc
      [4b45ff6f] libxfs: remove libxfs_nproc
      [4e5fe123] libxfs: remove libxfs_physmem
      [b658de93] libfrog: take over platform headers
      [ae14fe63] xfs_scrub: clean out the nproc global variable
      [e3724c8b] xfs_scrub: refactor xfs_iterate_inodes_range_check
      [e98616ba] xfs_scrub: fix misclassified error reporting
      [5155653f] xfs_scrub: simplify post-run reporting logic
      [420fad2d] xfs_scrub: clean up error level table
      [abc2e70d] xfs_scrub: explicitly track corruptions, not just errors=

      [e458f3f1] xfs_scrub: promote some of the str_info to str_error cal=
ls
      [05921544] xfs_scrub: refactor xfs_scrub_excessive_errors
      [49e05cb0] xfs_scrub: create a new category for unfixable errors

Eric Sandeen (1):
      [7e8275f8] xfs_growfs: allow mounted device node as argument


Code Diffstat:

 db/btheight.c              |  88 +++++++++++++-
 growfs/xfs_growfs.c        |   3 +
 include/libxfs.h           |   6 -
 include/platform_defs.h.in |   2 +
 libfrog/bitmap.c           |  39 +++++-
 libfrog/bitmap.h           |   2 +
 libfrog/linux.c            |   9 +-
 libfrog/platform.h         |  26 ++++
 libfrog/ptvar.h            |   8 +-
 libfrog/topology.c         |   1 +
 libfrog/workqueue.c        |  10 +-
 libxfs/init.c              |  18 +--
 libxfs/init.h              |  14 ---
 libxfs/rdwr.c              |   2 +-
 man/man8/xfs_growfs.8      |  10 +-
 man/man8/xfs_scrub.8       |   4 +
 mkfs/xfs_mkfs.c            |   7 +-
 po/pl.po                   |   2 +-
 repair/phase4.c            |   6 +-
 repair/phase6.c            |   8 +-
 repair/prefetch.c          |   2 +-
 repair/slab.c              |   2 +-
 repair/xfs_repair.c        |   3 +-
 scrub/common.c             |  54 +++++++--
 scrub/common.h             |   8 +-
 scrub/disk.c               |   6 +
 scrub/filemap.c            |   8 +-
 scrub/filemap.h            |   4 +
 scrub/fscounters.c         |   2 +-
 scrub/inodes.c             |  44 ++++---
 scrub/inodes.h             |   6 +
 scrub/phase1.c             |  12 +-
 scrub/phase4.c             |   5 +-
 scrub/phase5.c             |   2 +-
 scrub/phase6.c             | 287 ++++++++++++++++++++++++++++++++++-----=
------
 scrub/read_verify.c        |   8 +-
 scrub/scrub.c              |  17 ++-
 scrub/spacemap.h           |   4 +
 scrub/vfs.h                |  10 ++
 scrub/xfs_scrub.c          |  57 +++++----
 scrub/xfs_scrub.h          |   4 +-
 spaceman/health.c          |   4 +-
 42 files changed, 594 insertions(+), 220 deletions(-)
 create mode 100644 libfrog/platform.h


--CGELveDVEyNC4Ji49DszBpYp0dmMkU3XU--

--pDRnP8NTdSHZ1jxdYGV5W4dkmRVzEwTgS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl3Aj7MACgkQIK4WkuE9
3uB/bg/+M6UKG0v03Eh2O6KVhN9QMKBEKaBNRIgYEJjhZ3Rrx4JdIhY/GFBSQb8D
78wCfFUSqjCNCyagydqOvkyBvH8irkXouVfJ9GxSi2Hr8d6vzgBpApRQ1IAmUjOk
e0CCgvc5lh8j460DaOfT1G41YgZip3QcCKL3GGtE2Rk6tq/idlSBRAtRlehsmEuv
J6Yw0eev+F8EemkeqKJ8SdfjoW5Jd2NQkeqtX0716/Beqkd2L7tPV+PsRmAcrt1j
tnknF+F8F32gC/ove+oy0D2QDGoR1+6EqjesVoKkAMTwvzqQsOPOSyzUXABXlJU7
MrJ26foAyRih3ojYCbuIAwEl/xxh3+dL2Kp7jUcHzXbDEXR4Zx1tL9Jce6S95LZR
6wUT6/+shz+4ZeMcknEV5rk0EPFvPt7i76WCaWGecu2P0st8gLOUW2Th9VQcF5oI
TVINQOwzW1eWAKVrLrQbS+HaiepeTJNNr0QWiTUKGzkPylWECSIqT8sy18lwsTxf
wf8C0TAHcR2H7cpVSkD/CL1y0epDoDFEBy0YljItC4aK2/sbmww/HblFrylLB2/N
KJB0V+mkF5OWMEvpFGQDPv4N/rqwopPUHME094pCsD9v5MHl/UPWNfgrKbTP5CxG
RqOJ9aIbo0hPyEhg1j3k6KPVDJWGOfC+ksoLoD/OHY70dVEmFFY=
=2EhJ
-----END PGP SIGNATURE-----

--pDRnP8NTdSHZ1jxdYGV5W4dkmRVzEwTgS--
