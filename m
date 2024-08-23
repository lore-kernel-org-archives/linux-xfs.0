Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1D5AD59
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372283; cv=none; b=SrodOC+JkWGCft4PtsbyDfTzj8TjPF6x/19Gzk0pIEco5kGj0QF6QdkiL0Juf1OizpreZCZzYnH9ZmP6P2Ez2Rr6vsqlKMr78AQCHNmh4BXyLbsTc9GvC4vIaTwDxa30Yt8TyZ7oiH9Qf2yVHtvLKNyVwtGoHqYH/SC8Bxhkqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372283; c=relaxed/simple;
	bh=5vtQ6hRvDM9ILOUM86lV+047aqRF9n2dX+arbHuMzQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UdubtDqiQ0s1Tg7dF6D7wB7gABkgo0vf5aJI8lkUevWmG0OhhQc1BVbevSb1G5EELHNCUXgnA79YBtldMieFNlBngqY8vxwuYMfqAxayDRarf8i3uWPGN0hFAhaLqjEVksJhEcZ9jcfCFRIzDbQog7AgIh7mv61c9nEDZwE1kO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igg1ChLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igg1ChLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B92C4AF0E;
	Fri, 23 Aug 2024 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372283;
	bh=5vtQ6hRvDM9ILOUM86lV+047aqRF9n2dX+arbHuMzQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=igg1ChLmybMIgPQYxmO+o5jCa5VMW7MVT76PjyB0UvSzrRjC8/vPjEPIfXtIyK7vj
	 1FcgpUYuwkaoxxIvfTxai+7r7fHGyphBab1ZqJ9OfW7IZ25ya99ekuiL+fJrpe+9IC
	 Pq0UD+IFYmm8/D66DioXJEttwGo2ZzJmuIJRQXZsDW8SLwpT1r/TjUlZiBZAwsKd0A
	 InP8dbOJA7mp1mFGNcgG+X7PMOzjFzo1aMHPyKJF1+jIl0FmgXyhHxX0ATxhe7X5/w
	 zzTXLAvxsbmXIzbcWF8rLh+jNjQup1EGnzzVP3ZlMz3gGcLqFaKqZOs6RfbqunqTy/
	 2hevEgBwg1lmQ==
Date: Thu, 22 Aug 2024 17:18:02 -0700
Subject: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 51f04cad5227c..ae6d67c673b1a 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
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

