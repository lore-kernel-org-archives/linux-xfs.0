Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDFD9206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qch15rhW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAABWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:22:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAABWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:22:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Ea0G092104;
        Wed, 1 Jan 2020 01:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=b35kgt6wQpK9za9PMfb5yi8/cB3QnCSDQtuqOg/FeEQ=;
 b=Qch15rhWAZHQLM2Gs2hiBuw0gvvKfkH8XoBnJaTdokdlSGD4ZGm+15WoGkIY5Y4rxJbF
 MkEVfhC5ptnfQ/fMbMR7XviGjCCrEleOc4+VsjVz6km/69qL6HB+ExaT8LBWVXRYWcXN
 qLzLdnbuFNf7pNsrsJg3H0P9YbkVNjkbnAg8TXO/2yXwdjXs1TI+QqXajaYN/x1ocuQJ
 wJiNe9xojAB9Ok39cM+iS1Rgvx3mhXuEPsNXZKZcvCxKwzsF8YEdrJFyQmto5t29aleS
 Otfimujfh81o5WcJltJkUoENivFLHIIbX8MFMgojKW2Ue/Z7zZkkzW7b+Z/2+54NZmQS IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:22:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011JFTY024846;
        Wed, 1 Jan 2020 01:20:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8gueg53k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:42 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011KfPe015699;
        Wed, 1 Jan 2020 01:20:41 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:20:40 -0800
Subject: [PATCH 1/1] xfs_repair: fix totally broken unit conversion in
 directory invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:20:36 -0800
Message-ID: <157784163634.1371001.9270275500137619667.stgit@magnolia>
In-Reply-To: <157784163017.1371001.12249848065995361338.stgit@magnolia>
References: <157784163017.1371001.12249848065995361338.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
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
index 91d208a6..a11712a2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1276,7 +1276,7 @@ dir_binval(
 	struct xfs_ifork	*ifp;
 	struct xfs_da_geometry	*geo;
 	struct xfs_buf		*bp;
-	xfs_dablk_t		dabno, end_dabno;
+	xfs_dablk_t		dabno;
 	int			error = 0;
 
 	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
@@ -1286,11 +1286,9 @@ dir_binval(
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
 			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
 					whichfork);

