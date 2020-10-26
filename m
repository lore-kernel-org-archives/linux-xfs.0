Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D98C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1461D20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="plaRbcye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407232AbgJZXiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407229AbgJZXiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPIES158031;
        Mon, 26 Oct 2020 23:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HVjg2mSHHCwFQf1ORE2L20oFwdfa7W4lnxRkMBVuVZc=;
 b=plaRbcyeZICAyPj6GGRPCHdFAsr657mJ781Gk3elsF/cFSdl2AyllOvwF/Os/z+9eoEl
 Qn3t+aGF+VqVoGcpM5oKruU0WPat/4XJZtgVfZGxo9WhsaFQRL+hPkdFEHUm5S6+XYu+
 IyJP+0Q2uhPiBbu3COsMPrGibsb7BkJRfpAf2y4/RCGIe4Fqkdi01WqcY1rSAH0O4UX6
 fj2ARawDt/VAlkBSZFI4xmza/cMt2GJMWkOrL7pPKnrRAoAjy9Y9/848QBWV04ZZhjWG
 fOYl85VD/UQA9NCNAghT1hl0Hw4xoqCqZlv2DKNS04pB95fCMhhL/CMX7FIOLEgUOOAP IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQF7N032587;
        Mon, 26 Oct 2020 23:36:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1q2ca4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNa55w006255;
        Mon, 26 Oct 2020 23:36:05 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:04 -0700
Subject: [PATCH 18/26] libxfs: propagate bigtime inode flag when allocating
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:03 -0700
Message-ID: <160375536384.881414.3371469706002982157.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ensure that we propagate the bigtime inode flag correctly when creating
new inodes.  There critical part here is to use the new_diflags2 field
in the incore geometry just like we do in the kernel.

We also modify xfs_flags2diflags2 to have the same behavior as the
kernel.  This isn't strictly needed here, but we aim to avoid letting
userspace diverge from the kernel function when we can.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/util.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index c78074a01dab..252cf91e851b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -197,7 +197,8 @@ xfs_flags2diflags2(
 	unsigned int		xflags)
 {
 	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
+		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
+				      XFS_DIFLAG2_BIGTIME));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
@@ -307,8 +308,8 @@ libxfs_ialloc(
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		VFS_I(ip)->i_version = 1;
-		ip->i_d.di_flags2 = pip ? 0 : xfs_flags2diflags2(ip,
-				fsx->fsx_xflags);
+		ip->i_d.di_flags2 = pip ? ip->i_mount->m_ino_geo.new_diflags2 :
+				xfs_flags2diflags2(ip, fsx->fsx_xflags);
 		ip->i_d.di_crtime.tv_sec = (int32_t)VFS_I(ip)->i_mtime.tv_sec;
 		ip->i_d.di_crtime.tv_nsec = (int32_t)VFS_I(ip)->i_mtime.tv_nsec;
 		ip->i_d.di_cowextsize = pip ? 0 : fsx->fsx_cowextsize;

