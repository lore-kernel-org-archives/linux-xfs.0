Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD785C4725D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2733214D8
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hdaNfBCT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgD3WrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgD3WrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhLMa063585
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Xz2bJvQsISUXKEKLiGH1vFabN/Eit7Z61zirMUk3cgY=;
 b=hdaNfBCTFob471wOipCiArGGhIvMhOGK8YJiBaOVT0V2AryEH9ilJkZGFMwL2tkUXDtB
 kgRJTB+S2VrbrYCrjxjhr/0lPTUVcB7uBBWbyG1vyYozvhtD2ZkvF6Tk/qhDDLWrFGF1
 LsGkV4gLh0CNLYGHumK905EiyTda92t9gdIip1M75cSGXhUlOqhDUIP7xLh/POVCI6hJ
 jtA0dNVKLkaoi/3eM4cV2K240fd0pr+P7rnf5tsX0dbzSlst+a1GcCFiU136DZQ6QAcE
 NFNLvWTlKNO394WQrW4wO4OW0gN7w67SxS4JX9Pg650//1w9CyjCYKoyxKs8VN2Vv1o8 Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f80284-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgIkZ141641
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30qtg23drs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl9eh031998
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:09 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 17/43] xfsprogs: clean up the ATTR_REPLACE checks
Date:   Thu, 30 Apr 2020 15:46:34 -0700
Message-Id: <20200430224700.4183-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=867 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=909
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove superflous braces, elses after return statements and use a goto
label to merge common error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6298891..ca4e044 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -423,9 +423,9 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	trace_xfs_attr_sf_addname(args);
 
 	retval = xfs_attr_shortform_lookup(args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
 		return retval;
-	} else if (retval == -EEXIST) {
+	if (retval == -EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			return retval;
 		retval = xfs_attr_shortform_remove(args);
@@ -489,14 +489,11 @@ xfs_attr_leaf_addname(
 	 * the given flags produce an error or call for an atomic rename.
 	 */
 	retval = xfs_attr3_leaf_lookup_int(bp, args);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
-		xfs_trans_brelse(args->trans, bp);
-		return retval;
-	} else if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE) {	/* pure create op */
-			xfs_trans_brelse(args->trans, bp);
-			return retval;
-		}
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
+		goto out_brelse;
+	if (retval == -EEXIST) {
+		if (args->flags & ATTR_CREATE)	/* pure create op */
+			goto out_brelse;
 
 		trace_xfs_attr_leaf_replace(args);
 
@@ -637,6 +634,9 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
+	return retval;
 }
 
 /*
@@ -763,9 +763,9 @@ restart:
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
 		goto out;
-	} else if (retval == -EEXIST) {
+	if (retval == -EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			goto out;
 
-- 
2.7.4

