Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349344E658
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319634; cv=none; b=CaGYvrOP2woBS6ViD+wyS3vYDm1kTh4ObMEuQOk0ZAI1fLs45A/QNrtBOQA1cd50k0KmgoTKlYwE4AM/L7chMStvCH8yPNOucnDpagYsk5SZsJ6h5PCWP+8YY8HiKNFUpGq8MMPy7aGKfrnn4nUDAfS3W2nIaH+OMsn8qaasIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319634; c=relaxed/simple;
	bh=aL5FIvggNMvMo11p8BAuB+ZzsY6IP/Ieo/AOw6Jevpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1M0u0u98q7sGyjfek2zhZEWlegmhXwd++9cWkPWfSGsSuxTYt11+6j0cnFwMeGGldsjUOABAHYS0DfujJ7OWDc4dJ+jf3MeYlqm6aNa+G08Wa+xhtfwcxMFnrTfzzn3cuPtnWd9WoHs388D7b83iO3peuIa3pyXrGNDXUZOJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIeed78g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIeed78g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF511F00A3D;
	Wed, 29 Jul 2026 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319633;
	bh=CZAqngDmJMh3JAHvCaHOJmJT0VRbhSdRA3VKQb712x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIeed78g6/QSnCDUYJ5dtJeNgO78ISg71PYrnQrOcUlGo0NT1BImQGa5OtVlXX5Gw
	 iJnzsMDElrxWbmUaoaquODaXyrXGVq9aL3Kozepsi4eBgtJcsDgxNEYGnA+3iHw40c
	 9Y8OySvuyp9kmETBdXTA5bzC9N7yhej4w7kqi4uQfz0f6h8H08qyWuMfxtkqkRC73v
	 zTQw1HucJc/BK8v0KBLVMkbateWJ58qOMyDMejR1eKIgAkd5sWTfcdZQxm4whKIgwM
	 8OAwihNKVKuKJp2dxwYoGVcEQSmiF2cdbnmRHfJKpynQ75p8LdKLZEDoXMszxu1TXx
	 3Zxdd4O92F7/w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 32/33] xfs: make pNFS block allocation atomic with inode update
Date: Wed, 29 Jul 2026 20:02:16 +1000
Message-ID: <20260729100629.1943710-33-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restructure xfs_fs_map_blocks() to perform the extent allocation
and inode update in a single synchronous transaction, making the
operation atomic with respect to the ILOCK.

Previously the function used two separate transactions: one for
the extent allocation (via xfs_iomap_write_direct) and one for the
inode update (xfs_fs_map_update_inode), followed by an explicit
log force to ensure persistence.

Now the function uses a do {} while (!dwa.tp) loop to allocate a
transaction and re-read the mapping atomically. The inode update
(SUID/SGID strip, timestamps, PREALLOC flag) is performed in the
same transaction as the allocation, and the transaction is committed
synchronously via xfs_trans_set_sync().

xfs_fs_map_update_inode() is converted to take a transaction
parameter and no longer allocates or commits its own transaction.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 124 +++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 495e081838d0..37194e62d3cb 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -88,29 +88,17 @@ xfs_fs_get_uuid(
  * is from the client to indicate that data has been written and the file size
  * can be extended.
  */
-static int
+static void
 xfs_fs_map_update_inode(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_writeid,
-			0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	VFS_I(ip)->i_mode &= ~S_ISUID;
 	if (VFS_I(ip)->i_mode & S_IXGRP)
 		VFS_I(ip)->i_mode &= ~S_ISGID;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp);
 }
 
 /*
@@ -127,6 +115,10 @@ xfs_fs_map_blocks(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_direct_write_args dwa = {
+		.ip		= ip,
+		.iomap		= iomap,
+	};
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	loff_t			limit;
@@ -182,61 +174,67 @@ xfs_fs_map_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
+	/*
+	 * Extent allocation requires a transaction. If we find a hole, drop
+	 * the ILOCK, allocate a transaction and re-read the mapping so we
+	 * don't use a stale imap for determining the allocation.
+	 */
 	lock_flags = xfs_ilock_data_map_shared(ip);
-	/* request mappings for the specified range only */
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, 0);
-	if (error) {
-		xfs_iunlock(ip, lock_flags);
-		goto out_unlock;
-	}
-	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
-
-	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
-		if (offset + length > XFS_ISIZE(ip))
-			end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
-		else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
-			end_fsb = min(end_fsb, imap.br_startoff +
-					       imap.br_blockcount);
-		xfs_iunlock(ip, lock_flags);
-
-		{
-			struct xfs_direct_write_args args = {
-				.ip		= ip,
-				.offset_fsb	= offset_fsb,
-				.count_fsb	= end_fsb - offset_fsb,
-				.offset		= offset,
-				.length		= length,
-				.imap		= imap,
-				.iomap		= iomap,
-			};
-
-			error = xfs_iomap_write_direct(&args);
-		}
+	do {
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+					&imap, &nimaps, 0);
 		if (error)
-			goto out_unlock;
+			goto out_cancel;
+		ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
+		if (!write || (nimaps &&
+			       imap.br_startblock != HOLESTARTBLOCK)) {
+			seq = xfs_iomap_inode_sequence(ip, 0);
+			error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
+			goto out_cancel;
+		}
 
-		/*
-		 * Ensure the next transaction is committed synchronously so
-		 * that the blocks allocated and handed out to the client are
-		 * guaranteed to be present even after a server crash.
-		 */
-		error = xfs_fs_map_update_inode(ip);
-		if (!error)
-			error = xfs_log_force_inode(ip);
-		if (error)
-			goto out_unlock;
+		if (!dwa.tp) {
+			xfs_iunlock(ip, lock_flags);
+			error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+					0, 0, false, &dwa.tp);
+			if (error)
+				goto out_unlock;
+			lock_flags = XFS_ILOCK_EXCL;
+		}
+	} while (!dwa.tp);
+
+	if (offset + length > XFS_ISIZE(ip))
+		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
+	else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
+		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
+
+	dwa.offset_fsb = offset_fsb;
+	dwa.count_fsb = end_fsb - offset_fsb;
+	dwa.offset = offset;
+	dwa.length = length;
+	dwa.imap = imap;
+	error = xfs_iomap_write_direct(&dwa);
+	if (error)
+		goto out_cancel;
 
-	} else {
-		seq = xfs_iomap_inode_sequence(ip, 0);
-		xfs_iunlock(ip, lock_flags);
-		error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
-	}
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	*device_generation = mp->m_generation;
-	return error;
+	/*
+	 * Update the inode and commit synchronously so that the blocks
+	 * are guaranteed persistent before being handed to the client.
+	 */
+	xfs_fs_map_update_inode(dwa.tp, ip);
+	xfs_trans_set_sync(dwa.tp);
+	error = xfs_trans_commit(dwa.tp);
+	dwa.tp = NULL;
+
+out_cancel:
+	if (dwa.tp)
+		xfs_trans_cancel(dwa.tp);
+	xfs_iunlock(ip, lock_flags);
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	*device_generation = mp->m_generation;
 	return error;
 }
 
-- 
2.55.0

