Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A58E192B69
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991141; cv=none; b=hRVV8PR/XmjuRsohh4e6BGGCfmDBBBLUeNGoeD4H4akGh7UtgSd/9vJr7JEKGK8Tr0OFAQZ0phw/PZmnyGb4JnmNN6XUmzMfdlhz0lemmSatIXmy3z3P/pi+wj20kNMz0plLg0iGjwJ5EsO28x3nXr9v91If9S9qXVGNfp01Bfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991141; c=relaxed/simple;
	bh=+gPB3NGlpKsC1ufGKfMH7tL3SdxodyIDGS9JHD3gfTk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CgpRGVtotuCD5mJfXW5+YFjJBcowRarIwGKxf49U2a07UV+BWPMeIlDmLcTW4oGIdi+YnvoAHr9vwZmzTpvsLPFaXAKHHbBgZ4OxRmJOeonUWuQF+vF8t7/9671K8hk11/Nh7j7U2lu6EKTBbg7/I3Mzs34YzOOoZndlQ8QqXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thplwQ35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thplwQ35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A593FC4CED3;
	Mon, 23 Dec 2024 21:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991140;
	bh=+gPB3NGlpKsC1ufGKfMH7tL3SdxodyIDGS9JHD3gfTk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=thplwQ35N0Rjy7qqFw0moXnF3Xk4K115wTznODrfx4oiOHwsXotX1P0gmtu5kpC3M
	 8YS82MyS66iIP7hOrDgDpAwBirGqCQ/YyBoWYdgaYkWRKcVn//NZjZDrVQmO/SMqvL
	 w4ATOi8J0kvW4Pcy9X6ipm6CsSHHhW9kF3rVrH/57tSv3SYFBjz4cvXXYzx4aCd1Ie
	 65w1Ie+ciIN3bwLSDAYVqJHJSH8+aW9GMu3HQwDfukBVudA4UYeCGV4UXQrnqAEK8q
	 IavSJJkqS9BqdStrpvh0ilGbltJ32coFXdPY7n2s1eLt7yfxrRgMvVykPVefsbbpwA
	 IcUnFxCIEtPNA==
Date: Mon, 23 Dec 2024 13:59:00 -0800
Subject: [PATCH 03/52] xfs: add a lockdep class key for rtgroup inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942541.2295836.7102479522630859326.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c29237a65c8dbfade3c032763b66d495b8e8cb7a

Add a dynamic lockdep class key for rtgroup inodes.  This will enable
lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
order.  Each class can have 8 subclasses, and for now we will only have
2 inodes per group.  This enables rtgroup order and inode order checks
when nesting ILOCKs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 5c8e269b62dbc4..ece52626584200 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -196,3 +196,55 @@ xfs_rtgroup_trans_join(
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

