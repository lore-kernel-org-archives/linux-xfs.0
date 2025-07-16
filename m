Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C92341AA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670474; cv=none; b=l9pf038y9LTJuAZmVi8RK5QqlpjfGpE3Arx9EtJgvjuUVg/7TdOrAYw5bMu2cD/JM8MkGdOzp+jtCNEgRIm8Mv0dhhYC0fhn6X+jQ9BXwQcOre+yblPahEzq8JfrU5CpaVYOYNhnRmNO6yPxv/lMwAOB4YqJlt3F/lOXavES+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670474; c=relaxed/simple;
	bh=PpnTy1TIpkCMyVdI6ahko2XEMHcTpzKYYWfHlA3E1Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXYy2/FcRIXwPpy+q+x64Ie9311e7ShICfy31ljEppg+TTWY64DCVUKuZZLMkrYXoQ6G1OTHDUxqb3pgokQqV4n7S1m7cU9xBmKoIqjH8CngOYAeuQxGWc8fzsNLxs4tX6uZko1lPVjs+Y1ZEd4QLO4hvMWMjXpohHeaXUJslM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L4PjMHwa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L4PjMHwa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KOEBbkW+Apob2e3eBKgls8x4NhTy+7zr4IgkLHWZLPk=; b=L4PjMHwabBmwmrqgp4fEGp1stC
	CGt8JQEf2xAOlOerVgx4LO3QxrWL8MqFEx0/HPOPxfXoVTWDPwCyRqkgQbbpHWIGhNiEk12OM9bY6
	6Vo0udOyvO3OWXUzRSNcrOz1mTZCiyR/BbFLCWqyEBBPkxxo2hSpvOhHlA7TFN4m8IyMcYvZGP/ua
	FdGckNXLED+ylrek+iFsGUJyf5aHB0eWJsJ4nFROdFGdk5+yCbAO+krI/2APeip87sDOJ5ZIDZwKL
	cNjLgrKk4YmUiUoXXPHnJ3Ri53kQT9YmseA8g1GYNWa7oJ7ybvA2+QPRpV1x2g4wRlZI91xO47o5d
	tnqSpTsA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eZ-00000007iOA-1PnM;
	Wed, 16 Jul 2025 12:54:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: stop passing an inode to the zone space reservation helpers
Date: Wed, 16 Jul 2025 14:54:04 +0200
Message-ID: <20250716125413.2148420-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

