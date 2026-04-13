Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033B37DEAA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776087207; cv=none; b=YjZW9UmlxHkS3Qn/xS+6f/HqCThQP17OiwkSFRD+ZWoK9LxB0jfbfLBklhAMObuab5H01Z6TKOYfDauFG17boyL+MyhYWGgDfT7SQa7Q6QgDMFrSH5OtJ5ER4h/rfv63qM1EH1Ml4DWEG/tpYv/KI8EKwzBC2+sEav1s7psBS7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776087207; c=relaxed/simple;
	bh=LzBB4LwmiR3iVDOAGu5BHdftCaajXivzxU+A8a5AMFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWuUKY4jwhgtWNx1Hkby3+CX3goc3xJ38hMNAEN3pbN9ZLuBgxeGx5WI0hNuHZf72thllrHogr7rp7dLfLCxFmmMS+HC2TKeigCwT1sJNuAWgCS+ZSfRDC3UAyEpo7HxWTf9S5f+VIUcXtVah+iBQLEbF1dLNneqry5UC/R0ooQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4fvSz02Fr7z9sdM;
	Mon, 13 Apr 2026 15:33:16 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v2 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Date: Mon, 13 Apr 2026 15:32:56 +0200
Message-ID: <20260413133256.3378243-3-p.raghav@samsung.com>
In-Reply-To: <20260413133256.3378243-1-p.raghav@samsung.com>
References: <20260413133256.3378243-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4fvSz02Fr7z9sdM

If the underlying block device supports the unmap write zeroes
operation, this flag allows users to quickly preallocate a file with
written extents that contain zeroes. This is beneficial for subsequent
overwrites as it prevents the need for unwritten-to-written extent
conversions, thereby significantly reducing metadata updates and journal
I/O overhead, improving overwrite performance.

Co-developed-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_file.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..99a02982154a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1368,6 +1368,57 @@ xfs_falloc_force_zero(
 	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
 }
 
+static int
+xfs_falloc_write_zeroes(
+	struct file		*file,
+	int			mode,
+	loff_t			offset,
+	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			new_size = 0;
+	loff_t			old_size = XFS_ISIZE(ip);
+	int			error;
+	unsigned int		blksize = i_blocksize(inode);
+	loff_t			offset_aligned = round_down(offset, blksize);
+	bool			did_zero;
+
+	if (xfs_is_always_cow_inode(ip) ||
+	    !bdev_write_zeroes_unmap_sectors(
+		    xfs_inode_buftarg(XFS_I(inode))->bt_bdev))
+		return -EOPNOTSUPP;
+
+	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (error)
+		return error;
+
+	error = xfs_free_file_space(ip, offset, len, ac);
+	if (error)
+		return error;
+
+	/*
+	 * Zero the tail of the old EOF block and any space up to the new
+	 * offset.
+	 * In the usual truncate path, xfs_falloc_setsize takes care of
+	 * zeroing those blocks.
+	 */
+	if (offset_aligned > old_size)
+		error = xfs_zero_range(ip, old_size, offset_aligned - old_size,
+				NULL, &did_zero);
+	if (error)
+		return error;
+
+	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
+			new_size ? true : false);
+	if (error)
+		return error;
+
+	return error;
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1470,7 +1521,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1522,6 +1573,9 @@ __xfs_file_fallocate(
 	case FALLOC_FL_ALLOCATE_RANGE:
 		error = xfs_falloc_allocate_range(file, mode, offset, len);
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
+		error = xfs_falloc_write_zeroes(file, mode, offset, len, ac);
+		break;
 	default:
 		error = -EOPNOTSUPP;
 		break;
-- 
2.51.2

