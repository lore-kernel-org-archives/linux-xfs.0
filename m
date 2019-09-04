Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2F5C3A5A4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D506C22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRTWubGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfIDEh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfIDEh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844am5W040715;
        Wed, 4 Sep 2019 04:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=couewItz1utVyUTZlQsaNtySfRjaJZpKmWFMSGhYdcM=;
 b=CRTWubGHFvdVorqRh+wZVae/+BK7DKD7QxG92OoDDjHUOy1C9ut78fb0WDvEJw3S8e1k
 czOZIjAbJ0cxThKbb5vVzVrkCGXR+ctcLy7P8B0T5mn0hjYjhXVkOc7Sa7JG9Zdcr9pe
 /4boXDP4/D3jOKPwQbkrzbHynpeaXwfVsKCk+MfE888IUolWzATDn3pZKrwQh0xI7uBO
 kILi2gRjZJzlMIcR9Ai7Y6xR1rlNnhmA9JAJKXtDuaw4TbGif54Wig8JGCx4PH+QJTEs
 1YrZHITU9eVi4/qPSiuDNWb8UNz/1imNsdQVpVRRqyGxEZKD5P0R8wdi6d8+ePxI0Stu zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ut6d1r06q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFei027398;
        Wed, 4 Sep 2019 04:37:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ut1hmtvp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844bMP9004736;
        Wed, 4 Sep 2019 04:37:23 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:22 -0700
Subject: [PATCH 03/10] man: document the new allocation group geometry ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:37:21 -0700
Message-ID: <156757184149.1838441.15095911482164413079.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=906 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Document the new ioctl to describe an allocation group's geometry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_ag_geometry.2 |   82 ++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3                |    6 +++
 2 files changed, 88 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_ag_geometry.2


diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
new file mode 100644
index 00000000..ddd54265
--- /dev/null
+++ b/man/man2/ioctl_xfs_ag_geometry.2
@@ -0,0 +1,82 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-AG-GEOMETRY 2 2019-08-30 "XFS"
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
+	uint32_t  ag_flags;
+	uint64_t  ag_reserved[12];
+};
+.fi
+.in
+.TP
+.I ag_number
+The caller must set this field to the index of the allocation group that the
+caller wishes to learn about.
+.TP
+.I ag_length
+The length of the allocation group is returned in this field, in units of
+filesystem blocks.
+.TP
+.I ag_freeblks
+The number of free blocks in the allocation group is returned in this field, in
+units of filesystem blocks.
+.TP
+.I ag_icount
+The number of inode records allocated in this allocation group is returned in
+this field.
+.TP
+.I ag_ifree
+The number of unused inode records (of the space allocated) in this allocation
+group is returned in this field.
+.TP
+.I ag_flags
+The caller can set this field to change the operational behavior of the ioctl.
+Currently no flags are defined, so this field must be zero.
+.TP
+.IR ag_reserved
+All reserved fields will be set to zero on return.
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

