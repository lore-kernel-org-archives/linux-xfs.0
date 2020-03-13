Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166C2C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29CB2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgCMPZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:25:48 -0400
Received: from sandeen.net ([63.231.237.45]:36160 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgCMPZs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Mar 2020 11:25:48 -0400
Received: from Liberator.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 65AD7544
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2020 10:24:58 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.5.0 released
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c3c1a477-eadf-ae8a-8005-3b108af24e06@sandeen.net>
Date:   Fri, 13 Mar 2020 10:25:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6TBfgdGVJ1Up6hpu3PRZnmWBfYywS7HAF"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6TBfgdGVJ1Up6hpu3PRZnmWBfYywS7HAF
Content-Type: multipart/mixed; boundary="YXK5PipnEmBLOBiwAUz99J6ZFaBq2ArDk"

--YXK5PipnEmBLOBiwAUz99J6ZFaBq2ArDk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.5.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.5.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.5.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.5.0.tar=
=2Esign

The new head of the master branch is commit:

c5f89a87 (HEAD -> master, tag: v5.5.0, origin/master, origin/for-next, or=
igin/HEAD, korg/master, korg/for-next, for-next) xfsprogs: Release v5.5.0=


Abbreviated changelog:

xfsprogs-5.5.0 (13 Mar 2020)
        - xfsprogs: don't warn about packed members (Dave Chinner)

xfsprogs-5.5.0-rc1 (01 Mar 2020)
        - xfsprogs: don't redeclare globals provided by libraries (Eric S=
andeen)
        - xfsprogs: actually check that writes succeeded (Darrick Wong)
        - mkfs.xfs: check root inode location (Darrick Wong)
        - mkfs.xfs: efficient block zeroing (Eric Sandeen)
        - xfs_repair: fix broken unit conv. in dir invalidation (Darrick =
Wong)
        - xfs_repair: fix bad next_unlinked field (Eric Sandeen)
        - xfs_repair: don't corrupt attr fork clearing forw/back (Darrick=
 Wong)
        - xfs_repair: check root dir pointer before trashing it (Darrick =
Wong)
        - xfs_repair: try to fix sb_unit value from secondaries (Darrick =
Wong)
        - xfs_repair: join RT inodes to transaction only once (Eric Sande=
en)
        - xfs_io: fix over/underflow handling in timespecs (Darrick Wong)=

        - xfs_io: fix pwrite/pread length trunc on 32-bit systems (Darric=
k Wong)
        - xfs_io: fix copy_file_range length argument overflow (Darrick W=
ong)
        - xfs_io: support passing a keyring key to add_enckey (Eric Bigge=
rs)
        - xfs_scrub: fix reporting of EINVAL for online repairs (Darrick =
Wong)
        - man: document some missing xfs_db commands (Darrick Wong)
        - man: document the xfs_db btheight command  (Darrick Wong)
        - man: list xfs_io lsattr inode flag letters  (Darrick Wong)

xfsprogs-5.5.0-rc0 (22 Jan 2020)
        - libxfs changes merged from kernel 5.5

Thanks,
-Eric

