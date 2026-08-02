Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC001A9FB0
	for <linux-xfs@vger.kernel.org>; Sun,  2 Aug 2026 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785683948; cv=none; b=eJ9v5VxJXAXEgAcCSTkQrDowPe15UkGxaI52ojpn2/u0Qr/MgTCT5Q/1KKUTBK8C1LC/OHWKwE+yxIXGrYt5/VZ1sxDuMPaaD1TY+cJ4YhpoEnFbkKWfSvVbaUPhwePV0QEuFWWIjXE2cmdcnX/qU/AqXpI0I1Bxm8tKHkfEgNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785683948; c=relaxed/simple;
	bh=TtaeN+y83XFnrdAk5npQW10/YjxYNBaNdmK9Sis5VW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IHzl8WLOIt6Wrh/MhnrMajdGaMWPsGpqJ1nA+CfbFBWAxOaO8Fwm0WwcAWnZv9LsVp1Tsvrm8UMV3hvw2TS+jHwkIygJOVl+kvKfIlU7TjnZqaJiD+wXRKF7PWBx3L3T/9QrBVZ/0fGiSQiTiMy0QzQqvWDbZkDwT1IxmmKhhIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=suLdVuEH; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="suLdVuEH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785683945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NwzdByNZLFbkh+/I6SaSghJs9NJlicBrG5HzeXfLDyk=;
	b=suLdVuEHcJDCscMtq7kCpEWS0dh0LlwjjMvHzE4OXe85MLksE+VAP3Zls89/mwzZK6LKHe
	AEELVldam+cAL0mSCkLIsE+KQUCtZJUEV+XMY+C+p7ZQaYOneIwqxOXiLNXYQ72Fdo69BR
	YXWiZQ1yMsWZeP95UsPQYFUCCslF1Ik=
From: Huiwen He <huiwen.he@linux.dev>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH] xfs: avoid false ENOSPC for fully allocated fallocate ranges
Date: Sun,  2 Aug 2026 23:17:54 +0800
Message-ID: <20260802151754.50459-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Fallocate can fail when extending EOF over a range previously
allocated with KEEP_SIZE.

For example, on an XFS filesystem with 7G total capacity:

  $ df -h .
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/loop0      7.0G  169M  6.8G   3% /mnt/test

  $ xfs_io -f -c "falloc -k 0 4G" file
  $ xfs_io -c "falloc 0 4G" file
  fallocate: No space left on device

The first fallocate has already allocated the whole 4G range and leaves
about 2.8G free. The second fallocate should only extend EOF without
allocating more data blocks.

However, xfs_alloc_file_space() reserves space before xfs_bmapi_write()
checks the existing mappings. The second 4G reservation therefore
fails with ENOSPC.

Fix this by walking the existing mappings first. Skip written and
unwritten real extents, and call xfs_alloc_file_space() only for holes
or delayed-allocation extents. Factor this into
xfs_falloc_allocate_space(), shared by the allocate-range and
unshare-range paths.

After this change, both operations succeed:

  $ xfs_io -f -c "falloc -k 0 4G" file
  $ xfs_io -c "falloc 0 4G" file
  $ xfs_io -c "falloc -u 0 4G" file

Reported-by: Paulo Alcantara <pc@manguebit.org>
Link: https://lore.kernel.org/linux-cifs/97c0ca61c2bed2d2559b32b7ed967121@manguebit.org
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
Testing:
  - All supported tests in the xfstests prealloc and unshare groups
    passed.

 fs/xfs/xfs_file.c | 57 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..bfb37a73661a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1413,6 +1413,59 @@ xfs_falloc_zero_range(
 	return xfs_falloc_setsize(file, new_size);
 }
 
+/*
+ * Allocate only mappings that are not already backed by physical blocks.
+ * This avoids reserving data space for real extents before
+ * xfs_bmapi_write() discovers the existing mappings.
+ */
+static int
+xfs_falloc_allocate_space(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	imap;
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + len);
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
+	lock_mode = xfs_ilock_data_map_shared(ip);
+	while (start_fsb < end_fsb) {
+		xfs_filblks_t		count_fsb = end_fsb - start_fsb;
+		int			nimaps = 1;
+
+		error = xfs_bmapi_read(ip, start_fsb, count_fsb, &imap,
+				       &nimaps, 0);
+		if (error)
+			break;
+		if (XFS_IS_CORRUPT(mp, nimaps != 1 ||
+				   imap.br_startoff != start_fsb ||
+				   !imap.br_blockcount ||
+				   imap.br_blockcount > count_fsb)) {
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		start_fsb += imap.br_blockcount;
+		if (xfs_bmap_is_real_extent(&imap))
+			continue;
+
+		xfs_iunlock(ip, lock_mode);
+		error = xfs_alloc_file_space(ip,
+					     XFS_FSB_TO_B(mp, imap.br_startoff),
+					     XFS_FSB_TO_B(mp, imap.br_blockcount));
+		if (error)
+			return error;
+		lock_mode = xfs_ilock_data_map_shared(ip);
+	}
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
 static int
 xfs_falloc_unshare_range(
 	struct file		*file,
@@ -1432,7 +1485,7 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_falloc_allocate_space(XFS_I(inode), offset, len);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1460,7 +1513,7 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_falloc_allocate_space(XFS_I(inode), offset, len);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.43.0

