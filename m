Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768FC12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFtPIR7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EBAC433C7;
	Sun, 31 Dec 2023 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061623;
	bh=ZTd2UT1daDsUjkfL4PkfqO0+ghYOP3GqBexuFcU/2L4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CFtPIR7qfwNW6y3TH+houOEpjQR0b5wNcBFReIkj21/fWKM1kOHq6lXDSA/dOZD+q
	 zzBRG27wBk4qNPUvzWTq/bAFZYAlVIXlLb5IO7rVqso9dqlGUFTuVF1f/nuIbi+Z4V
	 GwJTw7arGwJimlZIocmBM+TzoWd23YXydxoh5hV2QbRQoC5DmtHAw3Lvse9cP+85pd
	 8KTM2p2q6kOdjX9QVby4ZxZKnM3ztREseE//hLGBVRHFRNK3mcLToy/XnsY6hflzxs
	 SdJHMDcbnw1iH6i/YcbBgra+r0IYtEEGn0BSfACk//KfeR9BQOIfAxgv4tgLLcjq06
	 aOxWDxbi5GvGA==
Date: Sun, 31 Dec 2023 14:27:03 -0800
Subject: [PATCH 4/4] mkfs: use libxfs to create symlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995933.1795978.7292049559517439041.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
References: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
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
index 2a8e09db0bf..a5b3baaa476 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -228,6 +228,7 @@
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
+#define xfs_symlink_write_target	libxfs_symlink_write_target
 
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f8e00c4b56f..0f2facbc32e 100644
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

