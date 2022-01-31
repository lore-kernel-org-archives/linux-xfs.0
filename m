Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8514C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 06:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbiAaGnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 01:43:55 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51533 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357729AbiAaGny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 01:43:54 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 812DF62C1CC
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:43:53 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-006J3X-Ov
        for linux-xfs@vger.kernel.org; Mon, 31 Jan 2022 17:43:52 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-0036UV-NE
        for linux-xfs@vger.kernel.org;
        Mon, 31 Jan 2022 17:43:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: fallocate() should call file_modified()
Date:   Mon, 31 Jan 2022 17:43:47 +1100
Message-Id: <20220131064350.739863-3-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131064350.739863-1-david@fromorbit.com>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f78529
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=DghFqjY3_ZEA:10 a=20KFwNOVAAAA:8 a=pJPz2Wz_UPgdBXldDbIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6eda41710a5a..223996822d84 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -953,6 +953,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -1053,11 +1057,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.33.0

