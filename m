Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10633BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR5bCm4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12A6C433C8;
	Sun, 31 Dec 2023 21:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056789;
	bh=O892RPEem754cWbfBuPUOYGwoDkOkgbAB98ZlIkh0oc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eR5bCm4wnOfKRN2lnkP2TvoYZxplq5nXyRMNz/WKuLQ0fClYiyAYviMo11cgW48OH
	 uXGHq3lY13DK/Dc5OsCQ73/OtwRg9zzkhmm7zLye4+izWXeN67aKooEIEQhyLpM2YD
	 xTZCa4Kj87RyGj6tOz31FrERbq5mxlnz5nsW6QMtRk1JMIwlsa2RXPKniIehxMjwvz
	 /u8c+6dBythRotIvYdBfeIrIlx0GoUCqpAfctOK/RekSKYeYgIquNu4KdbfmYHaG/z
	 KhZJxM0M4hyMo9qkHeoIC7WCH4HVGXdLd0l4mf/T6MhEqeT40yeDjHSpFyGZSWwazk
	 8n/ThzCQt56xw==
Date: Sun, 31 Dec 2023 13:06:29 -0800
Subject: [PATCH 01/32] xfs: don't use the incore struct xfs_sb for offsets
 into struct xfs_dsb
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844880.1760491.532290995573986019.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Currently, the XFS_SB_CRC_OFF macro uses the incore superblock struct
(xfs_sb) to compute the address of sb_crc within the ondisk superblock
struct (xfs_dsb).  This is a landmine if we ever change the layout of
the incore superblock (as we're about to do), so redefine the macro
to use xfs_dsb to compute the layout of xfs_dsb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    9 ++++-----
 fs/xfs/libxfs/xfs_ondisk.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b0aaa825539f6..c60af43696326 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -90,8 +90,7 @@ struct xfs_ifork;
 #define XFSLABEL_MAX			12
 
 /*
- * Superblock - in core version.  Must match the ondisk version below.
- * Must be padded to 64 bit alignment.
+ * Superblock - in core version.  Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
 	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -178,10 +177,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
-#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
-
 /*
- * Superblock - on disk version.  Must match the in core version above.
+ * Superblock - on disk version.
  * Must be padded to 64 bit alignment.
  */
 struct xfs_dsb {
@@ -265,6 +262,8 @@ struct xfs_dsb {
 	/* must be padded to 64 bit alignment */
 };
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
+
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index bffd39242d487..832d96f0f3c54 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -85,6 +85,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
+	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);

