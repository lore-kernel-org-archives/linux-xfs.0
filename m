Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD82C388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C3E206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tv0Pyl7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgKISRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9I9Cdg112559;
        Mon, 9 Nov 2020 18:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MojAbhtXM8BH7zc7RArrP2ESaTQPUl95kB5RhV8vXHM=;
 b=tv0Pyl7sGaPoHWE3BtuNUAfjuuhkxNluZhplHZjMg2jkpgm1Em/1KPQduUH2Y1SqIUI9
 AazeMzVnixhCPFrRHCzIT0jf8kREIW2dAKMS7TOMpLd5QeAlvFrcb8L/8MMgTsf60GvB
 5GE761FNMv+pmod5ZuJ1A83f/cnZ/ng0go57+OtbIkyP1MMgnM726Fyd5fLXQM+qfOI7
 9V/x/+ua68rkqBnbtUy6uitiX8KkEwCVZDYensaaIkySZnKbiKUF+uXWljM8OwzpSSJg
 qz9OxYCdT06wJw2rt8sJ8n/6WthpVnY/YLa+bbg3wnDNl4Ek2G5wvLe2Ip3/M4VWCWig 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72edmwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IAnis157295;
        Mon, 9 Nov 2020 18:17:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5fy1he3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9IHTlE001400;
        Mon, 9 Nov 2020 18:17:29 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:29 -0800
Subject: [PATCH 3/3] xfs: fix rmap key and record comparison functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:28 -0800
Message-ID: <160494584816.772693.2490433010759557816.stgit@magnolia>
In-Reply-To: <160494582942.772693.12774142799511044233.stgit@magnolia>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Keys for extent interval records in the reverse mapping btree are
supposed to be computed as follows:

(physical block, owner, fork, is_btree, is_unwritten, offset)

This provides users the ability to look up a reverse mapping from a bmbt
record -- start with the physical block; then if there are multiple
records for the same block, move on to the owner; then the inode fork
type; and so on to the file offset.

However, the key comparison functions incorrectly remove the
fork/btree/unwritten information that's encoded in the on-disk offset.
This means that lookup comparisons are only done with:

(physical block, owner, offset)

This means that queries can return incorrect results.  On consistent
filesystems this hasn't been an issue because blocks are never shared
between forks or with bmbt blocks; and are never unwritten.  However,
this bug means that online repair cannot always detect corruption in the
key information in internal rmapbt nodes.

Found by fuzzing keys[1].attrfork = ones on xfs/371.

Fixes: 4b8ed67794fe ("xfs: add rmap btree operations")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index beb81c84a937..577a66381327 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -243,8 +243,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
-	y = rec->rm_offset;
+	x = be64_to_cpu(kp->rm_offset);
+	y = xfs_rmap_irec_offset_pack(rec);
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -275,8 +275,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
-	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	x = be64_to_cpu(kp1->rm_offset);
+	y = be64_to_cpu(kp2->rm_offset);
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -390,8 +390,8 @@ xfs_rmapbt_keys_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
+	a = be64_to_cpu(k1->rmap.rm_offset);
+	b = be64_to_cpu(k2->rmap.rm_offset);
 	if (a <= b)
 		return 1;
 	return 0;
@@ -420,8 +420,8 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
+	a = be64_to_cpu(r1->rmap.rm_offset);
+	b = be64_to_cpu(r2->rmap.rm_offset);
 	if (a <= b)
 		return 1;
 	return 0;

