Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A411EBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="piZ2KTa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71447C433C8;
	Sun, 31 Dec 2023 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054161;
	bh=S5sTLP1z4LXkTjUU3rHwT5A8Gre0PwCtJH3JVb9XzMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=piZ2KTa8+dAm6R7ouGA+t5/0TasUllgUlwozvRB7/rUbV6/VJenbQTSJ8yYIwfgcT
	 uZgfp40UCtbzjs3B3eQVkAMZq7dbkxou/8VK0wMafPtpguAWm02XqtAO+s3VE53d9q
	 3dOGmvhXkntxfLzohS3Aedw7GDMEeejZGxT4EaR53B07Ar/+L1VDpJYf2zAmHv/fHm
	 zsG+TnLsJvwl1dSQTlSTLx2dx3hs2M8xdmiHvUXQpOjMZwCvJHdWZcePBcpMI0PSWT
	 LkWlXmRDbcLmZ+rT7ZpJ4uA3o41z3k5D/JGK/I8nCUasjywfp7V10yFtFUhAdpb0cb
	 Wmb0eVciG8MTg==
Date: Sun, 31 Dec 2023 12:22:41 -0800
Subject: [PATCH 2/3] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831907.1749931.14510682723075122416.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
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

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/xfs_bmap_item.c         |    8 ++++++++
 fs/xfs/xfs_trace.h             |   23 ++++++++++++++++++-----
 3 files changed, 29 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 269573c828085..16872972e1e97 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -838,10 +838,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3315a38f35973..d19f82c367f2b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -275,6 +275,8 @@ xfs_bmap_update_log_item(
 		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
 	if (bi->bi_whichfork == XFS_ATTR_FORK)
 		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		map->me_flags |= XFS_BMAP_EXTENT_REALTIME;
 }
 
 static struct xfs_log_item *
@@ -324,6 +326,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
 	/*
@@ -353,6 +358,9 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 52e54ec267cb8..a36b48432d093 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2958,9 +2958,11 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 	TP_ARGS(bi),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_ino_t, ino)
 		__field(xfs_agblock_t, agbno)
+		__field(xfs_fsblock_t, rtbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
@@ -2971,23 +2973,34 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		struct xfs_inode	*ip = bi->bi_owner;
 
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
-					bi->bi_bmap.br_startblock);
+		if (xfs_ifork_is_realtime(ip, bi->bi_whichfork)) {
+			__entry->agno = 0;
+			__entry->agbno = 0;
+			__entry->rtbno = bi->bi_bmap.br_startblock;
+			__entry->opdev = ip->i_mount->m_rtdev_targp->bt_dev;
+		} else {
+			__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
+						bi->bi_bmap.br_startblock);
+			__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
+						bi->bi_bmap.br_startblock);
+			__entry->rtbno = 0;
+			__entry->opdev = __entry->dev;
+		}
 		__entry->ino = ip->i_ino;
-		__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
-					bi->bi_bmap.br_startblock);
 		__entry->whichfork = bi->bi_whichfork;
 		__entry->l_loff = bi->bi_bmap.br_startoff;
 		__entry->l_len = bi->bi_bmap.br_blockcount;
 		__entry->l_state = bi->bi_bmap.br_state;
 		__entry->op = bi->bi_type;
 	),
-	TP_printk("dev %d:%d op %s ino 0x%llx agno 0x%x agbno 0x%x %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s opdev %d:%d ino 0x%llx agno 0x%x agbno 0x%x rtbno 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_BMAP_INTENT_STRINGS),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->ino,
 		  __entry->agno,
 		  __entry->agbno,
+		  __entry->rtbno,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,

