Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37680 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdJXA2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 20:28:52 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9O0Sp5b022640
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9O0SpZx008568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:51 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9O0SoCk008628
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:50 GMT
Date: Mon, 23 Oct 2017 17:28:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: validate sb_logsunit is a multiple of the fs blocksize
Message-ID: <20171024002844.GM5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Make sure the log stripe unit is sane before proceeding with mounting.
AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
block size.  Found this by setting the LSB of logsunit in xfs/350 and
watching the system crash as soon as we try to write to the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d729e00..da4dcab 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -659,6 +659,12 @@ xfs_log_mount(
 			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
 			 XFS_MAX_LOG_BYTES);
 		error = -EINVAL;
+	} else if (mp->m_sb.sb_logsunit > 1 &&
+		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
+		xfs_warn(mp,
+		"log stripe unit %u bytes must be a multiple of block size",
+			 mp->m_sb.sb_logsunit);
+		error = -EINVAL;
 	}
 	if (error) {
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