Code Diffstat since 5.4.0:

 VERSION                     |    2 +-
 configure.ac                |    3 +-
 copy/xfs_copy.c             |   21 +-
 db/attrset.c                |    4 +-
 db/bmap.c                   |    4 +-
 db/btdump.c                 |   18 +-
 db/check.c                  |   42 ++--
 db/dir2.c                   |   18 +-
 db/dir2sf.c                 |    8 +-
 db/dquot.c                  |    2 +-
 db/field.c                  |    2 +-
 db/fsmap.c                  |    6 +-
 db/info.c                   |  104 ++++++++
 db/init.c                   |   20 +-
 db/inode.c                  |    4 +-
 db/io.c                     |   10 +-
 db/metadump.c               |   43 ++--
 db/sb.c                     |    2 +-
 db/xfs_admin.sh             |   42 +---
 debian/changelog            |   18 ++
 doc/CHANGES                 |   26 ++
 include/builddefs.in        |    9 +-
 include/cache.h             |    2 +-
 include/kmem.h              |    2 +-
 include/libxfs.h            |   13 +-
 include/libxlog.h           |    9 +-
 include/linux.h             |   22 ++
 include/platform_defs.h.in  |    1 +
 include/xfs_inode.h         |   22 --
 include/xfs_log_recover.h   |    4 +-
 include/xfs_mount.h         |    3 +-
 include/xfs_trace.h         |    8 +-
 io/copy_file_range.c        |   15 +-
 io/encrypt.c                |   90 +++++--
 io/pread.c                  |    4 +-
 io/pwrite.c                 |    6 +-
 libfrog/fsgeom.c            |    4 +-
 libfrog/linux.c             |   35 ++-
 libfrog/platform.h          |    2 +-
 libxcmd/input.c             |   23 +-
 libxfs/Makefile             |    1 -
 libxfs/init.c               |  181 +++++++++++---
 libxfs/libxfs_api_defs.h    |  256 ++++++++++---------
 libxfs/libxfs_io.h          |  131 +++++-----
 libxfs/libxfs_priv.h        |   49 ++--
 libxfs/rdwr.c               |  909 +++++++++++++++++++++++++++++++++++++=
------------------------------
 libxfs/trans.c              |   29 +--
 libxfs/util.c               |   19 +-
 libxfs/xfs_ag_resv.c        |    5 +
 libxfs/xfs_alloc.c          | 1255 +++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++-------------------------------------
 libxfs/xfs_alloc.h          |   16 +-
 libxfs/xfs_alloc_btree.c    |    3 +
 libxfs/xfs_attr.c           |   24 +-
 libxfs/xfs_attr_leaf.c      |  135 +++++++---
 libxfs/xfs_attr_leaf.h      |   30 ++-
 libxfs/xfs_attr_remote.c    |    2 +
 libxfs/xfs_bit.c            |    1 +
 libxfs/xfs_bmap.c           |  726 +++++++++++++++++++++++++++++++------=
-----------------
 libxfs/xfs_bmap.h           |    3 +-
 libxfs/xfs_btree.c          |   99 +++++---
 libxfs/xfs_btree.h          |   37 ++-
 libxfs/xfs_da_btree.c       |  668 ++++++++++++++++++++++++-------------=
------------
 libxfs/xfs_da_btree.h       |   73 ++++--
 libxfs/xfs_da_format.c      |  888 -------------------------------------=
