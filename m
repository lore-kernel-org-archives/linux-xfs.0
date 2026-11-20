Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190338;
	b=YK3TQsp/8R/+mXVND1sakdt3tP7d6NOLCMDBhNzPtBiqGxmEtZPOooCnCL8tAmyJecvt
	 Mx6O4/nAyxQBr1LabioLVANApg1DkM477YmLxpAgzVpoS7i1yU3SgK3xbP7/Ahe21wqdS
	 vST5PwQaSEaYppJknQ6GtfL29fy+Xk+L+yMchgHREavHGGeSDgFuL0Bt/ZBelX0I/1G8x
	 GrymlwhTh8yz6zudPwrhMeo3P2bY821mFhXwZQwXc5IoyxcYO0nZi8Pu9U9aVG7jQft7K
	 joY7kfiuUzX56tEDwxgzc6LcyVd5ekg6j0KBvzH82hh483mCI7XsgUlCUDDxb+bPHEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pMQwf2aAtTpEZleMwDQJRCxpZd1X/m9lnVMxguZEhRg=;
	b=wvX6er4oHUukcn9drwEEya9ObBch54V8FihD6WH+R/Qv6AjPyDKiDpPIAnZyrNBODzab
	 jl2AWinWC7olGnD2iMn2tgqXvK43B2vDiv/qbVkubGttZPdL7JR9+mikKZ4aNk6IbfBqa
	 HFgQXjRfNHXysaZ/gsBQLLaDXtzPRppmB7/7yM9zczedScmUTaHkWImAQotfO/Scat8bO
	 oMZqAsTrGhtPyBv426Pj0TzI+h6BxdQdJuelcKxjyY9Nztr8mudkFC4pwCFJGTXcBfloB
	 AETyghx8DHhJoMYY8QTY0hmXErJY9EsKU/jumlrZrVx0zHsVazFVXkiAvJAbKoJfzlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHCxS6ju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB260A2608;
	Fri, 20 Nov 2026 15:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHCxS6ju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E161F000E0;
	Fri, 20 Nov 2026 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190337;
	bh=pMQwf2aAtTpEZleMwDQJRCxpZd1X/m9lnVMxguZEhRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHCxS6junggDlzNoAhGNt/B5blbplqlcIveugwDfbTTe3H8aEBj048Kz9plVJF60c
	 0dBbTL2Pz2ujaJ7RnaJN3gnSmqhPvYbWdoVAM4zOHLoGE/dkgbl1j6zHrUbv9NrTOQ
	 yqhoVEWPgFPl1VJ6DFIReNQg2FvB7khzB+grFfdEzGYbN1QI1TjWEnK4QRfdnr8+Pi
	 nt/2vuJcYnXjlTtiJkkOyY4isZalMu2MJzwgOjavkWsAOcjG6qMe/ghz+PpwpLlFLZ
	 RZWa7Aw5Xu+a1hsD7doKYWuDeFG3H85u/cIC15VFPA2S4R90eS9Uscxc4Ayb3lVePu
	 QaDrA0XBcGWJQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 14/15] xfs: introduce health state for corrupted fsverity metadata
Date: Fri, 20 Nov 2026 16:57:48 +0100
Message-ID: <20261120155752.192025-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report corrupted fsverity descriptor through health system.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 25 +++++++++++++++++++------
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c80133784419..84d62b7506a9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -422,6 +422,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_FSVERITY	(1 << 9)  /* fsverity metadata */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1d45cf5789e8..932b447190da 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -104,6 +104,7 @@ struct xfs_rtgroup;
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_FSVERITY	(1 << 14)  /* fsverity metadata */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -140,7 +141,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_FSVERITY)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index ec4006729e75..36520a187a2c 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -98,8 +98,10 @@ xfs_fsverity_get_descriptor(
 	if (error)
 		return error;
 
-	if (is_empty)
+	if (is_empty) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	/*
 	 * Make sure we can open large file on a 32-bit kernel
@@ -110,8 +112,10 @@ xfs_fsverity_get_descriptor(
 
 	last_block_offset =
 		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
-	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
+	if (last_block_offset <= xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	desc_size_pos = last_block_offset - sizeof(__be32);
 	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
@@ -120,20 +124,29 @@ xfs_fsverity_get_descriptor(
 		return error;
 
 	desc_size = be32_to_cpu(d_desc_size);
-	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
+	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
-	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
+	}
+
+	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	if (!buf_size)
 		return desc_size;
 
-	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
+	if (XFS_IS_CORRUPT(mp, desc_size > buf_size)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
-	if (desc_pos < xfs_fsverity_metadata_offset(ip))
+	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
 	if (error)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 239b843e83d4..be66760fb120 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -625,6 +625,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.54.0

