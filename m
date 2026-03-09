Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5227467F
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079744; cv=none; b=GAB02r0J7TnNQYdChClYyv1ZeROdmsA6VE5AlQ3UvPn9njX+ECGPTrmjkAFmYJim8dBMAf0Cw54f9Nj5pUPEBllT9QPdLNZTG1f+BbX9O2xGdxjximLAouZjGiDlN8vvhmr6iT8K74z34bUeMj4qZMoOu9CMLOco/vgTDZjvLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079744; c=relaxed/simple;
	bh=/Z0Tuteni38SV68OKRP5NmzDaFcxUU66neFFvnxNRWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M31vEj3zPaKr1dDrSH09sCWMut1o1L1jBWHQUHuyFBhfDyXgZm5QiLweqFtZEFglrNNCHZo0WQx455QoAeFJCAhQ3J5yWmeXA+1kooVqLwLYDo2xrj7PIAu7d9lhrSFP0ZNR+nFtlHsPvfdBH+axWn3MoTyHeiMFOhbAM/oPkxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 3BAC1180F243;
	Mon, 09 Mar 2026 19:08:58 +0100 (CET)
Received: from trufa.intra.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 8vDcK6cMr2k66h0AKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Mon, 09 Mar 2026 19:08:58 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	p.raghav@samsung.com,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 1/2] xfs: Introduce 'bmapi_flags' parameter to xfs_alloc_file_space()
Date: Mon,  9 Mar 2026 19:07:09 +0100
Message-ID: <20260309180708.427553-4-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309180708.427553-2-lukas@herbolt.com>
References: <20260309180708.427553-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bmapi_flags to xfs_alloc_file_space for future use with
FALLOC_FL_WRITE_ZEROES new fallocate mode. This allows callers to
explicitly pass the required  XFS_BMAPI_* allocation flags.

Update all existing callers to pass XFS_BMAPI_PREALLOC to maintain
the current behavior. No functional changes intended.

Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

---
 fs/xfs/xfs_bmap_util.c | 5 +++--
 fs/xfs/xfs_bmap_util.h | 2 +-
 fs/xfs/xfs_file.c      | 9 ++++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2208a720ec3f..e92f9cd05f52 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -646,7 +646,8 @@ int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	uint32_t                bmapi_flags)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -748,7 +749,7 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				allocatesize_fsb, bmapi_flags, 0, imapp,
 				&nimaps);
 		if (error) {
 			if (error != -ENOSR)
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..2895cc97a572 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+		xfs_off_t len, uint32_t bmapi_flags);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7874cf745af3..fd049a1fc9c6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1310,7 +1310,8 @@ xfs_falloc_zero_range(
 		len = round_up(offset + len, blksize) -
 			round_down(offset, blksize);
 		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+		error = xfs_alloc_file_space(ip, offset, len,
+				XFS_BMAPI_PREALLOC);
 	}
 	if (error)
 		return error;
@@ -1336,7 +1337,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1364,7 +1366,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.53.0

