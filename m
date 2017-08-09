Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38563 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbdHIBHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2017 21:07:03 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v79172HE014111
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:07:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v79172tX011014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:07:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v79171GK022721
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:07:01 GMT
Date: Tue, 8 Aug 2017 18:07:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] xfs: don't leak quotacheck dquots when cow recovery fails
Message-ID: <20170809010700.GA4461@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809010444.GR24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

If we fail a mount on account of cow recovery errors, it's possible that
a previous quotacheck left some dquots in memory.  The bailout clause of
xfs_mountfs forgets to purge these, and so we leak them.  Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d463ab3..8a12118 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1029,6 +1029,8 @@ xfs_mountfs(
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
  out_quota:
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
