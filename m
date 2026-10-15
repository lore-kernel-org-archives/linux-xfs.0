Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895DE44F54C;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037282; cv=none; b=DCgF2MLQf6/dAg7Uje2dHQyNFHKKKTPUk2NUDD3biDkFvbWmQ4UOhpJ/zijAFDNcpv9wY/BJrVDvfaE/hJw+/ykIbjb2yp0AZN2J0xFf84vhJ6PQniNOZizctbtsWAEUe+7dUo6II5z6mp4zIkbSVioGbwlwPj4IhDsDWhe7IrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037282; c=relaxed/simple;
	bh=o9LtJ8MKDySwi83KhGSWbJr1Ty8G1B0bj4qaGAlVqTw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g8dYQnZVikDhi13Tj9Oc1LliK8McJLThBt5cZuKXg/BHWCaVVp/veAUWIFhe0BXFIGLO+0Vaz8KUGOdzBs7YfY1Nb1aecrh+ZZUp9OOQPWZv0MYFx18xAGNVejQzlsXEUuOcaXp3OlW4TS/kw/SYh9nnJdy6ZsqFnznU3TtIa24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJYrdqpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJYrdqpM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F6CDC2BD00;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792037282;
	bh=o9LtJ8MKDySwi83KhGSWbJr1Ty8G1B0bj4qaGAlVqTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZJYrdqpM8J8w2kYiwVkcaSyXrIKXt00EoCUBJa2SXoKYnw35IsRB7e2FR3kjmvccG
	 CDCFR5uXpaJCfNcdHhmNGVPNt+VHsLRTCxe7Ya3AFEs9/vyS4U/Sp4hRWObKEK9oz5
	 FdOOVbhwFRpGS8GoAWi2+lMf47A72EdI6dn9yTaxlegxzdumasf+j14HYdUA54E/Kf
	 Ht4Zr6Uw/COBsaIR33pscCdiFHan8UAF/s/y5JrLkK7/FJpgAYfb9I2qBFP2SqZ0kV
	 byrDn/XKxJ8htiU8H7eENgDZJyBzYk73dRfEzIHqeKHbZINFkQd6qKxSnUqw2UtnZM
	 dJOS9sXo/5YeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA95CC6B35;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 15 Oct 2026 13:08:07 +0900
Subject: [PATCH v3 8/9] xfs: add datasync and log_flushed arguments to
 xfs_log_force_inode()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-xfs-pnfs-batch-v3-8-54fc7b2e467d@samsung.com>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
In-Reply-To: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792037279; l=8173;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=i5pmSpgPvKL2p/TWenNt7p6UkAXFU8tFUyEe6dL784Q=;
 b=joouWB55/BV9WQHPyfpGZmpjjU3kSoKV2KO8DcD1lk33Oduf1a2oT6vCf2U4UzRQJkIXWv/nq
 KMDvpmMliCAB6MdOHqBY1GsLBjNDB82p3VFwJ4SMCCoW1NhG5mksVMk
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_log_force_inode() is xfs_fsync_flush_log() without a datasync
variant and without the log_flushed result, plus a check for an inode
without a log item. Add the datasync and log_flushed arguments to
xfs_log_force_inode(), move the body and the comment of
xfs_fsync_flush_log() into it, and call it from xfs_file_fsync(), so
that code outside xfs_file.c can force the log for a datasync. The other
callers pass false and NULL. The next patch uses it in the pNFS
LAYOUTCOMMIT path.

No functional change: xfs_file_fsync() only calls it for an inode with a
log item, and the other callers force the log as before.

Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20261014130124.GA15407@lst.de
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_export.c  |  2 +-
 fs/xfs/xfs_file.c    | 50 ++++----------------------------------------------
 fs/xfs/xfs_inode.c   | 36 ++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_inode.h   |  3 ++-
 fs/xfs/xfs_pnfs.c    |  2 +-
 fs/xfs/xfs_zone_gc.c |  2 +-
 6 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 9afda52ed1..9dd6dd8c27 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -234,7 +234,7 @@ STATIC int
 xfs_fs_nfs_commit_metadata(
 	struct inode		*inode)
 {
-	return xfs_log_force_inode(XFS_I(inode));
+	return xfs_log_force_inode(XFS_I(inode), false, NULL);
 }
 
 const struct export_operations xfs_export_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 720f4a9b40..27176a4808 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -76,49 +76,7 @@ xfs_dir_fsync(
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 
 	trace_xfs_dir_fsync(ip);
-	return xfs_log_force_inode(ip);
-}
-
-/*
- * All metadata updates are logged, which means that we just have to push the
- * journal to the required sequence number than holds the updates. We track
- * datasync commits separately to full sync commits, and hence only need to
- * select the correct sequence number for the log force here.
- *
- * We don't have to serialise against concurrent modifications, as we do not
- * have to wait for modifications that have not yet completed. We define a
- * transaction commit as completing when the commit sequence number is updated,
- * hence if the sequence number has not updated, the sync operation has been
- * run before the commit completed and we don't have to wait for it.
- *
- * If we have concurrent fsync/fdatasync() calls, the sequence numbers remain
- * set on the log item until - at least - the journal flush completes. In
- * reality, they are only cleared when the inode is fully unpinned (i.e.
- * persistent in the journal and not dirty in the CIL), and so we rely on
- * xfs_log_force_seq() either skipping sequences that have been persisted or
- * waiting on sequences that are still in flight to correctly order concurrent
- * sync operations.
- */
-static int
-xfs_fsync_flush_log(
-	struct xfs_inode	*ip,
-	bool			datasync,
-	int			*log_flushed)
-{
-	struct xfs_inode_log_item *iip = ip->i_itemp;
-	xfs_csn_t		seq = 0;
-
-	spin_lock(&iip->ili_lock);
-	if (datasync)
-		seq = iip->ili_datasync_seq;
-	else
-		seq = iip->ili_commit_seq;
-	spin_unlock(&iip->ili_lock);
-
-	if (!seq)
-		return 0;
-
-	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
+	return xfs_log_force_inode(ip, false, NULL);
 }
 
 STATIC int
