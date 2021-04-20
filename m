Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BF7C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DBA9613E4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhDTRfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:35:44 -0400
Received: from sandeen.net ([63.231.237.45]:39876 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhDTRfo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:35:44 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A18D9EF8
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 12:33:58 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 92abc149
Message-ID: <07c5b8a1-174e-c034-7872-6980beeeb8ea@sandeen.net>
Date:   Tue, 20 Apr 2021 12:35:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Is7tTTXU9ILPMQ5NvrVWyISLWLNAVMhRv"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Is7tTTXU9ILPMQ5NvrVWyISLWLNAVMhRv
Content-Type: multipart/mixed; boundary="peHjwNVPUbOXYF1l1X8a5WIsGxzddPNDA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <07c5b8a1-174e-c034-7872-6980beeeb8ea@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 92abc149

--peHjwNVPUbOXYF1l1X8a5WIsGxzddPNDA
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

(Note: If it's not in here, I really did miss it, so feel free to
re-send or ping me if you were expecting your patches to be merged
this time.)

The new head of the for-next branch is commit:

92abc149 (HEAD -> for-next, origin/for-next, korg/for-next) mkfs: don't d=
efault to the physical sector size if > XFS_MAX_SECTORSIZE

New Commits:

Carlos Maiolino (2):
      [bc8ff335] Add dax mount option to man xfs(5)
      [366a2ad5] xfs_logprint: Fix buffer overflow printing quotaoff

Darrick J. Wong (2):
      [dcad5c60] libfrog: report inobtcount in geometry
      [1ff584b2] xfs_admin: pick up log arguments correctly

Dave Chinner (7):
      [b6af4fa8] workqueue: bound maximum queue depth
      [fdfd70e7] repair: Protect bad inode list with mutex
      [96496f5d] repair: protect inode chunk tree records with a mutex
      [39054ffe] repair: parallelise phase 6
      [1f7c7553] repair: don't duplicate names in phase 6
      [266b73fa] repair: convert the dir byaddr hash to a radix tree
      [6375c5b8] repair: scale duplicate name checking in phase 6.

Jeff Moyer (1):
      [92abc149] mkfs: don't default to the physical sector size if > XFS=
_MAX_SECTORSIZE

Leah Neukirchen (1):
      [3a882f0a] xfsprogs: include <signal.h> for platform_crash


Code Diffstat:

 db/xfs_admin.sh          |   9 +-
 include/linux.h          |   1 +
 libfrog/fsgeom.c         |   6 +-
 libfrog/radix-tree.c     |  46 ++++++
 libfrog/workqueue.c      |  42 ++++-
 libfrog/workqueue.h      |   4 +
 logprint/log_print_all.c |  12 +-
 man/man5/xfs.5           |  17 ++
 mkfs/xfs_mkfs.c          |  10 +-
 repair/dir2.c            |  34 ++--
 repair/dir2.h            |   2 +-
 repair/incore.h          |  23 +++
 repair/incore_ino.c      |  15 ++
 repair/phase6.c          | 395 +++++++++++++++++++++++------------------=
------
 14 files changed, 379 insertions(+), 237 deletions(-)


--peHjwNVPUbOXYF1l1X8a5WIsGxzddPNDA--

--Is7tTTXU9ILPMQ5NvrVWyISLWLNAVMhRv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmB/EM8FAwAAAAAACgkQIK4WkuE93uDb
1g/+NuDg58sQw24TFkm2sVRNQxb46iL3DVa83nNsm0oLnnJWOivArj89uHaZZmxoQJHqH9QGc5Bu
Wrhr2jSWoOuGY0QcWms0azageBAtnVIOb6mExMBrDTJbHQRhhpIml/Rx3Ea1o8E0AgDACBzaJJC6
uclQicawJxDtFXvfZRM4GYW9cJfU/yjD8LLevCZ3ceGE5vuCDUCuOjr35jdA8Ukhb5/Vu1d5oZTp
3OHlN6RAf+AATKNJit5Bie7rCEoA7fm/G4qhmUQANrwXwWiKn62gx6ZbdWvl1yi+KRNAf2h5l34N
JTPjH17d4Vv8pNaB9jgUl34BVl8H7PxKINiDkM5nbF+74ih4xNj9O+3aIhTZIDmzgsygfF47GJj0
CQsKb2deO86QdlXknCHM2tRrD2R5L6HAFYQRmQ34eEQHKVF9aAJVm/RgU1O/dKU7zR8V7j6p9MaF
ecQ296wZl46EiUfhqU0SuPUJFSwnfLh4CB2nSyzNfQVh6skc4txmir1Nip4Kxnl8YgRu16KrlobB
TGgtmy6JDLhuzaL7snFPiAupJBmFLDoGch4UfbphfMLHg8emBzLtlJ1Dl23C/kLlKzsJQpjLn0Wn
xmIozGcZJeX2iXRiOhvUtEnCahG2F8dbi/JdRxTPZ++6luL61eaJZzQWH2r2pG+X3/P20IkYIZux
ZhY=
=VQnk
-----END PGP SIGNATURE-----

--Is7tTTXU9ILPMQ5NvrVWyISLWLNAVMhRv--
