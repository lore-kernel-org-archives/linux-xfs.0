Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977BEC41514
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 673E322CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALlnQeNi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfIDEhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58454 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfIDEhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aYU3040540;
        Wed, 4 Sep 2019 04:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZLj2L1NzQibXuvDAwxj0Er0j9S0C8V3zyLNdHHJ/664=;
 b=ALlnQeNihlsp/nX0pFtD3GDZasZ4IZKJj5CqDaU4Drx44ro1zy3HPxpY6xrX138yU4Xe
 HtUxxpBJ+Jgp5A7WD2ApWEUUV8OHyNnDkXep1D6rTM7KiJQG1Y+AI38BH2gcEXO1ZyYT
 AwYBAiAcnuQt1EyonT0fnwyOPCCskOQ83xf8+6pUEaeqehSjtMzDel3klzF1zRGxleXB
 fIO/b37ztB44/2hjKHHvYWSAOKKUC1UJaEoRVihFxXWpvqOfvDaBQMS7S98XJ1U1LXc8
 ozzcUWC1vU12qYg3yR2xMpUgI1pWhe4Zb0eCVeMJfDmMGbFS5ceSAy1biWwa/DaN+lJ7 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut6d1r05p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XEor055516;
        Wed, 4 Sep 2019 04:37:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2us5phmt3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844bACZ023997;
        Wed, 4 Sep 2019 04:37:10 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:10 -0700
Subject: [PATCH 01/10] man: document the new v5 fs geometry ioctl structures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:37:09 -0700
Message-ID: <156757182904.1838441.1851639472366955352.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Amend the fs geometry ioctl documentation to cover the new v5 structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fsop_geometry.2 |    8 ++++++++
 1 file changed, 8 insertions(+)


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

