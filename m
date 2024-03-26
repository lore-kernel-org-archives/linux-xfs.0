Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB212880F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425774; cv=none; b=dMsVU8D5gy9/4JF31MsHCVrQrcZ/3+V4u6CIdvPqDkLd70XHZNk2W/IULgAEyYJU+0i4LjiPloE5Kr7tUlOR4dx26C+2PSqy4VimN9WAN3Dn59KwhiUYW1ZymNhYqBTkraxmUE41MSOlV6yWi6OKy+qzl1Zc1hX/PQ96PDXyquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425774; c=relaxed/simple;
	bh=2kR92yblPN0MQIpIwY1q8AX4HPc5v9CvlPvq1mtJH7o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlm6a3wlrSkCsVMCzCPpt4diOH7dxTtO7YbkE1iRY4E7UEGsAlYoZDYnrLsb+YA9KXCkPdXR0OTwETyjkKvAaedadSzWtMugdmINQTSOeRGHmQluBia5dFio96VKnFuth1d9WbyEiFWqsYB3kQ26lCg+/yPKxY6DuBKtV1lDnfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/601eo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/601eo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B03C433C7;
	Tue, 26 Mar 2024 04:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425773;
	bh=2kR92yblPN0MQIpIwY1q8AX4HPc5v9CvlPvq1mtJH7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e/601eo1SVzsoK0RQcWF4cwUAMvaQ9+InSqlaqrTXaxNWHUv6OVoWSo1PzRcGUKXx
	 iNPM/sE9cXpQLengSYQvtZ1L0GphTT29H8QUXrRdAFbE0zIWNnkwEGn9apUZkWCH7A
	 g+eEWUDZ+tQZaShu5zRahlKNGRF7h0ikYOryWvf1/AtUEHGtdifOadwSI8O3k3D7KG
	 Ymy/XRZsouVEe8Bkrt6u4McENnhJEdqxPZ1XWIMaes0DrMkAM7InySP3vedg7hOp0H
	 xE8fMUB+Qn9eJtLz3kn9jB858Fra/9qZluECIdyAZzTNV5jSPp06BecBp4ARaCX49K
	 hDzAGnv2aHsQA==
Date: Mon, 25 Mar 2024 21:02:53 -0700
Subject: [PATCH 1/1] mkfs: use libxfs to create symlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142135444.2220355.14042313671341548069.stgit@frogsfrogsfrogs>
In-Reply-To: <171142135429.2220355.9379791574025871779.stgit@frogsfrogsfrogs>
References: <171142135429.2220355.9379791574025871779.stgit@frogsfrogsfrogs>
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

Now that we've grabbed the kernel-side symlink writing function, use it
to create symbolic links from protofiles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2b1a2035c6a2..16f6513f671e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -240,6 +240,7 @@
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
+#define xfs_symlink_write_target	libxfs_symlink_write_target
 
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 10b929b2ec37..a923f9c1028b 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -16,8 +16,6 @@ static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
-static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int symlink, int logit,
-			char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
 static void rtfreesp_init(struct xfs_mount *mp);
@@ -243,31 +241,42 @@ rsvfile(
 		fail(_("committing space for a file failed"), error);
 }
 
-static int
-newfile(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	int		symlink,
-	int		logit,
-	char		*buf,
-	int		len)
+static void
+writesymlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	char			*buf,
+	int			len)
 {
-	struct xfs_buf	*bp;
-	xfs_daddr_t	d;
-	int		error;
-	int		flags;
-	xfs_bmbt_irec_t	map;
-	xfs_mount_t	*mp;
-	xfs_extlen_t	nb;
-	int		nmap;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_extlen_t		nb = XFS_B_TO_FSB(mp, len);
+	int			error;
+
+	error = -libxfs_symlink_write_target(tp, ip, buf, len, nb, nb);
+	if (error) {
+		fprintf(stderr,
+	_("%s: error %d creating symlink to '%s'.\n"), progname, error, buf);
+		exit(1);
+	}
+}
+
+static void
+writefile(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	char			*buf,
+	int			len)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_mount	*mp;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	xfs_extlen_t		nb;
+	int			nmap;
+	int			error;
 
-	flags = 0;
 	mp = ip->i_mount;
-	if (symlink && len <= xfs_inode_data_fork_size(ip)) {
-		libxfs_init_local_fork(ip, XFS_DATA_FORK, buf, len);
-		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
-		flags = XFS_ILOG_DDATA;
-	} else if (len > 0) {
+	if (len > 0) {
 		int	bcount;
 
 		nb = XFS_B_TO_FSB(mp, len);
@@ -289,7 +298,7 @@ newfile(
 			exit(1);
 		}
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		error = -libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
+		error = -libxfs_trans_get_buf(NULL, mp->m_dev, d,
 				nb << mp->m_blkbb_log, 0, &bp);
 		if (error) {
 			fprintf(stderr,
@@ -301,15 +310,10 @@ newfile(
 		bcount = BBTOB(bp->b_length);
 		if (len < bcount)
 			memset((char *)bp->b_addr + len, 0, bcount - len);
-		if (logit)
-			libxfs_trans_log_buf(tp, bp, 0, bcount - 1);
-		else {
-			libxfs_buf_mark_dirty(bp);
-			libxfs_buf_relse(bp);
-		}
+		libxfs_buf_mark_dirty(bp);
+		libxfs_buf_relse(bp);
 	}
 	ip->i_disk_size = len;
-	return flags;
 }
 
 static char *
@@ -491,7 +495,7 @@ parseproto(
 					   &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, 0, 0, buf, len);
+		writefile(tp, ip, buf, len);
 		if (buf)
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
@@ -575,7 +579,7 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, 1, 1, buf, len);
+		writesymlink(tp, ip, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
 		newdirent(mp, tp, pip, &xname, ip->i_ino);

