Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE068C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 03:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiERDAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 23:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiERDAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 23:00:46 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CD913150C
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 20:00:40 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 36D59170B67
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 22:00:28 -0500 (CDT)
Message-ID: <02a2b15a-f79f-5fa2-091a-6a28ae3f9757@sandeen.net>
Date:   Tue, 17 May 2022 22:00:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 9f4d6358
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------r7c3XDV6BwIG9KoibTvrEw7l"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------r7c3XDV6BwIG9KoibTvrEw7l
Content-Type: multipart/mixed; boundary="------------aOLPwiz34xGLGJZUhB7PWBCc";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <02a2b15a-f79f-5fa2-091a-6a28ae3f9757@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 9f4d6358

--------------aOLPwiz34xGLGJZUhB7PWBCc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just catching up w/ Darrick's recent patchsets. I'll scan
the list for other outstanding patches next.  (Not forgetting about
you, Andrey!) ;) Feel free to remind me of anything you're expecting
or hoping to get merged, though.

The new head of the for-next branch is commit:

9f4d6358 (HEAD -> for-next) xfs_scrub: don't revisit scanned inodes when =
reprocessing a stale inode

New Commits:

Darrick J. Wong (30):
      [a9d09df8] debian: refactor common options
      [920fd876] debian: bump compat level to 11
      [e63257c0] debian: support multiarch for libhandle
      [c74f0468] xfs_scrub: move to mallinfo2 when available
      [75ff9c67] xfs_db: fix a complaint about a printf buffer overrun
      [baf2beba] xfs: note the removal of XFS_IOC_FSSETDM in the document=
ation
      [9b9c121a] xfs_db: warn about suspicious finobt trees when metadump=
ing
      [744eb053] xfs_repair: warn about suspicious btree levels in AG hea=
ders
      [f0e1a584] xfs_db: support computing btheight for all cursor types
      [462c38a5] xfs_db: report absolute maxlevels for each btree type
      [3a7f7109] xfs_repair: fix sizing of the incore rt space usage map =
calculation
      [aba6743c] mkfs: fix missing validation of -l size against maximum =
internal log size
      [8d1bff2b] mkfs: reduce internal log size when log stripe units are=
 in play
      [1b580a77] mkfs: don't let internal logs bump the root dir inode ch=
unk to AG 1
      [93a199f2] mkfs: improve log extent validation
      [0da883dd] mkfs: round log size down if rounding log start up cause=
s overflow
      [79511c6a] mkfs: don't trample the gid set in the protofile
      [ddba9088] xfs_repair: detect v5 featureset mismatches in secondary=
 supers
      [97238aea] xfs_repair: improve error reporting when checking rmap a=
nd refcount btrees
      [9887f0ad] xfs_repair: check the ftype of dot and dotdot directory =
entries
      [3bc9ea15] xfs_scrub: collapse trivial file scrub helpers
      [a7ee7b68] xfs_scrub: in phase 3, use the opened file descriptor fo=
r scrub calls
      [7ddf6e0f] xfs_scrub: fall back to scrub-by-handle if opening handl=
es fails
      [12ca67b3] xfs_scrub: don't try any file repairs during phase 3 if =
AG metadata bad
      [26289d58] xfs_scrub: make phase 4 go straight to fstrim if nothing=
 to fix
      [bb9be147] xfs_scrub: in phase 3, use the opened file descriptor fo=
r repair calls
      [0e5dce33] xfs_scrub: widen action list length variables
      [8f0c270f] xfs_scrub: prepare phase3 for per-inogrp worker threads
      [245c72a6] xfs_scrub: balance inode chunk scan across CPUs
      [9f4d6358] xfs_scrub: don't revisit scanned inodes when reprocessin=
g a stale inode


Code Diffstat:

 configure.ac             |  12 ++
 db/btheight.c            |  99 ++++++++++++--
 db/io.c                  |   2 +-
 db/metadump.c            |  15 +++
 debian/compat            |   2 +-
 debian/rules             |  18 ++-
 include/builddefs.in     |   2 +
 include/xfs_inode.h      |  11 +-
 libxfs/libxfs_api_defs.h |   6 +
 libxfs/util.c            |   3 +-
 m4/multilib.m4           |  12 ++
 m4/package_libcdev.m4    |  18 +++
 man/man3/handle.3        |   1 +
 man/man3/xfsctl.3        |   2 +
 man/man8/xfs_db.8        |   8 +-
 mkfs/proto.c             |   3 +-
 mkfs/xfs_mkfs.c          | 121 +++++++++++++----
 repair/agheader.c        |  92 +++++++++++++
 repair/incore.c          |   2 +-
 repair/phase4.c          |  20 +--
 repair/phase6.c          |  79 ++++++++----
 repair/rmap.c            |  65 +++++++---
 repair/rmap.h            |   4 +-
 repair/scan.c            |  29 ++++-
 scrub/Makefile           |  15 ++-
 scrub/inodes.c           | 330 +++++++++++++++++++++++++++++++++++------=
------
 scrub/phase3.c           | 162 +++++++++++++++++------
 scrub/phase4.c           |  59 +++++++--
 scrub/phase7.c           |   2 +-
 scrub/repair.c           |  19 ++-
 scrub/repair.h           |  10 +-
 scrub/scrub.c            | 120 ++++-------------
 scrub/scrub.h            |  23 +---
 scrub/xfs_scrub.c        |  47 ++++---
 34 files changed, 1020 insertions(+), 393 deletions(-)

--------------aOLPwiz34xGLGJZUhB7PWBCc--

--------------r7c3XDV6BwIG9KoibTvrEw7l
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmKEYVYFAwAAAAAACgkQIK4WkuE93uCU
ng/+NmQUYWsOhmgPpmcGyuRQC8QeDordRJyt1EU2Z9oEI39iRLwfVWR7DCRbxoufOVomLeOdsG9R
mX77gFRA+dmLughQlr+8W5IRuNbgu1lMLtmT7yAYlWMn/9NGujOLOWlW9fTXLRVrjv33sbaEhucv
ZX0mNRNJRfpmVAV1B1yQ9rCSivRSw0s+booVqPidsHwcocg9XEq7Cupnx2GPszUfOMWMj38Yx0XT
RrEREVc6ehET5SeKU1BJtDlHSwsmGvBtXXUGb44yxo23Td/wpY+Q7vf7c4nyG5pk/jMmQ75Tz+Td
2VjJYneeLRJ3PRqBFpXiifrighaXZyKaoSvyUO1UAELE8bNcODLzl8LQbSQO4k1ImXyJi93oBLPf
St/0V+2K9OYXW/b6xhLK4HMGfPKJjikYtkXF0LL2hyb7xPyzdQeb5bK4S5GkVGC0RpMYlk4H177y
VjcueydbyMii5tczTPBIUsWqRhG/Y8NBBQnMeTUqY/ZtQq+Tl5lUgtMfzIV5RxqnFyHHY7hn0N5K
JkCpbmur8ehy1XoTx1j+mtjaONsy229JBSTN2xGdItHEp3aRCpGx22KBXlB3iEGxJA+4r1Gqr4p/
5aHqF8gCWHU5Safvw6ZaukYcmylpIptPn/O0rGn5igbOIcVYnzHwMo90ug25fT1RCyIrsdPOkFV1
uls=
=Kuiu
-----END PGP SIGNATURE-----

--------------r7c3XDV6BwIG9KoibTvrEw7l--
