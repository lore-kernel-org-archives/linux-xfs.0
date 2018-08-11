Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:09:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7BFXpq1068869
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ksreprnmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFZ40w029033
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:04 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7BFZ4I1011261
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:04 GMT
Subject: [PATCH 1/6] xfs: recalculate summary counters at mount time if
 icount is bad
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:35:03 -0700
Message-ID: <153400170370.27471.3984686896617555055.stgit@magnolia>
In-Reply-To: <153400169747.27471.4044680761841034489.stgit@magnolia>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the sb write verifier trips on bad icounts, we should also force a
mount time recalculation of the summary counters if the icount is bad.
This helps us avoid blowing up at freeze/unmount time when the bad
counter gets written back out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 99db27d6ac8a..02d15098dbee 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -637,6 +637,7 @@ xfs_check_summary_counts(
 	 */
 	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
+	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
 	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
 		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
 
