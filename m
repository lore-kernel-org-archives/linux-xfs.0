Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8C6C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA0D2071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fYysx2ec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgAXAR3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34394 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXAR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08oal024624;
        Fri, 24 Jan 2020 00:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9yrSnLPoCUY9dPsCSYgxzDN/3KK5EAkUYpC+I4SarBM=;
 b=fYysx2ecdT1vXMaDI/GKCNtOmIHP+25bmdh6HGbFb7CmvtFuAt/wukw78E3KudtlDGPP
 HIXP9yOhDyDTMyMgqdHBN1IMEtEAMK42GO7WsoThD4nEaLwtDocqpIXHnUkMcJzK7/m6
 WH5oWRf/hSb2JctqOcAGBXqhKgL9qmmV0kpRpw53MBRUbtG+ljEpQw+5nHgixy0SRGZZ
 VuqPfcIw+cmaSwPXX3kZzkp1OjGI8gzuDR4rRE/WTKYnNHpIvgcRUkEAMbq7TlhQMncb
 soYcrZSPFB6TAvu4+1Wx0yIb/Q9d8GO6mRrsQ8pmLbPNw4x75/aNZYOaxBWd1J0jksgL eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuwvwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E6XV111048;
        Fri, 24 Jan 2020 00:17:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1fwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O0HPYH007959;
        Fri, 24 Jan 2020 00:17:25 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:25 -0800
Subject: [PATCH 8/8] xfs_repair: fix totally broken unit conversion in
 directory invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:17:23 -0800
Message-ID: <157982504329.2765410.10475555316974599797.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=995
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Your humble author forgot that xfs_dablk_t has the same units as
xfs_fileoff_t, and totally screwed up the directory buffer invalidation
loop in dir_binval.  Not only is there an off-by-one error in the loop
conditional, but the unit conversions are wrong.

Fix all this stupidity by adding a for loop macro to take care of these
details for us so that everyone can iterate all logical directory blocks
(xfs_dir2_db_t) that start within a given bmbt record.

The pre-5.5 xfs_da_get_buf implementation mostly hides the off-by-one
error because dir_binval turns on "don't complain if no mapping" mode,
but on dirblocksize > fsblocksize filesystems the incorrect units can
cause us to miss invalidating some blocks, which can lead to other
buffer cache errors later.

Fixes: f9c559f4e4fb4 ("xfs_repair: invalidate dirty dir buffers when we zap a  directory")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 76709f73..0874b649 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1273,7 +1273,7 @@ dir_binval(
 	struct xfs_ifork	*ifp;
 	struct xfs_da_geometry	*geo;
 	struct xfs_buf		*bp;
-	xfs_dablk_t		dabno, end_dabno;
+	xfs_dablk_t		dabno;
 	int			error = 0;
 
 	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
@@ -1283,11 +1283,9 @@ dir_binval(
 	geo = tp->t_mountp->m_dir_geo;
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	for_each_xfs_iext(ifp, &icur, &rec) {
-		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
-				geo->fsbcount - 1);
-		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
-				rec.br_blockcount);
-		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
+		for (dabno = roundup(rec.br_startoff, geo->fsbcount);
+		     dabno < rec.br_startoff + rec.br_blockcount;
+		     dabno += geo->fsbcount) {
 			bp = NULL;
 			error = -libxfs_da_get_buf(tp, ip, dabno, &bp,
 					whichfork);

