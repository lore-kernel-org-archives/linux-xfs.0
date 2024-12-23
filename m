Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307EA192B86
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992736; cv=none; b=gIZbCaIF2nnLtZeaVkyDSmJSwMBUyafD8TcYR6Kyu6AV+V45p3hsVp6w8OfqJSZi1hAPmckJuZDcHefVhXgEFLu5c5Wjmn1BCx5DCi90SrWENAj/vL8dFu8VZ0NZTtXfNIveAzwThEWSrJ5031rZOdgC+w9LEwevd7svOXBVjho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992736; c=relaxed/simple;
	bh=zTmlcqHwfRxm2+48kwMJCKx22rsFj2lfzl5Mx72nWbA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E99n8AI3aOsBCaV6Pk7qEc9gJuFKI7yCmqmi3jZ2IvhCNJka3vqebF4iDhRR/thTuK0qmZU/WXpJboggMT8sV8W4557fOv98oxtSZJRl/cn/4/eUvTuD9lwwt5zescgWO9zbdXqCVx5NvNkF4FewT8h4agRUn6Bhe422zZyrQdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lj/S6kJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lj/S6kJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA076C4CED3;
	Mon, 23 Dec 2024 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992735;
	bh=zTmlcqHwfRxm2+48kwMJCKx22rsFj2lfzl5Mx72nWbA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lj/S6kJ0uSnq3Z1Qvud4FkLTMX0R1S/7iUQAtn5TqNL8Nk3CSLjsKJRCcXBjpvTmR
	 GqqRbUBPPzNwNJUfW89E75bnexNOXIyTs3iUBf0AN4BBbCoHzQ+nLGmjztalb+k9ZU
	 V5j2gUVPlU9VoEnvZmnBmnlMMd/80CxjwN8ndCdld4aJNiHRz+dZNT0gYXf5MNHwMA
	 Y+XKZThQlyzaqXbDG5o1sSybvwoZOvAsGjAN1ivRd0GjfQEj4i8BFCwuR5b1jel6mp
	 mAw0jPf44w1lsz3NkIPIpd6BAPcX7Xd9HFMJuAyzgTbwHoQzwl4Q5/x3MXtMqOq2zH
	 yzaS37EbaWsCw==
Date: Mon, 23 Dec 2024 14:25:35 -0800
Subject: [PATCH 2/7] xfs_db: support metadir quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944999.2299261.13893848897337655459.stgit@frogsfrogsfrogs>
In-Reply-To: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
References: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

