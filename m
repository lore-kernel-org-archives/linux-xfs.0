Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4768225A342
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185446; cv=none; b=SPxwBm2qh7r1K/2dyOsYsdCjcYUuZuCht3wduDbAbeJezk6GZob1Q1opfHcW6DajZjfVxU1sbJa2qr5z9QpsQCE3f9fHLeAFh0nIvKFpeP7r/pg6OFd+oyfAhBsqJjUVs4aRCdH+EOZzFj3IXbNcZht/iUmUXApKSSZT7+FWocI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185446; c=relaxed/simple;
	bh=x/oubIQD7mSwlRZ+funw7homoz5Y4KYRaAv3IZb7WTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KY4pMbXOM6P33YvVcriXO4M+VTbD4kafhq+AkSeJChLQPkEnA1lT/smPHMCwKvOzpF6Gk8K3QNfITYSgSGUwp+Qfqkes1x24ASqw3Odz48xhhqXu+hqS+G9cLDLtICByc6EsvKtDZHE9Azh0dK95glMGIRtZhSm64OsKUWMbrSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZtnzkaOm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZtnzkaOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EsomPPC6LaUE9kZ+3vetb9qKTaQ3o066bHkvnHGDi0U=; b=ZtnzkaOmUju5RzkqbGN6Axv4yq
	qgURk1mPeOhdpK51TpK8IsewEPdFYDyeVk69DU/a2etoqzXWbp0RED4f9pnA0KJatpbRSOJRzMPaj
	uHp8dDDYJAPmxCyFNiZNAkc7jjmPdcrt7dgQYplOwvmywgO/3hgM4RbPuio/3dIngKHFhlQBU+pSB
	wu5i5FAqUb8Z8Kvg9Q0kwEZgO3pvYKb4IKHeRaF/l78Vw58egvwsNgTO8+LuHgDGp+3WqB9fVntoB
	xtMto0Cuvbu3TDmBPB4mARyUcHqd9oYSdJq5tz1XQOFkUMtaG077QORilyTCJDIH13QaoPy0yEDYQ
	Av+61Vuw==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJI-00000006UX1-2EjI;
	Wed, 09 Apr 2025 07:57:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/45] xfs: implement zoned garbage collection
Date: Wed,  9 Apr 2025 09:55:24 +0200
Message-ID: <20250409075557.3535745-22-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 080d01c41d44f0993f2c235a6bfdb681f0a66be6

RT groups on a zoned file system need to be completely empty before their
space can be reused.  This means that partially empty groups need to be
emptied entirely to free up space if no entirely free groups are
available.

Add a garbage collection thread that moves all data out of the least used
zone when not enough free zones are available, and which resets all zones
that have been emptied.  To find empty zone a simple set of 10 buckets
based on the amount of space used in the zone is used.  To empty zones,
the rmap is walked to find the owners and the data is read and then
written to the new place.

To automatically defragment files the rmap records are sorted by inode
and logical offset.  This means defragmentation of parallel writes into
a single zone happens automatically when performing garbage collection.
Because holding the iolock over the entire GC cycle would inject very
noticeable latency for other accesses to the inodes, the iolock is not
taken while performing I/O.  Instead the I/O completion handler checks
that the mapping hasn't changed over the one recorded at the start of
the GC cycle and doesn't update the mapping if it change.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_group.h   | 21 +++++++++++++++++----
 libxfs/xfs_rtgroup.h |  6 ++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index a70096113384..cff3f815947b 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -19,10 +19,23 @@ struct xfs_group {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
-	/*
-	 * Track freed but not yet committed extents.
-	 */
-	struct xfs_extent_busy_tree *xg_busy_extents;
+	union {
+		/*
+		 * For perags and non-zoned RT groups:
+		 * Track freed but not yet committed extents.
+		 */
+		struct xfs_extent_busy_tree	*xg_busy_extents;
+
+		/*
+		 * For zoned RT groups:
+		 * List of groups that need a zone reset.
+		 *
+		 * The zonegc code forces a log flush of the rtrmap inode before
+		 * resetting the write pointer, so there is no need for
+		 * individual busy extent tracking.
+		 */
+		struct xfs_group		*xg_next_reset;
+	};
 
 	/*
 	 * Bitsets of per-ag metadata that have been checked and/or are sick.
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 5d8777f819f4..b325aff28264 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -58,6 +58,12 @@ struct xfs_rtgroup {
  */
 #define XFS_RTG_FREE			XA_MARK_0
 
+/*
+ * For zoned RT devices this is set on groups that are fully written and that
+ * have unused blocks.  Used by the garbage collection to pick targets.
+ */
+#define XFS_RTG_RECLAIMABLE		XA_MARK_1
+
 static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
 {
 	return container_of(xg, struct xfs_rtgroup, rtg_group);
-- 
2.47.2

