Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009B01B86C3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173532; cv=none; b=u8pinfswQ3Ebm1wXal3oQnql2XKVO6yYCPyuDFaJQAoX2jJ5mTXEInkAfq9oBnGXxgslSFlhJq50VaYPX0VX61NzGd7luNsCRtikM/MUavG39wEdbbFBtm1dZ9NtJJpMm+4fungGG2oIq2ae3xYoJCOlzJFViyk1vvnSpSk8i90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173532; c=relaxed/simple;
	bh=4S68yRZAbrqjqy5nqsT3325CdFnhJlYAGxpYsZTGy+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTaBnn2vAZN8IIUSDSXMNF4UtG0yEWhlRdNmXgxYOo0646Cu0E3FYBOdbg0sYTFyslVyM39cfzZQqJKDdzMw6E3ucHbJQ1c2ADSP5AO1+xu2Pc74rMa12yXNUOEG4sMbR/g7Ybp173iGw0Y8sdg0VWp9Zt8O4XWdD22y/ZSOQGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1607SyVT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1607SyVT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r190iGrAVCQFjs0PC9VjPB1pYaGSjXIoZSjjiHA6uuA=; b=1607SyVTt2HDTIFdyu/FXxbf4u
	3ov3Ffq+HiF8J8o9NgLKzu3veIkCe/0HlwY5qYs4HevrSpWPti6mP9DAhtijCFvbFEEXzs/oCwjtW
	DBGgExk8y4tIH4nddbngtK9zzsdHkz2EwredxaXpvgcHfYoyvPQ1E+rhZC8CTwI0zIYkPQkUODE3k
	MkV6df6J3BRs9zKmxhsX0vBqoeM/Vlsepjic/ITQMWRXZnlowhDh41AYy7IEyzvlkJ9KSnxjLCwqj
	PEuibhNTn0P8O2PYdVre74LbUlJoLb14/V66y9dC6HP+ldse6PCVO7X7ZC6Xn/jidJvZRiuds0p5N
	/0OHzZ+w==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgSIU-000000066aq-0lP9;
	Tue, 20 Aug 2024 17:05:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
Date: Tue, 20 Aug 2024 19:04:54 +0200
Message-ID: <20240820170517.528181-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240820170517.528181-1-hch@lst.de>
References: <20240820170517.528181-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_attr3_leaf_split propagates the need for an extra btree split as
-ENOSPC to it's only caller, but the same return value can also be
returned from xfs_da_grow_inode when it fails to find free space.

Distinguish the two cases by returning 1 for the extra split case instead
of overloading -ENOSPC.

This can be triggered relatively easily with the pending realtime group
support and a file system with a lot of small zones that use metadata
space on the main device.  In this case every about 5-10th run of
xfs/538 runs into the following assert:

	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);

in xfs_attr3_leaf_split caused by an allocation failure.  Note that
the allocation failure is caused by another bug that will be fixed
subsequently, but this commit at least sorts out the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c  | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bcaf28732bfcae..92acef51876e4b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1334,6 +1334,9 @@ xfs_attr3_leaf_create(
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
+ *
+ * Returns 0 if the entry was added, 1 if a further split is needed or a
+ * negative error number otherwise.
  */
 int
 xfs_attr3_leaf_split(
@@ -1390,7 +1393,7 @@ xfs_attr3_leaf_split(
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
 	if (!added)
-		return -ENOSPC;
+		return 1;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 16a529a8878083..17d9e6154f1978 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -593,9 +593,8 @@ xfs_da3_split(
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
-			if ((error != 0) && (error != -ENOSPC)) {
+			if (error < 0)
 				return error;	/* GROT: attr is inconsistent */
-			}
 			if (!error) {
 				addblk = newblk;
 				break;
@@ -617,6 +616,8 @@ xfs_da3_split(
 				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
+			if (error == 1)
+				return -ENOSPC;
 			if (error)
 				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;
-- 
2.43.0

