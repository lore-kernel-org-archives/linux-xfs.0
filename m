Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7820ED
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111816; cv=none; b=qNLgx1+8/YhjcQLDoFazIsxeU3AYhPns7N+DWo28ws2a29nlyYFGUMkeKRapMavh1inABiZDCsjsyvQXB8/66MuOrs23Qz5Hsst2l1cDQqPzk8GflgWSc1rgB7WoA7966/7qkJOcYptlESWJItSXIQwylRJB0nI6onCp0Txz7Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111816; c=relaxed/simple;
	bh=fyQQBIwDEgrIRGJYi0pZhGJL7DzZm4SE+OE9aZU88XY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p0OYo/P2TUkoXR/zWu7FO+DdgK4Hu+2WbCfIGLAhcWFnd3lxPvhuba9iTZLWHOC+7U1P8+IkEFZW6cFSM08/2x+yzPEw7ESBgKV+sjmRT7i/DoHoEgfs7TbeNsEQtfAhsD11qccBH7L1XlwXTWecOqSx8ZbQTPJojuJMqrk97rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p0KC+Nnj; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p0KC+Nnj"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cbee846deecso956010a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 00:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789111813; x=1789716613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2pBSvjGgqV/0n+gAuiTM+1gkiLcJjrUJllRVhmlIYy4=;
        b=p0KC+NnjGHq/STcKxMb1814fvfns4kKNyCHaWLhoa88YRSfS10+BI9BumWd4dDpNZb
         S4pPYY+dS/4SJhB98NkAHSw8/Fyxdk6tRTQ7BK7D1djCmHJzGvcsrYnE47h15SHvmSPR
         gv6YPgd/D3PlPdwzbnVJFdJTna7aevTAZdX9XH8obx+IKo72RKfyDe1sjfgg7kuL83rn
         a279O3oYB/rSHFma2KsnYm1xDXy8JICQXVdEo0NUCjyeymTqnNK+gmCdLfYARdU9RBBo
         OITN7CbYbMBrrSgocahlDW3SFenXpdwoGy7d75GV/TeBnmme5Se8t4aF1k7PtRfNbFgo
         zkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789111813; x=1789716613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2pBSvjGgqV/0n+gAuiTM+1gkiLcJjrUJllRVhmlIYy4=;
        b=AbH+g3Je6OzZvPawsOKBiw6y5ANhPGIEPTOVFrV5X2juX8GAoAkIn1Z1dclLvsavF+
         u/RXE7aG5uGB/rT0v/VLs9ubx3Iny7pgYZHONQwyEasL4sp3fOaxA1aVx8Us4FCTYcT1
         SbDOUKuGErNitrC5nSfcpQ38U2XO/4nFoPMtL3ke+9IToHJPaxACW4qZLihCq1caQeVE
         PJUjf1AX0uMAPfENeDWyTH3v/QMrNHoDuwFYOVmLPQGrAOwR3qSAf3G749lbmYwlnxi/
         3Hx5sL11NZ5/t+MZbwkUaX97g8Wv1oavogKBbrP7YhbXtBNTHZkhamdhRYt+ke/o+o9R
         ZRog==
X-Forwarded-Encrypted: i=1; AKwUvBygKnTewBLm7J2iVufkGaI6433WlqT4O6avIe/xwHF5fehCrUW475sTa6+bZm7gLlSNzKJSG6ov1EU=@vger.kernel.org
X-Gm-Message-State: AFuF++l+qsS8/pP+V2nfJErxmjEgWcz4sssaWduqpDuwBmCt753aIvLw
	RQa4/dtkGSln6AJL27U7wlCWpzhsoqa0CfjGnlzDLs7EXoSTxR+9ehlU
X-Gm-Gg: AYBFou2vaWANPkisWI2FbC09CxCeWFta22qYVcrUtBSxVKvZo//0SxM0DYVZe0pfzK0
	RxiHJT5aTSRzEv4bXGBMhYfZ/z7sCHBLM/BzLxfgs7SGLH9mu6qmv0ZGcm5/x1mfbLldVaYZR9F
	LawUdiucYtbQh//oM0PDQXCH5QQgMlFVbEQEIkfWWN9CnqPAza+G6kYPymEzR44v3VG/LVmyFIf
	ljLBd3srkz4UxPYgR4ciie3xDMC0D513dqxCMkH7jwAciUotXeVHM7N+xNOOJyZWmz42+jz2yMg
	CJJ2SPVLXkXFraxt1H/VDnNwwwL9zZlephe90nY6rTdbXbl8Zrqam0MFJK8y8sUJQfiV/1TwZ9+
	1inzUrQ+N+ZI27A/OfsHhhywdqXoyegLU9EA4SY+XbGYQ+CQwz2DpMn8ByM4R/EX74WGxkNQ5fB
	N2loQo5sZzmjZlsdJ1fDtMkdKeDabFCWutx6BsvgbKqnitRFt3Aya7M2BPDwRX0LiTEVsC/xfq+
	4w2TXjs+j9h0JPUrQthcT+IhQ==
