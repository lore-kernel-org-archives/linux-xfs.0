Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7744921BB
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435675; cv=none; b=TCMoe6CG4kGcrFdooWgDo2TUwN+8Y4pSGoBzqYo1M/R50SQWPqKtHSLC93CWDtp+Ud4HkVNGr8mAsj4xg013j6i2tYtMcODfivUjvCYv9gZxwPZ2NyPhwoEapQ222iDx/jPmiPSoMnn5UztmbdgVdJFjp8K0GMnxbvP4Rdw73Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435675; c=relaxed/simple;
	bh=8Km2RqWhIf+e0IL1avzGJDH/1oTfC6wFVZ0ujrW1BMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTHbQfBahmPhaT+T9Bllhe1VbcgLXO4NeVJ+P6gpuEEvMehsYFYNoFwFclzkbInTVzekKm3HsageRhKQCVYmGT01JJ95Q0yb+4o9xsOy3+DF1nX4RZ4F+zFN0MOtSMcZ2flwKD/VlY9tGpPYI7OcMsUUnL+6OHmjUimICHriPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgZWEM33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgZWEM33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7201F00AC4;
	Thu,  3 Sep 2026 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435662;
	bh=J9orpTklk0HxTA1BpydqU7g5kqxa55InRWqPPwKNWh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgZWEM33DpRGzDlCgqjxCKC5HK2TPrwrmseQe11mR+bJ7vKNsFPMU2BXcp4hxpJfF
	 gQciTFd7VgFP1QaaFB56Rnf5pBI+9Re5kH4leqnOuYBiyNyiNnogshCrhqWxhDnVBv
	 EJoMHrseGZX60b+N2mejMGtWsy3GCdI6RZQbKx8FD5FdkRDLnKUo25mcK1VWzv4Fm5
	 6pY9Rl7ooeBYn7qWMLhQdqwe9F7yyNuE6DfH329zratuTMNr+qCOMZPksClqQ2J/To
	 cT+AWUq2ua+Ek5sJpdF3AYoL3sJ6qHWiMh8OF3sm4Rlh6zk3DrVZ3OpqqiraMSRaLP
	 NXoca7A1yDMlw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 05/23] xfs: add a XFS_INODE_TO_AGINO helper
Date: Thu,  3 Sep 2026 13:39:47 +0200
Message-ID: <20260903114022.570210-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f46edc9f1310d27710e2b39bf561ecef51f879d2

Add a shortcut for the common XFS_INO_TO_AGINO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c            | 2 +-
 libxfs/iunlink.c        | 2 +-
 libxfs/xfs_format.h     | 2 ++
 libxfs/xfs_inode_util.c | 5 ++---
 repair/pptr.c           | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index 20946c967f54..7eeef5f0886e 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -23,7 +23,7 @@ count_rtblocks(
 		dbprintf(
 _("could not read AG %u agino %u extents, err=%d\n"),
 				XFS_INODE_TO_AGNO(ip),
-				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+				XFS_INODE_TO_AGINO(ip),
 				error);
 		return 0;
 	}
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 2d4dd0aee0b8..7a00915290db 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -66,7 +66,7 @@ xfs_iunlink_log_dinode(
 	}
 
 	trace_xfs_iunlink_update_dinode(mp, pag_agno(iup->pag),
-					XFS_INO_TO_AGINO(mp, ip->i_ino),
+					XFS_INODE_TO_AGINO(ip),
 					be32_to_cpu(dip->di_next_unlinked),
 					iup->next_agino);
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 36a00c174f1e..f812c6782492 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1280,6 +1280,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INODE_TO_AGINO(ip)		\
+	XFS_INO_TO_AGINO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGBNO(mp,i)		\
 	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
 		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 8e439dc2f4fa..63b95238d8ce 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -461,10 +461,9 @@ xfs_iunlink_insert_inode(
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
@@ -550,7 +549,7 @@ xfs_iunlink_remove_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
diff --git a/repair/pptr.c b/repair/pptr.c
index dc1ea2288eac..39e7bb5030d0 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1051,7 +1051,7 @@ crosscheck_file_parent_ptrs(
 	struct file_pptr	*file_pptr;
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	int			error;
 
 	ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
-- 
2.55.0

