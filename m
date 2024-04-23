Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9537144
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713883348; cv=none; b=TW9OjFa6KvJBHtWZ2FutD0Pizniw1ZIAQYLM57MGS63JC06dT7HKrICUTxCFyoYrtnOb3NL8b0JJ6rJ9FjSFRyEoT+LylcTpX4Xepy5wpc5Ae/4Lk5Pwz2Stl9j6lZ94hfII177GdhTxH0F2iqG7O6u/sGJk+exmsl7Q/dJrHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713883348; c=relaxed/simple;
	bh=lvfk9KOMFI37xV7oiqCr/6Y3+yUE1tDfQnT0kpHxBiM=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=Np6HABceKAyvKKKwPMFmLTpg33qL3Bw7GfTeozS6W6GWMUe5IOW7ZUOvp7x/d9+Eily23f33qX/IX9pzxsELKsUoF6f2IqUzN03KR34QJBQ0Ffwp0dTO6LK10zSiVxaJztsOhhPZSNQ6ybMMXsQhSagxgWtJBmZyYLFNXnczFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=WfcYWl52; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="WfcYWl52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1713883337; x=1714142537;
	bh=EU2T6FLzzC4R3l/Vb33/B3l9MK+dPpu7KpFUsEtXk/M=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=WfcYWl52JFny+Dzs8/QfN4hMfgMszOUGtkmYDc/oBsPoVcAJhu/6IM3bY0tgWkz2d
	 YGJFvlWVNFwNVjRxFv/gzh70ULJeLB8SlvNa6lNmJzMMKTXJDKx1IT4RGtybGiVOzJ
	 7b/KXPqgjVpGhOQ05HNfrbgIpfygYO+qvk9gjsnOJ4wmKveBXgTJbQCQ42N6ictmsR
	 Hc1XATycnOa+2yL1fJp/25YBVTMwa+8IkULpVvUzi2BaWOXwr7ERvbzAguQqnV9tks
	 FvZUpwaYyqzQbGukOBUTDqAOyUsExXAiw1/A2NL5vR2P9I5quFSMJ7977lvELz5B/1
	 ZYVbKLSELJw+A==
Date: Tue, 23 Apr 2024 14:42:05 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to d5d677df7
Message-ID: <6edmi2wfmto4sbw4miohlhfvbiyhg5hdan52dk27canoug6425@6c4acq6bzngn>
Feedback-ID: 28765827:user:proton
X-Pm-Message-ID: 4b6855b7f2521d7b6546edb207dd8eaa6a6021ee
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------716dcf833ce4b65195c29bb652daaf818a2eacf8001e376f1523fab240b57c06"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------716dcf833ce4b65195c29bb652daaf818a2eacf8001e376f1523fab240b57c06
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Apr 2024 16:42:02 +0200
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to d5d677df7
Message-ID: <6edmi2wfmto4sbw4miohlhfvbiyhg5hdan52dk27canoug6425@6c4acq6bzngn>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

d5d677df76af140532dc95f8fb133ba340ea64c8

118 new commits:

Andrey Albershteyn (8):
      [c8499fbfd] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
      [21dc682a3] xfs_db: fix leak in flist_find_ftyp()
      [fcac184cc] xfs_repair: make duration take time_t
      [c4dd920b8] xfs_scrub: don't call phase_end if phase_rusage was not initialized
      [9c6e9d8de] xfs_fsr: convert fsrallfs to use time_t instead of int
      [652f8066b] xfs_fsr: replace atoi() with strtol()
      [a21daa3a7] xfs_db: add helper for flist_find_type for clearer field matching
      [d03b73d24] xfs_repair: catch strtol() errors

Christoph Hellwig (29):
      [d57269fad] xfs: move xfs_ondisk.h to libxfs/
      [ba5ed3487] xfs: consolidate the xfs_attr_defer_* helpers
      [6b1f3546f] xfs: store an ops pointer in struct xfs_defer_pending
      [effb6e31d] xfs: pass the defer ops instead of type to xfs_defer_start_recovery
      [e6f5dc8a9] xfs: pass the defer ops directly to xfs_defer_add
      [0d263da3c] xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
      [6d40dad2e] xfs: also use xfs_bmap_btalloc_accounting for RT allocations
      [26b23b571] xfs: return -ENOSPC from xfs_rtallocate_*
      [55d00e3de] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
      [fbaaa7b36] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
      [5dded934b] xfs: split xfs_rtmodify_summary_int
      [6742ada6e] xfs: remove rt-wrappers from xfs_format.h
      [50e6e3c28] xfs: remove XFS_RTMIN/XFS_RTMAX
      [f81461975] xfs: make if_data a void pointer
      [4ff35b841] xfs: return if_data from xfs_idata_realloc
      [73d6f197d] xfs: move the xfs_attr_sf_lookup tracepoint
      [d0cd2078c] xfs: simplify xfs_attr_sf_findname
      [f4f98f2e6] xfs: remove xfs_attr_shortform_lookup
      [ef7e1fab3] xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
      [5e2372c48] xfs: remove struct xfs_attr_shortform
      [fcff0528e] xfs: remove xfs_attr_sf_hdr_t
      [5ef5d3286] xfs: turn the XFS_DA_OP_REPLACE checks in xfs_attr_shortform_addname into asserts
      [628b9f673] xfs: fix a use after free in xfs_defer_finish_recovery
      [dfc8456fe] xfs: use the op name in trace_xlog_intent_recovery_failed
      [2cfab496d] libxfs: remove the unused fs_topology_t typedef
      [f35e15ee6] libxfs: refactor the fs_topology structure
      [62aa97ee7] libxfs: remove the S_ISREG check from blkid_get_topology
      [258dd18d1] libxfs: also query log device topology in get_topology
      [53bf0604e] mkfs: use a sensible log sector size default