@@ -151,7 +109,7 @@ xfs_file_fsync(
 	 * no modifications to this inode that need to be pushed out.
 	 */
 	if (ip->i_itemp) {
-		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+		error = xfs_log_force_inode(ip, datasync, &log_flushed);
 		if (error)
 			return error;
 	}
@@ -1599,7 +1557,7 @@ __xfs_file_fallocate(
 	}
 
 	if (!error && xfs_file_sync_writes(file))
-		error = xfs_log_force_inode(ip);
+		error = xfs_log_force_inode(ip, false, NULL);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
@@ -1750,7 +1708,7 @@ xfs_file_remap_range(
 		goto out_unlock;
 
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
-		xfs_log_force_inode(dest);
+		xfs_log_force_inode(dest, false, NULL);
 out_unlock:
 	xfs_iunlock2_remapping(src, dest);
 	if (ret)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 15b62574b8..0d1c9531cd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,11 +2669,36 @@ xfs_irele(
 }
 
 /*
- * Ensure all committed transactions touching the inode are written to the log.
+ * Ensure all committed transactions touching the inode are written to the log,
+ * or with @datasync only those that fdatasync has to wait for.
+ *
+ * All metadata updates are logged, which means that we just have to push the
+ * journal to the required sequence number that holds the updates. We track
+ * datasync commits separately to full sync commits, and hence only need to
+ * select the correct sequence number for the log force here.
+ *
+ * We don't have to serialise against concurrent modifications, as we do not
+ * have to wait for modifications that have not yet completed. We define a
+ * transaction commit as completing when the commit sequence number is updated,
+ * hence if the sequence number has not updated, the sync operation has been
+ * run before the commit completed and we don't have to wait for it.
+ *
+ * If we have concurrent fsync/fdatasync() calls, the sequence numbers remain
+ * set on the log item until - at least - the journal flush completes. In
+ * reality, they are only cleared when the inode is fully unpinned (i.e.
+ * persistent in the journal and not dirty in the CIL), and so we rely on
+ * xfs_log_force_seq() either skipping sequences that have been persisted or
+ * waiting on sequences that are still in flight to correctly order concurrent
+ * sync operations.
+ *
+ * If @log_flushed is not NULL, it is set when the log force wrote an iclog,
+ * which flushes the device caches before the log write.
  */
 int
 xfs_log_force_inode(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			datasync,
+	int			*log_flushed)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
 	xfs_csn_t		seq = 0;
@@ -2682,12 +2707,15 @@ xfs_log_force_inode(
 		return 0;
 
 	spin_lock(&iip->ili_lock);
-	seq = iip->ili_commit_seq;
+	if (datasync)
+		seq = iip->ili_datasync_seq;
+	else
+		seq = iip->ili_commit_seq;
 	spin_unlock(&iip->ili_lock);
 
 	if (!seq)
 		return 0;
-	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1fa442b646..6dfd9271e6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -595,7 +595,8 @@ int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 
-int		xfs_log_force_inode(struct xfs_inode *ip);
+int		xfs_log_force_inode(struct xfs_inode *ip, bool datasync,
+				int *log_flushed);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 3d97b29b54..dd2df30717 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -118,7 +118,7 @@ xfs_fs_map_update_inode(
 	 * Force the log so that the blocks handed out to the client are
 	 * guaranteed to be present even after a server crash.
 	 */
-	return xfs_log_force_inode(ip);
+	return xfs_log_force_inode(ip, false, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 54b70ed292..cea5447a88 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -1018,7 +1018,7 @@ xfs_zone_gc_reset_zones(
 		struct xfs_gc_bio	*chunk;
 		struct bio		*bio;
 
-		xfs_log_force_inode(rtg_rmap(rtg));
+		xfs_log_force_inode(rtg_rmap(rtg), false, NULL);
 
 		next = rtg_group(rtg)->xg_next_reset;
 		rtg_group(rtg)->xg_next_reset = NULL;

-- 
2.43.0


