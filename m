Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E3DC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 01:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F7D2070A
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 01:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bAVWEO3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgC0BqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 21:46:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgC0BqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 21:46:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1iFGJ078504
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2020 01:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Fsd/X3++9R4WpShA2c3WwXHc/GV5WaN6dMAXtez7EkY=;
 b=bAVWEO3UcPdzllgAV8vWrXoC2JZVoKGh63tlj+T31y1ul1P7wplF4oBcoVjJ/dm1lldk
 T9wiafJKHtexXNQ6DNCUmHxAZu8PVzgaHUmUpr4b2ce/Crfn/DIWykQTGQRTpcYXGrHt
 y5kn93MdgrpLhsDNVsoB4ChMBvavpchJYKf0EWSKq9D4Reg7kG74hS3YlfIi8xvjKURk
 4MKi8T/LwASQk2B8zRJ6aEmpdfG9UROBzQcNhIheQz/jI/IJ1erXG6HYgNc2N5emSX64
 FTUDANSsKmprl2hZOCDzySQu96yewxLuEEL4JCOd8pZ+xM5VnEkzz8mAR42M8fqtja3x Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavmjvpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2020 01:46:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1gnPb065660
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2020 01:46:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30073f4ana-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2020 01:46:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R1jx8v005374
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2020 01:46:00 GMT
Received: from localhost (/10.159.247.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 18:45:59 -0700
Date:   Thu, 26 Mar 2020 18:45:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't flush the entire filesystem when a buffered write
 runs out of space
Message-ID: <20200327014558.GG29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A customer reported rcu stalls and softlockup warnings on a computer
with many CPU cores and many many more IO threads trying to write to a
filesystem that is totally out of space.  Subsequent analysis pointed to
the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
which causes a lot of wb_writeback_work to be queued.  The writeback
worker spends so much time trying to wake the many many threads waiting
for writeback completion that it trips the softlockup detector, and (in
this case) the system automatically reboots.

In addition, they complain that the lengthy xfs_flush_inodes scan traps
all of those threads in uninterruptible sleep, which hampers their
ability to kill the program or do anything else to escape the situation.

Fix this by replacing the full filesystem flush (which is offloaded to a
workqueue which we then have to wait for) with directly flushing the
file that we're trying to write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..08f0aa7e9cea 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -651,14 +651,18 @@ xfs_file_buffered_aio_write(
 
 	/*
 	 * If we hit a space limit, try to free up some lingering preallocated
-	 * space before returning an error. In the case of ENOSPC, first try to
-	 * write back all dirty inodes to free up some of the excess reserved
-	 * metadata space. This reduces the chances that the eofblocks scan
-	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
-	 * also behaves as a filter to prevent too many eofblocks scans from
-	 * running at the same time.
+	 * space and delalloc reservations before returning an error.
 	 */
-	if (ret == -EDQUOT && !enospc) {
+	if ((ret == -EDQUOT || ret == -ENOSPC) && !enospc) {
+		/*
+		 * Flush the current file's dirty data to free up any delalloc
+		 * reservation blocks that might have been reserved for bmbt
+		 * expansion.  Ignore the return code because we don't want to
+		 * return EIO for a different write that failed.
+		 */
+		filemap_fdatawrite(mapping);
+		filemap_fdatawait_keep_errors(mapping);
+
 		xfs_iunlock(ip, iolock);
 		enospc = xfs_inode_free_quota_eofblocks(ip);
 		if (enospc)
@@ -667,17 +671,6 @@ xfs_file_buffered_aio_write(
 		if (enospc)
 			goto write_retry;
 		iolock = 0;
-	} else if (ret == -ENOSPC && !enospc) {
-		struct xfs_eofblocks eofb = {0};
-
-		enospc = 1;
-		xfs_flush_inodes(ip->i_mount);
-
-		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-		goto write_retry;
 	}
 
 	current->backing_dev_info = NULL;
