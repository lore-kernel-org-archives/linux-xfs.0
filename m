Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1AE313E04
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764682656; cv=none; b=EPfrQSV2s0fLKyyX+zj3iL8QzRvj7j1RLuXcOq83j/2Qad/XfoJu297I3kLPMg2G/7XSozHaUV9KQllfPrDBQYY1DWGRi+waNL9SZ/SA4SSwgSfMyme8hieu1ntLcebfDA93FZBIgMUepAHARcSV0H+gnjqscC5gnmITIwNGP7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764682656; c=relaxed/simple;
	bh=1UIZVIUJeB4c3wo4Tb14aAfO0VbdU2ZRRZLMGYqZK4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9Uu+45u+u0LnURugCu+dPAkqWfYvPA2DkWdF1KRbAwU52VsPNBC5bnhmVSheW6kR51B+Ih05KggoQEFxMzui+b1+Rs/fTQB0OZ9uIwA07k7H4MAjLnXuq4F2Ss5XohqtjTg6PhaEhXP/K7X98kwN8+69plmUqQtJ6muYaS+0QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ps1OWM7J; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ps1OWM7J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+vbUsflSfa3htjloWIi+td9XPHuXfEFnOUxf7MipFpA=; b=Ps1OWM7JeBp8DC2bzAcunMRY99
	kAxCQ80R9GkzZeWC4AH4BMaCv0C5KSw7iPvDNWbEFG+nktsn3t8aeXic6NDXLrrv+dJVuOadb6nzO
	Zvh4onzcjgZAjgdrogDVawXjMB1KFRQmOx5gPokpdIg1M1XNZiyMXGtvcsv7OBeTjG491Z+nFnruJ
	OfKk6aI9GURlPtn7D6CiNk6uUIE7DlSPSeh3DGDotlfkwcZ2XgknPGWXR23emGX+xl5Rmy+YCzi/F
	kQUnEG8wMnDe0QA7d6fCgIa1vjE1pG9CKssgv5B3APpBdAHJXWrmeziUGFNawcEfZJXYWXzYLiva5
	SrEiXzqQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQQZO-00000005Ru9-1sX1;
	Tue, 02 Dec 2025 13:37:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: rename xfs.h to xfs_priv.h