Darrick J. Wong (75):
      [6b72d9dcd] debian: fix package configuration after removing platform_defs.h.in
      [d27e715c3] libxfs: fix incorrect porting to 6.7
      [94f4f0a73] mkfs: fix log sunit rounding when external logs are in use
      [b64874dba] xfs_repair: fix confusing rt space units in the duplicate detection code
      [e14fcb26f] libxfs: create a helper to compute leftovers of realtime extents
      [4fdb30cea] libxfs: use helpers to convert rt block numbers to rt extent numbers
      [2e62ddc46] xfs_repair: convert utility to use new rt extent helpers and types
      [d251bd115] mkfs: convert utility to use new rt extent helpers and types
      [61b7c5fda] xfs_{db,repair}: convert open-coded xfs_rtword_t pointer accesses to helper
      [742c5e97a] xfs_repair: convert helpers for rtbitmap block/wordcount computations
      [0457cd25c] xfs_{db,repair}: use accessor functions for bitmap words
      [113af2358] xfs_{db,repair}: use helpers for rtsummary block/wordcount computations
      [251eb5170] xfs_{db,repair}: use accessor functions for summary info words
      [9c69d1c72] xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks
      [1c499f7f3] xfs: use xfs_defer_pending objects to recover intent items
      [d56bb0de1] xfs: recreate work items when recovering intent items
      [ea8dad89a] xfs: use xfs_defer_finish_one to finish recovered work items
      [0c9b2da91] xfs: move ->iop_recover to xfs_defer_op_type
      [3810e2215] xfs: hoist intent done flag setting to ->finish_item callsite
      [63a3ea39f] xfs: hoist ->create_intent boilerplate to its callsite
      [35d610ce2] xfs: use xfs_defer_create_done for the relogging operation
      [db0fc90c6] xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
      [b315a11dd] xfs: hoist xfs_trans_add_item calls to defer ops functions
      [caa1ab41c] xfs: move ->iop_relog to struct xfs_defer_op_type
      [eb2a50fdb] xfs: make rextslog computation consistent with mkfs
      [a8ef1c96a] xfs: fix 32-bit truncation in xfs_compute_rextslog
      [befdc0c82] xfs: don't allow overly small or large realtime volumes
      [bd786d634] xfs: elide ->create_done calls for unlogged deferred work
      [bbd016cba] xfs: don't append work items to logged xfs_defer_pending objects
      [33d500a90] xfs: allow pausing of pending deferred work items
      [8876f46bd] xfs: remove __xfs_free_extent_later
      [1fb9c6611] xfs: automatic freeing of freshly allocated unwritten space
      [ae2063cd0] xfs: remove unused fields from struct xbtree_ifakeroot
      [63644c545] xfs: force small EFIs for reaping btree extents
      [152e82440] xfs: force all buffers to be written during btree bulk load
      [6feab85fb] xfs: set XBF_DONE on newly formatted btree block that are ready for writing
      [630045438] xfs: read leaf blocks when computing keys for bulkloading into node blocks
      [d05b191b8] xfs: move btree bulkload record initialization to ->get_record implementations
      [8c1ed622b] xfs: constrain dirty buffers while formatting a staged btree
      [8b58b0886] xfs: repair free space btrees
      [5f8e3af02] xfs: repair inode btrees
      [5c950b9a1] xfs: repair refcount btrees
      [fff96ea65] xfs: dont cast to char * for XFS_DFORK_*PTR macros
      [ae31a1813] xfs: set inode sick state flags when we zap either ondisk fork
      [7c5d4f922] xfs: zap broken inode forks
      [7310dea5d] xfs: repair inode fork block mapping data structures
      [719c1bfc2] xfs: create a ranged query function for refcount btrees
      [f76f73b3b] xfs: create a new inode fork block unmap helper
      [cdc6bcb83] xfs: improve dquot iteration for scrub
      [26da39996] xfs: fix backwards logic in xfs_bmap_alloc_account
      [a6e7d3699] xfs: remove conditional building of rt geometry validator functions
      [e7bba6c43] xfs_repair: adjust btree bulkloading slack computations to match online repair
      [2f2e6b36a] xfs_repair: bulk load records into new btree blocks
      [a66875ddf] xfs_repair: double-check with shortform attr verifiers
      [221bfd062] xfs_db: improve number extraction in getbitval
      [13eedd45a] xfs_scrub: fix threadcount estimates for phase 6
      [4d0ce76d3] xfs_scrub: don't fail while reporting media scan errors
      [16a75c71b] xfs_io: add linux madvise advice codes
      [9338bc8b1] mkfs: allow sizing allocation groups for concurrency
      [c02a18733] mkfs: allow sizing internal logs for concurrency
      [20860d6aa] libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
      [48508407f] libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub type
      [bd35f31ce] xfs_scrub: scan whole-fs metadata files in parallel
      [164a5514c] xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
      [e88445180] xfs_repair: sync bulkload data structures with kernel newbt code
      [b3bcb8f0a] xfs_repair: rebuild block mappings from rmapbt data
      [e9984a422] xfs_db: add a bmbt inflation command
      [d4bd0b1b1] xfs_repair: slab and bag structs need to track more than 2^32 items
      [cf3fe96eb] xfs_repair: support more than 2^32 rmapbt records per AG
      [d50ca6bd3] xfs_repair: support more than 2^32 owners per physical block
      [0b1e67af1] xfs_repair: clean up lock resources
      [346ce6d57] xfs_repair: constrain attr fork extent count
      [585a1f789] xfs_repair: don't create block maps for data files
      [90ee2c3a9] xfs_repair: support more than INT_MAX block maps
      [fa7037908] libxfs: print the device name if flush-on-close fails

