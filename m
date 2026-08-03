Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4113AC0CB
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 08:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747446; cv=none; b=u+Fnko85SKJdvGzeruy2BHBnZ2FJYf1PMQOBWpBXdbByE6AvZwI2wULSFdLihiSD8fXBoDvcFeyibw/f3RBL2GgkK9+tpKzycobhqxVnGJjD1EZ262x9eyqNvI+f+Bj2G+dfV76ms0wRXrRe1svcnbXORvCVQDcBHnecmtLYMoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747446; c=relaxed/simple;
	bh=7AXBt9B8kAdo1+kd26DHihTXYQ7VbHWWFxwwXbSt9Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IYvn7Rf2INF6hMOD1mHmc5Yuq+/kDHaaYGPZWPciJi67d1jnciTp773E8sbgddH8oOeXEWRzrCO/DJXa6ccEQ68wa27kh0T2mfPjNe5dX5kzHTBLVCqEO4FkoieskRPQaZB1WC4C4qpbrMBmMnPjo4pqWsewsWctncKGmc0cZCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AV/JRNno; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AV/JRNno"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785747438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jfoRf/yZtNvRWTO2I9Hy3qCaNsn4a7/3+rg+nBCMYP4=;
	b=AV/JRNno3P7W5Ux1AM+yKPwj5K05iTE7t7/WPhUc+tJ9MOJuTfd2oTk3KNrt25UOJ/9eKn
	yn7q9g9dgq5vOAOOM3G/UZhlrsegbuo4xAn+fyqDSU5BL7F/cP3VYr5enrnOpaqIhj/BUL
	j0Hdy5IZjkmA1r4AsJJXr4Cu4LJeYrg=
From: Huiwen He <huiwen.he@linux.dev>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v2] xfs: avoid false ENOSPC for fallocate ranges with real extents
Date: Mon,  3 Aug 2026 16:56:15 +0800
Message-ID: <20260803085615.134619-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Fallocate can incorrectly return ENOSPC when the requested range
contains real extents. This was observed when extending EOF over a
range previously allocated with KEEP_SIZE.

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

The same problem can occur in the unshare path. Unaligned ZERO_RANGE
can also include real extents because its rounded preallocation covers
partial edge blocks left allocated after hole punching.

Fix this by walking the existing mappings first. Skip written and
unwritten real extents, and call xfs_alloc_file_space() only for holes
or delayed-allocation extents. Factor this into
xfs_falloc_allocate_space(), shared by the zero-range, allocate-range,
and unshare-range paths.

After this change, the EOF extension, unshare, and ZERO_RANGE commands
below succeed:

  $ xfs_io -f -c "falloc -k 0 4G" file

  # EOF extension succeeds.
  $ xfs_io -c "falloc 0 4G" file

  # Unshare succeeds.
  $ xfs_io -c "falloc -u 0 4G" file

  $ xfs_io -f -c "pwrite -S 0x5a 0 4K" allocated
  $ dd if=/dev/zero of=filler bs=4K status=none
  dd: error writing 'filler': No space left on device

  # Unaligned ZERO_RANGE succeeds.
  $ xfs_io -c "fzero 1 4094" allocated

Reported-by: Paulo Alcantara <pc@manguebit.org>
Link: https://lore.kernel.org/linux-cifs/97c0ca61c2bed2d2559b32b7ed967121@manguebit.org
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
Changes since v1:
- Use xfs_falloc_allocate_space() in xfs_falloc_zero_range() to avoid
  false ENOSPC for real edge extents in unaligned ZERO_RANGE requests.
- Add an unaligned ZERO_RANGE test to the commit message.

Link to v1:
https://lore.kernel.org/linux-xfs/20260802151754.50459-1-huiwen.he@linux.dev/

 fs/xfs/xfs_file.c | 59 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..17e6316c58db 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1368,6 +1368,59 @@ xfs_falloc_force_zero(
 	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
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
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1406,7 +1459,7 @@ xfs_falloc_zero_range(
 		len = round_up(offset + len, blksize) -
 			round_down(offset, blksize);
 		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+		error = xfs_falloc_allocate_space(ip, offset, len);
 	}
 	if (error)
 		return error;
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

