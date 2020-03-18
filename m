Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B091C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C6920753
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCRQt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 12:49:57 -0400
Received: from sandeen.net ([63.231.237.45]:38172 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgCRQt5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 12:49:57 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5606C2A78
        for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2020 11:49:00 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 08814ce4
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4902df45-6fd3-6725-9086-9a24a8e47826@sandeen.net>
Date:   Wed, 18 Mar 2020 11:49:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dE6ghRbEGN5hEVDTEtCtmwYDIbfJcM17p"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dE6ghRbEGN5hEVDTEtCtmwYDIbfJcM17p
Content-Type: multipart/mixed; boundary="o9uFvA9MOWccK9qLfArmU4tHFsM8VaVhy"

--o9uFvA9MOWccK9qLfArmU4tHFsM8VaVhy
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

This is (mostly) just the libxfs/ sync for 5.6, with invaluable
assistance from Darrick as usual.

This has been tagged with v5.6.0-rc0.

The new head of the for-next branch is commit:

08814ce4 (HEAD -> for-next, tag: v5.6.0-rc0, origin/libxfs-5.6-sync, korg=
/libxfs-5.6-sync, korg/for-next) xfsprogs: Release v5.6.0-rc0

New Commits:

Allison Henderson (1):
      [bbe48258] xfs: Remove all strlen in all xfs_attr_* functions for a=
ttr names.

Christoph Hellwig (2):
      [352abebf] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HAN=
DLE
      [804b760d] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag

Darrick J. Wong (19):
      [d6574ca7] xfs: introduce XFS_MAX_FILEOFF
      [5867837a] xfs: refactor remote attr value buffer invalidation
      [a8bbb628] xfs: fix memory corruption during remote attr value buff=
er invalidation
      [30a4e0f9] xfs: streamline xfs_attr3_leaf_inactive
      [eea9e1a3] xfs: make struct xfs_buf_log_format have a consistent si=
ze
      [b3b1affe] libxfs: make __cache_lookup return an error code
      [a5ab418c] libxfs: make libxfs_getbuf_flags return an error code
      [583ca112] libxfs: make libxfs_buf_get_map return an error code
      [e5008359] libxfs: refactor libxfs_readbuf out of existence
      [4c947857] libxfs: make libxfs_buf_read_map return an error code
      [3e6069a1] xfs: make xfs_buf_read_map return an error code
      [58a8b31f] xfs: make xfs_buf_get return an error code
      [d918bc57] xfs: make xfs_buf_get_uncached return an error code
      [31079e67] xfs: make xfs_buf_read return an error code
      [51409fcc] xfs: make xfs_trans_get_buf_map return an error code
      [7f15a547] xfs: make xfs_trans_get_buf return an error code
      [78fcd346] xfs: remove the xfs_btree_get_buf[ls] functions
      [475f184c] xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYL=
OCK callers
      [74b654b4] xfs: remove unnecessary null pointer checks from _read_a=
gf callers

Eric Sandeen (2):
      [3b33e29f] xfs: remove shadow variable in xfs_btree_lshift
      [08814ce4] xfsprogs: Release v5.6.0-rc0

Vincenzo Frascino (1):
      [69e7b74f] xfs: Add __packed to xfs_dir2_sf_entry_t definition


Code Diffstat:

 VERSION                   |   4 +-
 configure.ac              |   2 +-
 copy/xfs_copy.c           |  11 +-
 db/attrset.c              |   4 +-
 db/io.c                   |   7 +-
 debian/changelog          |   6 +
 doc/CHANGES               |   3 +
 include/xfs_trans.h       |  15 +--
 libxfs/init.c             |  35 +++---
 libxfs/libxfs_io.h        |  68 +++++-----
 libxfs/libxfs_priv.h      |  10 +-
 libxfs/rdwr.c             | 311 +++++++++++++++++++++++++++-------------=
------
 libxfs/trans.c            |  48 +++----
 libxfs/xfs_ag.c           |  21 ++--
 libxfs/xfs_alloc.c        |  51 ++++----
 libxfs/xfs_attr.c         |  14 ++-
 libxfs/xfs_attr.h         |  15 ++-
 libxfs/xfs_attr_leaf.c    |   4 +-
 libxfs/xfs_attr_leaf.h    |   9 --
 libxfs/xfs_attr_remote.c  |  83 ++++++++-----
 libxfs/xfs_attr_remote.h  |   2 +
 libxfs/xfs_bmap.c         |  25 ++--
 libxfs/xfs_btree.c        |  47 +------
 libxfs/xfs_btree.h        |  21 ----
 libxfs/xfs_da_btree.c     |   8 +-
 libxfs/xfs_da_btree.h     |   4 +-
 libxfs/xfs_da_format.h    |   4 +-
 libxfs/xfs_format.h       |   7 ++
 libxfs/xfs_ialloc.c       |  12 +-
 libxfs/xfs_log_format.h   |  19 ++-
 libxfs/xfs_refcount.c     |   6 -
 libxfs/xfs_sb.c           |  17 +--
 libxlog/xfs_log_recover.c |   7 +-
 mkfs/proto.c              |  10 +-
 mkfs/xfs_mkfs.c           |  21 ++--
 repair/attr_repair.c      |  29 +++--
 repair/da_util.c          |   3 +-
 repair/dino_chunks.c      |  23 ++--
 repair/dinode.c           |  25 ++--
 repair/phase3.c           |   8 +-
 repair/phase5.c           | 138 ++++++++++++++------
 repair/prefetch.c         |  14 ++-
 repair/rt.c               |  12 +-
 repair/scan.c             |  76 ++++++++---
 44 files changed, 719 insertions(+), 540 deletions(-)


--o9uFvA9MOWccK9qLfArmU4tHFsM8VaVhy--

--dE6ghRbEGN5hEVDTEtCtmwYDIbfJcM17p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl5yUTIACgkQIK4WkuE9
3uCt4w//bSLo5bVkDlqNAk88VwYs8Ayg6ysIDfN0bB68Z0Rbf9IXu9Rry+IoT915
y7XNYMuQOLcRAcsKVbzBPpJnefma0cLn03CsppOtJRMkaA86umGPGtwPW+/rwB8O
mVUcpeOXTwaUtMX3JwClj/XsZKYwNApy46IH2TjQAJnwyUPD/q6H1SUYlIATiBxF
C0LStSrsaXxugAAMP720Qu+Oai0In1CkmSemnMpaxzKUpFUyxz1m0/6vRd0Dg8dx
9HRxFV0tiJ4t3VC7jqnFayEGoh8AVEunr1w26E8gG3FZBNrQ0+1gilfbENoQbrSS
PmJnhSPJxz0E61cc3asIoeqX5vUMTebEyile+nTPioPwRWgqZScSSAup+Mbv3mhP
0N3Uhda1/5qnfjTZX9dPteuSux9G68q3MsgaRz4uIhhqCwzVAvGzmC9p6GF4zwm3
xNkBoa1GOKHVg2Wt9iTatCgHavUVj/Coqt/Cp54VYe25eaEwt4ZN/79RuNVQmyho
EAQK7EkGFzShYPdPzLeRnLoNuUbtxuoHkVWO02jMm3Skna33SUxc5lzG6JCjn7AF
xl6tCtXYA+z/LHKzuPBIh47nc4V0/2MMr+jlSppRZ9um5eOY9MEO7bu4Ke29t0u5
nTr2b0WUzZ0YsWl/ReSjWrdGxkJHYUeW97fbOZtspI/Xj9obKBw=
=tbjF
-----END PGP SIGNATURE-----

--dE6ghRbEGN5hEVDTEtCtmwYDIbfJcM17p--