Jiachen Zhang (1):
      [aedfcddbb] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Long Li (2):
      [bf3acae1b] xfs: add lock protection when remove perag from radix tree
      [a410fa5f2] xfs: fix perag leak when growfs fails

Srikanth C S (1):
      [d5d677df7] xfs_repair: Dump both inode details in Phase 6 duplicate file check

Zhang Tianci (2):
      [2831e8f93] xfs: update dir3 leaf block metadata after swap
      [93d1bd08e] xfs: extract xfs_da_buf_copy() helper function

Code Diffstat:

 db/Makefile                 |  65 +++-
 db/attrshort.c              |  35 +--
 db/bit.c                    |  37 +--
 db/bmap_inflate.c           | 551 ++++++++++++++++++++++++++++++++
 db/check.c                  | 102 ++++--
 db/command.c                |   1 +
 db/command.h                |   1 +
 db/flist.c                  |  58 ++--
 db/inode.c                  |   6 +-
 db/metadump.c               |  16 +-
 db/namei.c                  |   4 +-
 debian/rules                |   6 +-
 fsr/xfs_fsr.c               |  36 ++-
 include/libxfs.h            |   4 +
 include/list.h              |  14 +
 include/xfs_trace.h         |   5 +
 include/xfs_trans.h         |   3 +-
 io/madvise.c                |  77 ++++-
 io/scrub.c                  |  13 +-
 libfrog/scrub.c             |  51 ++-
 libfrog/scrub.h             |  24 +-
 libfrog/util.h              |   5 +
 libxfs/Makefile             |   1 +
 libxfs/defer_item.c         |  16 +-
 libxfs/init.c               |  18 +-
 libxfs/libxfs_api_defs.h    |  28 +-
 libxfs/libxfs_io.h          |  11 +
 libxfs/libxfs_priv.h        |   7 +-
 libxfs/logitem.c            |   3 +-
 libxfs/topology.c           | 109 ++++---
 libxfs/topology.h           |  19 +-
 libxfs/trans.c              |  51 ++-
 libxfs/util.c               |   2 +-
 libxfs/xfs_ag.c             |  38 ++-
 libxfs/xfs_ag.h             |  12 +
 libxfs/xfs_ag_resv.c        |   2 +
 libxfs/xfs_alloc.c          | 116 ++++++-
 libxfs/xfs_alloc.h          |  24 +-
 libxfs/xfs_alloc_btree.c    |  13 +-
 libxfs/xfs_attr.c           | 131 +++-----
 libxfs/xfs_attr_leaf.c      | 238 +++++---------
 libxfs/xfs_attr_leaf.h      |   8 +-
 libxfs/xfs_attr_sf.h        |  24 +-
 libxfs/xfs_bmap.c           | 201 +++++++-----
 libxfs/xfs_bmap.h           |   9 +-
 libxfs/xfs_bmap_btree.c     | 124 ++++++--
 libxfs/xfs_bmap_btree.h     |   5 +
 libxfs/xfs_btree.c          |  28 +-
 libxfs/xfs_btree.h          |   5 +
 libxfs/xfs_btree_staging.c  |  89 ++++--
 libxfs/xfs_btree_staging.h  |  33 +-
 libxfs/xfs_da_btree.c       |  69 ++--
 libxfs/xfs_da_btree.h       |   2 +
 libxfs/xfs_da_format.h      |  33 +-
 libxfs/xfs_defer.c          | 452 +++++++++++++++++++++-----
 libxfs/xfs_defer.h          |  59 +++-
 libxfs/xfs_dir2.c           |   2 +-
 libxfs/xfs_dir2_block.c     |   6 +-
 libxfs/xfs_dir2_priv.h      |   3 +-
 libxfs/xfs_dir2_sf.c        |  91 ++----
 libxfs/xfs_format.h         |  19 +-
 libxfs/xfs_health.h         |  10 +
 libxfs/xfs_ialloc.c         |  36 ++-
 libxfs/xfs_ialloc.h         |   3 +-
 libxfs/xfs_ialloc_btree.c   |   2 +-
 libxfs/xfs_iext_tree.c      |  59 ++--
 libxfs/xfs_inode_fork.c     |  78 +++--
 libxfs/xfs_inode_fork.h     |  13 +-
 libxfs/xfs_ondisk.h         | 199 ++++++++++++
 libxfs/xfs_refcount.c       |  57 +++-
 libxfs/xfs_refcount.h       |  12 +-
 libxfs/xfs_refcount_btree.c |  15 +-
 libxfs/xfs_rmap.c           |   2 +-
 libxfs/xfs_rtbitmap.c       | 108 +++----
 libxfs/xfs_rtbitmap.h       |   7 +-
 libxfs/xfs_sb.c             |  20 +-
 libxfs/xfs_sb.h             |   2 +
 libxfs/xfs_shared.h         |   2 +-
 libxfs/xfs_symlink_remote.c |  12 +-
 libxfs/xfs_types.h          |  20 +-
 man/man8/mkfs.xfs.8.in      |  46 +++
 man/man8/xfs_db.8           |  23 ++
 mkfs/proto.c                |  41 ++-
 mkfs/xfs_mkfs.c             | 346 +++++++++++++++++---
 repair/Makefile             |   2 +
 repair/agbtree.c            | 202 +++++++-----
 repair/agheader.h           |   2 +-
 repair/attr_repair.c        |  65 ++--
 repair/bmap.c               |  23 +-
 repair/bmap.h               |   7 +-
 repair/bmap_repair.c        | 748 ++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h        |  13 +
 repair/bulkload.c           | 269 ++++++++++++++--
 repair/bulkload.h           |  34 +-
 repair/dino_chunks.c        |   5 +-
 repair/dinode.c             | 204 ++++++++----
 repair/dinode.h             |   7 +-
 repair/dir2.c               |   2 +-
 repair/globals.c            |   6 +-
 repair/globals.h            |   6 +-
 repair/incore.c             |  25 +-
 repair/incore.h             |  15 +-
 repair/incore_ext.c         |  74 ++---
 repair/phase4.c             |  16 +-
 repair/phase5.c             |   2 +-
 repair/phase6.c             |  88 ++++--
 repair/progress.c           |   9 +-
 repair/progress.h           |   2 +-
 repair/rmap.c               |  27 +-
 repair/rmap.h               |   5 +-
 repair/rt.c                 |  70 +++--
 repair/rt.h                 |   6 +-
 repair/sb.c                 |   8 +-
 repair/scan.c               |   2 +-
 repair/slab.c               |  36 +--
 repair/slab.h               |  36 ++-
 repair/xfs_repair.c         |  42 ++-
 scrub/phase2.c              | 135 ++++++--
 scrub/phase4.c              |   2 +-
 scrub/phase6.c              |  36 ++-
 scrub/phase7.c              |   4 +-
 scrub/scrub.c               |  75 +++--
 scrub/scrub.h               |   6 +-
 scrub/xfs_scrub.c           |   3 +-
 124 files changed, 5029 insertions(+), 1618 deletions(-)
 create mode 100644 db/bmap_inflate.c
 create mode 100644 libxfs/xfs_ondisk.h
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

--------716dcf833ce4b65195c29bb652daaf818a2eacf8001e376f1523fab240b57c06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmYnyL0JEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAEuxAQCnP26CddbK6dt2F3sbSiGNS4umIUPr9nawLxiNb+jixAEA6H4G
e9vYU5VSay7gbJxZ70ts47DYKlzt+IpkrTLg7Ak=
=jJKm
-----END PGP SIGNATURE-----


--------716dcf833ce4b65195c29bb652daaf818a2eacf8001e376f1523fab240b57c06--

