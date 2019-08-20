Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085F8C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEA322DD3
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c2+WZkxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfHTUbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbfHTUbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT1T1180561;
        Tue, 20 Aug 2019 20:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Nhoyq0hSsWomEjuVdr0hdt0xlGkkvMYvCHw2uB/sHFw=;
 b=c2+WZkxxVGy+JROPksnOsjHtvs4pLhM7kVWla0ygLe3gaZxawNC/t1NOYI0lE9uxMLcQ
 iP5213dHq2ZG9roYO3grTpLoqNXgOyZR01LqH1HAM8HJNj79qCiHl+IJ6ZBmWcdz1ldr
 o+d+G6qqnuJsp8qzSYAZyfHcQNC6PB1aLNRDTC4/dUbX/IfBwY3xc/uyq/12K37Wt0YN
 6tUcFgA3aW+XQ3dqfSyLacdIPSoJATo2W8S6zoK5+EymlWdnxBFa66FpGbET1RENPtfx
 tiKmy1JkBumsGgl4bv+ufishzgRbNbHcZJWN93gXMj6h/tPh7DiLtC1i5SenxC1yAAvo qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hph0nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTCdi071337;
        Tue, 20 Aug 2019 20:31:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ugj7pneup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKVbMg028427;
        Tue, 20 Aug 2019 20:31:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:37 -0700
Subject: [PATCH 04/12] man: document the new v5 fs geometry ioctl structures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:36 -0700
Message-ID: <156633309613.1215978.13281783388020912868.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Amend the fs geometry ioctl documentation to cover the new v5 structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c                   |    4 ++++
 man/man2/ioctl_xfs_fsop_geometry.2 |    8 ++++++++
 2 files changed, 12 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 06e4e663..159738c5 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -88,6 +88,10 @@ xfrog_geometry(
 	if (!ret)
 		return 0;
 
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V4, fsgeo);
+	if (!ret)
+		return 0;
+
 	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
 }
 
diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
index 68e3387d..365bda8b 100644
--- a/man/man2/ioctl_xfs_fsop_geometry.2
+++ b/man/man2/ioctl_xfs_fsop_geometry.2
@@ -12,6 +12,8 @@ ioctl_xfs_fsop_geometry \- report XFS filesystem layout and features
 .PP
 .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geom*" arg );
 .br
+.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
+.br
 .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
 .SH DESCRIPTION
 Report the details of an XFS filesystem layout, features, and other descriptive items.
@@ -43,6 +45,9 @@ struct xfs_fsop_geom {
 	/* struct xfs_fsop_geom_v1 stops here. */
 
 	__u32         logsunit;
+	/* struct xfs_fsop_geom_v4 stops here. */
+
+	__u64         reserved[18];
 };
 .fi
 .in
@@ -124,6 +129,9 @@ underlying log device, in filesystem blocks.
 This field is meaningful only if the flag
 .B  XFS_FSOP_GEOM_FLAGS_LOGV2
 is set.
+.PP
+.I reserved
+is set to zero.
 .SH FILESYSTEM FEATURE FLAGS
 Filesystem features are reported to userspace as a combination the following
 flags:

