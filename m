Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kRthK8Y4"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BCAFA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WfmothldDQrEgIWriX5jWo72i6h3hcRPpwQ3QVaw+OY=; b=kRthK8Y41kal+FesBHqTuxokRv
	9oJPCQG3peAEC/+i3Kxk5KIuGRbFAHzbOhbE+JKXZiDFrRcHvaQ6dX73Ed14AcsG/alfwEXJ1zcTL
	qEKimQBs0SNuynxbMm19UCTgevQowlyUz8Dh56GQnIh+P/VVP3rJ6CxrFYEivKQgrG+jnfAeGX+r8
	72qZXXN84v43mehVIx3MVO6aVbvRb17cSS7VLoZ2RIklxpIETKaRx5B7ujm8NhDAjahJU41LVdEXw
	kAQmr5YXo4UfbpyoCfBoaAe2TCZnpyt+bZyTvZtfWPBR55RaLcCPc3Msy7eKF3XeoEy/5PTco3Kql
	q02y0G/A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rACwP-005Dke-1p;
	Mon, 04 Dec 2023 17:41:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: clean up the xfs_reserve_blocks interface
Date: Mon,  4 Dec 2023 18:40:56 +0100
Message-Id: <20231204174057.786932-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204174057.786932-1-hch@lst.de>
References: <20231204174057.786932-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_reserve_blocks has a very odd interface that can only be explained
by it directly deriving from the IRIX fcntl handler back in the day.

Split reporting out the reserved blocks out of xfs_reserve_blocks into
the only caller that cares.  This means that the value reported from
XFS_IOC_SET_RESBLKS isn't atomically sampled in the same critical
section as when it was set anymore, but as the values could change
right after setting them anyway that does not matter.  It does
provide atomic sampling of both values for XFS_IOC_GET_RESBLKS now,
though.

Also pass a normal scalar integer value for the requested value instead
of the pointless pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 34 +++-------------------------------
 fs/xfs/xfs_fsops.h |  3 +--
 fs/xfs/xfs_ioctl.c | 13 ++++++-------
 fs/xfs/xfs_mount.c |  8 ++------
 fs/xfs/xfs_super.c |  6 ++----
 5 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 01681783e2c31a..4f5da19142f298 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -344,43 +344,20 @@ xfs_growfs_log(
 }
 
 /*
- * exported through ioctl XFS_IOC_SET_RESBLKS & XFS_IOC_GET_RESBLKS
- *
- * xfs_reserve_blocks is called to set m_resblks
- * in the in-core mount table. The number of unused reserved blocks
- * is kept in m_resblks_avail.
- *
  * Reserve the requested number of blocks if available. Otherwise return
  * as many as possible to satisfy the request. The actual number
- * reserved are returned in outval
- *
- * A null inval pointer indicates that only the current reserved blocks
- * available  should  be returned no settings are changed.
+ * reserved are returned in outval.
  */
-
 int
 xfs_reserve_blocks(
-	xfs_mount_t             *mp,
-	uint64_t              *inval,
-	xfs_fsop_resblks_t      *outval)
+	struct xfs_mount	*mp,
+	uint64_t		request)
 {
 	int64_t			lcounter, delta;
 	int64_t			fdblks_delta = 0;
-	uint64_t		request;
 	int64_t			free;
 	int			error = 0;
 
-	/* If inval is null, report current values and return */
-	if (inval == (uint64_t *)NULL) {
-		if (!outval)
-			return -EINVAL;
-		outval->resblks = mp->m_resblks;
-		outval->resblks_avail = mp->m_resblks_avail;
-		return 0;
-	}
-
-	request = *inval;
-
 	/*
 	 * With per-cpu counters, this becomes an interesting problem. we need
 	 * to work out if we are freeing or allocation blocks first, then we can
@@ -450,11 +427,6 @@ xfs_reserve_blocks(
 		spin_lock(&mp->m_sb_lock);
 	}
 out:
-	if (outval) {
-		outval->resblks = mp->m_resblks;
-		outval->resblks_avail = mp->m_resblks_avail;
-	}
-
 	spin_unlock(&mp->m_sb_lock);
 	return error;
 }
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 45f0cb6e805938..7536f8a92746f6 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -8,8 +8,7 @@
 
 extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
 extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
-extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
-				xfs_fsop_resblks_t *outval);
+int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
 
 extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 422686dda8c888..04b20bf79776df 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1871,7 +1871,6 @@ xfs_ioctl_getset_resblocks(
 	struct xfs_mount	*mp = XFS_I(file_inode(filp))->i_mount;
 	struct xfs_fsop_resblks	fsop = { };
 	int			error;
-	uint64_t		in;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1886,17 +1885,17 @@ xfs_ioctl_getset_resblocks(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		in = fsop.resblks;
-		error = xfs_reserve_blocks(mp, &in, &fsop);
+		error = xfs_reserve_blocks(mp, fsop.resblks);
 		mnt_drop_write_file(filp);
 		if (error)
 			return error;
-	} else {
-		error = xfs_reserve_blocks(mp, NULL, &fsop);
-		if (error)
-			return error;
 	}
 
+	spin_lock(&mp->m_sb_lock);
+	fsop.resblks = mp->m_resblks;
+	fsop.resblks_avail = mp->m_resblks_avail;
+	spin_unlock(&mp->m_sb_lock);
+
 	if (copy_to_user(arg, &fsop, sizeof(fsop)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index aed5be5508fe57..aabb25dc3efab2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -637,7 +637,6 @@ xfs_mountfs(
 	struct xfs_sb		*sbp = &(mp->m_sb);
 	struct xfs_inode	*rip;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	uint64_t		resblks;
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
 	int			error = 0;
@@ -974,8 +973,7 @@ xfs_mountfs(
 	 * we were already there on the last unmount. Warn if this occurs.
 	 */
 	if (!xfs_is_readonly(mp)) {
-		resblks = xfs_default_resblks(mp);
-		error = xfs_reserve_blocks(mp, &resblks, NULL);
+		error = xfs_reserve_blocks(mp, xfs_default_resblks(mp));
 		if (error)
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
@@ -1053,7 +1051,6 @@ void
 xfs_unmountfs(
 	struct xfs_mount	*mp)
 {
-	uint64_t		resblks;
 	int			error;
 
 	/*
@@ -1090,8 +1087,7 @@ xfs_unmountfs(
 	 * we only every apply deltas to the superblock and hence the incore
 	 * value does not matter....
 	 */
-	resblks = 0;
-	error = xfs_reserve_blocks(mp, &resblks, NULL);
+	error = xfs_reserve_blocks(mp, 0);
 	if (error)
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 764304595e8b00..d0009430a62778 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -906,10 +906,8 @@ xfs_fs_statfs(
 STATIC void
 xfs_save_resvblks(struct xfs_mount *mp)
 {
-	uint64_t resblks = 0;
-
 	mp->m_resblks_save = mp->m_resblks;
-	xfs_reserve_blocks(mp, &resblks, NULL);
+	xfs_reserve_blocks(mp, 0);
 }
 
 STATIC void
@@ -923,7 +921,7 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 	} else
 		resblks = xfs_default_resblks(mp);
 
-	xfs_reserve_blocks(mp, &resblks, NULL);
+	xfs_reserve_blocks(mp, resblks);
 }
 
 /*
-- 
2.39.2

