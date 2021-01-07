Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9771C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9515D233CF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAGVFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 16:05:22 -0500
Received: from sandeen.net ([63.231.237.45]:38182 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbhAGVFV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jan 2021 16:05:21 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 98B7411664
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jan 2021 15:03:13 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 167137fe
Message-ID: <07dc2ed0-7328-73e0-9953-ba69bab362ac@sandeen.net>
Date:   Thu, 7 Jan 2021 15:04:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yv9G2Vqp4xuTEq5gL8knoz9xyQAMys0c9"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yv9G2Vqp4xuTEq5gL8knoz9xyQAMys0c9
Content-Type: multipart/mixed; boundary="hQ6tJfJqgkdsiClphljgE8eDleHbzd8z3";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <07dc2ed0-7328-73e0-9953-ba69bab362ac@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 167137fe

--hQ6tJfJqgkdsiClphljgE8eDleHbzd8z3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the libxfs/ sync for 5.11; I should sweep up other outstandi=
ng
patches soon, but you are also welcome to resend if you like.

The new head of the for-next branch is commit:

167137fe xfs: remove xfs_buf_t typedef

New Commits:

Darrick J. Wong (7):
      [40d39723] xfs: move kernel-specific superblock validation out of l=
ibxfs
      [094e2416] xfs: define a new "needrepair" feature
      [fa9712a0] xfs: enable the needsrepair feature
      [92415d01] xfs: detect overflows in bmbt records
      [f28f7e4a] xfs: refactor data device extent validation
      [23e306ae] xfs: refactor realtime volume extent validation
      [7626c690] xfs: refactor file range validation

Dave Chinner (5):
      [9543cb30] xfs: introduce xfs_dialloc_roll()
      [f0d5b500] xfs: move on-disk inode allocation out of xfs_ialloc()
      [f7e5a7ae] xfs: move xfs_dialloc_roll() into xfs_dialloc()
      [8f1e9017] xfs: spilt xfs_dialloc() into 2 functions
      [167137fe] xfs: remove xfs_buf_t typedef

Eric Sandeen (2):
      [bbf6e32d] libxfs: cosmetic changes to libxfs_inode_alloc
      [1671c6df] xfs: don't catch dax+reflink inodes as corruption in ver=
ifier

Gao Xiang (3):
      [5e26c7ab] xfs: introduce xfs_validate_stripe_geometry()
      [6e8b0988] xfs: convert noroom, okalloc in xfs_dialloc() to bool
      [2cdc6e56] xfs: kill ialloced in xfs_dialloc()

Joseph Qi (1):
      [db9762f8] xfs: remove unneeded return value check for *init_cursor=
()

Kaixu Xia (2):
      [fc5d59c2] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_D=
Q_DIRTY flag
      [9e68bcae] xfs: remove the unused XFS_B_FSB_OFFSET macro

Zheng Yongjun (1):
      [d3ed327c] fs/xfs: convert comma to semicolon


Code Diffstat:

 copy/xfs_copy.c           |   2 +-
 include/libxfs.h          |   2 +-
 include/libxlog.h         |   6 +-
 include/xfs_inode.h       |   2 +-
 include/xfs_trans.h       |  29 ++++----
 libxfs/init.c             |   2 +-
 libxfs/libxfs_io.h        |   6 +-
 libxfs/libxfs_priv.h      |   4 +-
 libxfs/logitem.c          |   4 +-
 libxfs/rdwr.c             |  26 +++----
 libxfs/trans.c            |  16 ++---
 libxfs/util.c             | 121 ++++++++++++---------------------
 libxfs/xfs_alloc.c        |  16 ++---
 libxfs/xfs_bmap.c         |  28 +++-----
 libxfs/xfs_bmap_btree.c   |   2 -
 libxfs/xfs_btree.c        |  12 ++--
 libxfs/xfs_format.h       |  11 ++-
 libxfs/xfs_ialloc.c       | 170 ++++++++++++++++++++++++----------------=
------
 libxfs/xfs_ialloc.h       |  36 +++++-----
 libxfs/xfs_ialloc_btree.c |   5 --
 libxfs/xfs_inode_buf.c    |   4 --
 libxfs/xfs_refcount.c     |   9 ---
 libxfs/xfs_rmap.c         |   9 ---
 libxfs/xfs_rtbitmap.c     |  22 +++---
 libxfs/xfs_sb.c           |  84 ++++++++++++++++++-----
 libxfs/xfs_sb.h           |   3 +
 libxfs/xfs_shared.h       |   1 -
 libxfs/xfs_types.c        |  64 +++++++++++++++++
 libxfs/xfs_types.h        |   7 ++
 libxlog/xfs_log_recover.c |  12 ++--
 logprint/log_print_all.c  |   2 +-
 mkfs/proto.c              |  20 +++---
 mkfs/xfs_mkfs.c           |   2 +-
 repair/agheader.c         |   2 +-
 repair/attr_repair.c      |   4 +-
 repair/da_util.h          |   2 +-
 repair/dino_chunks.c      |   8 +--
 repair/incore.h           |   2 +-
 repair/phase5.c           |   2 +-
 repair/phase6.c           |   6 +-
 repair/prefetch.c         |  12 ++--
 repair/rt.c               |   4 +-
 repair/scan.c             |   4 +-
 repair/xfs_repair.c       |   2 +-
 44 files changed, 425 insertions(+), 362 deletions(-)


--hQ6tJfJqgkdsiClphljgE8eDleHbzd8z3--

--yv9G2Vqp4xuTEq5gL8knoz9xyQAMys0c9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl/3d2cFAwAAAAAACgkQIK4WkuE93uBG
CQ/5AXDu6idbmquoOhgaulEHsLotHyhDj5pYUKdrhIvI8Ty7oLmwim4EIAiz2ZYQqpqrBRUl1Tvx
Mkf6Xp87IkvPk5L1SCCEdlpufv+lZUKCBia5IMIO/zWIBVVuvqyg3DBZ1qn3vMu1oWuY1a4ASf4R
J0A4yjV+1lPnx42rntLVJO4nIZQ9LWaqV/bDQYUZj3lXb7H5vWy+g0WBllG2gqA1lCFbs5RqX75m
2Z0sORmHFflQkcU/Wm2m8nfSIf8AG47GSFtkmXo5NaGG6njEwcj3j6XJ/ovYMsmADSuMYamxFi95
Yt/nGrdsTG/2dIWN/aeP5SEgYTUlMlDTMPWjlZk/MdE0CJ+HGVtx6fbOht7O1n2I1FKk22hLtD1u
Y3kSxxKK0PwSiTVve1w10mYhfFyqFnDUjy03Q/TjlbxLeAbSWlHW4LgYxSNYxbTsTdVZU694f89Q
/okfJg5aaKR8MErGnt4wvqHnCZnuOTWBaEJKOB+ht0GwIBb5eNUZ/GZvtrvAM80/2HlfnbKBF+6h
C2IQOSanlWRGm0NOCTCiD7vL1XLWzpONr3xBCwQsHuhgxy2+xym7BzMSjnTTgQ4XEWjM1UzcbZ8X
ZqcJzPvq15SMpEBy7tHP5AvRCdjf4/A8INFspWQHNshIvpB8yH6AEfpnzfuCYzN2eqwyfkVH+IBo
qw8=
=ZMGn
-----END PGP SIGNATURE-----

--yv9G2Vqp4xuTEq5gL8knoz9xyQAMys0c9--
