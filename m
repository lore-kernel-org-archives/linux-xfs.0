Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271769;
	b=azxlxYgWmsyEI/50F+8ifQbzxLDb6ZoPRUFXRgPZWpVOv0oB7hDSW1NUaC/aZseGEXuh
	 +cots0Qdru/+lUCQosWbstiHaIPrPj5tOR+MNKNfjeJuCzIdIhpBD9r6jMtneOx7vXedW
	 jDaekgQIlqHh5IgQltx4fFtlw3bX6S3pp0/TQG0n8ruu3+cs4DLQaBxT1UGF6D6f2/GvN
	 23eGWa7qywh/am+vrw4rxTFLvKXZL40HjtNjNWCOcXWMnSPFnC0oljBqF7vR12izwWB1h
	 RJC1cZBIMpRtTERP8OSx6YGBGGyPuyApAF639F3y1cFSrM/VHLIxbSEbIrr/jEDAnmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=Q8M8fsB1VxEWSSz5VwuNz+5s/n+Oe9eTaZl2B1fEwQQ=;
	b=gtPKEjyqHM9cF7aqdKNZDrG99c5OfIt23TUurRyELLXweZgha/aIzD1JGnrlO/+8xWs8
	 STnjDOmGKoJa3BUR3QDWWeOCGCzXKrzZ3nDYCrax038ovcWS9LeaiBjCOqo8oaUMx2Xat
	 3R7/4OZx1RcTYtpCXxkBbOKCBO0RCwKg7CzwRjYgqmALskn2PlNNctDADQ1+jThZMkBLN
	 6EPIn53biriTr2/IT5jnFuE7WvxybRD/05PekH1fFMIfJ8ANC3ijfyn8iZ3nbtodkXBoJ
	 AtuZFkNfZzV+YTF9Tzp2CACJFfIYIs6SRkIF5Mg2kyp4CocNctW+Kbk6t/GUicwm90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKvxzSwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1833F60A2600;
	Tue, 10 Nov 2026 00:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKvxzSwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C741F008A6;
	Tue, 10 Nov 2026 00:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271769;
	bh=Q8M8fsB1VxEWSSz5VwuNz+5s/n+Oe9eTaZl2B1fEwQQ=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=VKvxzSwgqR4QtM6Kxgz16TMk41iAPEZciytTTnX5c8D9vsHtu4HtdohsfySEOM/zN
	 QTvNTej6PUj2P9aCJJlVh6wPQk9pPRZTmG/wOO9yqpspNh2BGk91K2cXYRgN47AmLT
	 y3shapts0UYpDmRvtDDIdGutseniciua4yIbay17SzHwiWgFvDxvVFTSk06GuCfvTt
	 0bu+72UoZQjOeYS8aE+US8InOIT6/UNJqmTfHNy4Sup1yXWmyBQKXQuOpo+vaxpjBV
	 ycUrMw0UmH1m8robXsCbGjBCtuu5HYjOqWUrLYdY0Xcn/eUlmEtkRbsqyCXZ47o7oK
	 DzEY8i8WiF7Cg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: mark the inode preallocated for pNFS write layouts past EOF" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:27 -0500
Message-ID: <20261110004927.3538730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: mark the inode preallocated for pNFS write layouts past EOF

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-mark-the-inode-preallocated-for-pnfs-write-layou.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a97d1000928b4113f027564b9d54e83a92e160b8
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:22:58 2026 +0900

    xfs: mark the inode preallocated for pNFS write layouts past EOF
    
    [ Upstream commit 8b8e265991556d99b6d721697f148975a7c68767 ]
    
    xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC only when it
    allocates blocks for a write layout. A write layout past EOF can also
    hand out allocated blocks, such as speculative preallocation. blockgc
    then frees them under the layout, and another file may get them.
    
    Mark the inode whenever a write mapping ends past EOF.
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Reported-by: Chuck Lever <cel@kernel.org>
    Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 38d23f0e703a8..d74133c3d784d 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -101,7 +101,15 @@ xfs_fs_map_update_inode(
 	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * Force the log so that the blocks handed out to the client are
+	 * guaranteed to be present even after a server crash.
+	 */
+	return xfs_log_force_inode(ip);
 }
 
 /*
@@ -126,6 +134,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -194,20 +203,27 @@ xfs_fs_map_blocks(
 				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
+		update_inode = true;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 
 		/*
-		 * Ensure the next transaction is committed synchronously so
-		 * that the blocks allocated and handed out to the client are
-		 * guaranteed to be present even after a server crash.
+		 * Blocks past EOF that were allocated for buffered writes, such
+		 * as speculative preallocation, can be freed by
+		 * xfs_free_eofblocks() without breaking the layout unless the
+		 * inode is marked as preallocated. Mark it before handing them
+		 * out for writing, as for blocks allocated above.
 		 */
+		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+		    imap.br_startoff + imap.br_blockcount >
+		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			update_inode = true;
+	}
+
+	if (update_inode) {
 		error = xfs_fs_map_update_inode(ip);
-		if (!error)
-			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
-
-	} else {
-		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