None of them actually needs the inode, the mount is enough.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c            | 24 ++++++++++++------------
 fs/xfs/xfs_iops.c            |  4 ++--
 fs/xfs/xfs_zone_alloc.h      |  4 ++--
 fs/xfs/xfs_zone_space_resv.c | 17 ++++++-----------
 4 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 38e365b16348..ed69a65f56d7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -497,7 +497,7 @@ xfs_file_write_checks(
 
 static ssize_t
 xfs_zoned_write_space_reserve(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
 	struct kiocb			*iocb,
 	struct iov_iter			*from,
 	unsigned int			flags,
@@ -533,8 +533,8 @@ xfs_zoned_write_space_reserve(
 	 *
 	 * Any remaining block will be returned after the write.
 	 */
-	return xfs_zoned_space_reserve(ip,
-			XFS_B_TO_FSB(ip->i_mount, count) + 1 + 2, flags, ac);
+	return xfs_zoned_space_reserve(mp, XFS_B_TO_FSB(mp, count) + 1 + 2,
+			flags, ac);
 }
 
 static int
@@ -718,13 +718,13 @@ xfs_file_dio_write_zoned(
 	struct xfs_zone_alloc_ctx ac = { };
 	ssize_t			ret;
 
-	ret = xfs_zoned_write_space_reserve(ip, iocb, from, 0, &ac);
+	ret = xfs_zoned_write_space_reserve(ip->i_mount, iocb, from, 0, &ac);
 	if (ret < 0)
 		return ret;
 	ret = xfs_file_dio_write_aligned(ip, iocb, from,
 			&xfs_zoned_direct_write_iomap_ops,
 			&xfs_dio_zoned_write_ops, &ac);
-	xfs_zoned_space_unreserve(ip, &ac);
+	xfs_zoned_space_unreserve(ip->i_mount, &ac);
 	return ret;
 }
 
@@ -1032,7 +1032,7 @@ xfs_file_buffered_write_zoned(
 	struct xfs_zone_alloc_ctx ac = { };
 	ssize_t			ret;
 
-	ret = xfs_zoned_write_space_reserve(ip, iocb, from, XFS_ZR_GREEDY, &ac);
+	ret = xfs_zoned_write_space_reserve(mp, iocb, from, XFS_ZR_GREEDY, &ac);
 	if (ret < 0)
 		return ret;
 
@@ -1073,7 +1073,7 @@ xfs_file_buffered_write_zoned(
 out_unlock:
 	xfs_iunlock(ip, iolock);
 out_unreserve:
-	xfs_zoned_space_unreserve(ip, &ac);
+	xfs_zoned_space_unreserve(ip->i_mount, &ac);
 	if (ret > 0) {
 		XFS_STATS_ADD(mp, xs_write_bytes, ret);
 		ret = generic_write_sync(iocb, ret);
@@ -1414,11 +1414,11 @@ xfs_file_zoned_fallocate(
 	struct xfs_inode	*ip = XFS_I(file_inode(file));
 	int			error;
 
-	error = xfs_zoned_space_reserve(ip, 2, XFS_ZR_RESERVED, &ac);
+	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
 	if (error)
 		return error;
 	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
-	xfs_zoned_space_unreserve(ip, &ac);
+	xfs_zoned_space_unreserve(ip->i_mount, &ac);
 	return error;
 }
 
@@ -1828,12 +1828,12 @@ xfs_write_fault_zoned(
 	 * But as the overallocation is limited to less than a folio and will be
 	 * release instantly that's just fine.
 	 */
-	error = xfs_zoned_space_reserve(ip, XFS_B_TO_FSB(ip->i_mount, len), 0,
-			&ac);
+	error = xfs_zoned_space_reserve(ip->i_mount,
+			XFS_B_TO_FSB(ip->i_mount, len), 0, &ac);
 	if (error < 0)
 		return vmf_fs_error(error);
 	ret = __xfs_write_fault(vmf, order, &ac);
-	xfs_zoned_space_unreserve(ip, &ac);
+	xfs_zoned_space_unreserve(ip->i_mount, &ac);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 01e597290eb5..149b5460fbfd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -970,7 +970,7 @@ xfs_setattr_size(
 	 * change.
 	 */
 	if (xfs_is_zoned_inode(ip)) {
-		error = xfs_zoned_space_reserve(ip, 1,
+		error = xfs_zoned_space_reserve(mp, 1,
 				XFS_ZR_NOWAIT | XFS_ZR_RESERVED, &ac);
 		if (error) {
 			if (error == -EAGAIN)
@@ -998,7 +998,7 @@ xfs_setattr_size(
 	}
 
 	if (xfs_is_zoned_inode(ip))
-		xfs_zoned_space_unreserve(ip, &ac);
+		xfs_zoned_space_unreserve(mp, &ac);
 
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index ecf39106704c..4db02816d0fd 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -23,9 +23,9 @@ struct xfs_zone_alloc_ctx {
  */
 #define XFS_ZR_RESERVED		(1U << 2)
 
-int xfs_zoned_space_reserve(struct xfs_inode *ip, xfs_filblks_t count_fsb,
+int xfs_zoned_space_reserve(struct xfs_mount *mp, xfs_filblks_t count_fsb,
 		unsigned int flags, struct xfs_zone_alloc_ctx *ac);
-void xfs_zoned_space_unreserve(struct xfs_inode *ip,
+void xfs_zoned_space_unreserve(struct xfs_mount *mp,
 		struct xfs_zone_alloc_ctx *ac);
 void xfs_zoned_add_available(struct xfs_mount *mp, xfs_filblks_t count_fsb);
 
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 93c9a7721139..1313c55b8cbe 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -117,11 +117,10 @@ xfs_zoned_space_wait_error(
 
 static int
 xfs_zoned_reserve_available(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
 	xfs_filblks_t			count_fsb,
 	unsigned int			flags)
 {
-	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_zone_info		*zi = mp->m_zone_info;
 	struct xfs_zone_reservation	reservation = {
 		.task		= current,
@@ -198,11 +197,10 @@ xfs_zoned_reserve_available(
  */
 static int
 xfs_zoned_reserve_extents_greedy(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
 	xfs_filblks_t			*count_fsb,
 	unsigned int			flags)
 {
-	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_zone_info		*zi = mp->m_zone_info;
 	s64				len = *count_fsb;
 	int				error = -ENOSPC;
@@ -220,12 +218,11 @@ xfs_zoned_reserve_extents_greedy(
 
 int
 xfs_zoned_space_reserve(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
 	xfs_filblks_t			count_fsb,
 	unsigned int			flags,
 	struct xfs_zone_alloc_ctx	*ac)
 {
-	struct xfs_mount		*mp = ip->i_mount;
 	int				error;
 
 	ASSERT(ac->reserved_blocks == 0);
@@ -234,11 +231,11 @@ xfs_zoned_space_reserve(
 	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
 			flags & XFS_ZR_RESERVED);
 	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
-		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
+		error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
 	if (error)
 		return error;
 
-	error = xfs_zoned_reserve_available(ip, count_fsb, flags);
+	error = xfs_zoned_reserve_available(mp, count_fsb, flags);
 	if (error) {
 		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb);
 		return error;
@@ -249,12 +246,10 @@ xfs_zoned_space_reserve(
 
 void
 xfs_zoned_space_unreserve(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
 	struct xfs_zone_alloc_ctx	*ac)
 {
 	if (ac->reserved_blocks > 0) {
-		struct xfs_mount	*mp = ip->i_mount;
-
 		xfs_zoned_add_available(mp, ac->reserved_blocks);
 		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, ac->reserved_blocks);
 	}
-- 
2.47.2

