Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76A2F7EE7;
	Wed, 15 Jul 2026 06:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784096533; cv=none; b=dDzbDOgXUKVKOaV4ipmhHSvRD8wi0sHhDIWHfliOstRsT2UHXl+TzfY+N7JsCjMEWXo7qdsb29Fz0Rk6lPLe8wO73WIBsmNiT+y6LbCGXrohzZDb3JcnP6k4JJ/oR0KQOT+PlrZf1rSbKTBi3y1DxwdFPGJH7lynM85jJrDSjWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784096533; c=relaxed/simple;
	bh=XxKkETVp0Hh9azu8mt6Em4cb00rNFxDsOWgaAy0NvzI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=id+6wkMpFQ+WIiybUtRV85sPjb7qMr8g/s191Bh4fJQfMvkdGcyW9KhGGJcmxf8DaUl9ZHVnWsaT9XHjX0r2u4d7dLUdDJU9Of7llg+jHlN/KX8qiuatmbKAR92CCoKKKPeMjoAcwZ+UE7+Zku69rvjiiUHDFqNC4Qt8l383G7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=nsA8OSOj; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="nsA8OSOj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784096480;
	bh=ujrTN8xbNJslpWS7mW43gjhrPShd6LplwsuV49qAs5M=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=nsA8OSOjozCJt4sUYH8ZkAtyt5zgzGVIkeFEUXITQdxytNiDN295bcV1MXTdcbhIO
	 JSBFznS+GVIP6DDt0M6CmMezbNlZtbq66WqvCBtoZbdguLKEJOtnRAfbdOYSZE6wB6
	 gxlO1JQCn5oS18UvxpT9b7lI0eLt6r2HZqeOO4cE=
X-QQ-mid: esmtpgz13t1784096474t7b33f734
X-QQ-Originating-IP: qrKLG5o0CrGgkXjc1X58gT/ksGTUsrPcLc40C1ucs1Q=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 15 Jul 2026 14:21:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 293116710031764307
EX-QQ-RecipientCnt: 7
From: caina <caina@uniontech.com>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	cem@kernel.org,
	caina <caina@uniontech.com>
Subject: [PATCH v4] xfs: clean up spelling and grammar errors in comments
Date: Wed, 15 Jul 2026 14:21:09 +0800
Message-Id: <20260715062109.24537-1-caina@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NYlggeZuI0UGg2Vnmw//uHIhy6rDos9yR4vqT2Tv8O5Nyv1vse7Cxhvz
	0A+sns0zvWnR80hrKsfoLmSWUPRAlwqX6zkYzlX3WfNbK/AFgGkRZ0HmJHJJBW0TpGgiufJ
	qxQbMli12fWN/tBwm1N1s52CFWVrL4b1HE59fSpv56VzQu+Ujk8dis+rOm/u3ssX0VsnWf6
	Q9pbzQTNqYuD0HqLKPjavOK/++kMRb8JfCht0TLMq8aOf6BCnZ3nTSaAvGqDC81ubUEqgX9
	SoUg6FFmjbD1B4Yrdxpcx6YbUdx3q5DQsDWC+SLvXJGP9iKyapJ8wG3rCxk8Tv+MgpsNMar
	XXEhmwCOPVcbQNEb5OjNj+hUsIADWYcmkxkwZbIaG8k4WnO8XpTHc0Kgt66UWme/Yix8Tb7
	u/u3HxGvQluDPAVdCf269FBX+NG59cwimcPd6/zaDHH2sHC8zZ2cNNxlNDWJHFQVO7/UBG8
	HU1lPP2gd0blKRu0jKRr3msQ/8RzhEr6YPKXaMTtHv2qpiMa3m5aeXMgq5+4csh1WLdK3nm
	FR/SubVIP1WH0yzqWPimuugaFhHAL/6sn4kWbFEhahOqzum6C8yu/mjatMFxOx882f6SKNL
	9PpEl5QMCP+re3Sg+7u/V8DKuDBNHEu4+E+XxAPF14KRrpJzy07DCXS7ABP4ZOnWEfdujLh
	zYBQZiS/AaCJla7pQCsKLPy1qiZP6I1/jKAtRRdYUwSf6+Qw3wNo2lYnpOR92GEPaK46+V0
	1X91QpCCryFgpkJ1KafMEtCN/vkomkxTiaQQ9XUcGHPctjA8xn+NM8hqLZFFrIps1dC+IE2
	18m40imOKjJLz4GkotddRTRwZWxkRyruUBtM9EHwvzEbDO6Gar0WRvPdwyH8NKnyPoT+WdI
	BlO5EAvl/oFd2YjBXyrQQmOC1rNQYYam7Sd38h/Dvb3sLdrjxqZn1sQKrLUAxHh7cu0Ii60
	JpeliTfSS9RmC6Br1q0AJRuYl9ZGY+FXFwoTEdv4zG72/7fTFiFr/udOWUVgcHDHE0ual4G
	3ReixysNA0odR+RSwf
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Clean up various spelling mistakes and grammar errors found in comments
across the XFS filesystem code.

