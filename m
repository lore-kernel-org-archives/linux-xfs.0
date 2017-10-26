Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31728 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdJZFtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:49:39 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9Q5nc10015820
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9Q5nctg022549
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:38 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9Q5nbA2012030
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 05:49:37 GMT
Subject: [PATCH 3/4] xfs: validate sb_logsunit is a multiple of the fs
 blocksize
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Oct 2017 22:49:36 -0700
Message-ID: <150899697674.18095.8949507524525909891.stgit@magnolia>
In-Reply-To: <150899696463.18095.9642473908739425678.stgit@magnolia>
References: <150899696463.18095.9642473908739425678.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the log stripe unit is sane before proceeding with mounting.
AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
block size.  Found this by setting the LSB of logsunit in xfs/350 and
watching the system crash as soon as we try to write to the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dc95a49..4edb36f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -608,6 +608,7 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
+	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -659,9 +660,20 @@ xfs_log_mount(
 			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
 			 XFS_MAX_LOG_BYTES);
 		error = -EINVAL;
+	} else if (mp->m_sb.sb_logsunit > 1 &&
+		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
+		xfs_warn(mp,
+		"log stripe unit %u bytes must be a multiple of block size",
+			 mp->m_sb.sb_logsunit);
+		error = -EINVAL;
+		fatal = true;
 	}
 	if (error) {
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		/*
+		 * Log check errors are always fatal on v5; or whenever bad
+		 * metadata leads to a crash.
+		 */
+		if (fatal) {
 			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
 			ASSERT(0);
 			goto out_free_log;

