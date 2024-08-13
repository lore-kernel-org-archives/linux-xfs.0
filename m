Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB22669DFF
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534820; cv=none; b=LZ32c3j8Gf+MpVYlY6mBe/pt3kFU8wj6m3ci/wl628INum5cHJxLc3m5XrjdqSuoecnXELUl/CkTh35233WANOcf1HSv7DNoRghSZM2VU82cfW7IQGd3IaSbs7PDVJ35+CP2Eea4wWkTyjnwAhIrxqU7D68KZ7Do9ydxJF4D+Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534820; c=relaxed/simple;
	bh=aM/WPl11H58JTmAWWCzx4g8EipOBoKHGlfb0riWuvbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdG4iyHb/ioaevibOX/7XZLaDUh/IdwoSZZV7LPOdEtDWZNSbNU9u94ikr5nO6eXuHt943veINnRDjyyu/cNocVVKQM8tk8dSRdPCZ5rr0YB18Vvpe30pEsbBGo8gXxl2FJaHq3SH/iTd5d54tZAgsrYJ3o7gBifg2R71V2TgV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hj7a8sk6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hj7a8sk6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TqjBvadcDJzqC2jtXCmwYVEUMaCBL6CCD10LTBau94E=; b=Hj7a8sk6Rhzc4UivbkOOXIdJnJ
	NunpUN2DXjq6Y6j61FDieLc84Ylp9LZhW480g0XBG17VwSnhq+I48pAiAt5/Ty1T2Djrd5SVjdLIs
	6CRncqxVT5qK6J54iGaonTvujCMR5fSsE8t6mtNF8pE71S9wCr95f1iy7WFCM3O9sDyIqoeuyJjQb
	lkUrDQouKzZPNstZeulfFv5pRXvpIbYwpCj16MNpmdgSb8Z9uwQqkqNVEWaEXgv2jFn31RO6WaEU5
	/GoQGnABA1d03tDAIiGHtp3Ftu/7dv0JZF7RUmqTJ5wWUWatMWktoB2PKEa8gx7Yv02t8OoOw/CF1
	huEWwE7Q==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8f-00000002lBE-3i0O;
	Tue, 13 Aug 2024 07:40:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: only free posteof blocks on first close
Date: Tue, 13 Aug 2024 09:39:39 +0200
Message-ID: <20240813073952.81360-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

Certain workloads fragment files on XFS very badly, such as a software
package that creates a number of threads, each of which repeatedly run
the sequence: open a file, perform a synchronous write, and close the
file, which defeats the speculative preallocation mechanism.  We work
around this problem by only deleting posteof blocks the /first/ time a
file is closed to preserve the behavior that unpacking a tarball lays
out files one after the other with no gaps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: rebased, updated comment, renamed the flag]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 32 +++++++++++---------------------
 fs/xfs/xfs_inode.h |  4 ++--
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 60424e64230743..30b553ac8f56bb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1204,15 +1204,21 @@ xfs_file_release(
 	 * exposed to that problem.
 	 */
 	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
-		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
+		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
 		if (ip->i_delayed_blks > 0)
 			filemap_flush(inode->i_mapping);
 	}
 
 	/*
 	 * XFS aggressively preallocates post-EOF space to generate contiguous
-	 * allocations for writers that append to the end of the file and we
-	 * try to free these when an open file context is released.
+	 * allocations for writers that append to the end of the file.
+	 *
+	 * To support workloads that close and reopen the file frequently, these
+	 * preallocations usually persist after a close unless it is the first
+	 * close for the inode.  This is a tradeoff to generate tightly packed
+	 * data layouts for unpacking tarballs or similar archives that write
+	 * one file after another without going back to it while keeping the
+	 * preallocation for files that have recurring open/write/close cycles.
 	 *
 	 * There is no point in freeing blocks here for open but unlinked files
 	 * as they will be taken care of by the inactivation path soon.
@@ -1230,25 +1236,9 @@ xfs_file_release(
 	    (file->f_mode & FMODE_WRITE) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
-			/*
-			 * Check if the inode is being opened, written and
-			 * closed frequently and we have delayed allocation
-			 * blocks outstanding (e.g. streaming writes from the
-			 * NFS server), truncating the blocks past EOF will
-			 * cause fragmentation to occur.
-			 *
-			 * In this case don't do the truncation, but we have to
-			 * be careful how we detect this case. Blocks beyond EOF
-			 * show up as i_delayed_blks even when the inode is
-			 * clean, so we need to truncate them away first before
-			 * checking for a dirty release. Hence on the first
-			 * dirty close we will still remove the speculative
-			 * allocation, but after that we will leave it in place.
-			 */
+		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
 			xfs_free_eofblocks(ip);
-			if (ip->i_delayed_blks)
-				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
 		}
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6ec83fab66266a..2763a9ffa643db 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -335,7 +335,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
 #define XFS_INEW		(1 << 3) /* inode has just been allocated */
 #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
-#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
+#define XFS_EOFBLOCKS_RELEASED	(1 << 6) /* eofblocks were freed in ->release */
 #define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
@@ -382,7 +382,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_EOFBLOCKS_RELEASED | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
 	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
 
 /*
-- 
2.43.0

