Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C10FC282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DF3A20678
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iiXYFGdt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgAISoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Id6dG156661
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XbeBwTixKQ+lWCtyudlrCGJDteb55lZxnbFxzt6cwng=;
 b=iiXYFGdtv7p8WyfMVujuGdg7AlMJcNR9Gu03AxSd83dd+uYuYAKzsMx5wdIa+wGTFZL+
 xqcrSg763pwybqKCq5GcFbpuQp3nvqom9TsCNumxQo2b9ndAbfYN+bTsFDY0APmKdm81
 PSg2e3h/gpifdY4qaj2FrWHrQHsEQ1129iNpDOcsNZCRS89CMxVrKBPFxR/wY5E/Ei1T
 WfcFSd6YP9a3dWUelI4QgwLt3zmhr1VAuUUzVzOGCSv/LCb0P3W9btzZmrYwZwGY2zis
 1JnWf080Ihq+yuF79JIlibCrpsi2AG0yDOMN2gifUsd8LuqWc+mC3lkMIdpYQ6DH88Iz Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4ucw8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Icwve169874
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xdrxbt5cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009IiPSU011621
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:25 -0800
Subject: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:22 -0800
Message-ID: <157859546284.163942.8882319204815065001.stgit@magnolia>
In-Reply-To: <157859545662.163942.11245536419486956862.stgit@magnolia>
References: <157859545662.163942.11245536419486956862.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new #define for the maximum supported file block offset.
We'll use this in the next patch to make it more obvious that we're
doing some operation for all possible inode fork mappings after a given
offset.  We can't use ULLONG_MAX here because bunmapi uses that to
detect when it's done.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/xfs_reflink.c       |    3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1b7dcbae051c..77e9fa385980 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1540,6 +1540,13 @@ typedef struct xfs_bmdr_block {
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+
+/*
+ * bmbt records have a file offset (block) field that is 54 bits wide, so this
+ * is the largest xfs_fileoff_t that we ever expect to see.
+ */
+#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK + BMBT_BLOCKCOUNT_MASK)
 
 typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index de451235c4ee..7a6c94295b8a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1457,7 +1457,8 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, XFS_MAX_FILEOFF,
+			true);
 	if (error)
 		return error;
 