This is a follow-up cleanup to improve code readability. No functional
changes.

Signed-off-by: caina <caina@uniontech.com>
---
Changes in v4:
- Drop the change to xfs_trans_buf.c as the "transaction" typo was already fixed.

Changes in v3:
- Fix "looks" to "locks" in repair.c comment (suggested by Christoph Hellwig).

Changes in v2:
- Keep "do so so that" in alloc_repair.c as the original wording is correct
  (suggested by Christoph Hellwig).
- Fix "Does" to "Do" in btree.c comment to match the plural subject "pointers"
  (suggested by Christoph Hellwig).

 fs/xfs/libxfs/xfs_alloc.c     |  6 +++---
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_btree.c     |  6 +++---
 fs/xfs/scrub/alloc_repair.c   |  4 ++--
 fs/xfs/scrub/btree.c          |  2 +-
 fs/xfs/scrub/repair.c         |  4 ++--
 fs/xfs/xfs_bmap_util.c        |  2 +-
 fs/xfs/xfs_buf_item_recover.c |  4 ++--
 fs/xfs/xfs_inode.c            |  4 ++--
 fs/xfs/xfs_inode_item.c       |  2 +-
 fs/xfs/xfs_log.c              | 10 +++++-----
 fs/xfs/xfs_log_cil.c          | 12 ++++++------
 fs/xfs/xfs_log_recover.c      |  2 +-
 fs/xfs/xfs_notify_failure.c   |  4 ++--
 fs/xfs/xfs_trans.c            | 10 +++++-----
 15 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d99602bcc16f..8695b22d88ff 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -37,7 +37,7 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_CNT_OK	2
 
 /*
- * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
+ * Size of the AGFL.  For CRC-enabled filesystems we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
  * and CRC.
  */
