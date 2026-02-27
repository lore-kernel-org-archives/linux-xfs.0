Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC41A9FAF
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201342; cv=none; b=LRHIBGvnWnhL7IM+0ESz85x2GMooj5NZLsAHg6VMBpOnwK80JvLcDEv3gNE0/udF2qh1MiGaQ2H86n1CYdSUim1gem9sZ66yxGVN4gADYv4LlqZtns7+TWZ7Sy0/WMzaTt6QhEQAyDiN2uwR4hkeYGtRbjo0A7cUehD+XyeUtew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201342; c=relaxed/simple;
	bh=gTWSujNQM48ImQs+R3U9F8Jskw7l5VnB/kmeWCqB7/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK5jqipJ/zixk0j36xdQZJVfGLdjWA2oE+egqEIXgZcJ8uHgweIllyyzSB5tepOk0MKCe2N6mzpHHW5I3wM0iE/JVZDQELi9jwQyh31bTp9Suml5F1HlgX2EQ9WNpZb2Uw2/zDfSazFnrHXBuc+y7PRRW16TYznCQkEPqD3r4fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4fMqtx2Qzyz9sSf;
	Fri, 27 Feb 2026 15:08:57 +0100 (CET)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	dchinner@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	cem@kernel.org,
	hch@infradead.org,
	lucas@herbolt.com
Subject: [RFC 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Date: Fri, 27 Feb 2026 15:08:42 +0100
Message-ID: <20260227140842.1437710-3-p.raghav@samsung.com>
In-Reply-To: <20260227140842.1437710-1-p.raghav@samsung.com>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4fMqtx2Qzyz9sSf

If the underlying block device supports the unmap write zeroes
operation, this flag allows users to quickly preallocate a file with
written extents that contain zeroes. This is beneficial for subsequent
overwrites as it prevents the need for unwritten-to-written extent
conversions, thereby significantly reducing metadata updates and journal
I/O overhead, improving overwrite performance.

When handling FALLOC_FL_WRITE_ZEROES, we first allocate unwritten
extents. This ensures that xfs_falloc_setsize() does not trip over a
written extent beyond i_size and trigger warnings in iomap_zero_range().
After the size is updated, we call xfs_alloc_file_space() again with the
XFS_BMAPI_CONVERT and XFS_BMAPI_ZERO flags to convert the unwritten
extents to written and offload the write zeroes operation to the device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_file.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3bd099534c68..38688cdf4cdc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1308,6 +1308,59 @@ xfs_falloc_force_zero(
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
+	unsigned int		blksize = i_blocksize(inode);
+	loff_t			new_size = 0;
+	int			error;
+
+	if (!bdev_write_zeroes_unmap_sectors(
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
+	len = round_up(offset + len, blksize) - round_down(offset, blksize);
+	offset = round_down(offset, blksize);
+
+	/*
+	 * Allocate unwritten extents first. This ensures that xfs_falloc_setsize
+	 * does not trip over a written extent beyond i_size and trigger warnings
+	 * in iomap_zero_range.
+	 */
+	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
+	if (error)
+		return error;
+
+	error = xfs_falloc_setsize(file, new_size);
+	if (error)
+		return error;
+
+	/*
+	 * Now convert the unwritten extents to written and zero them out using
+	 * unmap write zeroes.
+	 */
+	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1410,7 +1463,7 @@ xfs_falloc_allocate_range(
 		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
 		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
-		 FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 STATIC long
 __xfs_file_fallocate(
@@ -1462,6 +1515,9 @@ __xfs_file_fallocate(
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
2.50.1

