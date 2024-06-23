Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A3520E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120964; cv=none; b=pmzL3fXO3f7SqvePq+HKj4Qw0WnSTmfe++Med2FrSFaoq6wua8hP9GDY9QBJjvulOdxCXKEUM/7WOCZbDsAX61c6NQ41Jd58KBoaIdwH7RGZ1kqlyYc1q6s3JQplGH37EMyJs/z7DYDOuYXbfMaEVDsX3SKEDn9eXkD6OT35zho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120964; c=relaxed/simple;
	bh=Xa8X7DmNmvvBI+3BLcw4+/MYBQrq9Y8mwu6MOtxLbGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNJ2OjaI8JH2T9aJZtTvPs1FrsiXHklH1LmSFGQYd4Mke4X2L3plQuI3lJ5K51y0xsd2ADfOIui331kQ5RhqBAt9ug5c0mle+LpgcXMl8jaC2kteCp8gHBcWcRJ9Swkz+jXz2DuJLovIVB9mdjM5jEDv4ZeB5eQ9Nm8N/Vd/NG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BhqY2ePQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BhqY2ePQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ciLyMUR+tqJf1kco8npPGSIjJuVU20k7ydH1YSrLfXg=; b=BhqY2ePQG3YgjVkgwJKZvkdlTc
	89g35St5v/7YykGDFkllstUSUVgEFa1x8rAhsreDckn3VzzR5Um1cth9Cq70oeVEhW+Pr3csbx4zA
	DzREYVYHRKpd1PXqmP4uIliES3x/PApaD8E7NXv3s3RGKU7bPE7ZaXKuFg11cG2Nv8x6fwsOcq94u
	1ejBoDUAAG3f4DP4tGx+8py4j8HV2hqNV1xXI2t8Bt5JdJz+HiSHNnOlLAWmhx1+mYhAq0sd/Aicg
	5E4GuTRxV6jEOg5PkIwCH3mU4/OHsTX+R9GIFa92cQxl5npfPQI+ixKFuzLQdawak47jMvYMg7x7c
	/s4yJgAQ==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtS-0000000DOIP-12sH;
	Sun, 23 Jun 2024 05:36:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] xfs: only free posteof blocks on first close
Date: Sun, 23 Jun 2024 07:34:52 +0200
Message-ID: <20240623053532.857496-8-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
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
---
 fs/xfs/xfs_file.c  | 32 +++++++++++---------------------
 fs/xfs/xfs_inode.h |  4 ++--
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8d70171678fe24..de52aceabebc27 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1215,15 +1215,21 @@ xfs_file_release(
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
@@ -1241,25 +1247,9 @@ xfs_file_release(
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
index ae9851226f9913..548a4f00bcae1b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -336,7 +336,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
 #define XFS_INEW		(1 << 3) /* inode has just been allocated */
 #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
-#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
+#define XFS_EOFBLOCKS_RELEASED	(1 << 6) /* eofblocks were freed in ->release */
 #define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
@@ -383,7 +383,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_EOFBLOCKS_RELEASED | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
 	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
 
 /*
-- 
2.43.0

