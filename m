Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43094 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdHJFYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 01:24:00 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A5Nxb3016787
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A5NxHH008186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:59 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A5Nxjn015133
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:59 GMT
Subject: [PATCH 3/3] xfs: don't leak quotacheck dquots when cow recovery
 fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 09 Aug 2017 22:23:58 -0700
Message-ID: <150234263808.13754.11636194057966589953.stgit@magnolia>
In-Reply-To: <150234262066.13754.6534116056866237943.stgit@magnolia>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we fail a mount on account of cow recovery errors, it's possible that
a previous quotacheck left some dquots in memory.  The bailout clause of
xfs_mountfs forgets to purge these, and so we leak them.  Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: unmount quotas, then free all the quota information
---
 fs/xfs/xfs_mount.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8da5155..d50f4a7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1057,6 +1057,8 @@ xfs_mountfs(
 	xfs_fs_unreserve_ag_blocks(mp);
  out_quota:
 	xfs_qm_unmount_quotas(mp);
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:

