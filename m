Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48370 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbeBVXOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 18:14:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1MNCJ8F106975
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:14:37 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ga7a7g0rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:14:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1MN4a1h004608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:04:37 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1MN4aWF025968
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:04:36 GMT
Date: Thu, 22 Feb 2018 15:04:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't iunlock the quota ip when quota block allocation
 fails
Message-ID: <20180222230435.GJ9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_qm_dqalloc, we join the locked quota inode to the transaction we
use to allocate blocks.  If the allocation or mapping fails, we're not
allowed to unlock the inode because the transaction code is in charge of
unlocking it for us.  Therefore, remove the iunlock call to avoid
blowing asserts about unbalanced locking + mount hang.

Found by corrupting the AGF and allocating space in the filesystem
(quotacheck) immediately after mount.  The upcoming agfl wrapping fixup
test will trigger this scenario.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 43572f8..2410acc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -394,8 +394,6 @@ xfs_qm_dqalloc(
 error1:
 	xfs_defer_cancel(&dfops);
 error0:
-	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
-
 	return error;
 }
 
