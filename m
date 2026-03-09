Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CF82C15BA
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079978; cv=none; b=ouRNN6+sqc9eAzvxx5sTCENkyXUE5yxAfO9u8soQCibu4VYQyHfV2e4mFJIwcCWkPQ/Fy/aLLx2nVxzBFf0W8UhITAOkxsNjiacIt9itCG1stSA/+uNcYIX1dB68y8dNxFPmXnnYZtA/2SoF70Wr5o/USf9MgL9FL8rSqjIOmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079978; c=relaxed/simple;
	bh=lMLJ/JnXHS+U8DPpc85bprOo7EJuPTDZ7VEG5ufsnHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0S5M9j6qbQsp6UkeBbjTcZMWD1UAZIDOfj3/lhCshRbdZvuChrQ5aji+kWfstuBXzpsBU5Qkr3+Tkl2cMY4gYd1V2BbUbQn6JV9OG2JfHamWKEhIvzXhJO9X0I7VRu1eSjaTVhu16yiCktF8Rv2UTGN4f9sPhM/gWn6iB4WR5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 3543D180F243;
	Mon, 09 Mar 2026 19:12:53 +0100 (CET)
Received: from trufa.intra.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id lIqcA6UNr2mf6h0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 09 Mar 2026 19:12:53 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	p.raghav@samsung.com,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Date: Mon,  9 Mar 2026 19:12:36 +0100
Message-ID: <20260309181235.428151-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
enable the unmap write zeroes operation.

Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

---
 v11 changes:
	- split into 2 patches separating the bmapi_flags addition
	- 2 step allocation, to avoid zeroing beyond EOF

 fs/xfs/xfs_file.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fd049a1fc9c6..f8c1611e3267 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1293,29 +1293,45 @@ xfs_falloc_zero_range(
 	unsigned int		blksize = i_blocksize(inode);
 	loff_t			new_size = 0;
 	int			error;
+	bool                    need_convert = false;
 
 	trace_xfs_zero_file_space(ip);
 
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (xfs_is_always_cow_inode(ip) ||
+		    !bdev_write_zeroes_unmap_sectors(
+			    xfs_inode_buftarg(ip)->bt_bdev))
+			return -EOPNOTSUPP;
+		need_convert = true;
+	}
+
 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
 	if (error)
 		return error;
 
 	if (xfs_falloc_force_zero(ip, ac)) {
 		error = xfs_zero_range(ip, offset, len, ac, NULL);
-	} else {
-		error = xfs_free_file_space(ip, offset, len, ac);
-		if (error)
-			return error;
-
-		len = round_up(offset + len, blksize) -
-			round_down(offset, blksize);
-		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len,
-				XFS_BMAPI_PREALLOC);
+		goto set_filesize;
 	}
+	error = xfs_free_file_space(ip, offset, len, ac);
 	if (error)
 		return error;
-	return xfs_falloc_setsize(file, new_size);
+
+	len = round_up(offset + len, blksize) - round_down(offset, blksize);
+	offset = round_down(offset, blksize);
+	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
+
+set_filesize:
+	if (error)
+		return error;
+
+	error = xfs_falloc_setsize(file, new_size);
+	if (error)
+		return error;
+	if (need_convert)
+		error = xfs_alloc_file_space(ip, offset, len,
+				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+	return error;
 }
 
 static int
@@ -1377,7 +1393,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1420,6 +1436,7 @@ __xfs_file_fallocate(
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
 	case FALLOC_FL_ZERO_RANGE:
 		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
 		break;
-- 
2.53.0

