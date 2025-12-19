Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991C238C07
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122947; cv=none; b=Iol3WCvtaZ8LbReay6uuPWbxC95SKvnuykpsxWDgomNl9Ae/pdbmgWcRn0sTC75/S5CujHNGi2Gveql+TNgC2nNi0LlDEli4XmC44qhiiAA/8Enc40IPMChSYCKjhoo7tQlaedo2xJE7Ux5cIoq9vBFmkj9O5RIdnauvVBEoAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122947; c=relaxed/simple;
	bh=w3bDhiuyyg1tgKAOjQBaBgD7Fgivpbs1YzEN0b7JCtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmFxLCs1IcEccRyORWPgBpKQEj68xzDkVy0dSBriJfnK4e1ENtRqZszcsBA29Q3z/0erz4AFGpuCDae7gpat6lAcVOwKU1exjjfavIjGD017VjEHgyX0Eon84gXb0n7y/iPTuowZAkYPAvIel/TBolTBBhU9CSl1iFyqnuFM3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1pOZ60tk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1pOZ60tk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/r6gh+kzyj3hjME4BU4SDOtgGpX2j+5uugGsOQeZ9ls=; b=1pOZ60tkRh5mLG0KmbkPrA9dXu
	lDjteLGTkG+bQ9al9s1o35pNfPIAGekrKOuGlm76+1UCyk+3XK0KWkYsSqprV79YTbnIWOCIZN9dw
	qZVftTZ/uVKcndUIEPsB1kQKkY2lyvaxGaHUW8dX9nU0mnsQ92lRB12v3tvIz2AyLhdNu9iK8aIAG
	qTXxGWjuzoXWW1A0rS6jR+vMNG3lehR9NC4x8iNz9Z7U3OjNY7/nLpNpF9Yht10OL5ovCWq7mrDIQ
	XnG19WKtBg7Li5b4jJFtbkZML4vA3Od5XfSLGSu+Iycd8m4JQj0a4KsjIagVOL60ECp6TsRNymx7A
	g+Acj70g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTFr-00000009fIg-3370;
	Fri, 19 Dec 2025 05:42:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: directly include xfs_platform.h
