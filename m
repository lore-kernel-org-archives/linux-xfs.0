Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8124C4725C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A3120774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MhLitvgE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgD3WrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgD3WrP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhxeV047548
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=FAUP6Yt7JoTrcOjSHseLpFvHxlDXF6kfBE2Cbv9UB0c=;
 b=MhLitvgEKvtHRSQs7pxgeJBdIX53AE/pd9VlQPEekMCFe1sYCOUyelmTKFhbqdkaSL8d
 hN0/Dj2NkXCsRNlfcuGrkoMgU6nOwRvyUMggwo464X0epUIG75/de2cdA69RTxyg6VTX
 8Nv+krwNns6IrYnxm68+JuR7OXAJesngtx4FKg+WaEKIBkmRuw9rsvyI7Teic5z6ZUWC
 u8n8a/loede1tvhxJ3rd60/2x/mBNPeNpg0hv0Qolf73e0W9+nSgUts4uvvSA5gmpj2C
 unHgYcDgMY4Lx9auck9p2or77ydVU8X2uGY+TXK+8eYixXkOWJVBRBGxmCiYzlG+Nknm 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30r7f5r274-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgKjn141696
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23dw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMlDJO012379
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:13 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 32/43] xfsprogs: Remove unneeded xfs_trans_roll_inode calls
Date:   Thu, 30 Apr 2020 15:46:49 -0700
Message-Id: <20200430224700.4183-33-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
needed. If they are the last operations executed in these functions, and
no further changes are made, then higher level routines will roll or
commit the tranactions. The xfs_trans_roll in _removename is also not
needed because invalidating blocks is an incore-only change.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index dfb2854..d75bc2a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -698,16 +698,8 @@ xfs_attr_leaf_addname(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				return error;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
 		}
 
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -715,12 +707,6 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			return error;
-
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -785,9 +771,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	}
 	return 0;
 }
@@ -1075,13 +1058,6 @@ restart:
 				goto out;
 		}
 
-		/*
-		 * Commit and start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -1089,14 +1065,6 @@ restart:
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
-
-		 /*
-		  * Commit the flag value change and start the next trans in
-		  * series.
-		  */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
 	}
 	retval = error = 0;
 
@@ -1137,10 +1105,6 @@ xfs_attr_node_shrink(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	} else
 		xfs_trans_brelse(args->trans, bp);
 
@@ -1195,10 +1159,6 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
-
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
-- 
2.7.4

