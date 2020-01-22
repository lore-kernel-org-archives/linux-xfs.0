Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F01C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91EB321569
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAVQ6R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:58:17 -0500
Received: from sandeen.net ([63.231.237.45]:43390 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgAVQ6Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Jan 2020 11:58:16 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 12CBD2541
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 10:58:16 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs for-next updated to 251257e6
Message-ID: <9c82742a-fab2-78ba-f9bd-eb82f08353bf@sandeen.net>
Date:   Wed, 22 Jan 2020 10:58:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cAJB5kt0MHq9FONKb7r1cS0t71VMVPeMz"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cAJB5kt0MHq9FONKb7r1cS0t71VMVPeMz
Content-Type: multipart/mixed; boundary="0q8jCVyWpxsNJ5hVxQzQqcW8QZsVS0BoT"

--0q8jCVyWpxsNJ5hVxQzQqcW8QZsVS0BoT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.5.0-rc0

This is just the libxfs sync from kernelspace, with one extra
supporting patch for repair/

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

Onward.

The new head of the for-next branch is commit:

251257e6 (HEAD -> for-next, tag: v5.5.0-rc0, origin/libxfs-5.5-sync, orig=
in/for-next) xfsprogs: Release v5.5.0-rc0

New Commits:

Arnd Bergmann (1):
      [07c94b26] xfs: avoid time_t in user api

Brian Foster (14):
      [7777d8c6] xfs: track active state of allocation btree cursors
      [2950989c] xfs: introduce allocation cursor data structure
      [e055d59e] xfs: track allocation busy state in allocation cursor
      [19fe42e3] xfs: track best extent from cntbt lastblock scan in allo=
c cursor
      [04ea0ac1] xfs: refactor cntbt lastblock scan best extent logic int=
o helper
      [3ca39168] xfs: reuse best extent tracking logic for bnobt scan
      [46f7e323] xfs: refactor allocation tree fixup code
      [4f2eee5a] xfs: refactor and reuse best extent scanning logic
      [d0ebd9ee] xfs: refactor near mode alloc bnobt scan into separate f=
unction
      [dacde37d] xfs: factor out tree fixup logic into helper
      [4d66edb1] xfs: optimize near mode bnobt scans with concurrent cntb=
t lookups
      [06c4d767] xfs: don't set bmapi total block req where minleft is
      [496c8518] xfs: fix attr leaf header freemap.size underflow
      [e4d719e1] xfs: stabilize insert range start boundary to avoid COW =
writeback race

Carlos Maiolino (1):
      [cef0cc3b] xfs: Remove kmem_zone_free() wrapper

Chen Wandun (1):
      [44478d27] xfs: Make the symbol 'xfs_rtalloc_log_count' static

Christoph Hellwig (59):
      [75f533e6] xfs: use a struct iomap in xfs_writepage_ctx
      [2ac7663a] xfs: refactor xfs_bmapi_allocate
      [c3a24cde] xfs: move extent zeroing to xfs_bmapi_allocate
      [a85522b6] xfs: cleanup use of the XFS_ALLOC_ flags
      [bd045c51] xfs: move incore structures out of xfs_da_format.h
      [9ee31f90] xfs: use unsigned int for all size values in struct xfs_=
da_geometry
      [08c16786] xfs: devirtualize ->node_hdr_from_disk
      [b81278fa] xfs: devirtualize ->node_hdr_to_disk
      [8faa51a8] xfs: add a btree entries pointer to struct xfs_da3_icnod=
e_hdr
      [52be9b6a] xfs: move the node header size to struct xfs_da_geometry=

      [9db68faf] xfs: devirtualize ->leaf_hdr_from_disk
      [7adfbcf6] xfs: devirtualize ->leaf_hdr_to_disk
      [a2279497] xfs: add an entries pointer to struct xfs_dir3_icleaf_hd=
r
      [99e7b975] xfs: move the dir2 leaf header size to struct xfs_da_geo=
metry
      [d106a3e0] xfs: move the max dir2 leaf entries count to struct xfs_=
da_geometry
      [61e2142e] xfs: devirtualize ->free_hdr_from_disk
      [515b68f6] xfs: devirtualize ->free_hdr_to_disk
      [583be22f] xfs: make the xfs_dir3_icfree_hdr available to xfs_dir2_=
node_addname_int
      [cb5d1930] xfs: add a bests pointer to struct xfs_dir3_icfree_hdr
      [6006410b] xfs: move the dir2 free header size to struct xfs_da_geo=
metry
      [ae3cd5b1] xfs: move the max dir2 free bests count to struct xfs_da=
_geometry
      [63c36cc9] xfs: devirtualize ->db_to_fdb and ->db_to_fdindex
      [8a7190bd] xfs: devirtualize ->sf_get_parent_ino and ->sf_put_paren=
t_ino
      [660836c9] xfs: devirtualize ->sf_entsize and ->sf_nextentry
      [e96bd2d3] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
      [d49d4ff5] xfs: devirtualize ->sf_get_ftype and ->sf_put_ftype
      [7f351bbd] xfs: remove the unused ->data_first_entry_p method
      [5e9bc7ee] xfs: remove the data_dot_offset field in struct xfs_dir_=
ops
      [0e6944c5] xfs: remove the data_dotdot_offset field in struct xfs_d=
ir_ops
      [26df2433] xfs: remove the ->data_dot_entry_p and ->data_dotdot_ent=
ry_p methods
      [9c036d76] xfs: remove the ->data_unused_p method
      [08246d63] xfs: cleanup xfs_dir2_block_to_sf
      [5a73a1c9] xfs: cleanup xfs_dir2_data_freescan_int
      [014ee9ec] xfs: cleanup __xfs_dir3_data_check
      [e51152ca] xfs: remove the now unused ->data_entry_p method
      [9ad7a752] xfs: replace xfs_dir3_data_endp with xfs_dir3_data_end_o=
ffset
      [271a654f] xfs: devirtualize ->data_entsize
      [823711f2] xfs: devirtualize ->data_entry_tag_p
      [58a1d356] xfs: move the dir2 data block fixed offsets to struct xf=
s_da_geometry
      [e778c95d] xfs: cleanup xfs_dir2_data_entsize
      [04f6f354] xfs: devirtualize ->data_bestfree_p
      [28e6e614] xfs: devirtualize ->data_get_ftype and ->data_put_ftype
      [6908be48] xfs: remove the now unused dir ops infrastructure
      [d85595d0] xfs: merge xfs_dir2_data_freescan and xfs_dir2_data_free=
scan_int
      [7bba6d84] xfs: always pass a valid hdr to xfs_dir3_leaf_check_int
      [e169cc9b] xfs: devirtualize ->m_dirnameops
      [cb49e9a4] xfs: use a struct timespec64 for the in-core crtime
      [e6bd76f0] xfs: merge the projid fields in struct xfs_icdinode
      [7773baf3] xfs: don't reset the "inode core" in xfs_iread
      [59ab3748] xfs: simplify mappedbno handling in xfs_da_{get,read}_bu=
f
      [571973e8] xfs: refactor xfs_dabuf_map
      [48d1399b] xfs: improve the xfs_dabuf_map calling conventions
      [c6c4bbf3] xfs: remove the mappedbno argument to xfs_da_reada_buf
      [edf3b3a8] xfs: remove the mappedbno argument to xfs_attr3_leaf_rea=
d
      [0939d90b] xfs: remove the mappedbno argument to xfs_dir3_leaf_read=

      [5fcb9cbc] xfs: remove the mappedbno argument to xfs_dir3_leafn_rea=
d
      [02cc4995] xfs: split xfs_da3_node_read
      [5f356ae6] xfs: remove the mappedbno argument to xfs_da_read_buf
      [c1d19744] xfs: remove the mappedbno argument to xfs_da_get_buf

Darrick J. Wong (18):
      [1520370f] xfs: check attribute leaf block structure
      [43074fba] xfs: namecheck attribute names before listing them
      [88afc9cc] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadat=
a
      [9a7ae5a1] xfs: refactor xfs_iread_extents to use xfs_btree_visit_b=
locks
      [d11b23b6] xfs: relax shortform directory size checks
      [a0264b73] xfs: always log corruption errors
      [3af5535c] xfs: decrease indenting problems in xfs_dabuf_map
      [43be641e] xfs: fix missing header includes
      [530bc0fc] xfs: null out bma->prev if no previous extent
      [0bb673ce] xfs: clean up weird while loop in xfs_alloc_ag_vextent_n=
ear
      [23b2b324] xfs: refactor "does this fork map blocks" predicate
      [85b0f9e0] xfs: actually check xfs_btree_check_block return in xfs_=
btree_islastblock
      [fbb4fa7f] xfs: kill the XFS_WANT_CORRUPT_* macros
      [bc73da84] xfs: convert open coded corruption check to use XFS_IS_C=
ORRUPT
      [e1cb35b5] xfs: fix log reservation overflows when allocating large=
 rt extents
      [846e459c] libxfs: resync with the userspace libxfs
      [b75bb1bd] xfs: refactor agfl length computation function
      [1b0819ed] xfs: don't commit sunit/swidth updates to disk if that w=
ould cause repair failures

Dave Chinner (2):
      [b6d2b93c] xfs: fix inode fork extent count overflow
      [14058d94] xfs: cap longest free extent to maximum allocatable

Eric Sandeen (4):
      [e655785b] xfs_repair: stop using ->data_entry_p()
      [19879397] xfs: remove unused typedef definitions
      [5e852425] xfs: remove unused structure members & simple typedefs
      [251257e6] xfsprogs: Release v5.5.0-rc0

Joe Perches (1):
      [9bef1574] xfs: Correct comment tyops -> typos

Omar Sandoval (2):
      [f8446e51] xfs: fix realtime file data space leak
      [0b89c0a7] xfs: don't check for AG deadlock for realtime files in b=
unmapi

Pavel Reichl (2):
      [527e257f] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
      [84b9a2ca] xfs: remove the xfs_qoff_logitem_t typedef

YueHaibing (1):
      [d0704aa2] xfs: remove duplicated include from xfs_dir2_data.c

kaixuxia (1):
      [e9861d1b] xfs: Fix deadlock between AGI and AGF when target_ip exi=
sts in xfs_rename()


Code Diffstat:

 VERSION                    |    4 +-
 configure.ac               |    2 +-
 db/bmap.c                  |    4 +-
 db/btdump.c                |   18 +-
 db/check.c                 |   42 +-
 db/dir2.c                  |   18 +-
 db/dir2sf.c                |    8 +-
 db/dquot.c                 |    2 +-
 db/field.c                 |    2 +-
 db/inode.c                 |    4 +-
 db/metadump.c              |   43 +-
 db/sb.c                    |    2 +-
 debian/changelog           |    6 +
 doc/CHANGES                |    3 +
 include/kmem.h             |    2 +-
 include/libxfs.h           |   10 +-
 include/libxlog.h          |    8 +-
 include/platform_defs.h.in |    1 +
 include/xfs_inode.h        |   22 -
 include/xfs_log_recover.h  |    4 +-
 include/xfs_mount.h        |    1 -
 include/xfs_trace.h        |    8 +-
 libxfs/Makefile            |    1 -
 libxfs/libxfs_api_defs.h   |   22 +-
 libxfs/libxfs_priv.h       |   38 +-
 libxfs/rdwr.c              |    6 +-
 libxfs/trans.c             |    6 +-
 libxfs/util.c              |   19 +-
 libxfs/xfs_ag_resv.c       |    2 +
 libxfs/xfs_alloc.c         | 1254 ++++++++++++++++++++++++++------------=
------
 libxfs/xfs_alloc.h         |   16 +-
 libxfs/xfs_alloc_btree.c   |    1 +
 libxfs/xfs_attr.c          |   24 +-
 libxfs/xfs_attr_leaf.c     |  134 +++--
 libxfs/xfs_attr_leaf.h     |   30 +-
 libxfs/xfs_attr_remote.c   |    2 +
 libxfs/xfs_bit.c           |    1 +
 libxfs/xfs_bmap.c          |  725 ++++++++++++++-----------
 libxfs/xfs_bmap.h          |    3 +-
 libxfs/xfs_btree.c         |   97 ++--
 libxfs/xfs_btree.h         |   37 +-
 libxfs/xfs_da_btree.c      |  668 +++++++++++------------
 libxfs/xfs_da_btree.h      |   73 ++-
 libxfs/xfs_da_format.c     |  888 -------------------------------
 libxfs/xfs_da_format.h     |   59 +--
 libxfs/xfs_dir2.c          |   93 ++--
 libxfs/xfs_dir2.h          |   90 +---
 libxfs/xfs_dir2_block.c    |  131 +++--
 libxfs/xfs_dir2_data.c     |  282 +++++-----
 libxfs/xfs_dir2_leaf.c     |  307 ++++++-----
 libxfs/xfs_dir2_node.c     |  431 ++++++++-------
 libxfs/xfs_dir2_priv.h     |  103 +++-
 libxfs/xfs_dir2_sf.c       |  424 +++++++++------
 libxfs/xfs_dquot_buf.c     |    8 +-
 libxfs/xfs_format.h        |   14 +-
 libxfs/xfs_fs.h            |    4 +-
 libxfs/xfs_ialloc.c        |  181 +++++--
 libxfs/xfs_ialloc.h        |    1 +
 libxfs/xfs_iext_tree.c     |    2 +-
 libxfs/xfs_inode_buf.c     |   21 +-
 libxfs/xfs_inode_buf.h     |    5 +-
 libxfs/xfs_inode_fork.c    |   22 +-
 libxfs/xfs_inode_fork.h    |   18 +-
 libxfs/xfs_log_format.h    |    4 +-
 libxfs/xfs_refcount.c      |  174 ++++--
 libxfs/xfs_rmap.c          |  377 +++++++++----
 libxfs/xfs_rtbitmap.c      |    3 +-
 libxfs/xfs_sb.c            |    1 +
 libxfs/xfs_trans_inode.c   |    8 +-
 libxfs/xfs_trans_resv.c    |  102 +++-
 libxfs/xfs_types.h         |    2 -
 libxlog/xfs_log_recover.c  |   12 +-
 logprint/log_misc.c        |   20 +-
 logprint/log_print_all.c   |   10 +-
 logprint/log_print_trans.c |    8 +-
 repair/da_util.c           |   50 +-
 repair/dir2.c              |   67 ++-
 repair/phase2.c            |    2 +-
 repair/phase6.c            |   84 ++-
 79 files changed, 3805 insertions(+), 3576 deletions(-)
 delete mode 100644 libxfs/xfs_da_format.c


--0q8jCVyWpxsNJ5hVxQzQqcW8QZsVS0BoT--

--cAJB5kt0MHq9FONKb7r1cS0t71VMVPeMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl4ofycACgkQIK4WkuE9
3uAAHA//Un8w2oQ3y2xI6q62iztKqmPCb/5R3z9LckFdfBg4iEiAA4duAL5tIgtc
V92xUPygUfarxG0PWKsRljZNIwqnu7/HD6JFi9KfnyQi0k17yMaIL6/Z2q/52onn
ZTYBLY1HhxMxDOYDPZ4TA1xl+v00VibzALZ7XyWUFR3Be/yBVODphNKI+T2iU+wR
7qsn7WPCu5v+D81emGDiLhksdNKMBoRyi/e/ykPE5k2Tuxh31TZuIg87rMleaD6G
5yGoiasok1r6FHO/rX8eWwuyvOd0COGyqpbURlSbUTvzCloyEyT4Zf71AJyfpiQv
CKk3a4XO4tQbvA7ElubfSYpdWQVwaw29oed57ucQ4XodCFUBAlKQs0LbVp7Jy/Ir
Q+jDRAMbSEjRraXCw3eHL7M2an+hp0gDRIAfua3Tla0T+wXTHCAsZtH6Ld94I5Wh
kHGq3ZXGjRpFIL3iidjQq0IFWoABuOFsh05tpJ08dUdX/YhdsmSbCflhmc5nnMko
CwS27/24/gOzS0VDCvx2oVT4Au2Ef+6OMTEMVNdD1cTkJ9VNUrHUzoLdpU6r4woQ
XTefXm+4jD5JPmLqm6/2EJcIWH89CL5Ivwzb8W9jrnH9/L2WLZedqAu/AbTjXd0U
x+FjWl9qjTyKMowmVP4D7dnLr72geY7llBpTtYFEfkx+5Rf22BM=
=TAEO
-----END PGP SIGNATURE-----

--cAJB5kt0MHq9FONKb7r1cS0t71VMVPeMz--
