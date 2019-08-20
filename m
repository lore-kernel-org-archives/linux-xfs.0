Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90027C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6118622DD3
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LodEkLO5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbfHTUbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbfHTUbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSvwi165915;
        Tue, 20 Aug 2019 20:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oFSuHYvWrbt90dE0qxE+iaFJdENw72o334nkDq6mwSw=;
 b=LodEkLO5eNnsz9L8mTcAvIXuQe45K5QPjn8T2kkkKVlOVJ6rcboC2Qm65wpAZuoWSThV
 80PD9QrcbewTrvrG674YMwnD5hhYeHN2PInfrNuHRqj1s7JxlEmQC0HJkQRUV1GlTMuq
 xLB2D91uHzg8+LQFOKPiSYHNX8eI8e3TGcqwdZsbRgfabUrljro5j9Mwop5eR0Ehq6Cx
 8S3xwt8q+b/G9Ixcmb15dfZVm8600RP0H2bodwGIBpsutSs8qvE0jSS/CfrQoOyx19z/
 sVC4XZPw4Sf+ZukCkURwwYMoMhxcDDm5SZV7z/QGevtyvYYcfeb6j2c4L4waOee4SOyq DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7qs0j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTLWA191139;
        Tue, 20 Aug 2019 20:31:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ugj7p4sqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:49 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKVn9M019982;
        Tue, 20 Aug 2019 20:31:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:49 -0700
Subject: [PATCH 06/12] man: document the new allocation group geometry ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:48 -0700
Message-ID: <156633310832.1215978.10494838202211430225.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Document the new ioctl to describe an allocation group's geometry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_ag_geometry.2 |   74 ++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3                |    6 +++
 2 files changed, 80 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_ag_geometry.2


diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
new file mode 100644
index 00000000..5dfe0d08
--- /dev/null
+++ b/man/man2/ioctl_xfs_ag_geometry.2
@@ -0,0 +1,74 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-AG-GEOMETRY 2 2019-04-11 "XFS"
+.SH NAME
+ioctl_xfs_ag_geometry \- query XFS allocation group geometry information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_AG_GEOMETRY, struct xfs_ag_geometry *" arg );
+.SH DESCRIPTION
+This XFS ioctl retrieves the geometry information for a given allocation group.
+The geometry information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_ag_geometry {
+	uint32_t  ag_number;
+	uint32_t  ag_length;
+	uint32_t  ag_freeblks;
+	uint32_t  ag_icount;
+	uint32_t  ag_ifree;
+	uint32_t  ag_sick;
+	uint32_t  ag_checked;
+	uint32_t  ag_reserved32;
+	uint64_t  ag_reserved[12];
+};
+.fi
+.in
+.TP
+.I ag_number
+The number of allocation group that the caller wishes to learn about.
+.TP
+.I ag_length
+Length of the allocation group, in units of filesystem blocks.
+.TP
+.I ag_freeblks
+Number of free blocks in the allocation group, in units of filesystem blocks.
+.TP
+.I ag_icount
+Number of inode records allocated in this allocation group.
+.TP
+.I ag_ifree
+Number of unused inode records (of the space allocated) in this allocation
+group.
+.TP
+.IR ag_reserved " and " ag_reserved32
+Will be set to zero.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+The specified allocation group number is not valid for this filesystem.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 7e6588b8..dfebd12d 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -336,6 +336,12 @@ See
 .BR ioctl_xfs_fsop_geometry (2)
 for more information.
 
+.TP
+.B XFS_IOC_AG_GEOMETRY
+See
+.BR ioctl_xfs_ag_geometry (2)
+for more information.
+
 .TP
 .BR XFS_IOC_FSBULKSTAT " or " XFS_IOC_FSBULKSTAT_SINGLE
 See