-----------------------------
 libxfs/xfs_da_format.h      |   59 +----
 libxfs/xfs_defer.c          |    4 +
 libxfs/xfs_dir2.c           |   94 ++++---
 libxfs/xfs_dir2.h           |   90 +------
 libxfs/xfs_dir2_block.c     |  131 +++++-----
 libxfs/xfs_dir2_data.c      |  282 +++++++++++----------
 libxfs/xfs_dir2_leaf.c      |  307 +++++++++++++----------
 libxfs/xfs_dir2_node.c      |  431 +++++++++++++++++---------------
 libxfs/xfs_dir2_priv.h      |  103 +++++++-
 libxfs/xfs_dir2_sf.c        |  424 +++++++++++++++++++-------------
 libxfs/xfs_dquot_buf.c      |   11 +-
 libxfs/xfs_format.h         |   14 +-
 libxfs/xfs_fs.h             |    4 +-
 libxfs/xfs_ialloc.c         |  182 +++++++++++---
 libxfs/xfs_ialloc.h         |    1 +
 libxfs/xfs_iext_tree.c      |    8 +-
 libxfs/xfs_inode_buf.c      |   22 +-
 libxfs/xfs_inode_buf.h      |    5 +-
 libxfs/xfs_inode_fork.c     |   24 +-
 libxfs/xfs_inode_fork.h     |   18 +-
 libxfs/xfs_log_format.h     |    4 +-
 libxfs/xfs_refcount.c       |  175 +++++++++----
 libxfs/xfs_refcount_btree.c |    1 +
 libxfs/xfs_rmap.c           |  378 +++++++++++++++++++++-------
 libxfs/xfs_rtbitmap.c       |    3 +-
 libxfs/xfs_sb.c             |    1 +
 libxfs/xfs_trans_inode.c    |    8 +-
 libxfs/xfs_trans_resv.c     |  103 ++++++--
 libxfs/xfs_types.h          |    2 -
 libxlog/xfs_log_recover.c   |   47 ++--
 logprint/log_misc.c         |   20 +-
 logprint/log_print_all.c    |   12 +-
 logprint/log_print_trans.c  |    8 +-
 logprint/logprint.c         |    4 +-
 m4/package_libcdev.m4       |   21 ++
 man/man8/xfs_admin.8        |    4 +-
 man/man8/xfs_db.8           |  102 ++++++++
 man/man8/xfs_io.8           |   99 +++++++-
 man/man8/xfs_quota.8        |   15 +-
 mdrestore/xfs_mdrestore.c   |    1 -
 mkfs/proto.c                |    6 +-
 mkfs/xfs_mkfs.c             |  142 +++++++----
 repair/attr_repair.c        |  222 ++++++++++-------
 repair/da_util.c            |   86 +++----
 repair/dino_chunks.c        |   20 +-
 repair/dinode.c             |   73 +++---
 repair/dinode.h             |    4 -
 repair/dir2.c               |   97 ++++----
 repair/globals.c            |    6 -
 repair/globals.h            |    6 -
 repair/phase2.c             |    2 +-
 repair/phase3.c             |   10 +-
 repair/phase4.c             |   12 +-
 repair/phase5.c             |   72 +++---
 repair/phase6.c             |  142 +++++------
 repair/prefetch.c           |   42 ++--
 repair/rmap.c               |   13 +-
 repair/rt.c                 |    8 +-
 repair/scan.c               |   74 +++---
 repair/slab.c               |    2 +-
 repair/xfs_repair.c         |  286 +++++++++++----------
 scrub/scrub.c               |    5 +-
 126 files changed, 5874 insertions(+), 4891 deletions(-)
 delete mode 100644 libxfs/xfs_da_format.c



--YXK5PipnEmBLOBiwAUz99J6ZFaBq2ArDk--

--6TBfgdGVJ1Up6hpu3PRZnmWBfYywS7HAF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl5rpfoACgkQIK4WkuE9
3uBi7Q//dynhXU1gqjJximUVHnPIyCfpZiKvSkqVo8XWSilvuKXcBGEXHi+2qfn0
KcBrktOZ0iEU7MBpoIMJ6fROY66ByROfnT38S0s7tzicRl32UygP9sS5+71isYrQ
/NNGj9srMFjhYyqLRdMrqmuaIAgqcnJIzVloHtW3sboP7cvU/vtDqcD3fynHe8Dm
0Fgs1pELxbbS9RlgGp0yfffN2B2IdYYEdC+xjscL7esZXH1uKKX7WDsnYA2uZy5Y
e7saBRMcwN4vxnLlZBj5haRjC681ugY8H4WashlquWzigVfrQItXVl09TjsTcx4U
xuYzEeSIAs8x+/rQh+kEMP1dU5V3HuxcKbGY7ReBUu7jwpgwmprnWk3P5jJq1xmP
oS6kbgFYl/RYlhgoP+CttO52JJWaZIatatG/FLOUHc/e0HGZvKfDTTydm2oZAvlB
QjAer+BYbC9hP4mjXxcvlMHM9aIydAkXfL/XFUCfPI2plzMGoU6kDRZYxULdgTuC
zyN5LH5mb4RRWqH/IOZEsBqHijhFt4aX60x+zG6RdymALcabePTRQ54E7wmZ02/I
dQdmKOJOdbeCM/zkJN2RSN2o1K8Mid+4+wbOh03NzYEXtM3vpBScuk5C25sisuYl
T+NnFIqXlLXExamA4RxyhteW8noOElMPDk0WtPUk+Z42sspGGmg=
=qfIn
-----END PGP SIGNATURE-----

--6TBfgdGVJ1Up6hpu3PRZnmWBfYywS7HAF--
