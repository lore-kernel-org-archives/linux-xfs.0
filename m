Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D218621B43D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191628; cv=none; b=M3uUOIdHyBZgs512xiAXZqx/VKyl558ClFFNcxsKWPgi/30PXlhpZ6wtNL9aWw+M0/fqZokhwNod00U6aKf2uVZ1Q4wnsVu+fHWfAlOXTshc4YzLz2P/cFenxD/9KgvMemwNhbx7zB4f3zWPmgymI4OzScxGXbdLQPMKFPQtUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191628; c=relaxed/simple;
	bh=+AZH1LKe8aPQBU4xc6fm9RN4evSrRB3PvlLHQ3NJOXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ohT8hKt/+Kqr4z+XUiWYXVo24FidbshoWL4+LsHasKvhy3La44iP7K1W9KpR82rTa2NfyhI7HHMnZiqT5lNUz2FIBPDvwltvVBCNZD0g2sYWFP43u1Gd/GPQOfevYOBLzaYevnF7slDHGf+7KLXV1bGZJFJbb+1HctLvsJCQo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja9RYlQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja9RYlQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572C8C4CED0;
	Thu, 17 Oct 2024 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191628;
	bh=+AZH1LKe8aPQBU4xc6fm9RN4evSrRB3PvlLHQ3NJOXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ja9RYlQVS7S/hkEQ5/dQi9j16kGHGXaEKiwzypm3cfk16fv/mx4sbXY4Fm5fxokp7
	 mlNj2M2cvPpg6i9Qm6b6S1FF1mvDVb48NjBIr0ucZeLQUzohP+QwMeZckvzfBPW4H/
	 N9SAinfgeBJ+S+owQb92AomcHgMQeXFBR8bfaKGQLWzpSNGIg9zjmEQRibLbRl0Smb
	 kUsFVSxaw+Qd2ePZmc+m/KkDEslo+Cpz8XqdSOesgwEhziK7nq6YtnVZm3G+Cl+x31
	 usAkats0ykVSM67Bva7CbZ07mXZn1h+GqIxiLscJ+eKvNP8cIlVQvFQoFuxxii2+Fe
	 LQta0zzvudx2A==
Date: Thu, 17 Oct 2024 12:00:27 -0700
Subject: [PATCH 04/21] xfs: add a lockdep class key for rtgroup inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070465.3452315.9928120721277875984.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
index e3f167ce54793a..39e07e98eda1e5 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -198,3 +198,55 @@ xfs_rtgroup_trans_join(
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

