Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756065AbdLWAnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:43:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0h5k5097655
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2f1ct0r06e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:05 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0h4i2002599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:04 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0h37A026509
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:03 GMT
Subject: [PATCH 02/21] xfs: catch a few more error codes when scrubbing
 secondary sb
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:43:02 -0800
Message-ID: <151398978264.18741.5137794501763948676.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The superblock validation routines return a variety of error codes to
reject a mount request.  For scrub we can assume that the mount
succeeded, so if we see these things appear when scrubbing secondary sb
X, we can treat them all like corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index b599358..97beb47 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -126,6 +126,22 @@ xfs_scrub_superblock(
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
 		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	/*
+	 * The superblock verifier can return several different error codes
+	 * if it thinks the superblock doesn't look right.  For a mount these
+	 * would all get bounced back to userspace, but if we're here then the
+	 * fs mounted successfully, which means that this secondary superblock
+	 * is simply incorrect.  Treat all these codes the same way we treat
+	 * any corruption.
+	 */
+	switch (error) {
+	case -EINVAL:	/* also -EWRONGFS */
+	case -ENOSYS:
+	case -EFBIG:
+		error = -EFSCORRUPTED;
+	default:
+		break;
+	}
 	if (!xfs_scrub_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
 		return error;
 

