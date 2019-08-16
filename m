Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C502C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 16:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B092064A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 16:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nWk6FIht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfHPQLu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:11:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfHPQLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 12:11:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7GFxLak139918;
        Fri, 16 Aug 2019 16:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/XfcHtmvknRfAGCFyoREtSX/yPAfQMruwvDm1ATWtDE=;
 b=nWk6FIhtC6xe5nQGwTRsPSw+Gh4Uf0NYE3caRf13eC7UosRfXnHHJ7l6o7nWy9sd8I7D
 BxLcc2DMjDGQNSL9z4KeoM39LUgPVIQnhR1+Mjea7mZO44Iaff+da9ddjUwxy+hZUR3U
 byrTnVSo3UpIVilJhKgmMUN3e2z9ymzTUb2EM+r+VqtG0xdnL1+k7WUBEq+Qv3Skby/K
 X59vJ0n0o3BZ6j9R9Zibyrc8oaddcGDHl+sVxR8x3IIybKcSNNDu9ylrqdIqTCbKUbby
 AWA0gfY3qDmxPqRyRhFWUuyxwZWlDnQNxhH79PvkAKiFKU7ZqkF404FM+TVfMD+4l5Xt Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbu1dpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Aug 2019 16:11:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7GFw4pQ087449;
        Fri, 16 Aug 2019 16:11:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2udgqg9sa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Aug 2019 16:11:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7GGBa5F032097;
        Fri, 16 Aug 2019 16:11:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 09:11:35 -0700
Date:   Fri, 16 Aug 2019 09:11:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: fix reflink source file racing with directio writes
Message-ID: <20190816161134.GH15186@magnolia>
References: <20190815165043.GB15186@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815165043.GB15186@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908160170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908160170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While trawling through the dedupe file comparison code trying to fix
page deadlocking problems, Dave Chinner noticed that the reflink code
only takes shared IOLOCK/MMAPLOCKs on the source file.  Because
page_mkwrite and directio writes do not take the EXCL versions of those
locks, this means that reflink can race with writer processes.

For pure remapping this can lead to undefined behavior and file
corruption; for dedupe this means that we cannot be sure that the
contents are identical when we decide to go ahead with the remapping.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: break both layouts
---
 fs/xfs/xfs_reflink.c |   63 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c4ec7afd1170..edbe37b7f636 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1190,11 +1190,11 @@ xfs_reflink_remap_blocks(
 }
 
 /*
- * Grab the exclusive iolock for a data copy from src to dest, making
- * sure to abide vfs locking order (lowest pointer value goes first) and
- * breaking the pnfs layout leases on dest before proceeding.  The loop
- * is needed because we cannot call the blocking break_layout() with the
- * src iolock held, and therefore have to back out both locks.
+ * Grab the exclusive iolock for a data copy from src to dest, making sure to
+ * abide vfs locking order (lowest pointer value goes first) and breaking the
+ * layout leases before proceeding.  The loop is needed because we cannot call
+ * the blocking break_layout() with the iolocks held, and therefore have to
+ * back out both locks.
  */
 static int
 xfs_iolock_two_inodes_and_break_layout(
@@ -1203,33 +1203,44 @@ xfs_iolock_two_inodes_and_break_layout(
 {
 	int			error;
 
-retry:
-	if (src < dest) {
-		inode_lock_shared(src);
-		inode_lock_nested(dest, I_MUTEX_NONDIR2);
-	} else {
-		/* src >= dest */
-		inode_lock(dest);
-	}
+	if (src > dest)
+		swap(src, dest);
 
-	error = break_layout(dest, false);
-	if (error == -EWOULDBLOCK) {
-		inode_unlock(dest);
-		if (src < dest)
-			inode_unlock_shared(src);
+retry:
+	/* Wait to break both inodes' layouts before we start locking. */
+	error = break_layout(src, true);
+	if (error)
+		return error;
+	if (src != dest) {
 		error = break_layout(dest, true);
 		if (error)
 			return error;
-		goto retry;
 	}
+
+	/* Lock one inode and make sure nobody got in and leased it. */
+	inode_lock(src);
+	error = break_layout(src, false);
 	if (error) {
+		inode_unlock(src);
+		if (error == -EWOULDBLOCK)
+			goto retry;
+		return error;
+	}
+
+	if (src == dest)
+		return 0;
+
+	/* Lock the other inode and make sure nobody got in and leased it. */
+	inode_lock_nested(dest, I_MUTEX_NONDIR2);
+	error = break_layout(dest, false);
+	if (error) {
+		inode_unlock(src);
 		inode_unlock(dest);
-		if (src < dest)
-			inode_unlock_shared(src);
+		if (error == -EWOULDBLOCK)
+			goto retry;
 		return error;
 	}
-	if (src > dest)
-		inode_lock_shared_nested(src, I_MUTEX_NONDIR2);
+
 	return 0;
 }
 
@@ -1247,10 +1258,10 @@ xfs_reflink_remap_unlock(
 
 	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
 	if (!same_inode)
-		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
+		xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
 	inode_unlock(inode_out);
 	if (!same_inode)
-		inode_unlock_shared(inode_in);
+		inode_unlock(inode_in);
 }
 
 /*
@@ -1325,7 +1336,7 @@ xfs_reflink_remap_prep(
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else
-		xfs_lock_two_inodes(src, XFS_MMAPLOCK_SHARED, dest,
+		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
 				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
