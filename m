Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955E0148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529129; cv=none; b=alPSgStjynKlaUK5U3deoSfwfCybChObKx83ZldiVkXSU1fliwx987+7iYiMqCzDlMgUy9tVJI0wr2CZ9lw2hN7b9XGWsEPp2fR//3sXc/Wp9MXqgx4TgkIs6zFj60N2Aiee2s3632SOfcyXJ+y2/oDYX4qKTKfPQiBxQcX86BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529129; c=relaxed/simple;
	bh=+gPB3NGlpKsC1ufGKfMH7tL3SdxodyIDGS9JHD3gfTk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbNw/nYEnrajcVIcw62XT8nbZTaoA7V7mquoeH0RtCUyRoa0lrKuYsiPOA6H8YQVTQBB6zM9HMVq6XFYMjXTrdm+w5gGJBXyjdB2apSo+dEti5IIzKS060P0D30vf5+UFliekHidk0BwtLsamom682LeeUjfAZzeX+sndx2+hX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doZNvCks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doZNvCks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E68C4CED1;
	Fri,  6 Dec 2024 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529129;
	bh=+gPB3NGlpKsC1ufGKfMH7tL3SdxodyIDGS9JHD3gfTk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=doZNvCksfQPNVvW9dveCrbYa13ijD4H9QWuW1XaciFbcsjY1JIrAx01FPoyjsAnmx
	 3NFZEUCHnqxSTXueX0jJCtlFZM01MEYqrPOhBlV52cBFVQD5EcF7wCjYozeiO5pmTA
	 TBJ2i0uq+VNqHj4UZOM7U7HDzPNMgw2Pdr5Gt8QbfQuH5Ux+RBfPuyv0T7CnKb8BOY
	 sFA6HP00JlHwT4RPka4y81oLVCFO1N/4dJ/T6JyJlHtsED84RNBj9Bn0uZDgEm3Sjr
	 UDMSabJBj4zuaA1qjSYDXg5js5IZXia/npoE3VIpG79iHATZdTbSIgIP2kvDkUzh8C
	 KelYIIovj/lyw==
Date: Fri, 06 Dec 2024 15:52:09 -0800
Subject: [PATCH 03/46] xfs: add a lockdep class key for rtgroup inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750040.124560.1090788433633647088.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

