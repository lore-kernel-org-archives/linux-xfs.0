Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD2BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiLaCyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:54:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E22619039
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:54:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95A7561BCB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C5FC433D2;
        Sat, 31 Dec 2022 02:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455250;
        bh=uNPzDITLHOX/N1QrM+l7A0Wxfz+dHMM5Yfe9vosO50o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rCJQJDfP/Dmn7CG9Kxy5+iuuL9i4SEHafQHZC04thmnjV+AVX/26yH198QDnIl1UO
         VyFKdPe2AFj2LKEZj4UfU/3lxl4mpiocyTzL+X0VJdhNduJwaQcD8TXiTQaCwVHpCA
         /zCAuM2/Mkjf2CbGjh48vjY2OB4aQn9cUI6w1DtJasYkZV25jxPdi+c4Sf2Omt9mBm
         6gOniibrf4C6GVXgiZ2MNZ1QMYAhq+0oayIhg1iqrbZfVGSdbmItEDEzFYGyqmvdfB
         GiMSRe+zqxdtz9PStGOVGzeILQXPnkB4XpinQQM5nv0q7/jSu1K+HS90T8tcMWsyGw
         DzIv7LM2UuirQ==
Subject: [PATCH 4/4] mkfs: use file write helper to populate files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:04 -0800
Message-ID: <167243880451.733953.13743974415145453004.stgit@magnolia>
In-Reply-To: <167243880399.733953.2483387870694006201.stgit@magnolia>
References: <167243880399.733953.2483387870694006201.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the file write helper to write files into the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    2 ++
 libxfs/util.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/proto.c     |   26 ++++----------------
 3 files changed, 76 insertions(+), 21 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index d4985a5769f..0949bbd39a5 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -169,6 +169,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 extern int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 					xfs_off_t len, int alloc_type);
+extern int	libxfs_file_write(struct xfs_trans *tp, struct xfs_inode *ip,
+				  void *buf, size_t len, bool logit);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index bb6867c21af..5643da72570 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -534,3 +534,72 @@ libxfs_imeta_ensure_dirpath(
 
 	return error == -EEXIST ? 0 : error;
 }
+
+/*
+ * Write a buffer to a file on the data device.  We assume there are no holes
+ * and no unwritten extents.
+ */
+int
+libxfs_file_write(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	void			*buf,
+	size_t			len,
+	bool			logit)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	xfs_fileoff_t		bno = 0;
+	xfs_fileoff_t		end_bno = XFS_B_TO_FSB(mp, len);
+	size_t			count;
+	size_t			bcount;
+	int			nmap;
+	int			error = 0;
+
+	/* Write up to 1MB at a time. */
+	while (bno < end_bno) {
+		xfs_filblks_t	maplen;
+
+		maplen = min(end_bno - bno, XFS_B_TO_FSBT(mp, 1048576));
+		nmap = 1;
+		error = libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -ENOSPC;
+
+		if (map.br_startblock == HOLESTARTBLOCK ||
+		    map.br_state == XFS_EXT_UNWRITTEN)
+			return -EINVAL;
+
+		error = libxfs_trans_get_buf(tp, mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				XFS_FSB_TO_BB(mp, map.br_blockcount),
+				0, &bp);
+		if (error)
+			break;
+		bp->b_ops = NULL;
+
+		count = min(len, XFS_FSB_TO_B(mp, map.br_blockcount));
+		memmove(bp->b_addr, buf, count);
+		bcount = BBTOB(bp->b_length);
+		if (count < bcount)
+			memset((char *)bp->b_addr + count, 0, bcount - count);
+
+		if (tp) {
+			libxfs_trans_log_buf(tp, bp, 0, bcount - 1);
+		} else {
+			libxfs_buf_mark_dirty(bp);
+			libxfs_buf_relse(bp);
+		}
+		if (error)
+			break;
+
+		buf += count;
+		len -= count;
+		bno += map.br_blockcount;
+	}
+
+	return error;
+}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index c62918a2f7d..96eab25da45 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -244,16 +244,12 @@ writefile(
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_mount	*mp;
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;
 	xfs_extlen_t		nb;
 	int			nmap;
 	int			error;
 
 	mp = ip->i_mount;
 	if (len > 0) {
-		int	bcount;
-
 		nb = XFS_B_TO_FSB(mp, len);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
@@ -263,30 +259,18 @@ writefile(
 					progname);
 			exit(1);
 		}
-		if (error) {
+		if (error)
 			fail(_("error allocating space for a file"), error);
-		}
 		if (nmap != 1) {
 			fprintf(stderr,
 				_("%s: cannot allocate space for file\n"),
 				progname);
 			exit(1);
 		}
-		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		error = -libxfs_trans_get_buf(NULL, mp->m_dev, d,
-				nb << mp->m_blkbb_log, 0, &bp);
-		if (error) {
-			fprintf(stderr,
-				_("%s: cannot allocate buffer for file\n"),
-				progname);
-			exit(1);
-		}
-		memmove(bp->b_addr, buf, len);
-		bcount = BBTOB(bp->b_length);
-		if (len < bcount)
-			memset((char *)bp->b_addr + len, 0, bcount - len);
-		libxfs_buf_mark_dirty(bp);
-		libxfs_buf_relse(bp);
+
+		error = -libxfs_file_write(tp, ip, buf, len, false);
+		if (error)
+			fail(_("error writing file"), error);
 	}
 	ip->i_disk_size = len;
 }

