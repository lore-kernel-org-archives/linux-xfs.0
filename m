Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEE8C3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 16:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12581206C1
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 16:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b7/Hj/bz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfHOQws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 12:52:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfHOQwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 12:52:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGn69Y008256;
        Thu, 15 Aug 2019 16:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=uu8qtbHDF7mg0Kp3jXyjK8pP99GWIfWdV+RlXmylyRc=;
 b=b7/Hj/bzRXNtNkIi7YyaDSvndEPFEtMhd0QLJBN6OWAVxSy4itl6FcrmqyQvLmCBFPbh
 jaJHWZDbjFWfzFIg5lvdWVQVluWrMRk4NHgGld8KcZQo013DhQVvt/uOy+yDbjecYq33
 t2bjp7m3iqh7otdtK8N6TPAIZgcYeF8GIcP9GoClwE7cmDY2cztkLRPy9r4pmnjh5zg2
 ovRdrtKCCM2fN0S3TngTfh3q02wFMmOHt73cr/u80vqqo89FRLu16u/s+p0MnA4EglyG
 ncDlTyP02B601t/2MNtIlD2nDLoG02NG0lhxSaL58KA3YztSstRS1nwvqm9d0HSIFOu/ PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtuty9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:52:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGlnEk026827;
        Thu, 15 Aug 2019 16:50:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ucgf183fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:50:44 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FGoint030058;
        Thu, 15 Aug 2019 16:50:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:50:43 -0700
Date:   Thu, 15 Aug 2019 09:50:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix reflink source file racing with directio writes
Message-ID: <20190815165043.GB15186@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150164
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
 fs/xfs/xfs_reflink.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c4ec7afd1170..9fd417de15c9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1205,7 +1205,7 @@ xfs_iolock_two_inodes_and_break_layout(
 
 retry:
 	if (src < dest) {
-		inode_lock_shared(src);
+		inode_lock(src);
 		inode_lock_nested(dest, I_MUTEX_NONDIR2);
 	} else {
 		/* src >= dest */
@@ -1216,7 +1216,7 @@ xfs_iolock_two_inodes_and_break_layout(
 	if (error == -EWOULDBLOCK) {
 		inode_unlock(dest);
 		if (src < dest)
-			inode_unlock_shared(src);
+			inode_unlock(src);
 		error = break_layout(dest, true);
 		if (error)
 			return error;
@@ -1225,11 +1225,11 @@ xfs_iolock_two_inodes_and_break_layout(
 	if (error) {
 		inode_unlock(dest);
 		if (src < dest)
-			inode_unlock_shared(src);
+			inode_unlock(src);
 		return error;
 	}
 	if (src > dest)
-		inode_lock_shared_nested(src, I_MUTEX_NONDIR2);
+		inode_lock_nested(src, I_MUTEX_NONDIR2);
 	return 0;
 }
 
@@ -1247,10 +1247,10 @@ xfs_reflink_remap_unlock(
 
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
@@ -1325,7 +1325,7 @@ xfs_reflink_remap_prep(
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else
-		xfs_lock_two_inodes(src, XFS_MMAPLOCK_SHARED, dest,
+		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
 				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
