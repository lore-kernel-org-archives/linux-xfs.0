Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FA7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiLaASq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiLaASp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A49817597
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABEA61C52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564BCC433D2;
        Sat, 31 Dec 2022 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445922;
        bh=A8JxKZYwraW9UeedifutKM7UAN6dCYt4+n8qZzLhafs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kvN8sMIdbHdK0BhSEsILlbq0EJYxGv6WNmpJwNGqyZHC22PedN4lHQXrqxGtxm2WF
         zxmif3JPqLkchXG/AK0gWVzSLY4cOjlxLTlbk1iAO4fRM/J5RC4ZQWhq4sceB3BxOY
         ve0T4h2+8Wy6OMBS13DorOPlLJhaOUATQNI83VlMOD13S2EvF8JYWAFmqTB5dvAAJy
         QX9Xlp6YLUGuzCP2DujMkh/jDRtcH5yrv3qj/dU5F5idUdWELQWtaBQVkk+2wY7Bby
         B/slyE6GfOoZRU1bkxIiaWpKW5hNZQnrbXWG+9gFhzd3rOkF1w9e+OsqA4VkbSipGj
         RAVmZSeKkZ7Pg==
Subject: [PATCH 4/4] mkfs: use libxfs to create symlinks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:56 -0800
Message-ID: <167243867641.713532.4167978409051098779.stgit@magnolia>
In-Reply-To: <167243867587.713532.17037228277541976894.stgit@magnolia>
References: <167243867587.713532.17037228277541976894.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've grabbed the kernel-side symlink writing function, use it
to create symbolic links from protofiles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index aa71914af97..81dfb10575d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -209,6 +209,7 @@
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
+#define xfs_symlink_write_target	libxfs_symlink_write_target
 
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 68ecdbf3632..bd306f95568 100644
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
 static long filesize(int fd);
@@ -217,31 +215,42 @@ rsvfile(
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
@@ -263,7 +272,7 @@ newfile(
 			exit(1);
 		}
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		error = -libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
+		error = -libxfs_trans_get_buf(NULL, mp->m_dev, d,
 				nb << mp->m_blkbb_log, 0, &bp);
 		if (error) {
 			fprintf(stderr,
@@ -275,15 +284,10 @@ newfile(
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
@@ -459,7 +463,7 @@ parseproto(
 					   &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, 0, 0, buf, len);
+		writefile(tp, ip, buf, len);
 		if (buf)
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
@@ -543,7 +547,7 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, 1, 1, buf, len);
+		writesymlink(tp, ip, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
 		newdirent(mp, tp, pip, &xname, ip->i_ino);

