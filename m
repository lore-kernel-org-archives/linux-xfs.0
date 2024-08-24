Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC6026AFB
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470871; cv=none; b=svnPTtXxAueofcRkl7JGw+25233dZR9LE7Fq1ue0XctTrCk+U5LXBLeIYpzSjxIrr6fNLeE5a+WqZeE/U6f3/blbl/7eZXg0Mma0KhTW5kp8O7OtiBoDiNDWVOoJuA02antvoIITsZLKRNdeBbI1o3TzjfWS1N17KP3jRZefJbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470871; c=relaxed/simple;
	bh=F4ulWzTOBsK0zxu59h+Fp+pEWmKVBI31W8TTEUML9IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmP6kefgRT2euh3SUgBBOn4tsdq0eq5YCgIM3MKMvhpO01lgHbn9N9GmXdrOkh4CVr4+xeeVf4qEMQkBBzjkh5hCkh36QLiHfiOt1cQq/Gq8yMsO1iQwjUmQNl1QD6iqDS/Uj0QR5OrrkC4PkKl8qDG1YC80dqpJHJ0ukSZY9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bqnaGHIx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bqnaGHIx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RWGoCOPeteOdMMMpAbf5O7z50dypjnEphGeiTr5gjDU=; b=bqnaGHIxL/yCXwiE4CUwwNDkH8
	9ZbyLAG7DlpHcUEx2TGe6ig/ToogZKXHeZjnws9OniOp3ei3qPF4ckLlm5ZcIGssSrsYrcaIapsGZ
	HeCLCnyEr8wyJJURayM/zfF6zvkyDzu0uz44/+ewdpzkWem3YNBuLLA3Jj+BZJBafaJc2k0yFPXIe
	u88Ye/1tIkp2e4I5lFqAWmCYtiVJfdJRKHqAJ6PnCwnbLmansz+GUZPkzIxYmuaZReJSAOxLZwgK1
	KRMfSh07ml2U6WktzRnLJfb3P7MDtMra/qEgATU1ymAEJcMfKhOa5b/JYmKH4Hy4h553LdNZoL7Ly
	wi2OjCaQ==;
Received: from 2a02-8389-2341-5b80-7457-864c-9b77-b751.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7457:864c:9b77:b751] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shheH-00000001MQW-1fzK;
	Sat, 24 Aug 2024 03:41:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
Date: Sat, 24 Aug 2024 05:40:09 +0200
Message-ID: <20240824034100.1163020-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824034100.1163020-1-hch@lst.de>
References: <20240824034100.1163020-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