Date: Fri, 19 Dec 2025 06:41:47 +0100
Message-ID: <20251219054202.1773441-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251219054202.1773441-1-hch@lst.de>
References: <20251219054202.1773441-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xfs.h header conflicts with the public xfs.h in xfsprogs, leading
to a spurious difference in all shared libxfs files that have to
include libxfs_priv.h in userspace.  Directly include xfs_platform.h so
that we can add a header of the same name to xfsprogs and remove this
major annoyance for the shared code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c               |  2 +-
 fs/xfs/libxfs/xfs_ag_resv.c          |  2 +-
 fs/xfs/libxfs/xfs_alloc.c            |  2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c      |  2 +-
 fs/xfs/libxfs/xfs_attr.c             |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        |  2 +-
 fs/xfs/libxfs/xfs_attr_remote.c      |  2 +-
 fs/xfs/libxfs/xfs_bit.c              |  2 +-
 fs/xfs/libxfs/xfs_bmap.c             |  2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       |  2 +-
 fs/xfs/libxfs/xfs_btree.c            |  2 +-
 fs/xfs/libxfs/xfs_btree_mem.c        |  2 +-
 fs/xfs/libxfs/xfs_btree_staging.c    |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c         |  2 +-
 fs/xfs/libxfs/xfs_defer.c            |  2 +-
 fs/xfs/libxfs/xfs_dir2.c             |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c       |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c        |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c        |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c        |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c          |  2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c        |  2 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |  2 +-
 fs/xfs/libxfs/xfs_group.c            |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c           |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_iext_tree.c        |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c       |  2 +-
 fs/xfs/libxfs/xfs_inode_util.c       |  2 +-
 fs/xfs/libxfs/xfs_log_rlimit.c       |  2 +-
 fs/xfs/libxfs/xfs_metadir.c          |  2 +-
 fs/xfs/libxfs/xfs_metafile.c         |  2 +-
 fs/xfs/libxfs/xfs_parent.c           |  2 +-
 fs/xfs/libxfs/xfs_refcount.c         |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_rmap.c             |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c       |  2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c         |  2 +-
 fs/xfs/libxfs/xfs_rtgroup.c          |  2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_sb.c               |  2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c   |  2 +-
 fs/xfs/libxfs/xfs_trans_inode.c      |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c       |  2 +-
 fs/xfs/libxfs/xfs_trans_space.c      |  2 +-
 fs/xfs/libxfs/xfs_types.c            |  2 +-
 fs/xfs/libxfs/xfs_zones.c            |  2 +-
 fs/xfs/scrub/agb_bitmap.c            |  2 +-
 fs/xfs/scrub/agheader.c              |  2 +-
 fs/xfs/scrub/agheader_repair.c       |  2 +-
 fs/xfs/scrub/alloc.c                 |  2 +-
 fs/xfs/scrub/alloc_repair.c          |  2 +-
 fs/xfs/scrub/attr.c                  |  2 +-
 fs/xfs/scrub/attr_repair.c           |  2 +-
 fs/xfs/scrub/bitmap.c                |  2 +-
 fs/xfs/scrub/bmap.c                  |  2 +-
 fs/xfs/scrub/bmap_repair.c           |  2 +-
 fs/xfs/scrub/btree.c                 |  2 +-
 fs/xfs/scrub/common.c                |  2 +-
 fs/xfs/scrub/cow_repair.c            |  2 +-
 fs/xfs/scrub/dabtree.c               |  2 +-
 fs/xfs/scrub/dir.c                   |  2 +-
 fs/xfs/scrub/dir_repair.c            |  2 +-
 fs/xfs/scrub/dirtree.c               |  2 +-
 fs/xfs/scrub/dirtree_repair.c        |  2 +-
 fs/xfs/scrub/dqiterate.c             |  2 +-
 fs/xfs/scrub/findparent.c            |  2 +-
 fs/xfs/scrub/fscounters.c            |  2 +-
 fs/xfs/scrub/fscounters_repair.c     |  2 +-
 fs/xfs/scrub/health.c                |  2 +-
 fs/xfs/scrub/ialloc.c                |  2 +-
 fs/xfs/scrub/ialloc_repair.c         |  2 +-
 fs/xfs/scrub/inode.c                 |  2 +-
 fs/xfs/scrub/inode_repair.c          |  2 +-
 fs/xfs/scrub/iscan.c                 |  2 +-
 fs/xfs/scrub/listxattr.c             |  2 +-
 fs/xfs/scrub/metapath.c              |  2 +-
 fs/xfs/scrub/newbt.c                 |  2 +-
 fs/xfs/scrub/nlinks.c                |  2 +-
 fs/xfs/scrub/nlinks_repair.c         |  2 +-
 fs/xfs/scrub/orphanage.c             |  2 +-
 fs/xfs/scrub/parent.c                |  2 +-
 fs/xfs/scrub/parent_repair.c         |  2 +-
 fs/xfs/scrub/quota.c                 |  2 +-
 fs/xfs/scrub/quota_repair.c          |  2 +-
 fs/xfs/scrub/quotacheck.c            |  2 +-
 fs/xfs/scrub/quotacheck_repair.c     |  2 +-
 fs/xfs/scrub/rcbag.c                 |  2 +-
 fs/xfs/scrub/rcbag_btree.c           |  2 +-
 fs/xfs/scrub/readdir.c               |  2 +-
 fs/xfs/scrub/reap.c                  |  2 +-
 fs/xfs/scrub/refcount.c              |  2 +-
 fs/xfs/scrub/refcount_repair.c       |  2 +-
 fs/xfs/scrub/repair.c                |  2 +-
 fs/xfs/scrub/rgsuper.c               |  2 +-
 fs/xfs/scrub/rmap.c                  |  2 +-
 fs/xfs/scrub/rmap_repair.c           |  2 +-
 fs/xfs/scrub/rtbitmap.c              |  2 +-
 fs/xfs/scrub/rtbitmap_repair.c       |  2 +-
 fs/xfs/scrub/rtrefcount.c            |  2 +-
 fs/xfs/scrub/rtrefcount_repair.c     |  2 +-
 fs/xfs/scrub/rtrmap.c                |  2 +-
 fs/xfs/scrub/rtrmap_repair.c         |  2 +-
 fs/xfs/scrub/rtsummary.c             |  2 +-
 fs/xfs/scrub/rtsummary_repair.c      |  2 +-
 fs/xfs/scrub/scrub.c                 |  2 +-
 fs/xfs/scrub/stats.c                 |  2 +-
 fs/xfs/scrub/symlink.c               |  2 +-
 fs/xfs/scrub/symlink_repair.c        |  2 +-
 fs/xfs/scrub/tempfile.c              |  2 +-
 fs/xfs/scrub/trace.c                 |  2 +-
 fs/xfs/scrub/xfarray.c               |  2 +-
 fs/xfs/scrub/xfblob.c                |  2 +-
 fs/xfs/scrub/xfile.c                 |  2 +-
 fs/xfs/xfs.h                         | 11 -----------
 fs/xfs/xfs_acl.c                     |  2 +-
 fs/xfs/xfs_aops.c                    |  2 +-
 fs/xfs/xfs_attr_inactive.c           |  2 +-
 fs/xfs/xfs_attr_item.c               |  2 +-
 fs/xfs/xfs_attr_list.c               |  2 +-
 fs/xfs/xfs_bio_io.c                  |  2 +-
 fs/xfs/xfs_bmap_item.c               |  2 +-
 fs/xfs/xfs_bmap_util.c               |  2 +-
 fs/xfs/xfs_buf.c                     |  2 +-
 fs/xfs/xfs_buf_item.c                |  2 +-
 fs/xfs/xfs_buf_item_recover.c        |  2 +-
 fs/xfs/xfs_buf_mem.c                 |  2 +-
 fs/xfs/xfs_dahash_test.c             |  2 +-
 fs/xfs/xfs_dir2_readdir.c            |  2 +-
 fs/xfs/xfs_discard.c                 |  2 +-
 fs/xfs/xfs_dquot.c                   |  2 +-
 fs/xfs/xfs_dquot_item.c              |  2 +-
 fs/xfs/xfs_dquot_item_recover.c      |  2 +-
 fs/xfs/xfs_drain.c                   |  2 +-
 fs/xfs/xfs_error.c                   |  2 +-
 fs/xfs/xfs_exchmaps_item.c           |  2 +-
 fs/xfs/xfs_exchrange.c               |  2 +-
 fs/xfs/xfs_export.c                  |  2 +-
 fs/xfs/xfs_extent_busy.c             |  2 +-
 fs/xfs/xfs_extfree_item.c            |  2 +-
 fs/xfs/xfs_file.c                    |  2 +-
 fs/xfs/xfs_filestream.c              |  2 +-
 fs/xfs/xfs_fsmap.c                   |  2 +-
 fs/xfs/xfs_fsops.c                   |  2 +-
 fs/xfs/xfs_globals.c                 |  2 +-
 fs/xfs/xfs_handle.c                  |  2 +-
 fs/xfs/xfs_health.c                  |  2 +-
 fs/xfs/xfs_hooks.c                   |  2 +-
 fs/xfs/xfs_icache.c                  |  2 +-
 fs/xfs/xfs_icreate_item.c            |  2 +-
 fs/xfs/xfs_inode.c                   |  2 +-
 fs/xfs/xfs_inode_item.c              |  2 +-
 fs/xfs/xfs_inode_item_recover.c      |  2 +-
 fs/xfs/xfs_ioctl.c                   |  2 +-
 fs/xfs/xfs_ioctl32.c                 |  2 +-
 fs/xfs/xfs_iomap.c                   |  2 +-
 fs/xfs/xfs_iops.c                    |  2 +-
 fs/xfs/xfs_itable.c                  |  2 +-
 fs/xfs/xfs_iunlink_item.c            |  2 +-
 fs/xfs/xfs_iwalk.c                   |  2 +-
 fs/xfs/xfs_log.c                     |  2 +-
 fs/xfs/xfs_log_cil.c                 |  2 +-
 fs/xfs/xfs_log_recover.c             |  2 +-
 fs/xfs/xfs_message.c                 |  2 +-
 fs/xfs/xfs_mount.c                   |  2 +-
 fs/xfs/xfs_mru_cache.c               |  2 +-
 fs/xfs/xfs_notify_failure.c          |  2 +-
 fs/xfs/xfs_pnfs.c                    |  2 +-
 fs/xfs/xfs_pwork.c                   |  2 +-
 fs/xfs/xfs_qm.c                      |  2 +-
 fs/xfs/xfs_qm_bhv.c                  |  2 +-
 fs/xfs/xfs_qm_syscalls.c             |  2 +-
 fs/xfs/xfs_quotaops.c                |  2 +-
 fs/xfs/xfs_refcount_item.c           |  2 +-
 fs/xfs/xfs_reflink.c                 |  2 +-
 fs/xfs/xfs_rmap_item.c               |  2 +-
 fs/xfs/xfs_rtalloc.c                 |  2 +-
 fs/xfs/xfs_stats.c                   |  2 +-
 fs/xfs/xfs_super.c                   |  2 +-
 fs/xfs/xfs_symlink.c                 |  2 +-
 fs/xfs/xfs_sysctl.c                  |  2 +-
 fs/xfs/xfs_sysfs.c                   |  2 +-
 fs/xfs/xfs_trace.c                   |  2 +-
 fs/xfs/xfs_trans.c                   |  2 +-
 fs/xfs/xfs_trans_ail.c               |  2 +-
 fs/xfs/xfs_trans_buf.c               |  2 +-
 fs/xfs/xfs_trans_dquot.c             |  2 +-
 fs/xfs/xfs_xattr.c                   |  2 +-
 fs/xfs/xfs_zone_alloc.c              |  2 +-
 fs/xfs/xfs_zone_gc.c                 |  2 +-
 fs/xfs/xfs_zone_info.c               |  2 +-
 fs/xfs/xfs_zone_space_resv.c         |  2 +-
 194 files changed, 193 insertions(+), 204 deletions(-)
 delete mode 100644 fs/xfs/xfs.h

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..586918ed1cbf 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -5,7 +5,7 @@
  * All rights reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 8ac8230c3d3c..c4cdcc570d61 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad381c73abc4..5bec3365a99a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index fa1f03c1331e..29f6ec1c3f6f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d48..866abae58fe1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 91c1b30ebaab..6061230b17ef 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index bff3dc226f81..e6c8dd1a997a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 40ce5f3094d1..f05a07c0f75d 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_log_format.h"
 #include "xfs_bit.h"
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 53ef4b7e504d..7a4c8f1aa76c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 188feac04b60..1c7165df483a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index dbe9df8c3300..7012f3570c8d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index f2f7b4305413..37136a70e56d 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 5ed84f9cc877..4300c058807b 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2020 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 90f7fc219fcc..766631f0562e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5b377cbbb1f7..0bd87b40d091 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 82a338458a51..107c1a5b8a96 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f93ed1a4a74..6d70e6b429e7 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index a16b05c43e2e..80ba94f51e5c 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 71c2f22a3f6e..bc909543eb74 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index fe8d4fa13128..ed0b5287a44f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 17a20384c8b7..1a67cdd6a707 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index dceef2abd4e2..ce767b40482f 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 932ee4619e9e..5d28f4eac527 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 792f76d2e2a0..2ff9d1e56b47 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018 Red Hat, Inc.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d97295eaebe6..232c7ec0aef1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 100afdd66cdd..1376e8630449 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 8796f2b3e534..5b2b926ab228 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2017 Christoph Hellwig.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b1812b2c3cce..a017016e9075 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1772d82f2d68..d14a7f2f4c03 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 309ce6dd5553..551fa51befb6 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 34bba96d30ca..37712b2f8757 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2013 Jie Liu.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 178e89711cb7..3e5c61188927 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index b02e3d6c0868..cf239f862212 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 69366c44a701..6539f5adae2d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2484dc9f6d7e..915ec85530e7 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 06da3ca14727..7e5f92c1ac56 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 83e0488ff773..e78133c908ca 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index bf16aee50d73..10b3272238eb 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 618061d898d4..bc4c0a99f4dd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9186c58e83d5..678dec4ed095 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ac11e94b42ae..c1518267eb17 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 55f903165769..00557b7ef298 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 94c272a2ae26..38d16fe1f6d8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index fb47a76ead18..f9a5966d8048 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012-2013 Red Hat, Inc.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index c962ad64b0c1..1a0fdcbf39fa 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 86a111d0f2fc..3151e97ca8ff 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index b9dc3752f702..9b8f495c9049 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 1faf04204c5d..67c947a47f14 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2017 Oracle.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_shared.h"
diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
index b40f71f878b5..8c3c67caf64e 100644
--- a/fs/xfs/libxfs/xfs_zones.c
+++ b/fs/xfs/libxfs/xfs_zones.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agb_bitmap.c b/fs/xfs/scrub/agb_bitmap.c
index 573e4e062754..0194e3aaa1fa 100644
--- a/fs/xfs/scrub/agb_bitmap.c
+++ b/fs/xfs/scrub/agb_bitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 303374df44bd..7ffe4b0ef0f1 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index cd6f0223879f..1c09948d841e 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 8b282138097f..48edaa2cb1e0 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index bed6a09aa791..d84777e23321 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd..eeb5ac34d742 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 09d63aa10314..1da1354f5e06 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 7ba35a7a7920..51f3171bc6c8 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 4f1e2574660d..d40534bf9ef9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 1084213b8e9b..1d1056d447e0 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index cd6f0ff382a7..8ba004979862 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7bfa37c99480..38d0b7d5c894 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index b2a83801412e..33749cf43520 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 056de4819f86..dd14f355358c 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c877bde71e62..1d98775b4b17 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 8d3b550990b5..d54206f674e2 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 3a9cdf8738b6..529dae105e57 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 5c04e70ba951..019feaf0d606 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 20c4daedd48d..10950e4bd4c3 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 84487072b6dd..2076f028d271 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index cebd0d526926..b35f65b537ba 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index f0d2b04644e4..783e409f8f3c 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 3c0f25098b69..2171bcf0f6c1 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4dc7c83dc08a..911dc0f9a79d 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 14e48d3f1912..bccf2e18d43e 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index bb3f475b6353..948d04dcba2a 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4f7040c9ddf0..bf182a18f115 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 84f117667ca2..2a974eed00cc 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 256ff7700c94..0863db64b1b2 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 378ec7c8d38e..3d9de59c1758 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 951ae8b71566..43e868f829aa 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 091c79e432e5..8bf0bff64b41 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 6ef2ee9c3814..9049215c6eae 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 4e550a1d5353..52a108f6d5f4 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 11d5de10fd56..36d505f3e40b 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 2949feda6271..512a546f8ce1 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5c5374c44c5a..1d25bd5b892e 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index b1d661aa5f06..487bd4f68ebb 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index d412a8359784..00e0c0e56d82 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 51be8d8d261b..dbb522e1513b 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index e1e52bc20713..c1a97a073d92 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 9a4ef823c5a7..367f8ccf55c4 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 01c9a2dc0f2c..c66ec9093a38 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 07f5bb8a6421..fff23932828b 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index d46528023015..bf87025f24fc 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 9c8cb5332da0..46546bf6eb13 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index efd5a7ccdf62..3ebe27524ce3 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index d189732d0e24..482f899a518a 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 39e9ad7cd8ae..2c25910e2903 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 17d4a38d735c..f27e3c8aa6d5 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d5ff8609dbfb..4bcfd99cec17 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 203a1a97c502..fd0d12db55f9 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 4c5dffc73641..8cfe2f120b6b 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 983362447826..a092934ed371 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 12989fe80e8b..8b1a8389d32f 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 7561941a337a..5af94e48d8cf 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 4ac679c1bd29..712f27f6266c 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index d593977d70df..afffbd6e0ad1 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3c3b0d25006f..670ac2baae0c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index f8a37ea97791..4efafc5ae966 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index c848bcc07cd5..91d40b9fb5c6 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index df629892462f..25416dfb5189 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index cf99e0ca51b0..8d754df72aa5 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 987313a52e64..70d353287993 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ed2e8c64b1a8..c7c4a71b6fa7 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
index 6ef2a9637f16..96fc360312de 100644
--- a/fs/xfs/scrub/xfblob.c
+++ b/fs/xfs/scrub/xfblob.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index c753c79df203..2998c9b62f4b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
deleted file mode 100644
index 3ec52f2ec4b2..000000000000
--- a/fs/xfs/xfs.h
+++ /dev/null
@@ -1,11 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_H__
-#define __XFS_H__
-
-#include "xfs_platform.h"
-
-#endif	/* __XFS_H__ */
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index c7c3dcfa2718..fdfca6fc75b6 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 56a544638491..043ab12a18ea 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2016-2025 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 319004bf089f..92331991f9fd 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ad2956f78eca..354472bf45f1 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -4,7 +4,7 @@
  * Author: Allison Henderson <allison.henderson@oracle.com>
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 379b48d015d2..114566b1ae5c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eafb..b87e7975b613 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2019 Christoph Hellwig.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 
 static inline unsigned int bio_max_vecs(unsigned int count)
 {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f38ed63fe86b..e8775f254c89 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2208a720ec3f..0ab00615f1ad 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 47edf3041631..db46883991de 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include <linux/backing-dev.h>
 #include <linux/dax.h>
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index cb2a36374ed4..8487635579e5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e4c8af873632..77ad071ebe78 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index dcbfa274e06d..0106da0a9f44 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_buf.h"
 #include "xfs_buf_mem.h"
diff --git a/fs/xfs/xfs_dahash_test.c b/fs/xfs/xfs_dahash_test.c
index 0dab5941e080..f1ee2643b948 100644
--- a/fs/xfs/xfs_dahash_test.c
+++ b/fs/xfs/xfs_dahash_test.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 06ac5a7de60a..60a80d4173f7 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index b6ffe4807a11..31477a74b523 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2010, 2023 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 612ca682a513..2b208e2c5264 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8bc7f43093a2..491e2a7053a3 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 89bc9bcaf51e..fe419b28de22 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index fa5f31931efd..1ad67f6c1fbf 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 39830b252ac8..873f2d1a134c 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_fs.h"
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 10d6fbeff651..13a42467370f 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 0b41bdfecdfb..5c083f29ea65 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de08..e3e3c3c89840 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2004-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index da3161572735..cfecb2959472 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2011 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3d1edc43e6fb..749a4eb9793c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7874cf745af3..d36a9aafa8ab 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 044918fbae06..44e1b14069a3 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2014 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index af68c7de8ee8..098c2b50bc6f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..b687c5fa34ac 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 566fd663c95b..60efe8246304 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_error.h"
 
 /*
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 5a3e3bf4e7cc..d1291ca15239 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2022-2024 Oracle.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 3c1557fb1cf0..12fa8f24da85 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_hooks.c b/fs/xfs/xfs_hooks.c
index a58d1de2d37d..a09109e692b1 100644
--- a/fs/xfs/xfs_hooks.c
+++ b/fs/xfs/xfs_hooks.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 23a920437fe4..dbaab4ae709f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 004dd22393dc..95b0eba242e9 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008-2010, 2013 Dave Chinner
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f1f88e48fe22..50c0404f9064 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -5,7 +5,7 @@
  */
 #include <linux/iversion.h>
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 81dfe70e173d..8913036b8024 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 9d1999d41be1..5d93228783eb 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 59eaad774371..54cef912e05f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b64785dc4354..c66e192448a8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -5,7 +5,7 @@
  */
 #include <linux/mount.h>
 #include <linux/fsmap.h>
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 04f39ea15898..2acccb7ed70b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2016-2018 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ad94fbf55014..165001c7423d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2aa37a4d2706..9faff287f747 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 1fd70a7aed63..a03a48eeb9a8 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2022, Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c1c31d1a8e21..ed4033006868 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 511756429336..b5f20b4a580c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index bc25012ac5c0..566976b8fef3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2010 Red Hat, Inc. All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 03e42c7dab56..94e8598056eb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 19aba2c3d525..16bdc38887ab 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_error.h"
 #include "xfs_shared.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0953f6ae94ab..4b0046483ca6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 73b7e72944e4..4e417747688f 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2006-2007 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_mru_cache.h"
 
 /*
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index b17672889942..a6a34dc2c028 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022 Fujitsu.  All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index afe7497012d4..221e55887a2a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2014 Christoph Hellwig.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index c283b801cc5d..7c79ab0db0e2 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 95be67ac6eb4..a3e7d4a107d4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index edc0aef3cf34..a094b8252ffd 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 022e2179c06b..d50b7318cb5c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -5,7 +5,7 @@
  */
 
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 94fbe3d99ec7..8804508cc2b8 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a41f5b577e22..881c3f3a6a24 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3f177b4ec131..db23a0f231d6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8bf04b101156..a39fe08dcd8f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e063f4f2f2e6..c9c704d97fdd 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 35c7fb3ba324..9781222e0653 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 
 struct xstats xfsstats;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..845abf437bf5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4252b07cd251..c4da624fb296 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012-2013 Red Hat, Inc.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 9918f14b4874..7f32d282dc88 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2001-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_error.h"
 
 static struct ctl_table_header *xfs_table_header;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7a5c5ef2db92..6c7909838234 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index a60556dbd172..478aebb60411 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2009, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..2c3c29d0d4a0 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 38983c6777df..363d7f88c2c6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2008 Dave Chinner
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 53af546c0b23..95db73a37e57 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c842ce06acd6..eaf9de6e07fd 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ac5cecec9aa1..a735f16d9cd8 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -4,7 +4,7 @@
  * Portions Copyright (C) 2000-2008 Silicon Graphics, Inc.
  */
 
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bbcf21704ea0..4ca7769b5adb 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 3c52cc1497d4..446d7cd1545c 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 07e30c596975..53eabbc3334c 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index fc1a4d1ce10c..5c6e6ef627e4 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
-- 
2.47.3

