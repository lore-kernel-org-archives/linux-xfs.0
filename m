Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11767EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9Z/o8Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC42C433C8;
	Mon,  1 Jan 2024 00:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068628;
	bh=qdKEx2rpWozOVsvTtQh6xcauYkBVOVWNlCmgCsr9TzI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t9Z/o8Kuim/tkqr4/4RVvtbDgorwm1/0J8CJpc5JWpHS017OasSsUBxyGz7Yo1xRZ
	 F1kjB2jPX7BKmFVIcAKp9YnGItV27eMcKrUzXDARbybV4hz3t4q69tFAYujTyOaMwT
	 IhOeAAinVrEAmvlKlDwyigUiuJVJJAbwj5Pqr6Gq0iAt+efZpwvFXSgWNvQmqzCqMt
	 kxHNt+TfUPk5PfA3D2xDajF+ArP07aGvkJX9IJGE1wrAffQzFZe4Dt2AkyZf8Gm7UN
	 lmuo+zTw8AFza7Akvg5iDQ6culDCNn6UOqBOtLrVCpf9K+9yVPOzGC91q+k8sZYmK4
	 kJg8+NKrPTBsQ==
Date: Sun, 31 Dec 2023 16:23:48 +9900
Subject: [PATCH 4/4] mkfs: use file write helper to populate files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016291.1816687.462249301510411866.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
References: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
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

Use the file write helper to write files into the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    2 ++
 libxfs/util.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/proto.c     |   26 ++++----------------
 3 files changed, 76 insertions(+), 21 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 1fc8bc0e97b..46003fe641d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -176,6 +176,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 extern int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 					xfs_off_t len, uint32_t bmapi_flags);
+extern int	libxfs_file_write(struct xfs_trans *tp, struct xfs_inode *ip,
+				  void *buf, size_t len, bool logit);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index aec7798a814..f2be9dbf4a2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -537,3 +537,72 @@ get_random_u32(void)
 	return ret;
 }
 #endif
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
index 83888572395..436f9ac82b2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -270,16 +270,12 @@ writefile(
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
@@ -289,30 +285,18 @@ writefile(
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

