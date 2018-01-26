Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbeAZCRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:17:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2HPLi151175
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:36 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2fqu8f00xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25ZtO029276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:35 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25YJk010835
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:34 GMT
Subject: [PATCH 6/6] xfs: don't clobber inobt/finobt cursors when xref with
 rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:05:25 -0800
Message-ID: <151693232496.7395.4886935058204635001.stgit@magnolia>
In-Reply-To: <151693228803.7395.12526880865470882359.stgit@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Even if we can't use the inobt/finobt cursors to count the number of
inode btree blocks, we are never allowed to clobber the cursor of the
btree being checked, so don't do this.  Found by fuzzing level = ones
in xfs/364.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 21c850a..63ab3f9 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -391,12 +391,12 @@ xfs_scrub_iallocbt_xref_rmap_btreeblks(
 
 	/* Check that we saw as many inobt blocks as the rmap says. */
 	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur))
+	if (!xfs_scrub_process_error(sc, 0, 0, &error))
 		return;
 
 	if (sc->sa.fino_cur) {
 		error = xfs_btree_count_blocks(sc->sa.fino_cur, &finobt_blocks);
-		if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur))
+		if (!xfs_scrub_process_error(sc, 0, 0, &error))
 			return;
 	}
 

