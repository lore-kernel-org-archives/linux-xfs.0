Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521892;
	b=QzCfc4979D5iG11Asm85mBh4LSkaxqoza2D1hDoGI5JHb/YGHPpBnawc99t+i7S5RNxt
	 fefVP/FuAbEbXGD9QQHBwVBYwx1EfXk5FlXnd9ghP8zLtcFUe3PQlIHdgXsPLFkQkyrZJ
	 y4rM2VDnKbyhsBt5i/ZphUDFPWDoz9AVhQ+kqnQjywxKcse7eFD0Ydz0DEJzJcYsGyyaX
	 +AjAwOXRevT2stAy8Rujv9BNofLDGqaDuUMHXEj7NLEhP9Wa6fHE0y4tZ0aspEOlt6sf1
	 qbtTImRyHdYw4y6UqmKstm1nF8D0ShHRsmlukPvNELET/Ot5GEBSeDmOfO0totU5+1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521892;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=Rb8ZxI2HpXFGMiKW0KzjSkQ9TnzWyp7s0HuM9e4/t7Y=;
	b=bwTxC5HqJwwDdUZN1mpibmTq39++XznufLZyZ0MLaObWLdpGq3azXsPrw6IKr7KwjOTQ
	 HxBrZHstlPIv1wM42B1aYXUHI8nj4PSOUb7z/Q4BnEYy7MnWV7dpLaBP7pCjQ7MDPr2Y8
	 aPitGg28zNqEHut+hBQQX6tGe6+JR9FiISBRGbIl5Rv5FRgnJVTyQIoB485vrYY27JDnu
	 N5utybK3qxa/5rP+qcgBg/QC9miVCJgnK2U0Joyxj1R2qs9iO0L6zDD7aXdrkU4wc+RBh
	 hSRWlhfiGMXQ6FR3B6rsQLlhvSue2ljLdf2C1hs0+IxmLA4S/ibt3gOjgpKnB538+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=O03bWh+b;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC88D606A332
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 12:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC88D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=O03bWh+b
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Rb8ZxI2HpXFGMiKW0KzjSkQ9TnzWyp7s0HuM9e4/t7Y=;
	b=O03bWh+b0WG4J3FqRiuyEZVlvh2N/uUVhRZSPKwpJ1a/tGq1JOq7sEcMLGzOrr9cXAqTeE5YH
	KMgsgEfp+VXJp12TKta1TYAqTFnglgr9znXnJRTFnS0GQkdiY82l7UDbcdY9XG88rnxyGPFh6b0
	ojfawSssDvdwZjjQz+M6QtU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jYhLc4kFmzmVcD;
	Tue, 24 Nov 2026 20:04:24 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id E341D40565;
	Tue, 24 Nov 2026 20:04:47 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 24 Nov
 2026 20:04:47 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <ranhongyun1@huawei.com>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>,
	<wozizhi@huawei.com>
Subject: [PATCH 2/2] xfs: refuse to bump the link count of zero-link inodes
Date: Tue, 24 Nov 2026 19:55:26 +0800
Message-ID: <20261124115526.2328491-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200001.china.huawei.com (7.185.36.96)

The VFS inc_nlink() warns when incrementing the link count of a
zero-link inode that is not marked I_LINKABLE.

A crafted image can contain a directory with di_nlink == 0 while a
directory entry still points to it.  xfs_dinode_verify() accepts this
because it only checks nlink when di_size is zero.  mkdir() or rename()
in that directory then calls xfs_bumplink() -> inc_nlink() and trips
the warning.