@@ -770,7 +770,7 @@ xfs_alloc_fixup_trees(
  *
  * However, we can't even do that for v4 format filesystems because there are
  * old versions of mkfs out there that does not initialise the AGFL to known,
- * verifiable values. HEnce we can't tell the difference between a AGFL block
+ * verifiable values. Hence we can't tell the difference between a AGFL block
  * allocated by mkfs and a corrupted AGFL block here on v4 filesystems.
  *
  * As a result, we can only fully validate AGFL block numbers when we pull them
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
index 86c5c09a5db4..384122757d43 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1701,7 +1701,7 @@ xfs_attr3_leaf_add_work(
 			/*
 			 * This freemap entry starts at the old end of the
 			 * leaf entry array, so we need to adjust its base
-			 * upward to accomodate the larger array.
+			 * upward to accommodate the larger array.
 			 */
 			diff = sizeof(struct xfs_attr_leaf_entry);
 		} else if (ichdr->freemap[i].size > 0 &&
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b1d3..45cbe0144b23 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -398,7 +398,7 @@ xfs_btree_check_ptr(
  * Calculate CRC on the whole btree block and stuff it into the
  * long-form btree header.
  *
- * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
+ * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
  * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
@@ -436,7 +436,7 @@ xfs_btree_fsblock_verify_crc(
  * Calculate CRC on the whole btree block and stuff it into the
  * short-form btree header.
  *
- * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
+ * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
  * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
@@ -4738,7 +4738,7 @@ xfs_btree_visit_blocks(
  * Change the owner of a btree.
  *
  * The mechanism we use here is ordered buffer logging. Because we don't know
- * how many buffers were are going to need to modify, we don't really want to
+ * how many buffers we are going to need to modify, we don't really want to
  * have to make transaction reservations for the worst case of every buffer in a
  * full size btree as that may be more space that we can fit in the log....
  *
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index dce6ab0429dc..0b40de6331f7 100644
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
@@ -751,7 +751,7 @@ xrep_abt_build_new_trees(
 		goto err_cur;
 
 	/*
-	 * If we need to re-sort the free extents by length, do so so that we
+	 * If we need to re-sort the free extents by length, do so that we
 	 * can put the records into the cntbt in the correct order.
 	 */
 	if (needs_resort) {
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 786b1e7c4dc3..0e90ac00717d 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -342,7 +342,7 @@ xchk_btree_block_check_siblings(
 	/*
 	 * Does the left & right sibling pointers match the adjacent
 	 * parent level pointers?
-	 * (These function absorbs error codes for us.)
+	 * (These functions absorb error codes for us.)
 	 */
 	error = xchk_btree_block_check_sibling(bs, level, -1, &leftsib);
 	if (error)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 11697a8b2a1d..9fd3480b7410 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -368,7 +368,7 @@ xrep_calc_ag_resblks(
 		 * used blocks.  However, with reflink it's possible to have
 		 * more than one rmap record per AG block.  We don't know how
 		 * many rmaps there could be in the AG, so we start off with
-		 * what we hope is an generous over-estimation.
+		 * what we hope is a generous over-estimation.
 		 */
 		if (xfs_has_reflink(mp))
 			rmapbt_sz = xfs_rmapbt_calc_size(mp,
@@ -1257,7 +1257,7 @@ xrep_metadata_inode_forks(
 
 /*
  * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
- * a shmem file might take loks, so we cannot be in transaction context.  Park
+ * a shmem file might take locks, so we cannot be in transaction context.  Park
  * our resources in the scrub context and let the teardown function take care
  * of them at the right time.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c88b9ade7389..0b2f9b94dec3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1607,7 +1607,7 @@ xfs_swap_extents(
 		goto out_unlock;
 
 	/*
-	 * Lock and join the inodes to the tansaction so that transaction commit
+	 * Lock and join the inodes to the transaction so that transaction commit
 	 * or cancel will unlock the inodes from this point onwards.
 	 */
 	xfs_lock_two_inodes(ip, XFS_ILOCK_EXCL, tip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b5..768358b12576 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -227,7 +227,7 @@ xlog_recover_validate_buf_type(
 
 	/*
 	 * We can only do post recovery validation on items on CRC enabled
-	 * fielsystems as we need to know when the buffer was written to be able
+	 * filesystems as we need to know when the buffer was written to be able
 	 * to determine if we should have replayed the item. If we replay old
 	 * metadata over a newer buffer, then it will enter a temporarily
 	 * inconsistent state resulting in verification failures. Hence for now
@@ -806,7 +806,7 @@ xlog_recover_do_primary_sb_buffer(
  *
  * The magic number might not match the buffer type we are going to recover
  * (e.g. reallocated blocks), so we ignore the xfs_buf_log_format flags.  Hence
- * extract the LSN of the existing object in the buffer based on it's current
+ * extract the LSN of the existing object in the buffer based on its current
  * magic number.  If we don't recognise the magic number in the buffer, then
  * return a LSN of -1 so that the caller knows it was an unrecognised block and
  * so can recover the buffer.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 15279d22a894..54636f50dace 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1763,7 +1763,7 @@ xfs_ifree_cluster(
 		 * IO and it won't be unlocked until the cluster freeing has
 		 * been committed to the journal and the buffer unpinned. If it
 		 * is written, we want to know about it, and we want it to
-		 * fail. We can acheive this by adding a write verifier to the
+		 * fail. We can achieve this by adding a write verifier to the
 		 * buffer.
 		 */
 		bp->b_flags |= XBF_DONE;
@@ -2669,7 +2669,7 @@ xfs_irele(
 }
 
 /*
- * Ensure all commited transactions touching the inode are written to the log.
+ * Ensure all committed transactions touching the inode are written to the log.
  */
 int
 xfs_log_force_inode(
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 99d6ecccdaa7..fbe33619da9b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -984,7 +984,7 @@ xfs_iflush_ail_updates(
 
 		/*
 		 * dgc: Not sure how this happens, but it happens very
-		 * occassionaly via generic/388.  xfs_iflush_abort() also
+		 * occasionally via generic/388.  xfs_iflush_abort() also
 		 * silently handles this same "under writeback but not in AIL at
 		 * shutdown" condition via xfs_trans_ail_delete().
 		 */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..b76eb47505e7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -415,7 +415,7 @@ xfs_log_reserve(
  * before we tear down the AIL.
  *
  * We avoid processing actively referenced iclogs so that we don't run callbacks
- * while the iclog owner might still be preparing the iclog for IO submssion.
+ * while the iclog owner might still be preparing the iclog for IO submission.
  * These will be caught by xlog_state_iclog_release() and call this function
  * again to process any callbacks that may have been added to that iclog.
  */
@@ -446,7 +446,7 @@ xlog_state_shutdown_callbacks(
 }
 
 /*
- * Flush iclog to disk if this is the last reference to the given iclog and the
+ * Flush iclog to disk if this is the last reference to the given iclog and
  * it is in the WANT_SYNC state.
  *
  * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
@@ -632,7 +632,7 @@ xfs_log_mount(
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 
 	/*
-	 * Now the log has been fully initialised and we know were our
+	 * Now the log has been fully initialised and we know where our
 	 * space grant counters are, we can initialise the permanent ticket
 	 * needed for delayed logging to work.
 	 */
@@ -1554,7 +1554,7 @@ xlog_write_iclog(
 	 * triggered during unmount, and that can occur asynchronously to the
 	 * unmount thread, and hence we need to ensure that completes before
 	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
-	 * across the log IO to archieve that.
+	 * across the log IO to achieve that.
 	 */
 	down(&iclog->ic_sema);
 	if (xlog_is_shutdown(log)) {
@@ -1747,7 +1747,7 @@ xlog_sync(
 	if (bno + BTOBB(count) > log->l_logBBsize)
 		xlog_split_iclog(log, iclog->ic_header, bno, count);
 
-	/* calculcate the checksum */
+	/* calculate the checksum */
 	iclog->ic_header->h_crc = xlog_cksum(log, iclog->ic_header,
 			iclog->ic_datap, XLOG_REC_SIZE, size);
 	/*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 639f875a8fb2..1b03f05b94ac 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -253,7 +253,7 @@ xlog_cil_iovec_space(
  * the incoming modification. Then during the formatting of the item we can swap
  * the active buffer with the new one if we can't reuse the existing buffer. We
  * don't free the old buffer as it may be reused on the next modification if
- * it's size is right, otherwise we'll free and reallocate it at that point.
+ * its size is right, otherwise we'll free and reallocate it at that point.
  *
  * This function builds a vector for the changes in each log item in the
  * transaction. It then works out the length of the buffer needed for each log
@@ -1223,7 +1223,7 @@ struct xlog_cil_trans_hdr {
  *
  * This is the only place we write a transaction header, so we also build the
  * log opheaders that indicate the start of a log transaction and wrap the
- * transaction header. We keep the start record in it's own log vector rather
+ * transaction header. We keep the start record in its own log vector rather
  * than compacting them into a single region as this ends up making the logic
  * in xlog_write() for handling empty opheaders for start, commit and unmount
  * records much simpler.
@@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
  * allocation context. However, we do not want to block on memory reclaim
  * recursing back into the filesystem because this push may have been triggered
  * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
- * contraints here.
+ * constraints here.
  */
 static void
 xlog_cil_push_work(
@@ -1539,7 +1539,7 @@ xlog_cil_push_work(
 	 * checks for this - ACTIVE can be either a past completed iclog or a
 	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
 	 * past or future iclog awaiting IO or ordered IO completion to be run.
-	 * In the latter case, if it's a future iclog and we wait on it, the we
+	 * In the latter case, if it's a future iclog and we wait on it, we
 	 * will hang because it won't get processed through to ic_force_wait
 	 * wakeup until this commit_iclog is written to disk.  Hence we use the
 	 * iclog header lsn and compare it to the commit lsn to determine if we
@@ -1574,7 +1574,7 @@ xlog_cil_push_work(
 	 *
 	 * If the push caller needs the commit to be immediately stable and the
 	 * commit_iclog is not yet marked as XLOG_STATE_WANT_SYNC to indicate it
-	 * will be written when released, switch it's state to WANT_SYNC right
+	 * will be written when released, switch its state to WANT_SYNC right
 	 * now.
 	 */
 	ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
@@ -1984,7 +1984,7 @@ xlog_cil_force_seq(
 
 	/*
 	 * We detected a shutdown in progress. We need to trigger the log force
-	 * to pass through it's iclog state machine error handling, even though
+	 * to pass through its iclog state machine error handling, even though
 	 * we are already in a shutdown state. Hence we can't return
 	 * NULLCOMMITLSN here as that has special meaning to log forces (i.e.
 	 * LSN is already stable), so we return a zero LSN instead.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fdb011e6ef60..f3e8bfe6bb84 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2304,7 +2304,7 @@ xlog_recovery_process_trans(
 
 	/*
 	 * Callees must not free the trans structure. We'll decide if we need to
-	 * free it or not based on the operation being done and it's result.
+	 * free it or not based on the operation being done and its result.
 	 */
 	switch (flags) {
 	/* expected flag values */
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index b994ff15d5e4..86a6fe23446d 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -281,10 +281,10 @@ xfs_dax_notify_dev_failure(
 		xfs_info(mp, "Device is about to be removed!");
 		/*
 		 * Freeze fs to prevent new mappings from being created.
-		 * - Keep going on if others already hold the kernel forzen.
+		 * - Keep going on if others already hold the kernel frozen.
 		 * - Keep going on if other errors too because this device is
 		 *   starting to fail.
-		 * - If kernel frozen state is hold successfully here, thaw it
+		 * - If kernel frozen state is held successfully here, thaw it
 		 *   here as well at the end.
 		 */
 		kernel_frozen = xfs_dax_notify_failure_freeze(mp) == 0;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bfbd9f6f0df..8e44f27256cc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -84,7 +84,7 @@ xfs_trans_free(
  * permanent log reservation of the given transaction.  The remaining
  * unused block and rt extent reservations are also inherited.  This
  * implies that the original transaction is no longer allowed to allocate
- * blocks.  Locks and log items, however, are no inherited.  They must
+ * blocks.  Locks and log items, however, are not inherited.  They must
  * be added to the new transaction explicitly.
  */
 STATIC struct xfs_trans *
@@ -1056,7 +1056,7 @@ xfs_trans_roll(
 }
 
 /*
- * Allocate an transaction, lock and join the inode to it, and reserve quota.
+ * Allocate a transaction, lock and join the inode to it, and reserve quota.
  *
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The caller is responsible for
@@ -1184,7 +1184,7 @@ xfs_trans_reserve_more_inode(
 }
 
 /*
- * Allocate an transaction in preparation for inode creation by reserving quota
+ * Allocate a transaction in preparation for inode creation by reserving quota
  * against the given dquots.  Callers are not required to hold any inode locks.
  */
 int
@@ -1234,7 +1234,7 @@ xfs_trans_alloc_icreate(
 }
 
 /*
- * Allocate an transaction, lock and join the inode to it, and reserve quota
+ * Allocate a transaction, lock and join the inode to it, and reserve quota
  * in preparation for inode attribute changes that include uid, gid, or prid
  * changes.
  *
@@ -1348,7 +1348,7 @@ xfs_trans_alloc_ichange(
 }
 
 /*
- * Allocate an transaction, lock and join the directory and child inodes to it,
+ * Allocate a transaction, lock and join the directory and child inodes to it,
  * and reserve quota for a directory update.  If there isn't sufficient space,
  * @dblocks will be set to zero for a reservationless directory update and
  * @nospace_error will be set to a negative errno describing the space
-- 
2.20.1