X-Received: by 2002:a05:6a20:c70b:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3daed6813c8mr5461874637.17.1789111813029;
        Fri, 11 Sep 2026 00:30:13 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33baf0ea9a1sm846373eec.8.2026.09.11.00.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 00:30:12 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] xfs: fix typos and repeated words in comments
Date: Fri, 11 Sep 2026 13:00:07 +0530
Message-ID: <20260911073007.22530-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct ten misspellings and eight accidentally doubled words in
comments.  No code changes.

The doubled word in xfs_zone_alloc.c was not a duplicate: "so that is is
reused" is "it is" misspelt, so that one reads "so that it is reused"
rather than dropping a word.

Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
v3: dropped the Assisted-by trailer, as Carlos asked.  No change to the
    patch itself; the diff is byte for byte the v2 one.

v2:
 - fold the two patches into one, as Carlos and Darrick asked
 - xfs_zone_alloc.c: "so that it is reused"; v1 dropped the second "is",
   which left the sentence with no subject
 - Darrick's Reviewed-by was given on v1; the xfs_zone_alloc.c hunk
   changed after that review, so please re-check that one line

v2: https://lore.kernel.org/all/20260910045550.54432-1-hemanth.selam@gmail.com/
v1: https://lore.kernel.org/all/20260904112909.8197-1-hemanth.selam@gmail.com/

 fs/xfs/libxfs/xfs_ag.h         | 2 +-
 fs/xfs/libxfs/xfs_alloc.c      | 4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c  | 2 +-
 fs/xfs/libxfs/xfs_errortag.h   | 2 +-
 fs/xfs/libxfs/xfs_exchmaps.c   | 2 +-
 fs/xfs/libxfs/xfs_format.h     | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/scrub/agheader_repair.c | 2 +-
 fs/xfs/scrub/alloc_repair.c    | 2 +-
 fs/xfs/scrub/dirtree.c         | 2 +-
 fs/xfs/scrub/reap.c            | 2 +-
 fs/xfs/xfs_bmap_item.c         | 2 +-
 fs/xfs/xfs_inode.c             | 2 +-
 fs/xfs/xfs_log_cil.c           | 2 +-
 fs/xfs/xfs_platform.h          | 2 +-
 fs/xfs/xfs_zone_alloc.c        | 2 +-
 fs/xfs/xfs_zone_gc.c           | 2 +-
 17 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index fd22fe598931..ee636b66a72f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -207,7 +207,7 @@ xfs_perag_next(
 }
 
 /*
- * Per-ag geometry infomation and validation
+ * Per-ag geometry information and validation
  */
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d99602bcc16f..f762dcce8d13 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3487,7 +3487,7 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Pre-proces allocation arguments to set initial state that we don't require
+ * Pre-process allocation arguments to set initial state that we don't require
  * callers to set up correctly, as well as bounds check the allocation args
  * that are set up.
  */
@@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
 	 * ABBA AGF deadlocks because a future allocation attempt in this
 	 * transaction may attempt to lock a lower number AGF.
 	 *
