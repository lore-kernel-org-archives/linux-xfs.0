Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971E6CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E00B214B2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jd9thKRu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfJ2EE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 00:04:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfJ2EE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 00:04:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T41LIq183811;
        Tue, 29 Oct 2019 04:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=z9bJcoUsVqn2z/aHEBFfopYMxY5mMsONKO4uFvTVPPU=;
 b=Jd9thKRuv86iXol2u/gDiOHfIMKxoeM4/dpjI0UQzj9Y/w4dCvng4do5LT6ilUMZ1l/I
 1rVI7cbuILReXevFGCIQUFBrnYM+IRgaZWn6pSkEjRdOqWcMcQJ2/n7lovR/2pHLayoz
 zJ2BhlAJjpMnvNbOQUYFnBWidrlOcCC8IkMuxGHYQGE28JoioY6AaM4DuLRN3OfEaz+E
 QloROZaCni2qaet1e27i4RAcqnv3tWr5IB9iuGAc1YUHN9Rrkw3dCcIu5kbQ78XAC/ew
 guT3hs0+ChhNElp2FsCCH5ovoJsyqXymz4VQhLF3ZOWr4AJ+rhrT0m2dgiMw1ewYVItj 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vvumfb0e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:04:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T40LHC164897;
        Tue, 29 Oct 2019 04:04:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vwam06req-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:04:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9T446NS018721;
        Tue, 29 Oct 2019 04:04:06 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 21:04:06 -0700
Subject: [PATCH 3/4] xfs: namecheck directory entry names before listing them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de
Date:   Mon, 28 Oct 2019 21:04:05 -0700
Message-ID: <157232184576.593721.4790987759528633416.stgit@magnolia>
In-Reply-To: <157232182246.593721.4902116478429075171.stgit@magnolia>
References: <157232182246.593721.4902116478429075171.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually call namecheck on directory entry names before we hand them
over to userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dir2_readdir.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 283df898dd9f..a0bec0931f3b 100644
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
@@ -208,12 +214,16 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
+		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 dp->i_mount);
+			error = -EFSCORRUPTED;
+			goto out_rele;
+		}
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
-			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
-			xfs_trans_brelse(args->trans, bp);
-			return 0;
-		}
+			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
+			goto out_rele;
 	}
 
 	/*
@@ -222,8 +232,9 @@ xfs_dir2_block_getdents(
 	 */
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
 								0x7fffffff;
+out_rele:
 	xfs_trans_brelse(args->trans, bp);
-	return 0;
+	return error;
 }
 
 /*
@@ -456,6 +467,12 @@ xfs_dir2_leaf_getdents(
 		filetype = dp->d_ops->data_get_ftype(dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 dp->i_mount);
+			error = -EFSCORRUPTED;
+			break;
+		}
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))

