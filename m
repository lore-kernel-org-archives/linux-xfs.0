Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C6AC11F64
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jul 2021 17:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7106D613C0
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jul 2021 17:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhGARoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jul 2021 13:44:14 -0400
Received: from sandeen.net ([63.231.237.45]:49002 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhGARoN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jul 2021 13:44:13 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 32179571
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jul 2021 12:41:11 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs updated to 76a369e1 / v5.13.0-rc0
Message-ID: <eb46c0cd-0622-1950-179b-02b2b8b1e292@sandeen.net>
Date:   Thu, 1 Jul 2021 12:41:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uRLTcOinTtSuSFe53olrWB4oj3Ejuf9Yn"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uRLTcOinTtSuSFe53olrWB4oj3Ejuf9Yn
Content-Type: multipart/mixed; boundary="I7lS6klntO0i3LYcuiyY0WduyAgnxjdjq";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <eb46c0cd-0622-1950-179b-02b2b8b1e292@sandeen.net>
Subject: [ANNOUNCE] xfsprogs updated to 76a369e1 / v5.13.0-rc0

--I7lS6klntO0i3LYcuiyY0WduyAgnxjdjq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.13.0-rc0

Note: This is just the 5.13 libxfs sync.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

76a369e1 (HEAD -> for-next, tag: v5.13.0-rc0, korg/for-next, refs/patches=
/for-next/5.13.0-rc0) xfsprogs: Release v5.13.0-rc0

New Commits:

Anthony Iliopoulos (1):
      [e3e2f9e6] xfs: deprecate BMV_IF_NO_DMAPI_READ flag

Brian Foster (2):
      [3a3e3384] xfs: unconditionally read all AGFs on mounts with perag =
reservation
      [92c76be5] xfs: introduce in-core global counter of allocbt blocks

Chandan Babu R (2):
      [839b0c6d] xfs: Initialize xfs_alloc_arg->total correctly when allo=
cating minlen extents
      [e0144e40] xfs: Use struct xfs_bmdr_block instead of struct xfs_btr=
ee_block to calculate root node size

Christoph Hellwig (23):
      [c074900b] xfs: split xfs_imap_to_bp
      [5b9782c9] xfs: remove the unused xfs_icdinode_has_bigtime helper
      [ed6a3429] xfs: remove the di_dmevmask and di_dmstate fields from s=
truct xfs_icdinode
      [0ca7fa97] xfs: move the di_projid field to struct xfs_inode
      [509dcb4b] xfs: move the di_size field to struct xfs_inode
      [aa00f286] xfs: move the di_nblocks field to struct xfs_inode
      [fd2f92c8] xfs: move the di_extsize field to struct xfs_inode
      [fd535ea4] xfs: move the di_cowextsize field to struct xfs_inode
      [36e4f363] xfs: move the di_flushiter field to struct xfs_inode
      [dc1d7a09] xfs: use a union for i_cowextsize and i_flushiter
      [073f2424] xfs: move the di_forkoff field to struct xfs_inode
      [4350eee7] xfs: move the di_flags field to struct xfs_inode
      [defd6446] xfs: move the di_flags2 field to struct xfs_inode
      [a1f6b388] xfs: move the di_crtime field to struct xfs_inode
      [e00c57e7] xfs: move the XFS_IFEXTENTS check into xfs_iread_extents=

      [229442ec] xfs: rename and simplify xfs_bmap_one_block
      [7373ad4f] xfs: simplify xfs_attr_remove_args
      [fca0a273] xfs: only look at the fork format in xfs_idestroy_fork
      [84094546] xfs: remove XFS_IFBROOT
      [9b014ae4] xfs: remove XFS_IFINLINE
      [30de9f1c] xfs: remove XFS_IFEXTENTS
      [27bb0efa] xfs: rename xfs_ictimestamp_t
      [59301887] xfs: rename struct xfs_legacy_ictimestamp

Colin Ian King (1):
      [9dc99f95] xfs: fix return of uninitialized value in variable error=


Darrick J. Wong (8):
      [b81d043c] xfs_repair: refactor resetting incore dinode fields to z=
ero
      [55369096] xfs: validate ag btree levels using the precomputed valu=
es
      [126b608a] xfs: prevent metadata files from being inactivated
      [afad5103] xfs: remove obsolete AGF counter debugging
      [c36b50cb] xfs: restore old ioctl definitions
      [57cd98fd] xfs: check free AG space when making per-AG reservations=

      [ef39c7c7] xfs: standardize extent size hint validation
      [c16edcd7] xfs: validate extsz hints against rt extent size when rt=
inherit is set

Dave Chinner (9):
      [652a2133] xfs: initialise attr fork on inode create
      [dc91402a] xfs: type verification is expensive
      [af10e4bc] xfs: No need for inode number error injection in __xfs_d=
ir3_data_check
      [f5e56725] xfs: reduce debug overhead of dir leaf/node checks
      [c06c9d5a] xfs: default attr fork size does not handle device inode=
s
      [4acdeb81] xfs: precalculate default inode attribute offset
      [5155fce1] xfs: update superblock counters correctly for !lazysbcou=
nt
      [f355a7d0] xfs: btree format inode forks can have zero extents
      [c50edcaa] xfs: bunmapi has unnecessary AG lock ordering issues

Eric Sandeen (1):
      [76a369e1] xfsprogs: Release v5.13.0-rc0

Gao Xiang (2):
      [f63a38ff] xfs: introduce xfs_ag_shrink_space()
      [c4add24c] xfs: add error injection for per-AG resv failure

Miklos Szeredi (1):
      [9214e361] xfs: convert to fileattr


Code Diffstat:

 VERSION                    |   4 +-
 configure.ac               |   2 +-
 db/namei.c                 |   8 +-
 doc/CHANGES                |   3 +
 include/atomic.h           |   3 +
 include/xfs_inode.h        |  22 ++++-
 include/xfs_mount.h        |   8 ++
 io/inject.c                |   1 +
 libxfs/libxfs_priv.h       |  24 ++++-
 libxfs/rdwr.c              |   6 +-
 libxfs/util.c              |  50 +++++-----
 libxfs/xfs_ag.c            | 114 +++++++++++++++++++++
 libxfs/xfs_ag.h            |   2 +
 libxfs/xfs_ag_resv.c       |  52 +++++++---
 libxfs/xfs_alloc.c         |  25 +++--
 libxfs/xfs_alloc_btree.c   |   4 +-
 libxfs/xfs_attr.c          |  54 ++++++----
 libxfs/xfs_attr.h          |   1 +
 libxfs/xfs_attr_leaf.c     |  35 +++----
 libxfs/xfs_bmap.c          | 239 +++++++++++++++++----------------------=
------
 libxfs/xfs_bmap.h          |   2 +-
 libxfs/xfs_bmap_btree.c    |   6 +-
 libxfs/xfs_btree_staging.c |   1 -
 libxfs/xfs_da_btree.c      |   4 +-
 libxfs/xfs_dir2.c          |  14 +--
 libxfs/xfs_dir2_block.c    |  12 +--
 libxfs/xfs_dir2_data.c     |   2 +-
 libxfs/xfs_dir2_leaf.c     |  12 ++-
 libxfs/xfs_dir2_node.c     |   4 +-
 libxfs/xfs_dir2_priv.h     |   3 +-
 libxfs/xfs_dir2_sf.c       |  58 ++++++-----
 libxfs/xfs_errortag.h      |   4 +-
 libxfs/xfs_format.h        |   5 +-
 libxfs/xfs_fs.h            |   2 +-
 libxfs/xfs_ialloc.c        |   4 +-
 libxfs/xfs_iext_tree.c     |   2 +-
 libxfs/xfs_inode_buf.c     | 127 +++++++++++++-----------
 libxfs/xfs_inode_buf.h     |  33 +------
 libxfs/xfs_inode_fork.c    |  48 ++++-----
 libxfs/xfs_inode_fork.h    |  20 ++--
 libxfs/xfs_log_format.h    |  12 +--
 libxfs/xfs_rmap_btree.c    |   2 -
 libxfs/xfs_rtbitmap.c      |   4 +-
 libxfs/xfs_sb.c            |  16 ++-
 libxfs/xfs_shared.h        |   4 +
 libxfs/xfs_trans_inode.c   |  24 ++++-
 libxfs/xfs_types.c         |  18 ++--
 logprint/log_misc.c        |   6 +-
 logprint/logprint.h        |   2 +-
 mkfs/proto.c               |  10 +-
 repair/phase6.c            |  68 +++++++------
 repair/quotacheck.c        |  32 +++---
 52 files changed, 690 insertions(+), 528 deletions(-)


--I7lS6klntO0i3LYcuiyY0WduyAgnxjdjq--

--uRLTcOinTtSuSFe53olrWB4oj3Ejuf9Yn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmDd/lUFAwAAAAAACgkQIK4WkuE93uDx
Dw/9Hq9Ni/6xQQ7j6GSDeUtfv4JQmcDFTBM0BcvuTvWELfsPXwjHstV9AphLiPXCPNigxYQJrUBo
ZWvwZjep/zGvnMTnL6wD65AxHVnqUTxhaNXWJPFGJ2VCD38qgejNjMM1pVX70ChxwivYsLe/cslN
RamWc6eYMHpuFX9aOSsBYwMZNGzw3DDAfSC8+ztItcNB8xmMsCoFoXM2aoFO1wZcACwGcOq2Fuhq
rCD9yd0diQpE3bPS9d6mSm+6h5GM1DlqddBzEeVGVTOBX8eWwv42k7t9kTspX15eE99Cebx1PTPn
nWVIkiic82NBeIkAwuQAbPgMAMIuJP3vbaul92A8qoJ0F+W+B7zQvkvkK+AnR8kN4icIyEZHJBUO
4RHbLHV4uzdiL3qCvtDIoOngiKKM2HyGFcQ4wUQ/FGQUmXtg8F5KQsBFRJDdBP+q0saq2swmPux9
o9DekdhxSs56qhK00VvD8nl/ig4HayHq7f115b8/SHJ4E6uAfLtdbsaQK1pB8EvVfInHMNrnwz0G
iKmnVHoqsuvWcf7ML3OHCrzfwyvtsDWj15j1jvxK791CVYVMMeCJIBmiZKFE8Qlqzq1OMgXBZf/H
7q4r9BhYReV65ZMyxCChLJDUnKCXBOs0/o34spLBM8/SpewNteUrnJ2lMUBO6szCXvF/zQxW6VPE
2ZU=
=p/Xd
-----END PGP SIGNATURE-----

--uRLTcOinTtSuSFe53olrWB4oj3Ejuf9Yn--
