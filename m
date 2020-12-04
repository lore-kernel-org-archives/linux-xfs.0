Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189D1C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3DF224B8
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgLDBNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:13:39 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58394 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgLDBNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:13:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419jm3187991
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GaDjGPt9X0/ZJFNGcg7D288jWW74Mcy7Ppy6860QgaA=;
 b=Ol/y+BEZfYTacdlNK3nUPzwZIFSqCqz4n207lDqx/JO+td0d48gfOdRb4RzdfveSjbCT
 v1se11PbjwyU0isCcTIXtX5Ve6QqrNtfVPD2tct1WuSUB+LjB84AvC/1CK6YfD8GkHtF
 +m1A203GGrQZpkxAv/kpwdxxTN4YDtuUU34v0g4xhDtWVC6kSulcyksGAnXaWDr9igVy
 wq5es6V9PyBRtkcN5tU92KV072YAAb2kuGz65QN1HLwgNOrpZMqsFXPfDlRjp2BOH7F7
 RVV2OtyDbrWl5+7i84902t1MGS4SFLM4x3+E75vhhx42OO1gzmjJUMHKt4R10us8UMFk fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b937q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:12:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AWDk093308
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404rn7av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:12:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B41CvpK013124
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:57 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:57 -0800
Subject: [PATCH 2/3] xfs: fix parent pointer scrubber bailing out on
 unallocated inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:56 -0800
Message-ID: <160704437622.736504.16651484693320221547.stgit@magnolia>
In-Reply-To: <160704436050.736504.11280764290946254498.stgit@magnolia>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_iget can return -ENOENT for a file that the inobt thinks is
allocated but has zeroed mode.  This currently causes scrub to exit
with an operational error instead of flagging this as a corruption.  The
end result is that scrub mistakenly reports the ENOENT to the user
instead of "directory parent pointer corrupt" like we do for EINVAL.

Fixes: 5927268f5a04 ("xfs: flag inode corruption if parent ptr doesn't get us a real inode")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/parent.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 855aa8bcab64..66c35f6dfc24 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -164,13 +164,13 @@ xchk_parent_validate(
 	 * can't use DONTCACHE here because DONTCACHE inodes can trigger
 	 * immediate inactive cleanup of the inode.
 	 *
-	 * If _iget returns -EINVAL then the parent inode number is garbage
-	 * and the directory is corrupt.  If the _iget returns -EFSCORRUPTED
-	 * or -EFSBADCRC then the parent is corrupt which is a cross
-	 * referencing error.  Any other error is an operational error.
+	 * If _iget returns -EINVAL or -ENOENT then the parent inode number is
+	 * garbage and the directory is corrupt.  If the _iget returns
+	 * -EFSCORRUPTED or -EFSBADCRC then the parent is corrupt which is a
+	 *  cross referencing error.  Any other error is an operational error.
 	 */
 	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
-	if (error == -EINVAL) {
+	if (error == -EINVAL || error == -ENOENT) {
 		error = -EFSCORRUPTED;
 		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
 		goto out;

