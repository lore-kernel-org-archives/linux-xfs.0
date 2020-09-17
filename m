Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D41FC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C474206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hodt54HL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIQD2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:28:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIQD2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:28:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Pw9C116628
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5+vdpq3JTTtwsC1DdYhK+nYceHlmHtuBIw0+SvacPLE=;
 b=hodt54HLpNrT9a0Lbqu5YB8BORN0SWd8gYzr9WWg8L1viXXDSZiRhJE1fElRvcgeEUKq
 e+qF2stC+fKyCOyoa4NfCFDCQC/a/K2uHP8xnnPa6Q6g+6uvp10z7dx/3lmclHu2Jmcm
 J4gDs3KnlIeX94MYNsn6qEoAyFxH7me69mb+HQMs/QapBXVs6RkWwF9or+OmaaKhU8Vb
 xFxSy49JYAFZnP56iKdIlTl72serJKvzMh/YYd0fPtmHcoljuy36e6jJAqO6H3/SaXB6
 vyW5A8deJO2RfBlG8hZpG343AXqsmDjtOB5MEQJaDV1EyWgMWKZV1vTOfi8O00C7vren Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dr5f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3PWbV080061
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88a24qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H3SYUQ020137
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:34 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:28:34 +0000
Subject: [PATCH 1/2] xfs: don't free rt blocks when we're doing a REMAP
 bunmapi call
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Sep 2020 20:28:33 -0700
Message-ID: <160031331319.3624286.3971628628820322437.stgit@magnolia>
In-Reply-To: <160031330694.3624286.7407913899137083972.stgit@magnolia>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
to be unmapped from the given file fork without the extent being freed.
We do this for non-rt files, but we forgot to do this for realtime
files.  So far this isn't a big deal since nobody makes a bunmapi call
to a rt file with the REMAP flag set, but don't leave a logic bomb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1b0a01b06a05..e8cd0012a017 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,9 +5057,12 @@ xfs_bmap_del_extent_real(
 				  &mod);
 		ASSERT(mod == 0);
 
-		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
-		if (error)
-			goto done;
+		if (!(bflags & XFS_BMAPI_REMAP)) {
+			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			if (error)
+				goto done;
+		}
+
 		do_fx = 0;
 		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;

