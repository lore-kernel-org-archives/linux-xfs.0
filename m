Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2622F139D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301046; cv=none; b=Xcq9J/HupakIpRRRyuT31L0yamnSNFeCDWfSaAXOoYQzR168uUIgg/X1CIVn9ng6wF/1O/ouPGc5jijAJ71xgV/bpXEG36qonZiExD22VxgkD4kKOO/Enlxs8ImAVSNfvN7EfimE+fnodMB5ReZ6/zMyE0V/NCi9HLbdPeP/Os4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301046; c=relaxed/simple;
	bh=GlZHkeRjbsmfOuc+5KKc0/Mxp2jhey03XWXUx1WJ5AY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8aW0r2y3bQtJIJYr8TDEJmjAPydqYCScYTomJnWAMJ0s5d/ghRU7Cez1L7iALpWJzFyJpviEzOeHROusA850FpwBEJdmbA7UBlg7FgeqGCABqS/FyCyJobOPRcnBq0kpK5tspGgGuzYBLxYY40xE7bia2IcpcYM8/dsMK7jnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNurUfCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNurUfCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000D9C4AF07;
	Tue, 30 Jul 2024 00:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301046;
	bh=GlZHkeRjbsmfOuc+5KKc0/Mxp2jhey03XWXUx1WJ5AY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XNurUfCot0bXpSHmfXv8bG6zbiXm7EvJUymExpMv04sn20s9j0xZVdE/JT1N+xvPI
	 lgQhSzYCKfhfI8/pWiBB81wgtrBt6mup6+yosnNG+M49gASylsrM1VWKDjj6/uNQ1U
	 xN7dOCCeyhnIjb2Aan4uVB195pjLHoZcH1KJu6Q8xicT8v8AfehZofRXAyZwtU6ybA
	 12uYhV2afLXV5c/BOAPDAYivTTfGqlkYkturnOiqJSx1rbsFYECgQsaqnzmpxEWKRE
	 UiCsChJrK0OVaGoVS29wi7eBAOi0TWbCRlmJ91adXk3fjAXuvhUoiNNP4wmqO+IoWL
	 FMWqdobTY6+tQ==
Date: Mon, 29 Jul 2024 17:57:25 -0700
Subject: [PATCH 1/2] libxfs: port the bumplink function from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845224.1345564.16569522664327555196.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845209.1345564.9915639548188043835.stgit@frogsfrogsfrogs>
References: <172229845209.1345564.9915639548188043835.stgit@frogsfrogsfrogs>
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

Port the xfs_bumplink function from the kernel and use it to replace raw
calls to inc_nlink.  The next patch will need this common function to
prevent integer overflows in the link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h |    2 ++
 libxfs/util.c       |   17 +++++++++++++++++
 mkfs/proto.c        |    4 ++--
 repair/phase6.c     |   10 +++++-----
 4 files changed, 26 insertions(+), 7 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index c6e4f84bd..45339b426 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -359,6 +359,8 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
+void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
diff --git a/libxfs/util.c b/libxfs/util.c
index 2656c99a8..dc54e3ee6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -240,6 +240,23 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/*
+ * Increment the link count on an inode & log the change.
+ */
+void
+libxfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	inc_nlink(inode);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5125ee44f..a9a9b704a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -591,7 +591,7 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		inc_nlink(VFS_I(ip));		/* account for . */
+		libxfs_bumplink(tp, ip);		/* account for . */
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
@@ -601,7 +601,7 @@ parseproto(
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino);
-			inc_nlink(VFS_I(pip));
+			libxfs_bumplink(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
diff --git a/repair/phase6.c b/repair/phase6.c
index 92a58db0d..47dd9de27 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -947,7 +947,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
 	}
-	inc_nlink(VFS_I(ip));		/* account for . */
+	libxfs_bumplink(tp, ip);		/* account for . */
 	ino = ip->i_ino;
 
 	irec = find_inode_rec(mp,
@@ -999,7 +999,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * for .. in the new directory, and update the irec copy of the
 	 * on-disk nlink so we don't fail the link count check later.
 	 */
-	inc_nlink(VFS_I(pip));
+	libxfs_bumplink(tp, pip);
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 	add_inode_ref(irec, 0);
@@ -1094,7 +1094,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				inc_nlink(VFS_I(orphanage_ip));
+				libxfs_bumplink(tp, orphanage_ip);
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
@@ -1103,7 +1103,7 @@ mv_orphanage(
 				do_error(
 	_("creation of .. entry failed (%d)\n"), err);
 
-			inc_nlink(VFS_I(ino_p));
+			libxfs_bumplink(tp, ino_p);
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 			err = -libxfs_trans_commit(tp);
 			if (err)
@@ -1128,7 +1128,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				inc_nlink(VFS_I(orphanage_ip));
+				libxfs_bumplink(tp, orphanage_ip);
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			/*

