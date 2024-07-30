Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5619B4A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299105; cv=none; b=CvG7SsiLIJwbFv7PtuZb8P+D5SjmfNV8eg+P4ToaY/vZ+4pSwH3ecGD8WeRB6oGu/38MEY/Nna9dTJUMghDdha44DXy6ZP7hhxbo5e0BDC9UqNlaMrtAYIVcqkrk1PZFK1Dke6hr/TcNkM00s603anR2+qXe81ReIoytf149qG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299105; c=relaxed/simple;
	bh=Ve5Zk//9hTyqxr0ENgT+23KB0V+VFDH87S+dMxH0OVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwvLG4ZDvj94HqqVe3D7IgP6O7CCCmQm+qv1SyiIOCsG6xRsxqjj+NLo4EyOWryrPqEoiYshrYUmJzNg5KfgyqleGwC76/F2u3ME0htc4RRiBpnKs4cWplTYK+WQoZcSWnYAznR585gdlZTmtkRdahos39Vy2LCR7zWzqqFUHOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0S46F2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0S46F2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE0DC32786;
	Tue, 30 Jul 2024 00:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299105;
	bh=Ve5Zk//9hTyqxr0ENgT+23KB0V+VFDH87S+dMxH0OVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X0S46F2aF3uZg75TjLACctb3sOmYckBxlT03Lp+24bdbIz3icrchm68zAPvGDKhG/
	 2atyZQoURuio3bJUxhuveU6jWmKXEC597KuhVkP/GozABgNBsviuQR0EjXP6LKal8k
	 Pm3CXt/q1clTFaAj0Z/sOE2Zkq79ekFeb6M8qFu0obqzJAtDtNw9KvBoctG95acYny
	 1nlJtdk6gw/xbzow269XWkAw5UFC3+0forv7iqsjCAc5sqPvAU8RSimru2mXhP33Qt
	 88JUnJET3Ss/6htKWAe9DGYi/sVGDb/FRTcpnpjyD+f5x9c0B56GWYqmiQI8v1E/ry
	 eDx6l3tfs8tzA==
Date: Mon, 29 Jul 2024 17:25:04 -0700
Subject: [PATCH 005/115] xfs: introduce a file mapping exchange log intent
 item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842512.1338752.945394817660315327.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6c08f434bd33f88cf169e9e43c7a5e42fb3f2118

Introduce a new intent log item to handle exchanging mappings between
the forks of two files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_format.h |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 16872972e..09024431c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
-
+#define XLOG_REG_TYPE_XMI_FORMAT	31
+#define XLOG_REG_TYPE_XMD_FORMAT	32
+#define XLOG_REG_TYPE_MAX		32
 
 /*
  * Flags to log operation header
@@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUD		0x1245
 #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
+#define	XFS_LI_XMI		0x1248  /* mapping exchange intent */
+#define	XFS_LI_XMD		0x1249  /* mapping exchange done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
 	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
-	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
+	{ XFS_LI_XMI,		"XFS_LI_XMI" }, \
+	{ XFS_LI_XMD,		"XFS_LI_XMD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -878,6 +883,37 @@ struct xfs_bud_log_format {
 	uint64_t		bud_bui_id;	/* id of corresponding bui */
 };
 
+/*
+ * XMI/XMD (file mapping exchange) log format definitions
+ */
+
+/* This is the structure used to lay out an mapping exchange log item. */
+struct xfs_xmi_log_format {
+	uint16_t		xmi_type;	/* xmi log item type */
+	uint16_t		xmi_size;	/* size of this item */
+	uint32_t		__pad;		/* must be zero */
+	uint64_t		xmi_id;		/* xmi identifier */
+
+	uint64_t		xmi_inode1;	/* inumber of first file */
+	uint64_t		xmi_inode2;	/* inumber of second file */
+	uint64_t		xmi_startoff1;	/* block offset into file1 */
+	uint64_t		xmi_startoff2;	/* block offset into file2 */
+	uint64_t		xmi_blockcount;	/* number of blocks */
+	uint64_t		xmi_flags;	/* XFS_EXCHMAPS_* */
+	uint64_t		xmi_isize1;	/* intended file1 size */
+	uint64_t		xmi_isize2;	/* intended file2 size */
+};
+
+#define XFS_EXCHMAPS_LOGGED_FLAGS		(0)
+
+/* This is the structure used to lay out an mapping exchange done log item. */
+struct xfs_xmd_log_format {
+	uint16_t		xmd_type;	/* xmd log item type */
+	uint16_t		xmd_size;	/* size of this item */
+	uint32_t		__pad;
+	uint64_t		xmd_xmi_id;	/* id of corresponding xmi */
+};
+
 /*
  * Dquot Log format definitions.
  *

