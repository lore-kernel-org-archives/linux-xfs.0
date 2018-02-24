Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp004.me.com ([17.110.69.135]:28538 "EHLO
        mr11p00im-asmtp004.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbeBXLdj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 06:33:39 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp004.me.com by
 mr11p00im-asmtp004.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P4N00I00H6RMT00@mr11p00im-asmtp004.me.com> for
 linux-xfs@vger.kernel.org; Sat, 24 Feb 2018 10:33:35 +0000 (GMT)
From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH] xfs: fix potential memory leak in mount option parsing
Date: Sat, 24 Feb 2018 18:33:26 +0800
Message-id: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

When specifying string type mount option (e.g., logdev)
several times in a mount, current option parsing may
cause memory leak. Hence, call kfree for previous one
in this case.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 fs/xfs/xfs_super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7aba628..93588ea 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -250,6 +250,7 @@ enum {
 				return -EINVAL;
 			break;
 		case Opt_logdev:
+			kfree(mp->m_logname);
 			mp->m_logname = match_strdup(args);
 			if (!mp->m_logname)
 				return -ENOMEM;
@@ -258,6 +259,7 @@ enum {
 			xfs_warn(mp, "%s option not allowed on this system", p);
 			return -EINVAL;
 		case Opt_rtdev:
+			kfree(mp->m_rtname);
 			mp->m_rtname = match_strdup(args);
 			if (!mp->m_rtname)
 				return -ENOMEM;
-- 
1.8.3.1

