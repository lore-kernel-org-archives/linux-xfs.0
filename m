Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF00C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A12EB2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DDPuTZ1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAABJ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgAABJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119R5Z089230
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MB051OOVeLNKLRqjmW8cN13Rjv3Q8LzBl9DCJpNA+zk=;
 b=DDPuTZ1NomoPBa5TjFo/LgArvDknQO/JQFKK1mVzIbQP74QA9XyVGBSOaiHTBpfLwnSD
 hp4OuW0sufW7AOpLfEXXYKwxXQLUT5ZOQYKDzdQAKvfJJ2i8u5xjiy7gVm3mey+S0bQM
 joN/U4LjTC0p+IIjWKlBxAytJd1+hx0DB27DKjzcaezNQF4ZRBi7dpy5i2rT7KSCXxqU
 /30Y6QyZoUE533c6Q0zM6MIlCule/oz4vU5QIIWb626oyaq6i13AsQi5zKA1te4KPaVu
 Keuf0hqYLtEwgC8u5JldxT5JOiy6+NRuKhbNF/+Fjr5hNFI25YniaxsRYIrBEqmJ5tp/ bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xhJ012473
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8gueecgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:27 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00119QJR031519
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:26 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:25 -0800
Subject: [PATCH 07/10] xfs: force inode inactivation and retry fs writes
 when there isn't space
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:23 -0800
Message-ID: <157784096361.1362752.6646122257069139549.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Any time we try to modify a file's contents and it fails due to ENOSPC
or EDQUOT, force inactivation work to free up some resources and try one
more time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b398f197d748..192852499729 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -883,6 +883,7 @@ xfs_buffered_write_iomap_begin(
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
 	bool			eof = false, cow_eof = false, shared = false;
+	bool			cleared_space = false;
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
@@ -893,6 +894,7 @@ xfs_buffered_write_iomap_begin(
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 
+start_over:
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, XFS_DATA_FORK)) ||
@@ -1035,6 +1037,18 @@ xfs_buffered_write_iomap_begin(
 		break;
 	case -ENOSPC:
 	case -EDQUOT:
+		/*
+		 * If the delalloc reservation failed due to a lack of space,
+		 * try to flush inactive inodes to free some space.
+		 */
+		if (!cleared_space) {
+			cleared_space = true;
+			allocfork = XFS_DATA_FORK;
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_inactive_force(mp);
+			error = 0;
+			goto start_over;
+		}
 		/* retry without any preallocation */
 		trace_xfs_delalloc_enospc(ip, offset, count);
 		if (prealloc_blocks) {

