Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A185BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5lq1yoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB59C433C8;
	Sun, 31 Dec 2023 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056836;
	bh=T6GT53cZvxcw6WKR5X/8Ph65DQQiIav3ts+sKO1taoE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D5lq1yoM+4L0qySjTUMOQPB5MNb+97nnLcyCe3O2uX8a1P6qGFV3s3QkswOJzI4db
	 6hVS8rGt4mM4Pj6HaHHjGFSCRNJUNVqQOQ4ZOMGMYCK7vyP69WYC9gQEHllm4rIB+T
	 Z+N1vjmfM1Tt3DhYJxGlmcDMpVuZD+n1Vq3oWq+2WPGWXy+vLnOLnRMYOPWdRntSm2
	 OlRr22nzFQzxF6o8aHMnfnN1tq/gk2qwL/rTk4T+nwDroBryuOF7TmTFx5kcpe5Ezn
	 gA5w3/QnPNtA3KPWaCgEOkGGAGv+I+oe9/x/iJmwjN2ouJhlrElYZfeu9UkavqzLkd
	 vwNfp+IGPVj4w==
Date: Sun, 31 Dec 2023 13:07:16 -0800
Subject: [PATCH 04/32] xfs: refactor the v4 group/project inode pointer switch
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844928.1760491.12662709098659330743.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Refactor the group and project quota inode pointer switcheroo that
happens only on v4 filesystems into a separate function prior to
enhancing the xfs_qm_qino_alloc function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   90 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 07d0d0231252a..3e7e0f9cecc0e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -732,6 +732,57 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+/*
+ * Switch the group and project quota in-core inode pointers if needed.
+ *
+ * On v4 superblocks that don't have separate pquotino, we share an inode
+ * between gquota and pquota. If the on-disk superblock has GQUOTA and the
+ * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
+ * and vice-versa.
+ */
+STATIC int
+xfs_qm_qino_switch(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**ipp,
+	unsigned int		flags,
+	bool			*need_alloc)
+{
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	if (xfs_has_pquotino(mp) ||
+	    !(flags & (XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)))
+		return 0;
+
+	if ((flags & XFS_QMOPT_PQUOTA) &&
+	    (mp->m_sb.sb_gquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_gquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_pquotino != NULLFSINO)) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
+			return -EFSCORRUPTED;
+		}
+	} else if ((flags & XFS_QMOPT_GQUOTA) &&
+		   (mp->m_sb.sb_pquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_pquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_gquotino != NULLFSINO)) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	if (ino == NULLFSINO)
+		return 0;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	if (error)
+		return error;
+
+	mp->m_sb.sb_gquotino = NULLFSINO;
+	mp->m_sb.sb_pquotino = NULLFSINO;
+	*need_alloc = false;
+	return 0;
+}
+
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -747,43 +798,10 @@ xfs_qm_qino_alloc(
 	bool			need_alloc = true;
 
 	*ipp = NULL;
-	/*
-	 * With superblock that doesn't have separate pquotino, we
-	 * share an inode between gquota and pquota. If the on-disk
-	 * superblock has GQUOTA and the filesystem is now mounted
-	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
-	 * vice-versa.
-	 */
-	if (!xfs_has_pquotino(mp) &&
-			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
-		xfs_ino_t ino = NULLFSINO;
 
-		if ((flags & XFS_QMOPT_PQUOTA) &&
-			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_gquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_pquotino != NULLFSINO)) {
-				xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
-				return -EFSCORRUPTED;
-			}
-		} else if ((flags & XFS_QMOPT_GQUOTA) &&
-			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_pquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_gquotino != NULLFSINO)) {
-				xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
-				return -EFSCORRUPTED;
-			}
-		}
-		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
-			if (error)
-				return error;
-			mp->m_sb.sb_gquotino = NULLFSINO;
-			mp->m_sb.sb_pquotino = NULLFSINO;
-			need_alloc = false;
-		}
-	}
+	error = xfs_qm_qino_switch(mp, ipp, flags, &need_alloc);
+	if (error)
+		return error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,

