Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35268 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbdLHERN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 23:17:13 -0500
Subject: [PATCH 4/5] mkfs: document sb_feat_args members
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3d8eeb94-8333-9d3d-7767-0a0267a2986e@sandeen.net>
Date: Thu, 7 Dec 2017 22:17:12 -0600
MIME-Version: 1.0
In-Reply-To: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Some of these are more self-explanatory than others ("nci?").
Just mention the bit each one controls, and put them in order
while we're at it.  There are more comments about each bit
near its definition.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/xfs_mkfs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f6e2fad..3f6315d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -760,17 +760,17 @@ struct sb_feat_args {
 	int	log_version;
 	int	attr_version;
 	int	dir_version;
-	bool	inode_align;
-	bool	nci;
-	bool	lazy_sb_counters;
-	bool	projid32bit;
-	bool	crcs_enabled;
-	bool	dirftype;
-	bool	finobt;
-	bool	spinodes;
-	bool	rmapbt;
-	bool	reflink;
-	bool	parent_pointers;
+	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
+	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
+	bool	lazy_sb_counters;	/* XFS_SB_VERSION2_LAZYSBCOUNTBIT */
+	bool	parent_pointers;	/* XFS_SB_VERSION2_PARENTBIT */
+	bool	projid32bit;		/* XFS_SB_VERSION2_PROJID32BIT */
+	bool	crcs_enabled;		/* XFS_SB_VERSION2_CRCBIT */
+	bool	dirftype;		/* XFS_SB_VERSION2_FTYPE */
+	bool	finobt;			/* XFS_SB_FEAT_RO_COMPAT_FINOBT */
+	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
+	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
+	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	nodalign;
 	bool	nortalign;
 };
-- 
1.8.3.1

