Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1B4C54FCF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3833020724
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C2l8xL9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgCYDZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 23:25:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYDZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 23:25:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3NUG6110385
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ryadn3Bdx2R+EGEMlBiN1HxZLPtVhNiSW8HKgwPTqA8=;
 b=C2l8xL9pX8qcjdvhYLXIfiMlHUTZ9V2dM1PEQbbIqQDkYoXbZxNSHBeoqELPW1WMGeQv
 ZjJhSJMBehTvXBGONFlx/kKNybM9mGI42+KKvhrAWUTNy/YPcF1QLUhXPi3wmgKOu8t7
 nxDoTe777a0Ttazqtf64U0ubtm/Nf5mwWLjuRcu6yJBxFcfGFtTZmGNa75oJNW09IdPB
 ZnOUH6BYN9RCsxbImd707TF84ywLyVgXqH0pRSbM9juiKj+xb7qqPuctrI8L+bdjpkzh
 uqqZXGMwC5dNqmXV7VR5tr2AV1gvTuTruB0Mg0bnVzCAPKtYsdb0EZVSCZxdcUIJnOI1 eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ywabr7kuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3NoNf139489
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yxw6p0p27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:59 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02P3OwDQ000706
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 20:24:58 -0700
Subject: [PATCH 4/4] xfs: directory bestfree check should release buffers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 24 Mar 2020 20:24:55 -0700
Message-ID: <158510669552.922633.1875283669671200158.stgit@magnolia>
In-Reply-To: <158510667039.922633.6138311243444001882.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're checking bestfree information in directory blocks, always
drop the block buffer at the end of the function.  We should always
release resources when we're done using them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c186c83544ac..f4655453f605 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -508,7 +508,7 @@ xchk_directory_leaf1_bestfree(
 	/* Read the free space block. */
 	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
-		goto out;
+		return error;
 	xchk_buffer_recheck(sc, bp);
 
 	leaf = bp->b_addr;
@@ -573,9 +573,10 @@ xchk_directory_leaf1_bestfree(
 		xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-			goto out;
+			break;
 	}
 out:
+	xfs_trans_brelse(sc->tp, bp);
 	return error;
 }
 
@@ -597,7 +598,7 @@ xchk_directory_free_bestfree(
 	/* Read the free space block */
 	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
-		goto out;
+		return error;
 	xchk_buffer_recheck(sc, bp);
 
 	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
@@ -620,7 +621,7 @@ xchk_directory_free_bestfree(
 				0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
-			break;
+			goto out;
 		xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 	}
@@ -628,6 +629,7 @@ xchk_directory_free_bestfree(
 	if (freehdr.nused + stale != freehdr.nvalid)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 out:
+	xfs_trans_brelse(sc->tp, bp);
 	return error;
 }
 

