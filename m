Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99E0C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB7322067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IKifaJoB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgAHERn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:17:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHERn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:17:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EFxY023479
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Xxdc4FCWsx0mDjsEEZawa+vMYHw/rPU9z6pRa/H/xIQ=;
 b=IKifaJoBFq6CtmGjKhtHT+IppOjbmLHNbe8tjBdT6GN5EBvH3s/+FD7/97pGFiOchZv5
 oHZDXD7wZYhBAKSqwxqAXOV4+j04aTf4s1t+xvY0pkjePIljk06OyqHyxrmwfRZQTrDy
 x5umKVrp8FnXgtWjPT7CV///tsAKXqcpODckmL1FHpinKfKOk6TclW9YmRRfkYHzWV6+
 T84UMJOe5v2TZkIHy23otu1azZtxRApQmo96eaiWWTPh/jjQB+iSVC0wiQHCSlMkeC1w
 zHVYWRgkE/tqR56qXE9EI+PBBQ/EX6LtbKXiGn2mpBEKO4YJg2b8yD1IMsdfNKXWKkti rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnq1ejm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EDun127674
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xcpanyuju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084HeGr007712
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:17:40 -0800
Subject: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:17:38 -0800
Message-ID: <157845705884.82882.5003824524655587269.stgit@magnolia>
In-Reply-To: <157845705246.82882.11480625967486872968.stgit@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080036
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
 fs/xfs/libxfs/xfs_format.h |    1 +
 fs/xfs/xfs_reflink.c       |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1b7dcbae051c..c2976e441d43 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)
 
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
 

