Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D00C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 22:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B515600D4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 22:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbhDLWKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:10:52 -0400
Received: from sandeen.net ([63.231.237.45]:48630 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237058AbhDLWKv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Apr 2021 18:10:51 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A15F04872FA
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 17:09:26 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to cdbe59c9
Message-ID: <4b915905-62aa-8627-2227-5ac248234150@sandeen.net>
Date:   Mon, 12 Apr 2021 17:10:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GJWWaXayzXzlw7GbnqvTXPU5KqBFIDNpu"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GJWWaXayzXzlw7GbnqvTXPU5KqBFIDNpu
Content-Type: multipart/mixed; boundary="EVMKxavHCmKLxdABKLe3EtATKh38kpima";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <4b915905-62aa-8627-2227-5ac248234150@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to cdbe59c9

--EVMKxavHCmKLxdABKLe3EtATKh38kpima
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.12.0-rc0

This is just the libxfs sync part, and now on to the more interesting
changes; I will pull them from the list.

That said, I am happy to get reminders or re-posts if you prefer.
Or wait 'til the next update, and if your favorite patch isn't in
there, let me know at that point.

The new head of the for-next branch is commit:

cdbe59c9 (HEAD -> tag: v5.12.0-rc0, korg/libxfs-5.12-sync, korg/for-next,=20
refs/patches/libxfs-5.12-sync/v5.12.0-rc0) xfsprogs: Release v5.12.0-rc0

New Commits:

Brian Foster (1):
      [339c7931] xfs: consider shutdown in bmapbt cursor delete assert

Chandan Babu R (16):
      [d629a2d9] xfs: Add helper for checking per-inode extent count over=
flow
      [75cb5a60] xfs: Check for extent overflow when trivally adding a ne=
w extent
      [65f4eca0] xfs: Check for extent overflow when punching a hole
      [a03446b5] xfs: Check for extent overflow when adding dir entries
      [7428ec5b] xfs: Check for extent overflow when removing dir entries=

      [45140de8] xfs: Check for extent overflow when renaming dir entries=

      [430cf788] xfs: Check for extent overflow when adding/removing xatt=
rs
      [b4024c15] xfs: Check for extent overflow when writing to unwritten=20
extent
      [594b2f28] xfs: Check for extent overflow when moving extent from c=
ow to data fork
      [24bc2803] xfs: Check for extent overflow when swapping extents
      [b88613bd] xfs: Introduce error injection to reduce maximum inode f=
ork extent count
      [0f3f87a3] xfs: Remove duplicate assert statement in xfs_bmap_btall=
oc()
      [3f08f006] xfs: Compute bmap extent alignments in a separate functi=
on
      [fc177ab0] xfs: Process allocated extent in a separate function
      [3006cea4] xfs: Introduce error injection to allocate only minlen s=
ize extents for files
      [3af6ab0a] xfs: Fix 'set but not used' warning in xfs_bmap_compute_=
alignments()

Darrick J. Wong (6):
      [d816345e] xfs: fix an ABBA deadlock in xfs_rename
      [7cd46253] xfs: clean up quota reservation callsites
      [9fcc3af9] xfs: create convenience wrappers for incore quota block =
reservations
      [4c315460] xfs: reserve data and rt quota at the same time
      [d2b662c2] xfs: refactor common transaction/inode/quota allocation =
idiom
      [36bd1bdd] xfs: allow reservation of rtblocks with xfs_trans_alloc_=
inode

Dave Chinner (1):
      [cf47075f] xfs: use current->journal_info for detecting transaction=20
recursion

Eric Sandeen (1):
      [cdbe59c9] xfsprogs: Release v5.12.0-rc0

Zorro Lang (1):
      [bdeb0141] libxfs: expose inobtcount in xfs geometry


Code Diffstat:

 VERSION                  |   4 +-
 configure.ac             |   2 +-
 doc/CHANGES              |   5 +-
 include/kmem.h           |   4 +-
 include/xfs_trans.h      |   3 +
 io/inject.c              |   2 +
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/libxfs_priv.h     |  10 +-
 libxfs/trans.c           |  33 +++++
 libxfs/xfs_alloc.c       |  50 ++++++++
 libxfs/xfs_alloc.h       |   3 +
 libxfs/xfs_attr.c        |  22 ++--
 libxfs/xfs_bmap.c        | 315 ++++++++++++++++++++++++++++++++---------=
------
 libxfs/xfs_btree.c       |  45 ++++---
 libxfs/xfs_dir2.h        |   2 -
 libxfs/xfs_dir2_sf.c     |   2 +-
 libxfs/xfs_errortag.h    |   6 +-
 libxfs/xfs_fs.h          |   1 +
 libxfs/xfs_inode_fork.c  |  27 ++++
 libxfs/xfs_inode_fork.h  |  63 ++++++++++
 libxfs/xfs_sb.c          |   2 +
 21 files changed, 459 insertions(+), 143 deletions(-)


--EVMKxavHCmKLxdABKLe3EtATKh38kpima--

--GJWWaXayzXzlw7GbnqvTXPU5KqBFIDNpu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmB0xVcFAwAAAAAACgkQIK4WkuE93uDC
Cg//dJCVoYUBMO+V5ERdeSdQN54IfS/T8WLiMk1WF2+f7mMi4oT/WmjBgj4J/3LyhSac3x95plPu
bWb09C+lJ6/TBJWaEbUh5mSS/nybnTj7RYe4YTbbUQc8TE2C+N1Fib8FtY6nHskl+j9r4dJ/SLXN
zfkUH+fiAjLy76r5eO5H7EruIxU8Ko0IoIZDvOkPd7o7tjJNLH58VFyW5NrD7V32u/fBEGWQsUsz
FoyFs6bRc5ksfIzlc5aHB73bcw2o8iwFay6l5+OsPYmrRjKv9TqxGsr9HUEmU1exRJvnaz2pcqsF
DndsDUFIPHgp61kizXEuojyWmkXneQgB1mzxs+xPizNlkYF/XeftqFnPHJ6izR1lpfsw8Cl/eOih
/eXBzkphO0TSuAwk7/rCDmMaSMHtV7h55jP43m/ZmeOgznGutIXOZDPzLlDmW542EaShmbkdl+CR
NbSnDr0Z5qzcvFr1WNMF3lqLX4QNMFs9qhndU92WCM+In9wKynbVyn4wpBWn0x2d8HttBQi7c+Kf
evHuDzXPi7IEC6OjykXSuxX75A2mX0Uq6drKsTcZPv0GMwoN/wYe3GGvlXbwQFV2739PLm725Jzh
tW4uUHDS1JTRpkeedt+zOS5GGpAJQOwVZUOD3rVbyCT2pqCcMufGd7BzdqQ2wnMLiN5vNPpf/3p4
10Q=
=pxNe
-----END PGP SIGNATURE-----

--GJWWaXayzXzlw7GbnqvTXPU5KqBFIDNpu--
