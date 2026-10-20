Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465730;
	b=aHedArncFWZxDjbH83PJvasRgrVqD34qzu6RC9VqpEFa6BSCE+97VYu5bTOGYl2n7g1t
	 HByYLMM70Ca9YVMmZpzvUjK7ZbDFjpvsUfmQApk5kmr5w4Yx8XmoneA+QAe0hYC/aAOVH
	 VJMbbeK6+1uCkAHJV7lK6FmSmfxCpX7HUVCt1yW+vz+c6aAfDqJcBRXt/ig9NVCy3CiMR
	 xDl37Tgg4GBb1uk8TjGpUPuOP3bdTqTs5X0F0MmRQs4xB9CZHPzqRXXXEkA/TIjrsQ4RA
	 ObZLsw5ghGI7cm5SlrGLiebYyP2NPSrAMoypQobuCxh1NlHbweHzr7Za3y/krRj16Iw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465730;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qRKJN+EqJUWlZiKz0FevzKVVHVfCsJOlLUx9jyK0bGM=;
	b=gIFwbulkQ7Pq8s2/F362C0m1UCMPFpW37bvDLfkRLVaaKlF1YiPzACooNDXlDOFDDuSH
	 rekAEK1JylW6zIFhJ3oxizsLAsG/+wwY4T3iBP9mqVPbkDhCBIRi4HXKiu3C4RVr3eMcx
	 PRZZ0oVfyhzBcPPZD1nHgNP4tmYJtV6CtkLP8Kdz9s0YbG4dKWHRhDTqZO6/MdbZLciKM
	 81PURRgfirmRS0uxdqwoUda9MolsuWnvdhQsAcSTOZ5pL4uR9hrizK2CjOyh31WAnjy6c
	 zcbSrbsZTYIVuN48E1HkRubRB9NnpqoEmLMXvaa3zxk5HNhTCTXia3GfJ7+3NzOuhig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnxKBBAM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBD560A261E;
	Tue, 20 Oct 2026 03:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnxKBBAM
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465729;
	b=g2OeFBBmu6JE/zaTT6pSjAPJr8YcR7yvGZTadHoeiCGIO+sDEA2F2v2EjizaiJqkEdDd
	 eRRMt1wPcyKmtYd6CrRqRhEua80dyKLqwKTSJbmuOIvoV/LRZTg6gYSv/MQDCkC2tlUcT
	 +4GfMrS26AmdCQBIt3gzESX9wyI1h6pAvSlS5/z8u1qICBfYexdgjpfwZsmP0K8JcT2mU
	 hLR6ep4b78uXhEkzYJjofaR5HdTnyECljgA6NRgwYRRIJjYPXs0NWLnUmccDl1VH3CgA+
	 KpBaBhLREOLqewtCBY2upqP/1ErTiCvvWKX3doySJPTgilBionSDyKvduC+IqpklCkg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465729;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qRKJN+EqJUWlZiKz0FevzKVVHVfCsJOlLUx9jyK0bGM=;
	b=dI6/La1VPZRvjgTC3Hot2f6m7bELOHci4NPTpzB+Oou7ESFndPCkG+XTZ4l6AH1Xq5ND
	 qtLhKdW68vwaiO/7jBypCPI3VzHFaVID8o16yIgSMjH/lcvqxIbWR6gC0bJSTFl11Tgkt
	 53qcIX1DFMU30sU9yvk+DBNQ2t/yt53sg3xlOmi3kT29N/oeVTDH38ZjaX5WDVZeE0LkW
	 6NxXFbD0dX7jeHejK8F1NglXXaa2p6XmpwjGCLQTatY6NwXMyzwrwWMWHJprZC8YIi/q+
	 NCE7Vk7iJMI++rbknpqs3YmzBTs3se3Or/fko4zfhP908aJfXZsAcyQewhctIOFupQw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 352171F000CE;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465729;
	bh=qRKJN+EqJUWlZiKz0FevzKVVHVfCsJOlLUx9jyK0bGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DnxKBBAMVRBP5iK+5KFBv90f9Km2MsnNhqKPoUUrQQnGpVpLVRKEmIfc6YzZ39Rmd
	 xRhKRmBhZWYVFiiVFybdGXS0BYw0mV47tHwMvm6nNX/Mcykaof0CyZvjrMM5vRi+bF
	 t6J5VMvNt1eiY9VK5Zw1Xxp2OmeEn8RVmeHQNB0RUJOWq2yQJZOhX4hgjj1k4PrxNv
	 UHnm854WliOFoTCkfyNPVN3EYeMbNvkpmu+yTB7Ou1U1pPZEjn1QzHgj3TOOSaPT/A
	 wQEN25q1P81w3HZTbLJOAV0C7cYudviKpeZOKhnDJoMQABsCeqLnmaKtkIKA8VqMlW
	 fQ4evYBoQT3Qg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1139B43058;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:51 +0900
Subject: [PATCH v4 8/9] xfs: add datasync and log_flushed arguments to
 xfs_log_force_inode()
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261020-xfs-pnfs-batch-v4-8-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=8218;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=EkakyQg5RkYzl1UE9lhzZFf/ZqyNAWOR0TGPsMkn4eE=;
 b=FAPLe36TI4wtGlUPc/tSrlnSZFnfMpjZaRjHCrlgmvesepP0cfiM7Th3G+g8+bkSPzFij1/SD
 zoUzrlGuDVhA/KT3pNSwGa2fzhrhX0mItyhliLLp+FiKpC/0wf/AS5C
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 8d7a71db5f..1e47d0aa6a 100644
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