Make xfs_bumplink() reject the zero link count with -EFSCORRUPTED.
Repair paths that relink such inodes set the link count directly, so
they keep working.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 24 ++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_util.c | 14 ++++++++++++--
 fs/xfs/libxfs/xfs_inode_util.h |  2 +-
 fs/xfs/scrub/metapath.c        |  8 ++++++--
 fs/xfs/scrub/orphanage.c       | 11 ++++++++---
 5 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 0c0402a29b6b..715c06892f81 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -869,7 +869,9 @@ xfs_dir_create_child(
 		if (error)
 			return error;
 
-		xfs_bumplink(tp, dp);
+		error = xfs_bumplink(tp, dp);
+		if (error)
+			return error;
 	}
 
 	/*
@@ -933,7 +935,9 @@ xfs_dir_add_child(
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
-	xfs_bumplink(tp, ip);
+	error = xfs_bumplink(tp, ip);
+	if (error)
+		return error;
 
 	/*
 	 * If we have parent pointers, we now need to add the parent record to
@@ -1087,7 +1091,9 @@ xfs_dir_exchange_children(
 				error = xfs_droplink(tp, dp2);
 				if (error)
 					return error;
-				xfs_bumplink(tp, dp1);
+				error = xfs_bumplink(tp, dp1);
+				if (error)
+					return error;
 			}
 
 			/*
@@ -1111,7 +1117,9 @@ xfs_dir_exchange_children(
 				error = xfs_droplink(tp, dp1);
 				if (error)
 					return error;
-				xfs_bumplink(tp, dp2);
+				error = xfs_bumplink(tp, dp2);
+				if (error)
+					return error;
 			}
 
 			/*
@@ -1252,7 +1260,9 @@ xfs_dir_rename_children(
 		if (error)
 			return error;
 
-		xfs_bumplink(tp, du_wip->ip);
+		error = xfs_bumplink(tp, du_wip->ip);
+		if (error)
+			return error;
 	}
 
 	/*
@@ -1273,7 +1283,9 @@ xfs_dir_rename_children(
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		if (new_parent && src_is_directory) {
-			xfs_bumplink(tp, target_dp);
+			error = xfs_bumplink(tp, target_dp);
+			if (error)
+				return error;
 		}
 	} else { /* target_ip != NULL */
 		/*
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index f486b23a9b52..c7c98b9a9e98 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -668,15 +668,24 @@ xfs_droplink(
 }
 
 /*
- * Increment the link count on an inode & log the change.
+ * Increment the link count on an inode & log the change.  Returns
+ * -EFSCORRUPTED if the inode has zero links and is not I_LINKABLE.
  */
-void
+int
 xfs_bumplink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
 
+	if (inode->i_nlink == 0 &&
+	    !(inode_state_read_once(inode) & I_LINKABLE)) {
+		xfs_info_ratelimited(tp->t_mountp,
+				"%s: Attempt to bump inode 0x%llx with nlink zero.",
+				__func__, I_INO(ip));
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
@@ -687,6 +696,7 @@ xfs_bumplink(
 		inc_nlink(inode);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
 }
 
 /* Free an inode in the ondisk index and zero it out. */
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index e9eac35159c3..b76bfda060bf 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -57,6 +57,6 @@ int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
 int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
-void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 76b48c443a41..0e2d6be9b2aa 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -405,12 +405,16 @@ xrep_metadir_add_child(
 		set_nlink(VFS_I(ip), 1);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	} else {
-		xfs_bumplink(tp, ip);
+		error = xfs_bumplink(tp, ip);
+		if (error)
+			return error;
 	}
 
 	/* update dotdot entry in child */
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		xfs_bumplink(tp, dp);
+		error = xfs_bumplink(tp, dp);
+		if (error)
+			return error;
 
 		/* Replace the dotdot entry in the child */
 		if (old_dotdot != I_INO(dp)) {
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index d8e1457f0d5e..dcdc5f54dd59 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -567,13 +567,18 @@ xrep_adoption_move(
 	 */
 	xfs_trans_ichgtime(sc->tp, sc->orphanage,
 			XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	if (isdir)
-		xfs_bumplink(sc->tp, sc->orphanage);
+	if (isdir) {
+		error = xfs_bumplink(sc->tp, sc->orphanage);
+		if (error)
+			return error;
+	}
 	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
 
 	/* Bump the link count of the child. */
 	if (adopt->bump_child_nlink) {
-		xfs_bumplink(sc->tp, sc->ip);
+		error = xfs_bumplink(sc->tp, sc->ip);
+		if (error)
+			return error;
 		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
 	}
 
-- 
2.52.0

