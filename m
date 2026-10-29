Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240583;
	b=YDfCRHXjedwuCC8wvP8zCIj66iMUSwB6C/cgqo6DvhhQqmhD1h6IJhbsjiFjSe777PRQ
	 iRLyS5Rg4PQx6+1J3DHfyUcwHxV85tKqrsgMMZEnYJEAqkZfemoXeikN4hQ7Asc40BhHA
	 GuhRd53ggx3nNm/We2ttG3zGgQvw8/Hcm3Vu5nl+PIYlDFdyzAyOBd4Qkoa+vF9+PFK2x
	 ValpihurMTyvnZR5bTW46twWT2awboUSMxQZ84Gp/RGET93SNLNQp4ZfmDv0UVoEou4yc
	 O5DncnLcnPw3aj3uhRr4q9syw+2Z2Dl9xL55Vz+v2Nwpeb2JWhubaAX013lF4CkN0Ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240583;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ztfNwlimDaIMYDDPx5TENK7cTQYslQEtVX07RmPCZkk=;
	b=F4ytYBXvJR17pODE5u0C12D7JsRYeQgWsgb3Yr1CPGe6bRTTPOQHzYWKvg7Hwf88guof
	 UZsAP5zUtz+lxdMHEMrictF1q9Tov850JD4WKXjDDzeO2hligxtdsMZ9OtyTiR+EIdA/f
	 H1Ks4Fk3roR05rXWi5KLFGmKiNJ68SnH3vm3Cw8ZDTMYg4j0eWZrPBSgykQjsQVa3kIdO
	 Z5inU8yZin3jdrf1DB+q7Qzye06gJLbDo3v8sdZrXu1i93ItY/GJKoKGl4Z807Raf1EiC
	 HXp+1tHskLXKC0NxPnEur7iHHaMcy7yNKmtwxTBtMwF57FtUF55H8aZZKiEaM+lpuKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kSvMlEb/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE1606A32C;
	Thu, 29 Oct 2026 02:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSvMlEb/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240582;
	b=tHQS2dwyR7yz4xcYuilXWpUdNdijf6sU7QF9vROI5KyOaIMDpuIFcMWOBA9hP9cNVMiy
	 2EWDP3dnTcZPsp70Ufcn5JgMdQByRJlisY5IQ5ofzrAFa9824ThAZKKEW9O5ym/Qn3YYH
	 tz/FwjGxcFQbaihf/WMO7BhWficXU7F6lvDWN6bRxlONcw8T0+BqN2zesoSF0ykEWeUwM
	 QTzjhi4SpQc1dfshOiS2Uyyv/fmBKAhNMmDpygQdL08nDBYKywRP7MbPvNADNh32BNrUb
	 oV3mC9pEx5BAVTR0Eybu7L3j1JxiHRETLyDho0uvB9n66+ZHaPvDIU+/SZVRlGKzhug==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240582;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ztfNwlimDaIMYDDPx5TENK7cTQYslQEtVX07RmPCZkk=;
	b=q4HnwXX6FLqbs2zS8oZOUkOnTWdxGeATkDrbEIoNknzTR7VShlhmvUXzH48A3qQIajyh
	 d6Cxy9H6EiHEm3HTQDbtg/Tt1wEi2ZPm7MtTEpDh8mVbGGixpTFJ0eDfhRkejeFnPldag
	 IqyT7T3oNi46zi03ujBw0uln16wW4T0Lpey8uQbwoHJbxjo4a2TwTsxwHdS5EORTbY6iR
	 yqhJ4oKhKnL+yl/N26e3X4GIhdGyRAz1wVT1g7McJyoiX/5e/TiGe1EjwTlSYVgXsEXGl
	 KMLRpjZGR7oJCVvfBrbjBf2eXHi7Hz+YMJ7syVCidnoa/AB86/VSQDgD4hpSJL83pPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 020131F031E6;
	Thu, 29 Oct 2026 02:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240582;
	bh=ztfNwlimDaIMYDDPx5TENK7cTQYslQEtVX07RmPCZkk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kSvMlEb/7KGhLspd360RCvqdHoQTaHqwz/cnLMeGFXgjha0lMYu+TEGsaMqm23dWR
	 LymIssACcS9FYLHMjnHmO6IBkcNHVREbRGYi8Oht80vq6Ap43jI27+FuTGWNsGYlT4
	 DJD5mt8YfBO7GErNvmKaln/GMW0aGD9ZV0HLrClD8jKp0xOYc5B+DLL4lp5LnXJaRg
	 vTqtYc4dXmOkqREPidLR4yMtnWqLjSuRUye2Jm3HSBwkJZZfhVjN8bwbUR1o9dwG5S
	 zE4MvlGXpy3ve716pRlLcI1kQn1ZBm7/c+uynhBABQoMubc6bDZMxMoauEVROfXar9
	 9rH7Y+zxn5Fhg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 11E77456A2;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:05 +0900
Subject: [PATCH v5 8/9] xfs: add datasync and log_flushed arguments to
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
Message-Id: <20261029-xfs-pnfs-batch-v5-8-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=7887;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Nk+YR6VX9t0NZiz+UYJSWclOe3yOkmbiwsMnQiHyqeg=;
 b=uEkmlVQV/SRpaQLmeETqXxq/8IUovjnSIIWPvlwop/Dgs364zwCn3XrqCJxGNyI5NjzzJLcy/
 PWYjARpEzusBuSdnIqWFbT/j4tEYK5ydwNcp+Du9chICZQQgmZkPeZb
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Add datasync and log_flushed arguments to xfs_log_force_inode() and
move the body of xfs_fsync_flush_log() into it. The next patch needs a
datasync log force in the pNFS LAYOUTCOMMIT path. xfs_file_fsync()
calls it instead, and the other callers pass false and NULL. No
functional change.

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
index c1a6409f00..f4c4a02e5c 100644
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


