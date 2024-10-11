Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFFA4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608204; cv=none; b=GFt7v05qqfjsGf2xANQ+U+Q/jW7wSVv3p3s+GMj5Uz2Dxh3SxJyNqi62RUiWrFD8XFLqwcMYkZJ5eCmhaq+EAWGvWuuLKzQsPiyNWHGmT6fQfLgq7Dh6gTy6jM0RwCRlVB8oBWIcmV8HsmENv4vrPq0gdupf/f1uVBCRR+5Clvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608204; c=relaxed/simple;
	bh=oVKxRyD/mHpITBpUF2FIuPu969HgOXnmbaIEU5DKwo4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pn/Fl+7w+QRFKjNr1QA9RelrTqfcIS9KpvuoTLkCoA8PfmLXzHK2JAGj/UDgPHipfULueARHnN/dQIu2bWlBcuzO70KkxzwOD+2EeHG8MWfAkVeCmX6G/0BjDP8i/+8CN6T77CXzcHMn4qxf40HOoN91yTI/rbNxZgI8YwFWCgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMaWAkCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMaWAkCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F1EC4CEC5;
	Fri, 11 Oct 2024 00:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608204;
	bh=oVKxRyD/mHpITBpUF2FIuPu969HgOXnmbaIEU5DKwo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eMaWAkCMMCss7agX7bjuM6OwPNGZKyP2cPQSk5A0zSK4nQaLf79j0FbLuvGAJk16j
	 HqSLZVOYyltrC4LdeKquWL/0rKkeScYmtAKUB7T6wczD+cnT4F+Z1tsDUjQ8B+YyTF
	 Olrc1ddjHyMPCfSRpuJfIUQ3qWkr10xjnhy26UtDkq0BLmPbLROnrXEAX1jBi7v8PT
	 92XSCqwEHp7gTrVyIiA2rYr81O6EcfiDvMRFvlLCE14B6QtuG/Ri5/MnI2yX5NLU8O
	 nOdDFrilZkdhPphh364YlUImP3XcPQLAKUIO5AQCCxnTBmaP51tZ5TWPnsIwLrngnL
	 p4rbTWq0fEIDQ==
Date: Thu, 10 Oct 2024 17:56:43 -0700
Subject: [PATCH 04/21] xfs: add a lockdep class key for rtgroup inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643015.4177836.5196179299864426837.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a dynamic lockdep class key for rtgroup inodes.  This will enable
lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
order.  Each class can have 8 subclasses, and for now we will only have
2 inodes per group.  This enables rtgroup order and inode order checks
when nesting ILOCKs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 3eedc4a68a3acd..7d7608c38e0e37 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -176,3 +176,55 @@ xfs_rtgroup_trans_join(
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
 		xfs_rtbitmap_trans_join(tp);
 }
+
+#ifdef CONFIG_PROVE_LOCKING
+static struct lock_class_key xfs_rtginode_lock_class;
+
+static int
+xfs_rtginode_ilock_cmp_fn(
+	const struct lockdep_map	*m1,
+	const struct lockdep_map	*m2)
+{
+	const struct xfs_inode *ip1 =
+		container_of(m1, struct xfs_inode, i_lock.dep_map);
+	const struct xfs_inode *ip2 =
+		container_of(m2, struct xfs_inode, i_lock.dep_map);
+
+	if (ip1->i_projid < ip2->i_projid)
+		return -1;
+	if (ip1->i_projid > ip2->i_projid)
+		return 1;
+	return 0;
+}
+
+static inline void
+xfs_rtginode_ilock_print_fn(
+	const struct lockdep_map	*m)
+{
+	const struct xfs_inode *ip =
+		container_of(m, struct xfs_inode, i_lock.dep_map);
+
+	printk(KERN_CONT " rgno=%u", ip->i_projid);
+}
+
+/*
+ * Most of the time each of the RTG inode locks are only taken one at a time.
+ * But when committing deferred ops, more than one of a kind can be taken.
+ * However, deferred rt ops will be committed in rgno order so there is no
+ * potential for deadlocks.  The code here is needed to tell lockdep about this
+ * order.
+ */
+static inline void
+xfs_rtginode_lockdep_setup(
+	struct xfs_inode	*ip,
+	xfs_rgnumber_t		rgno,
+	enum xfs_rtg_inodes	type)
+{
+	lockdep_set_class_and_subclass(&ip->i_lock, &xfs_rtginode_lock_class,
+			type);
+	lock_set_cmp_fn(&ip->i_lock, xfs_rtginode_ilock_cmp_fn,
+			xfs_rtginode_ilock_print_fn);
+}
+#else
+#define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
+#endif /* CONFIG_PROVE_LOCKING */

