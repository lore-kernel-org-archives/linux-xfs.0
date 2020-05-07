Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C728C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4591220735
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dj9LKPaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgEGBEc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:04:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgEGBEb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:04:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xYXN123239;
        Thu, 7 May 2020 01:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hoHALx1LCbK3g+Dnwqt1yz17Ay2/IhnQRh180inp4RE=;
 b=Dj9LKPaFUij8Y4d/SU/l73/Mmtp/3RcXnQjfnOa3IWEX02LMt/j6FFq1iHm10/uUEvOB
 jkb2Zn6Js7BZJ3+jWaZCpil5CRnjOFRJaWbPCsZMQAAP5g7I/rFQ0I89CWm4+BKjpphT
 K82uxPHt2iEgsDms7ckqT/oi2sz8Ud2o3uE1AJDUXr5n2+ZTfdAaff+gy8/Bg6UJ+iuq
 utzz5a7lQ3fMdqaJP6aRGT0UrufWg0TVUNQx4Z10FHW86UF2afsLGEhWTGPsuJnAec3W
 kahLImgaBTlYozoeZArLCNsfX/bsQ23lWMr1PgjEuc2CSwyvupHQ9gLF0Zk+kI6TxVsJ XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30usgq4jhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470upDs190094;
        Thu, 7 May 2020 01:04:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdwswd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:28 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04714Rd4028944;
        Thu, 7 May 2020 01:04:27 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:04:27 -0700
Subject: [PATCH 25/25] xfs: remove unnecessary includes from xfs_log_recover.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:04:23 -0700
Message-ID: <158881346355.189971.17393800521171400725.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove unnecessary includes from the log recovery code.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_log_recover.c |    8 --------
 1 file changed, 8 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 572e6707362a..ec015df55b77 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -18,21 +18,13 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
-#include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
-#include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_error.h"
-#include "xfs_dir2.h"
-#include "xfs_rmap_item.h"
 #include "xfs_buf_item.h"
-#include "xfs_refcount_item.h"
-#include "xfs_bmap_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 