-	 * We can't release the AGF until the transaction is commited, so at
+	 * We can't release the AGF until the transaction is committed, so at
 	 * this point we must update the "first allocation" tracker to point at
 	 * this AG if the tracker is empty or points to a lower AG. This allows
 	 * the next allocation attempt to be modified appropriately to avoid
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b6288395f853..2c80f4fd0b78 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1715,7 +1715,7 @@ xfs_attr3_leaf_add_work(
 			/*
 			 * This freemap entry starts at the old end of the
 			 * leaf entry array, so we need to adjust its base
-			 * upward to accomodate the larger array.
+			 * upward to accommodate the larger array.
 			 */
 			diff = sizeof(struct xfs_attr_leaf_entry);
 		} else if (ichdr->freemap[i].size > 0 &&
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6de207fed2d8..f0c83f1f0b3b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -83,7 +83,7 @@
 #define XFS_RANDOM_DEFAULT				100
 
 /*
- * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
+ * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
  *   1. The XFS_ERRTAG_ flag but without the prefix;
  *   2. The name of the sysfs knob; and
  *   3. The default value for the knob.
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 3efed37cb98a..6a66b6075e0a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -395,7 +395,7 @@ xfs_exchmaps_one_step(
 	/*
 	 * Re-add both mappings.  We exchange the file offsets between the two
 	 * maps and add the opposite map, which has the effect of filling the
-	 * logical offsets we just unmapped, but with with the physical mapping
+	 * logical offsets we just unmapped, but with the physical mapping
 	 * information exchanged.
 	 */
 	swap(irec1->br_startoff, irec2->br_startoff);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd0ed046fbe9..1a7a7e60a170 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
  * block is 1KB in size.
  *
  * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
- * with 1KB sized blocks, a file can reach upto,
+ * with 1KB sized blocks, a file can reach up to,
  * 1KB * (2^31) = 2TB
  *
  * This is much larger than the theoretical maximum size of a directory
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e4c3f7b24e95..0340e2189921 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -626,7 +626,7 @@ xfs_dinode_verify(
 	 * have di_nlink track the link count, even if the actual filesystem
 	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
 	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
-	 * the the incore di_nlink value, which is why we cannot check for
+	 * the incore di_nlink value, which is why we cannot check for
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2104512f1ee1..493efa2b2f0d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1352,7 +1352,7 @@ xrep_iunlink_mark_ondisk(
 
 /*
  * Walk an iunlink bucket's inode list.  For each inode that should be on this
- * chain, clear its entry in in iunlink_bmp because it's ok and we don't need
+ * chain, clear its entry in iunlink_bmp because it's ok and we don't need
  * to touch it further.
  */
 STATIC int
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index dce6ab0429dc..84ae88ca027a 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -338,7 +338,7 @@ xrep_cntbt_extent_cmp(
 }
 
 /*
- * Sort the free extents by length so so that we can put the records into the
+ * Sort the free extents by length so that we can put the records into the
  * cntbt in the correct order.  Don't let userspace kill us if we're resorting
  * after allocating btree blocks.
  */
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index b2cf6e5439d9..469ba30670f0 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -994,7 +994,7 @@ xchk_dirtree(
 	return error;
 }
 
-/* Does the directory targetted by this scrub have no parents? */
+/* Does the directory targeted by this scrub have no parents? */
 bool
 xchk_dirtree_parentless(const struct xchk_dirtree *dl)
 {
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index fcd14c1703ea..d1f4b7159af2 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -172,7 +172,7 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
 }
 
 /*
- * Decide if we need to roll the transaction to clear out the the log
+ * Decide if we need to roll the transaction to clear out the log
  * reservation that we allocated to buffer invalidations.
  */
 static inline bool xreap_want_binval_roll(const struct xreap_state *rs)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 89f6e79a955f..aa5b41629747 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -339,7 +339,7 @@ xfs_bmap_update_get_group(
 
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
-	 * intent items that that we can queue when we finish this bmap work.
+	 * intent items that we can queue when we finish this bmap work.
 	 * This new intent item will bump the intent count before the bmap
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 030a7c8f2c12..621513d7215e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,7 +2669,7 @@ xfs_irele(
 }
 
 /*
- * Ensure all commited transactions touching the inode are written to the log.
+ * Ensure all committed transactions touching the inode are written to the log.
  */
 int
 xfs_log_force_inode(
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 639f875a8fb2..defd121690f5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
  * allocation context. However, we do not want to block on memory reclaim
  * recursing back into the filesystem because this push may have been triggered
  * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
- * contraints here.
+ * constraints here.
  */
 static void
 xlog_cil_push_work(
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 5d542e95fe44..745d715b4c64 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -153,7 +153,7 @@ static inline void delay(long ticks)
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
- * the XFS sysfs object heirarchy. Define it here for broad access throughout
+ * the XFS sysfs object hierarchy. Define it here for broad access throughout
  * the codebase.
  */
 struct xfs_kobj {
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bdbb60cc5d5b..b8230b5bf4e3 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -826,7 +826,7 @@ xfs_get_cached_zone(
 }
 
 /*
- * Stash our zone in the inode so that is is reused for future allocations.
+ * Stash our zone in the inode so that it is reused for future allocations.
  *
  * The open_zone structure will be pinned until either the inode is freed or
  * until the cached open zone is replaced with a different one because the
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 5fdcf98a2133..54b70ed2922f 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -46,7 +46,7 @@
  * before remapping.
  *
  * Once a zone does not contain any valid data, be that through GC or user
- * block removal, it is queued for for a zone reset.  The reset operation
+ * block removal, it is queued for a zone reset.  The reset operation
  * carefully ensures that the RT device cache is flushed and all transactions
  * referencing the rmap have been committed to disk.
  */
-- 
2.48.1