Date: Tue,  2 Dec 2025 14:37:20 +0100
Message-ID: <20251202133723.1928059-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202133723.1928059-1-hch@lst.de>
References: <20251202133723.1928059-1-hch@lst.de>
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
include libxfs_priv.h in userspace.  Rename xfs.h to xfs_priv.h so
that we can apply the same rename (or a wrapper) to libxfs_priv.h in
xfsprogs and remove this major annoyance for the shared code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c               | 2 +-
 fs/xfs/libxfs/xfs_ag_resv.c          | 2 +-
 fs/xfs/libxfs/xfs_alloc.c            | 2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c      | 2 +-
 fs/xfs/libxfs/xfs_attr.c             | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.c      | 2 +-
 fs/xfs/libxfs/xfs_bit.c              | 2 +-
 fs/xfs/libxfs/xfs_bmap.c             | 2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       | 2 +-
 fs/xfs/libxfs/xfs_btree.c            | 2 +-
 fs/xfs/libxfs/xfs_btree_mem.c        | 2 +-
 fs/xfs/libxfs/xfs_btree_staging.c    | 2 +-
 fs/xfs/libxfs/xfs_da_btree.c         | 2 +-
 fs/xfs/libxfs/xfs_defer.c            | 2 +-
 fs/xfs/libxfs/xfs_dir2.c             | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c       | 2 +-
 fs/xfs/libxfs/xfs_dir2_data.c        | 2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c        | 2 +-
 fs/xfs/libxfs/xfs_dir2_node.c        | 2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c          | 2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c        | 2 +-
 fs/xfs/libxfs/xfs_exchmaps.c         | 2 +-
 fs/xfs/libxfs/xfs_group.c            | 2 +-
 fs/xfs/libxfs/xfs_ialloc.c           | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     | 2 +-
 fs/xfs/libxfs/xfs_iext_tree.c        | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c        | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_util.c       | 2 +-
 fs/xfs/libxfs/xfs_log_rlimit.c       | 2 +-
 fs/xfs/libxfs/xfs_metadir.c          | 2 +-
 fs/xfs/libxfs/xfs_metafile.c         | 2 +-
 fs/xfs/libxfs/xfs_parent.c           | 2 +-
 fs/xfs/libxfs/xfs_refcount.c         | 2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c   | 2 +-
 fs/xfs/libxfs/xfs_rmap.c             | 2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c       | 2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c         | 2 +-
 fs/xfs/libxfs/xfs_rtgroup.c          | 2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 2 +-
 fs/xfs/libxfs/xfs_sb.c               | 2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c   | 2 +-
 fs/xfs/libxfs/xfs_trans_inode.c      | 2 +-
 fs/xfs/libxfs/xfs_trans_resv.c       | 2 +-
 fs/xfs/libxfs/xfs_trans_space.c      | 2 +-
 fs/xfs/libxfs/xfs_types.c            | 2 +-
 fs/xfs/libxfs/xfs_zones.c            | 2 +-
 fs/xfs/scrub/agb_bitmap.c            | 2 +-
 fs/xfs/scrub/agheader.c              | 2 +-
 fs/xfs/scrub/agheader_repair.c       | 2 +-
 fs/xfs/scrub/alloc.c                 | 2 +-
 fs/xfs/scrub/alloc_repair.c          | 2 +-
 fs/xfs/scrub/attr.c                  | 2 +-
 fs/xfs/scrub/attr_repair.c           | 2 +-
 fs/xfs/scrub/bitmap.c                | 2 +-
 fs/xfs/scrub/bmap.c                  | 2 +-
 fs/xfs/scrub/bmap_repair.c           | 2 +-
 fs/xfs/scrub/btree.c                 | 2 +-
 fs/xfs/scrub/common.c                | 2 +-
 fs/xfs/scrub/cow_repair.c            | 2 +-
 fs/xfs/scrub/dabtree.c               | 2 +-
 fs/xfs/scrub/dir.c                   | 2 +-
 fs/xfs/scrub/dir_repair.c            | 2 +-
 fs/xfs/scrub/dirtree.c               | 2 +-
 fs/xfs/scrub/dirtree_repair.c        | 2 +-
 fs/xfs/scrub/dqiterate.c             | 2 +-
 fs/xfs/scrub/findparent.c            | 2 +-
 fs/xfs/scrub/fscounters.c            | 2 +-
 fs/xfs/scrub/fscounters_repair.c     | 2 +-
 fs/xfs/scrub/health.c                | 2 +-
 fs/xfs/scrub/ialloc.c                | 2 +-
 fs/xfs/scrub/ialloc_repair.c         | 2 +-
 fs/xfs/scrub/inode.c                 | 2 +-
 fs/xfs/scrub/inode_repair.c          | 2 +-
 fs/xfs/scrub/iscan.c                 | 2 +-
 fs/xfs/scrub/listxattr.c             | 2 +-
 fs/xfs/scrub/metapath.c              | 2 +-
 fs/xfs/scrub/newbt.c                 | 2 +-
 fs/xfs/scrub/nlinks.c                | 2 +-
 fs/xfs/scrub/nlinks_repair.c         | 2 +-
 fs/xfs/scrub/orphanage.c             | 2 +-
 fs/xfs/scrub/parent.c                | 2 +-
 fs/xfs/scrub/parent_repair.c         | 2 +-
 fs/xfs/scrub/quota.c                 | 2 +-
 fs/xfs/scrub/quota_repair.c          | 2 +-
 fs/xfs/scrub/quotacheck.c            | 2 +-
 fs/xfs/scrub/quotacheck_repair.c     | 2 +-
 fs/xfs/scrub/rcbag.c                 | 2 +-
 fs/xfs/scrub/rcbag_btree.c           | 2 +-
 fs/xfs/scrub/readdir.c               | 2 +-
 fs/xfs/scrub/reap.c                  | 2 +-
 fs/xfs/scrub/refcount.c              | 2 +-
 fs/xfs/scrub/refcount_repair.c       | 2 +-
 fs/xfs/scrub/repair.c                | 2 +-
 fs/xfs/scrub/rgsuper.c               | 2 +-
 fs/xfs/scrub/rmap.c                  | 2 +-
 fs/xfs/scrub/rmap_repair.c           | 2 +-
 fs/xfs/scrub/rtbitmap.c              | 2 +-
 fs/xfs/scrub/rtbitmap_repair.c       | 2 +-
 fs/xfs/scrub/rtrefcount.c            | 2 +-
 fs/xfs/scrub/rtrefcount_repair.c     | 2 +-
 fs/xfs/scrub/rtrmap.c                | 2 +-
 fs/xfs/scrub/rtrmap_repair.c         | 2 +-
 fs/xfs/scrub/rtsummary.c             | 2 +-
 fs/xfs/scrub/rtsummary_repair.c      | 2 +-
 fs/xfs/scrub/scrub.c                 | 2 +-
 fs/xfs/scrub/stats.c                 | 2 +-
 fs/xfs/scrub/symlink.c               | 2 +-
 fs/xfs/scrub/symlink_repair.c        | 2 +-
 fs/xfs/scrub/tempfile.c              | 2 +-
 fs/xfs/scrub/trace.c                 | 2 +-
 fs/xfs/scrub/xfarray.c               | 2 +-
 fs/xfs/scrub/xfblob.c                | 2 +-
 fs/xfs/scrub/xfile.c                 | 2 +-
 fs/xfs/xfs_acl.c                     | 2 +-
 fs/xfs/xfs_aops.c                    | 2 +-
 fs/xfs/xfs_attr_inactive.c           | 2 +-
 fs/xfs/xfs_attr_item.c               | 2 +-
 fs/xfs/xfs_attr_list.c               | 2 +-
 fs/xfs/xfs_bio_io.c                  | 2 +-
 fs/xfs/xfs_bmap_item.c               | 2 +-
 fs/xfs/xfs_bmap_util.c               | 2 +-
 fs/xfs/xfs_buf.c                     | 2 +-
 fs/xfs/xfs_buf_item.c                | 2 +-
 fs/xfs/xfs_buf_item_recover.c        | 2 +-
 fs/xfs/xfs_buf_mem.c                 | 2 +-
 fs/xfs/xfs_dahash_test.c             | 2 +-
 fs/xfs/xfs_dir2_readdir.c            | 2 +-
 fs/xfs/xfs_discard.c                 | 2 +-
 fs/xfs/xfs_dquot.c                   | 2 +-
 fs/xfs/xfs_dquot_item.c              | 2 +-
 fs/xfs/xfs_dquot_item_recover.c      | 2 +-
 fs/xfs/xfs_drain.c                   | 2 +-
 fs/xfs/xfs_error.c                   | 2 +-
 fs/xfs/xfs_exchmaps_item.c           | 2 +-
 fs/xfs/xfs_exchrange.c               | 2 +-
 fs/xfs/xfs_export.c                  | 2 +-
 fs/xfs/xfs_extent_busy.c             | 2 +-
 fs/xfs/xfs_extfree_item.c            | 2 +-
 fs/xfs/xfs_file.c                    | 2 +-
 fs/xfs/xfs_filestream.c              | 2 +-
 fs/xfs/xfs_fsmap.c                   | 2 +-
 fs/xfs/xfs_fsops.c                   | 2 +-
 fs/xfs/xfs_globals.c                 | 2 +-
 fs/xfs/xfs_handle.c                  | 2 +-
 fs/xfs/xfs_health.c                  | 2 +-
 fs/xfs/xfs_hooks.c                   | 2 +-
 fs/xfs/xfs_icache.c                  | 2 +-
 fs/xfs/xfs_icreate_item.c            | 2 +-
 fs/xfs/xfs_inode.c                   | 2 +-
 fs/xfs/xfs_inode_item.c              | 2 +-
 fs/xfs/xfs_inode_item_recover.c      | 2 +-
 fs/xfs/xfs_ioctl.c                   | 2 +-
 fs/xfs/xfs_ioctl32.c                 | 2 +-
 fs/xfs/xfs_iomap.c                   | 2 +-
 fs/xfs/xfs_iops.c                    | 2 +-
 fs/xfs/xfs_itable.c                  | 2 +-
 fs/xfs/xfs_iunlink_item.c            | 2 +-
 fs/xfs/xfs_iwalk.c                   | 2 +-
 fs/xfs/xfs_log.c                     | 2 +-
 fs/xfs/xfs_log_cil.c                 | 2 +-
 fs/xfs/xfs_log_recover.c             | 2 +-
 fs/xfs/xfs_message.c                 | 2 +-
 fs/xfs/xfs_mount.c                   | 2 +-
 fs/xfs/xfs_mru_cache.c               | 2 +-
 fs/xfs/xfs_notify_failure.c          | 2 +-
 fs/xfs/xfs_pnfs.c                    | 2 +-
 fs/xfs/{xfs.h => xfs_priv.h}         | 2 +-
 fs/xfs/xfs_pwork.c                   | 2 +-
 fs/xfs/xfs_qm.c                      | 2 +-
 fs/xfs/xfs_qm_bhv.c                  | 2 +-
 fs/xfs/xfs_qm_syscalls.c             | 2 +-
 fs/xfs/xfs_quotaops.c                | 2 +-
 fs/xfs/xfs_refcount_item.c           | 2 +-
 fs/xfs/xfs_reflink.c                 | 2 +-
 fs/xfs/xfs_rmap_item.c               | 2 +-
 fs/xfs/xfs_rtalloc.c                 | 2 +-
 fs/xfs/xfs_stats.c                   | 2 +-
 fs/xfs/xfs_super.c                   | 2 +-
 fs/xfs/xfs_symlink.c                 | 2 +-
 fs/xfs/xfs_sysctl.c                  | 2 +-
 fs/xfs/xfs_sysfs.c                   | 2 +-
 fs/xfs/xfs_trace.c                   | 2 +-
 fs/xfs/xfs_trans.c                   | 2 +-
 fs/xfs/xfs_trans_ail.c               | 2 +-
 fs/xfs/xfs_trans_buf.c               | 2 +-
 fs/xfs/xfs_trans_dquot.c             | 2 +-
 fs/xfs/xfs_xattr.c                   | 2 +-
 fs/xfs/xfs_zone_alloc.c              | 2 +-
 fs/xfs/xfs_zone_gc.c                 | 2 +-
 fs/xfs/xfs_zone_info.c               | 2 +-
 fs/xfs/xfs_zone_space_resv.c         | 2 +-
 194 files changed, 194 insertions(+), 194 deletions(-)
 rename fs/xfs/{xfs.h => xfs_priv.h} (93%)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..e43a710300f4 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -5,7 +5,7 @@
  * All rights reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 8ac8230c3d3c..21f7c7e1bbd6 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad381c73abc4..b83965e3acb5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index fa1f03c1331e..de1c2ec5c5ae 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d48..a5138dcaaadd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 91c1b30ebaab..5710dd2e62ed 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index bff3dc226f81..907239f78979 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 40ce5f3094d1..15cfd421db14 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_log_format.h"
 #include "xfs_bit.h"
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 53ef4b7e504d..002343f0af99 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 188feac04b60..8aa965035e47 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index dbe9df8c3300..541ff7171978 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index f2f7b4305413..ce70582435ae 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 5ed84f9cc877..27c0c88487eb 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2020 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 90f7fc219fcc..a57b97a7a7e0 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5b377cbbb1f7..183604675a77 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 82a338458a51..f3762bf6d94a 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f93ed1a4a74..6fbbd6eac8b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index a16b05c43e2e..324c7f4841f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 71c2f22a3f6e..089db5d4c944 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index fe8d4fa13128..dcbdfdf6f780 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 17a20384c8b7..a0beaca01db0 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index dceef2abd4e2..169d09fe9086 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 932ee4619e9e..1b04e200efd0 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 792f76d2e2a0..5763474cc740 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018 Red Hat, Inc.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d97295eaebe6..62ccf40025c8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 100afdd66cdd..475f57c2cd2b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 8796f2b3e534..3e160ca52e38 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2017 Christoph Hellwig.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b1812b2c3cce..ac97b767db43 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1772d82f2d68..766d739a4198 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 309ce6dd5553..23df0253a427 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 34bba96d30ca..f7ea32d5dd6d 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2013 Jie Liu.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 178e89711cb7..a38d072ccaa0 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index b02e3d6c0868..ef680c9bdddd 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 69366c44a701..2a857aed8be3 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2484dc9f6d7e..016cece8ca8b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 06da3ca14727..4709361fcaa7 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 83e0488ff773..48c26516b06b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index bf16aee50d73..a0bc7b14d24a 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 618061d898d4..b0816d2c4428 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9186c58e83d5..0234c100d12c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ac11e94b42ae..a6560654727a 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 55f903165769..cc4d4b1a63f6 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cdd16dd805d7..f66385a659d1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index fb47a76ead18..e1c979bde639 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012-2013 Red Hat, Inc.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index c962ad64b0c1..7fc95bcd80a2 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 86a111d0f2fc..77f9a0f8e1e0 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index b9dc3752f702..557acbdd847b 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 1faf04204c5d..e0fcfd0f6a7b 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2017 Oracle.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_shared.h"
diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
index b0791a71931c..c8b59b390666 100644
--- a/fs/xfs/libxfs/xfs_zones.c
+++ b/fs/xfs/libxfs/xfs_zones.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agb_bitmap.c b/fs/xfs/scrub/agb_bitmap.c
index 573e4e062754..f9269799e4a9 100644
--- a/fs/xfs/scrub/agb_bitmap.c
+++ b/fs/xfs/scrub/agb_bitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 303374df44bd..817e02bb632c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index cd6f0223879f..a31cd584703d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 8b282138097f..e783a76bf287 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index bed6a09aa791..1b7c01e830e2 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd..49b4655cf636 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7eb94069caf..9db34ad3e2bf 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 7ba35a7a7920..c6cabc70f92c 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 4f1e2574660d..9142eb11d1bf 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 1084213b8e9b..3226327e2286 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index cd6f0ff382a7..a570713e45ed 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2ef7742be7d3..8d58daf641aa 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index b2a83801412e..4a6557a4a13d 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 056de4819f86..b8d3ee25dee0 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c877bde71e62..19e8ca86d6e8 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 8d3b550990b5..6da7d2a0947d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 3a9cdf8738b6..4d3c33d06ea1 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 5c04e70ba951..67e39e7d0aa8 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 20c4daedd48d..f58f482e8e3b 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 84487072b6dd..9e9d3187abb7 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index cebd0d526926..cb52013af7d0 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index f0d2b04644e4..e14469cc4260 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 3c0f25098b69..6c5f9611c3f8 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4dc7c83dc08a..95bd908a3f77 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 14e48d3f1912..412a91b19f36 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index bb3f475b6353..ee09893135a3 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a90a011c7e5f..55df5fba6b92 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 84f117667ca2..df2855640e68 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 256ff7700c94..57ce358f97d9 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 378ec7c8d38e..7a1f8b1ffbc9 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 951ae8b71566..c938315f5991 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 091c79e432e5..98b7e8164abb 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 6ef2ee9c3814..c37409c08979 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 9c12cb844231..7124e5302c15 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 3b692c4acc1e..852c242754a4 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 2949feda6271..e665acdb11ea 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 58d6d4ed2853..923ada0a1692 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 8f4c8d41f308..672e6fc08cbe 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index e4105aaafe84..4dbcb756f717 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index dd8554c755b5..0f349128a8d1 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index e1e52bc20713..c5e42fbf65f0 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 9a4ef823c5a7..c369e76d6128 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 01c9a2dc0f2c..05d51ca6218b 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 07f5bb8a6421..eabe4b5bae54 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index d46528023015..ff100c1230ad 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 9c8cb5332da0..56b8529e7382 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index efd5a7ccdf62..72f1fb574299 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index d189732d0e24..1e8f312ee537 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 39e9ad7cd8ae..a0bdc7ba7d0e 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 17d4a38d735c..041bf461c6af 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d5ff8609dbfb..bcbd1016debf 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 203a1a97c502..f39ebcba2316 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 4c5dffc73641..a658395b168e 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 983362447826..6b871571438d 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 12989fe80e8b..4826612d7beb 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 7561941a337a..14ba29f4407f 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 4ac679c1bd29..e237246c3f52 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index d593977d70df..f4fd59c63c1b 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3c3b0d25006f..9d0529fa91ef 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index f8a37ea97791..629b185e1a97 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index c848bcc07cd5..4b1f5858c009 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index df629892462f..2e519fb7c0b0 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index cf99e0ca51b0..fbb04beb4c67 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 987313a52e64..41de3003c6cc 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index cdd13ed9c569..b69a778171b0 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
index 6ef2a9637f16..4d23d6abd336 100644
--- a/fs/xfs/scrub/xfblob.c
+++ b/fs/xfs/scrub/xfblob.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index c753c79df203..efcf812b1ecd 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index c7c3dcfa2718..a21c8da689d5 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a26f79815533..38384e23826b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2016-2025 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 319004bf089f..37945c6b59bb 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c3a593319bee..caf43afdacb2 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -4,7 +4,7 @@
  * Author: Allison Henderson <allison.henderson@oracle.com>
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 379b48d015d2..682ee478b7ce 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eafb..36adbe38c56b 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2019 Christoph Hellwig.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 
 static inline unsigned int bio_max_vecs(unsigned int count)
 {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 80f0c4bcc483..60aee07a4f11 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e43..ed5b08c6197d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 47edf3041631..b948f735e7e8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include <linux/backing-dev.h>
 #include <linux/dax.h>
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8d85b5eee444..e3ec23bfd326 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e4c8af873632..a917810b1706 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index dcbfa274e06d..c47f6af37098 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_buf.h"
 #include "xfs_buf_mem.h"
diff --git a/fs/xfs/xfs_dahash_test.c b/fs/xfs/xfs_dahash_test.c
index 0dab5941e080..e1f49c5aaa6e 100644
--- a/fs/xfs/xfs_dahash_test.c
+++ b/fs/xfs/xfs_dahash_test.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 06ac5a7de60a..d1a51b55f148 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6917de832191..c7322e0461fa 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2010, 2023 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 0bd8022e47b4..d263caa54f2a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 271b195ebb93..55b82b942736 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 89bc9bcaf51e..0efc7c7627ef 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index fa5f31931efd..9480a7a5beaf 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 39830b252ac8..90f55e3fbe7a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_fs.h"
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 229cbe0adf17..58ab69b1b8ee 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 0b41bdfecdfb..e5e34bb4de13 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de08..89d57a7393f3 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2004-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index da3161572735..4fc429f4b8c8 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2011 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 418ddab590e0..6a2dea90ec70 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2702fef2c90c..5b53e81bb0fe 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 044918fbae06..e6f67552c322 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2014 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index af68c7de8ee8..0ff25aa76b96 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..34efd004c422 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 566fd663c95b..96c483de90ab 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_error.h"
 
 /*
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index f19fce557354..32ebcb13737f 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2022-2024 Oracle.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 7c541fb373d5..1ce301633351 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_hooks.c b/fs/xfs/xfs_hooks.c
index a58d1de2d37d..2c4b8f566702 100644
--- a/fs/xfs/xfs_hooks.c
+++ b/fs/xfs/xfs_hooks.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..ee4248a8d516 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index f83ec2bd0583..2ef8d045fdd5 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008-2010, 2013 Dave Chinner
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36b39539e561..1328b34ca325 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -5,7 +5,7 @@
  */
 #include <linux/iversion.h>
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1bd411a1114c..0e14a01016d8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 9d1999d41be1..0898f50ccbff 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a6bb7ee7a27a..9c4689af3c1b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b64785dc4354..edd444548ccd 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -5,7 +5,7 @@
  */
 #include <linux/mount.h>
 #include <linux/fsmap.h>
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 490e12cb99be..75c80095dcbf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2016-2018 Christoph Hellwig.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index caff0125faea..dbcecf9d02b5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2aa37a4d2706..f608c2b728af 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 1fd70a7aed63..dd477b13030a 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2022, Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c1c31d1a8e21..0591eb3d80ae 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4c..5a1d0884c24e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f443757e93c2..dcd200f7e6df 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2010 Red Hat, Inc. All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 549d60959aee..a206c22a2daa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 19aba2c3d525..b74525b1d5d9 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_error.h"
 #include "xfs_shared.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0953f6ae94ab..780b5124dcf8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 73b7e72944e4..364445f901a6 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2006-2007 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_mru_cache.h"
 
 /*
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index b17672889942..cd690cb6ba6a 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022 Fujitsu.  All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index afe7497012d4..ef469e8002d6 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2014 Christoph Hellwig.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs_priv.h
similarity index 93%
rename from fs/xfs/xfs.h
rename to fs/xfs/xfs_priv.h
index 9355ccad9503..d49c987f51f7 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs_priv.h
@@ -25,4 +25,4 @@
 
 #include "xfs_linux.h"
 
-#endif	/* __XFS_H__ */
+#endif	/* __XFS_PRIV_H__ */
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index c283b801cc5d..dca1cb4f4a98 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 23ba84ec919a..fb647181c7dd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 245d754f382a..50c00e9133bc 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 0c78f30fa4a3..d6df2d5b1b9e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -5,7 +5,7 @@
  */
 
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 4c7f7ce4fd2f..6590c66798fe 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2008, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3728234699a2..964c78daeb1b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3f177b4ec131..7079a2400eae 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 15f0903f6fd4..bb8c7d66a2c1 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..a27c03cbbb7e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 35c7fb3ba324..e28ede1e7a09 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 
 struct xstats xfsstats;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..1d35f6a15dcc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4252b07cd251..4ee22ba2ebe3 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012-2013 Red Hat, Inc.
  * All rights reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 9918f14b4874..11e434897ded 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2001-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_error.h"
 
 static struct ctl_table_header *xfs_table_header;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7a5c5ef2db92..8a7fe65a1d74 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index a60556dbd172..7c9b82d2b009 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2009, Christoph Hellwig
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..93d5435a8650 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 38983c6777df..ffa7b4f1e2a4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2008 Dave Chinner
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 53af546c0b23..7b828fd7d489 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 765456bf3428..0ae95e6ba425 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ac5cecec9aa1..965a65aabce3 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -4,7 +4,7 @@
  * Portions Copyright (C) 2000-2008 Silicon Graphics, Inc.
  */
 
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index ef7a931ebde5..9d1f3b9fd737 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 4ade54445532..9179dcef3426 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 07e30c596975..42985775fae3 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 9cd38716fd25..81ebb4969622 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "xfs.h"
+#include "xfs_priv.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
-- 
2.47.3

