Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61306C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 06:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357759AbiAaGnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 01:43:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36949 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357737AbiAaGnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 01:43:55 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F5E110C46AF
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:43:53 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-006J3Z-QA
        for linux-xfs@vger.kernel.org; Mon, 31 Jan 2022 17:43:52 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-0036UZ-Ou
        for linux-xfs@vger.kernel.org;
        Mon, 31 Jan 2022 17:43:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Mon, 31 Jan 2022 17:43:48 +1100
Message-Id: <20220131064350.739863-4-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131064350.739863-1-david@fromorbit.com>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f78529
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=DghFqjY3_ZEA:10 a=20KFwNOVAAAA:8 a=n-keCb1F8oNt4y2wP1kA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 3 +++
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d4a387d3d0ce..44fd91deeca8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -869,6 +869,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+                xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		/*
 		 * Complete the transaction
 		 */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 223996822d84..ae6f5b15a023 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -908,7 +908,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -1006,8 +1005,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1057,11 +1054,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.33.0

