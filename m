Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEPUjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 16:39:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B114356C4
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:39:17 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F11B11001943
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:39:16 +0000 (UTC)
Subject: [PATCH 5/3] libxfs: rename bli_format to avoid confusion with
 bli_formats
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d8f37464-9d76-2b09-f458-e236ef9afd95@redhat.com>
Date: Thu, 16 May 2019 15:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Rename the bli_format structure to __bli_format to avoid
accidently confusing them with the bli_formats pointer.

(nb: userspace currently has no bli_formats pointer)

Source kernel commit: b94381737e9c4d014a4003e8ece9ba88670a2dd4

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_trans.h | 2 +-
 libxfs/logitem.c    | 6 +++---
 libxfs/trans.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 953da5d1..fe03ba64 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -39,7 +39,7 @@ typedef struct xfs_buf_log_item {
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* recursion count */
-	xfs_buf_log_format_t	bli_format;	/* in-log header */
+	xfs_buf_log_format_t	__bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
 #define XFS_BLI_DIRTY			(1<<0)
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 4da9bc1b..e862ab4f 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -107,9 +107,9 @@ xfs_buf_item_init(
 	bip->bli_item.li_mountp = mp;
 	INIT_LIST_HEAD(&bip->bli_item.li_trans);
 	bip->bli_buf = bp;
-	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
+	bip->__bli_format.blf_type = XFS_LI_BUF;
+	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
+	bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
 	bp->b_log_item = bip;
 }
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6967a1de..f3c28fa7 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -531,8 +531,8 @@ xfs_trans_binval(
 	xfs_buf_stale(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
+	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
-- 
2.17.0
