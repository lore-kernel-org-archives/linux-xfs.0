Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933642AbcJFVSg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Oct 2016 17:18:36 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 213F3C04B921
        for <linux-xfs@vger.kernel.org>; Thu,  6 Oct 2016 21:18:36 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] xfs: Remove unused xfs_evict_inode tracepoint
Date: Thu,  6 Oct 2016 23:18:33 +0200
Message-Id: <1475788713-3415-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Commit 8179c036 removed the ->evict_inode super operation but left the
xfs_evict_inode tracepoint in place, with the effect that that
tracepoint is now unused.  Remove the tracepoint as well now.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d303a66..fdd9d53 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -677,7 +677,6 @@ DEFINE_INODE_EVENT(xfs_ioctl_setattr);
 DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_evict_inode);
 DEFINE_INODE_EVENT(xfs_update_time);
 
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
-- 
2.7.4

