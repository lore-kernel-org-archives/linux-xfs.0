Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC0DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4445D21872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="On8Df2oW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392698AbfJYFPK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:15:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5Dm6v102644
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=h4S8ivx/sX/n4/y1+2X2rofM/kE0Lcv3JMP4ite+M2E=;
 b=On8Df2oWGme0YvAcLa3vtPdzJYm/ieAYyD/ZhYfNBE2FQFZJ3HFpWYnrd+qmdUXXIRmE
 I1H4BRo3D3J3EdjUSH1Smtg7NIXEDG11KEIL8rYIfddqICjpTRAVVOnFgg0WsdH5bAVa
 GyJUM3PUbFWmENfkYYHnk3carZVerxwL1v6qO5bSM9OMiAg03PYZarW2bcf9V1KArQuj
 2iOBXleIizvtoqNWpfBzVSCIkNl+GwFH5rMWKbhF6jpsYA9tVj7w0i+UQs5ZDgtGF9Jn
 IGdJLqb4GqKT1TNutqCkJwB417jUC5a0aOuU8dlfBxWtMIZAG7L5t83xrxyWZemMND/R JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4r7yhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DhMr073733
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vtsk6uerx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P5F6xb020972
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:15:06 -0700
Subject: [PATCH 3/4] xfs: namecheck directory entry names before listing them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:15:05 -0700
Message-ID: <157198050564.2873445.4054092614183428143.stgit@magnolia>
In-Reply-To: <157198048552.2873445.18067788660614948888.stgit@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually call namecheck on directory entry names before we hand them
over to userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dir2_readdir.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 283df898dd9f..a8fb0a6829fd 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -17,6 +17,7 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_error.h"
 
 /*
  * Directory file type support functions
@@ -115,6 +116,11 @@ xfs_dir2_sf_getdents(
 		ino = dp->d_ops->sf_get_ino(sfp, sfep);
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
+		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 dp->i_mount);
+			return -EFSCORRUPTED;
+		}
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
@@ -208,6 +214,11 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
+		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 dp->i_mount);
+			return -EFSCORRUPTED;
+		}
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
 			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
@@ -456,6 +467,11 @@ xfs_dir2_leaf_getdents(
 		filetype = dp->d_ops->data_get_ftype(dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 dp->i_mount);
+			return -EFSCORRUPTED;
+		}
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))

