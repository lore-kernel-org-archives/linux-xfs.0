Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbeBWCM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:12:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N2CPJB076402
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:12:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2ga9bpg33v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:12:26 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1N1xnbn029961
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:49 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N1xniC005215
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:49 GMT
Subject: [PATCH 1/5] xfs: don't iunlock the quota ip when quota block
 allocation fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 17:59:48 -0800
Message-ID: <151935118851.21654.14051188649580444275.stgit@magnolia>
In-Reply-To: <151935118240.21654.10146641674018880885.stgit@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
 

