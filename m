Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C39322B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530711; cv=none; b=YSQTLap0bFctzDUpRCM+uTNYWUbcY5KH6QBnEbJV0CSjQnIDRmDlfd0DRcd/m5nmrZSgLOoARyRmeHpXpAn3eL+482l0g5iiuUCDKrg4Qnt6pkdiTIxc6F6x3S++2877lz9E/OLkPCC9RiwJpnjDFlDxxOBoRZLH2n5GlpNcqWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530711; c=relaxed/simple;
	bh=1beFTftpmrIjss6bEdJKbzPjsNQSLYDlUWl3Qt5db5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iT1Up7eNaSWAnr10j26BrtNz9WSDmHHBrFAGz5MYg1NneCdsmBhSh1akt+psPGmIiUEecGiznibcw69GG3XmPqULNAYUVxmK4XV3TS0Vu9B6yJjDhKw0Xmwv/u9Or1ilwja4Fd2aALcsAmacTc7lnrHj1R8JWNLcj0IiTPwYe6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NplBBSO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NplBBSO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABD1C4CED1;
	Sat,  7 Dec 2024 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530711;
	bh=1beFTftpmrIjss6bEdJKbzPjsNQSLYDlUWl3Qt5db5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NplBBSO5qA374xVaFMykJ2CEbXChQttEfoM3My3YQEs3Un9RxmFeuhnrRAnpfu2Zo
	 coNrq/ZBRzqImOeBcYJ2pgUblKjrqxxOEkbhRxuUYhkDa0cgWxqRF+OPPaCNJehsVj
	 UKx5ZFuYilV4ZFxmWgxUTPa+FBFp28yXxfoXaLyy8hx4cTeG//Psg21BUKKor4+Oi+
	 RqNM+fWcZ/mah9xZ2GRJzcqkOaCCbpBPd5UC/ie+o2ETD2DXjhKlUpl6C+zCClc8xw
	 dtMyYnREPv+SUS+1X32OsxFzmvF7pXTOWD+oKC8Ca7xqocOGKVA5TdrU4nHzVD673l
	 wJYMG4FAjH2vA==
Date: Fri, 06 Dec 2024 16:18:30 -0800
Subject: [PATCH 2/7] xfs_db: support metadir quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753263.129683.13463573262283190371.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support finding the quota files in the metadata directory.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/dquot.c               |   59 ++++++++++++++++++++++++++++++++++------------
 libxfs/libxfs_api_defs.h |    6 +++++
 2 files changed, 50 insertions(+), 15 deletions(-)


diff --git a/db/dquot.c b/db/dquot.c
index 338d064995155e..d2c76fd70bf1a6 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -81,6 +81,41 @@ dquot_help(void)
 {
 }
 
+static xfs_ino_t
+dqtype_to_inode(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type)
+{
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp = NULL;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ret = NULLFSINO;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return NULLFSINO;
+
+	if (xfs_has_metadir(mp)) {
+		error = -libxfs_dqinode_load_parent(tp, &dp);
+		if (error)
+			goto out_cancel;
+	}
+
+	error = -libxfs_dqinode_load(tp, dp, type, &ip);
+	if (error)
+		goto out_dp;
+
+	ret = ip->i_ino;
+	libxfs_irele(ip);
+out_dp:
+	if (dp)
+		libxfs_irele(dp);
+out_cancel:
+	libxfs_trans_cancel(tp);
+	return ret;
+}
+
 static int
 dquot_f(
 	int		argc,
@@ -88,8 +123,7 @@ dquot_f(
 {
 	bmap_ext_t	bm;
 	int		c;
-	int		dogrp;
-	int		doprj;
+	xfs_dqtype_t	type = XFS_DQTYPE_USER;
 	xfs_dqid_t	id;
 	xfs_ino_t	ino;
 	xfs_extnum_t	nex;
@@ -97,38 +131,33 @@ dquot_f(
 	int		perblock;
 	xfs_fileoff_t	qbno;
 	int		qoff;
-	char		*s;
+	const char	*s;
 
-	dogrp = doprj = optind = 0;
+	optind = 0;
 	while ((c = getopt(argc, argv, "gpu")) != EOF) {
 		switch (c) {
 		case 'g':
-			dogrp = 1;
-			doprj = 0;
+			type = XFS_DQTYPE_GROUP;
 			break;
 		case 'p':
-			doprj = 1;
-			dogrp = 0;
+			type = XFS_DQTYPE_PROJ;
 			break;
 		case 'u':
-			dogrp = doprj = 0;
+			type = XFS_DQTYPE_USER;
 			break;
 		default:
 			dbprintf(_("bad option for dquot command\n"));
 			return 0;
 		}
 	}
-	s = doprj ? _("project") : dogrp ? _("group") : _("user");
+
+	s = libxfs_dqinode_path(type);
 	if (optind != argc - 1) {
 		dbprintf(_("dquot command requires one %s id argument\n"), s);
 		return 0;
 	}
-	ino = mp->m_sb.sb_uquotino;
-	if (doprj)
-		ino = mp->m_sb.sb_pquotino;
-	else if (dogrp)
-		ino = mp->m_sb.sb_gquotino;
 
+	ino = dqtype_to_inode(mp, type);
 	if (ino == 0 || ino == NULLFSINO) {
 		dbprintf(_("no %s quota inode present\n"), s);
 		return 0;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a8416dfbb27f59..6b2dc7a30d2547 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -159,6 +159,12 @@
 #define xfs_dir_replace			libxfs_dir_replace
 
 #define xfs_dqblk_repair		libxfs_dqblk_repair
+#define xfs_dqinode_load		libxfs_dqinode_load
+#define xfs_dqinode_load_parent		libxfs_dqinode_load_parent
+#define xfs_dqinode_mkdir_parent	libxfs_dqinode_mkdir_parent
+#define xfs_dqinode_metadir_create	libxfs_dqinode_metadir_create
+#define xfs_dqinode_metadir_link	libxfs_dqinode_metadir_link
+#define xfs_dqinode_path		libxfs_dqinode_path
 #define xfs_dquot_from_disk_ts		libxfs_dquot_from_disk_ts
 #define xfs_dquot_verify		libxfs_dquot_verify
 

