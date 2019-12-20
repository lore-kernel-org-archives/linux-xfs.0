Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC91C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 21:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B6D21655
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 21:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLTV7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 16:59:19 -0500
Received: from sandeen.net ([63.231.237.45]:40248 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfLTV7T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Dec 2019 16:59:19 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5A4F1146282
        for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2019 15:59:00 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.4.0 released
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <a5cdfcf1-48dc-1ff6-bf4c-6c9ad2b2fdc8@sandeen.net>
Date:   Fri, 20 Dec 2019 15:59:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U7qmKhO2NWBQuzDXRRgQcm7l7RjlnxXPn"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U7qmKhO2NWBQuzDXRRgQcm7l7RjlnxXPn
Content-Type: multipart/mixed; boundary="ww6Utlr43GtkvNGtPz2H5K5b44OhL3i9X"

--ww6Utlr43GtkvNGtPz2H5K5b44OhL3i9X
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.4.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.4.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.4.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.4.0.tar=
=2Esign

This is a relatively minor update aside from the normal libxfs changes.
Details are below.

Thanks,
-Eric

Abbreviated changelog:

xfsprogs-5.4.0 (20 Dec 2019)
        - No further changes

xfsprogs-5.4.0-rc1 (17 Dec 2019)
        - mkfs.xfs: Notify about discard & make it interruptable (Pavel R=
eichl)
        - xfs_admin: support external log devices (Darrick Wong)
        - xfs_admin: enable online label getting and setting (Darrick Won=
g)

xfsprogs-5.4.0-rc0 (15 Nov 2019)
        - libxfs changes merged from kernel 5.4



Commits since 5.3.0:

0cfb2952 (HEAD -> guilt/for-next, tag: v5.4.0, korg/master, korg/for-next=
, refs/patches/for-next/xfsprogs-5.4.0) xfsprogs: Release v5.4.0

New Commits:

Brian Foster (4):
      [e102336b] xfs: convert inode to extent format after extent merge d=
ue to shift
      [2e3614c7] xfs: log the inode on directory sf to block format chang=
e
      [a35db947] xfs: remove broken error handling on failed attr sf to l=
eaf change
      [feee8e52] xfs: move local to extent inode logging into bmap helper=


Christoph Hellwig (2):
      [ed110c33] xfs: remove the unused XFS_ALLOC_USERDATA flag
      [14790ed0] xfs: add a xfs_valid_startblock helper

Darrick J. Wong (15):
      [78173279] xfs: fix maxicount division by zero error
      [6c3013ad] xfs: don't return _QUERY_ABORT from xfs_rmap_has_other_k=
eys
      [9e468ed6] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys=

      [4b4772dc] xfs: remove unnecessary parameter from xfs_iext_inc_seq
      [46d29bb9] xfs: remove unnecessary int returns from deferred rmap f=
unctions
      [5965a482] xfs: remove unnecessary int returns from deferred refcou=
nt functions
      [60a802cc] xfs: remove unnecessary int returns from deferred bmap f=
unctions
      [d4eb45ad] xfs: reinitialize rm_flags when unpacking an offset into=
 an rmap irec
      [a0f17dde] xfs: remove all *_ITER_ABORT values
      [7dd6dee1] xfs: remove all *_ITER_CONTINUE values
      [feb5c737] xfs: define a flags field for the AG geometry ioctl stru=
cture
      [c3fcbe14] xfs: revert 1baa2800e62d ("xfs: remove the unused XFS_AL=
LOC_USERDATA flag")
      [0f498e72] xfs: change the seconds fields in xfs_bulkstat to signed=

      [8db10a9a] xfs_admin: support external log devices
      [3f153e05] xfs_admin: enable online label getting and setting

Dave Chinner (11):
      [74945501] xfs: add kmem allocation trace points
      [e3d4203e] xfs: move xfs_dir2_addname()
      [34af510f] xfs: factor data block addition from xfs_dir2_node_addna=
me_int()
      [64b80d86] xfs: factor free block index lookup from xfs_dir2_node_a=
ddname_int()
      [4ebdc2c8] xfs: speed up directory bestfree block scanning
      [b5784c09] xfs: reverse search directory freespace indexes
      [42a383ab] xfs: make attr lookup returns consistent
      [ab0d25d8] xfs: remove unnecessary indenting from xfs_attr3_leaf_ge=
tvalue
      [17e72771] xfs: move remote attr retrieval into xfs_attr3_leaf_getv=
alue
      [4343d303] xfs: consolidate attribute value copying
      [b4b9ad30] xfs: allocate xattr buffer on demand

Eric Sandeen (7):
      [55b503df] xfs: log proper length of superblock
      [2671b64d] xfs: remove unused flags arg from xfs_get_aghdr_buf()
      [6f1df6a3] xfsprogs: Release v5.4.0-rc0
      [998aed52] xfsprogs: remove stray libxfs whitespace
      [2383d7c5] mkfs: tidy up discard notifications
      [a4e8b806] xfsprogs: Release v5.4.0-rc1
      [0cfb2952] xfsprogs: Release v5.4.0

John Pittman (1):
      [2ab6ea6a] xfsprogs: add missing line feeds in libxfs/rdwr.c

Pavel Reichl (1):
      [7e8a6edb] mkfs: Break block discard into chunks of 2 GB

Tetsuo Handa (1):
      [6cd1e6db] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.

zhengbin (1):
      [763d7f07] xfs: remove excess function parameter description in 'xf=
s_btree_sblock_v5hdr_verify'


Code Diffstat:

 VERSION                   |   2 +-
 configure.ac              |   2 +-
 db/xfs_admin.sh           |  54 +++++-
 debian/changelog          |  18 ++
 doc/CHANGES               |  11 ++
 include/kmem.h            |   3 +-
 include/xfs_mount.h       |   8 -
 libxfs/kmem.c             |   6 +
 libxfs/libxfs_priv.h      |   2 +-
 libxfs/logitem.c          |   6 +-
 libxfs/rdwr.c             |   6 +-
 libxfs/trans.c            |   4 +-
 libxfs/xfs_ag.c           |   5 +-
 libxfs/xfs_alloc.c        |   2 +-
 libxfs/xfs_attr.c         |  79 +++++---
 libxfs/xfs_attr.h         |   6 +-
 libxfs/xfs_attr_leaf.c    | 151 +++++++--------
 libxfs/xfs_attr_remote.c  |   2 +
 libxfs/xfs_bmap.c         |  88 ++++-----
 libxfs/xfs_bmap.h         |  14 +-
 libxfs/xfs_bmap_btree.c   |  16 +-
 libxfs/xfs_btree.c        |  14 +-
 libxfs/xfs_btree.h        |  10 +-
 libxfs/xfs_da_btree.c     |   6 +-
 libxfs/xfs_da_btree.h     |   4 +-
 libxfs/xfs_defer.c        |   2 +-
 libxfs/xfs_dir2.c         |  14 +-
 libxfs/xfs_dir2_block.c   |   4 +-
 libxfs/xfs_dir2_node.c    | 678 ++++++++++++++++++++++++++++++++--------=
----------------------------
 libxfs/xfs_dir2_sf.c      |   8 +-
 libxfs/xfs_fs.h           |  12 +-
 libxfs/xfs_ialloc.c       |   9 +-
 libxfs/xfs_iext_tree.c    |   8 +-
 libxfs/xfs_inode_buf.c    |   1 +
 libxfs/xfs_inode_fork.c   |  16 +-
 libxfs/xfs_refcount.c     |  50 ++---
 libxfs/xfs_refcount.h     |  12 +-
 libxfs/xfs_rmap.c         |  59 +++---
 libxfs/xfs_rmap.h         |  11 +-
 libxfs/xfs_sb.c           |   2 +-
 libxfs/xfs_shared.h       |   6 -
 libxfs/xfs_trans_inode.c  |   1 +
 libxfs/xfs_types.h        |   8 +
 libxlog/xfs_log_recover.c |  10 +-
 man/man8/xfs_admin.8      |  18 +-
 mkfs/xfs_mkfs.c           |  54 ++++--
 46 files changed, 818 insertions(+), 684 deletions(-)


--ww6Utlr43GtkvNGtPz2H5K5b44OhL3i9X--

--U7qmKhO2NWBQuzDXRRgQcm7l7RjlnxXPn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl39RDUACgkQIK4WkuE9
3uCeYw//aBY9nlSCsebBoTaM+ZMiUAG28bpA3XyHWZLnSXTCckQ9PvBWasVIFjcl
dr4W37RXX2CDLHB7JewntPiy9DKkmTRUVq5hQOL/IJ34uVnCkKUmzljLnbZIxmHc
DU2ijpTU0rRJrRDVc3pcXfntLriBm8PHDQRxow1B/sdTXRMTRxLBtcBNMnSOGcyo
9DpqOj9LK9Akoz8ZNOGMQ17Xzb7Kevc4g6VrxOokVVUDR8rpqaePE1+x7exdk72z
dIRtiZdUsW+ScdZ5TkuHeZ53yoLyF52DxQYBQw6nnR49sV45ft4K47z9gA8Sc9fC
O/SEeICKbk5z6YCHFS3IJ9C7EmJWlhqIkuCzWj7woS5J6V4Rh8DKqWR/jrHfjnzL
GTBOQzjt0Mr1hvxQ6+jNC2/OC6IIQ77j71X8IwgkVFnKXoGt8NKrYHnpVViERBfd
HowIALW2462Aj0IgU082JbfXdQXYyAxBjtdFOxBZ7BUDksFf8V9fweJYtWWnHMq+
djnbsj7K42pv/ZAAH+eDcwvypzFFB8YQcOnlbL7I5OICa5h5o3ttm/NlRDXOIF/H
sVzq8ixd+apkQnOCLNvCTaDb5DR6z8QHwF/1GaneOEKvfr4DxD/cnU0x8f+iN+C1
zikt06D3CNKRoa0Z6eBEGQT02EldPVWtLLuEOsg18Lno9vmBFnA=
=MrwC
-----END PGP SIGNATURE-----

--U7qmKhO2NWBQuzDXRRgQcm7l7RjlnxXPn--
