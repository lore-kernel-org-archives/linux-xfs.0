Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07D6C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiAaX4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:56:38 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59513 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbiAaX4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:56:37 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7CA7962C89C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 10:56:36 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGZ-006aSA-0X
        for linux-xfs@vger.kernel.org; Tue, 01 Feb 2022 10:39:23 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-003I2D-Vf
        for linux-xfs@vger.kernel.org;
        Tue, 01 Feb 2022 10:39:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: ensure log flush at the end of a synchronous fallocate call
Date:   Tue,  1 Feb 2022 10:39:20 +1100
Message-Id: <20220131233920.784181-6-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131233920.784181-1-david@fromorbit.com>
References: <20220131233920.784181-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f87734
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=fMX4GkhXMM7_DdFnNeUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Since we've started treating fallocate more like a file write, we
should flush the log to disk if the user has asked for synchronous
writes either by setting it via fcntl flags, or inode flags, or with
the sync mount option.  We've already got a helper for this, so use
it.

[Slightly massaged by <dchinner@redhat.com> to fit this patchset]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cecc5dedddff..5bddb1e9e0b3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -861,6 +861,21 @@ xfs_break_layouts(
 	return error;
 }
 
+/* Does this file, inode, or mount want synchronous writes? */
+static inline bool xfs_file_sync_writes(struct file *filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (xfs_has_wsync(ip->i_mount))
+		return true;
+	if (filp->f_flags & (__O_SYNC | O_DSYNC))
+		return true;
+	if (IS_SYNC(file_inode(filp)))
+		return true;
+
+	return false;
+}
+
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
@@ -1048,7 +1063,7 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
-	if (file->f_flags & O_DSYNC)
+	if (xfs_file_sync_writes(file))
 		error = xfs_log_force_inode(ip);
 
 out_unlock:
@@ -1081,21 +1096,6 @@ xfs_file_fadvise(
 	return ret;
 }
 
-/* Does this file, inode, or mount want synchronous writes? */
-static inline bool xfs_file_sync_writes(struct file *filp)
-{
-	struct xfs_inode	*ip = XFS_I(file_inode(filp));
-
-	if (xfs_has_wsync(ip->i_mount))
-		return true;
-	if (filp->f_flags & (__O_SYNC | O_DSYNC))
-		return true;
-	if (IS_SYNC(file_inode(filp)))
-		return true;
-
-	return false;
-}
-
 STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
-- 
2.33.0

