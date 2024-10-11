Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A40D11C83
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610578; cv=none; b=ZG9dJ07tnbFhhUNdB3ABGRZpKcXJoBZB5CHo2adjz2nb2oLIt8ZCEiYmWv2Pd+ot+OT9xSjcezZpxsIXK/0vAml9Z6UMtrWl+6qzIunGw3LaQvyEl9oiJlgsjXaQjk9vQWnncXiTILT8mGDRVFebLA0DZ36dPVHqoQyNe1Wkfh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610578; c=relaxed/simple;
	bh=JU9ftvfZZDogNxXBVQRpF0ft/z+dy4rcn9Acl9SukCw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9KCjvyWq39YjsYS0e5R9ndZRSuztgLC70AmuadXLIWj3hSzT2Z3im4wjY1OwlnYPFHS7R7neEEek1hLp0spQjqaUtTC0nFdU0qkAtXBymafNa3lNm67k4ZCcF6f9lKApbVlnrtD9h/EYTWmUEBGVv2AdLpqRrWQUvk55C4tIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdcwJZPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdcwJZPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A77C4CEC5;
	Fri, 11 Oct 2024 01:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610577;
	bh=JU9ftvfZZDogNxXBVQRpF0ft/z+dy4rcn9Acl9SukCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdcwJZPvEmrfz4F8qDChQbic7usj9XVkjLZGYxUWZYIOT8WsxeoN6JjFlfla1J5oB
	 oS9yGOrOGAhvVk6a/SXPu5lw22Y954nVXBVKQjbaPNA6UqZ3+eh/HnCkwkOF3GivdW
	 coHtcHGSYEjcOjwJZ+4qucanWm2J3DjIGZEHIlI8lJndP1e3rg3PVQtxTYWkLijxNH
	 /U5zmBv9iHjKrUIlSDydslJvNkermvHOjhYQqlxn/h8HjOQOgIWiEewqSooHW8giK4
	 I8PuFAlFQT9ihtBJEU8BRecrAPmN7GsW3Gp4kH4sCxKLu4cvfiUCvGLwOlRVQd8rvT
	 ML73OQwZj4pdQ==
Date: Thu, 10 Oct 2024 18:36:17 -0700
Subject: [PATCH 2/7] xfs_db: support metadir quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656403.4186076.16895674507948377981.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

Support finding the quota files in the metadata directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index b9287a7da4208d..0850f02c58501b 100644
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
 

