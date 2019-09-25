Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1DBC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA9021D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ew/vcTRo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfIYVcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:32:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfIYVcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLT2WV005744;
        Wed, 25 Sep 2019 21:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Qm6EWx6d8TIyzmFvr4u8JctQdWZ+za9q0dMLaFPGt+w=;
 b=Ew/vcTRoMOcvR/AbxCJcY3/IOkL39PIwtmvhX8w+bfKnJ36t0yakFRwOhaiiTKay5/Sq
 VNBwfBglETbtcyxpHfdzYx8cJibCvws0V9VEY/6YEjFC3L3FfoVnYBiPPmkcPnxzwtOz
 FIXENOw+KN77lSV5PDG20yxETjlhvDJEaU/XrBqybrj5eyeQ22lNeyt/aSY0q5I34MXi
 rUhDgQ+4qQAH0Pc50+qr/wk1eL8bnLLTr0Lye09PR8QspAA4+l7srEfnW3sD54do/JpV
 4UTRLNt7ShGU8PvRi3I4OassUCAEOwsN3rUGZeZWlPHSrym7tEXueh1vhfFpLAWw4gr9 HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq7her-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTEDJ085254;
        Wed, 25 Sep 2019 21:32:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakpsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLWegT013985;
        Wed, 25 Sep 2019 21:32:40 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:40 -0700
Subject: [PATCH 2/4] man: add documentation for v5 inumbers ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:32:39 -0700
Message-ID: <156944715928.297379.7728068992247988597.stgit@magnolia>
In-Reply-To: <156944714720.297379.5532805895370082740.stgit@magnolia>
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a manpage describing the new v5 XFS_IOC_INUMBERS ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_inumbers.2 |  118 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_inumbers.2


diff --git a/man/man2/ioctl_xfs_inumbers.2 b/man/man2/ioctl_xfs_inumbers.2
new file mode 100644
index 00000000..b1e854d3
--- /dev/null
+++ b/man/man2/ioctl_xfs_inumbers.2
@@ -0,0 +1,118 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-INUMBERS 2 2019-05-23 "XFS"
+.SH NAME
+ioctl_xfs_inumbers \- query allocation information for groups of XFS inodes
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_INUMBERS, struct xfs_inumbers_req *" arg );
+.SH DESCRIPTION
+Query inode allocation information for groups of XFS inodes.
+This ioctl uses
+.B struct xfs_inumbers_req
+to set up a bulk transfer with the kernel:
+.PP
+.in +4n
+.nf
+struct xfs_inumbers_req {
+	struct xfs_bulk_ireq    hdr;
+	struct xfs_inumbers     inumbers[];
+};
+
+struct xfs_bulk_ireq {
+	uint64_t                ino;
+	uint32_t                flags;
+	uint32_t                icount;
+	uint32_t                ocount;
+	uint32_t                agno;
+	uint64_t                reserved[5];
+};
+.fi
+.in
+.PP
+.I hdr
+describes the information to query.
+The layout and behavior are documented in the
+.BR ioctl_xfs_bulkstat (2)
+manpage and will not be discussed further here.
+
+.PP
+.I inumbers
+is an array of
+.B struct xfs_inumbers
+which is described below.
+The array must have at least
+.I icount
+elements.
+.PP
+.in +4n
+.nf
+struct xfs_inumbers {
+	uint64_t                xi_startino;
+	uint64_t                xi_allocmask;
+	uint8_t                 xi_alloccount;
+	uint8_t                 xi_version;
+	uint8_t                 xi_padding[6];
+};
+.fi
+.in
+.PP
+This structure describes inode usage information for a group of 64 consecutive
+inode numbers.
+.PP
+.I xi_startino
+is the first inode number of this group.
+.PP
+.I xi_allocmask
+is a bitmask telling which inodes in this group are allocated.
+To clarify, bit
+.B N
+is set if inode
+.BR xi_startino + N
+is allocated.
+.PP
+.I xi_alloccount
+is the number of inodes in this group that are allocated.
+This should be equal to popcnt(xi_allocmask).
+.PP
+.I xi_version
+is the version of this data structure.
+Currently, only 1 or 5 are supported.
+.PP
+.I xi_padding[6]
+is zeroed.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFAULT
+The kernel was not able to copy into the userspace buffer.
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One of the arguments was not valid.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2),
+.BR ioctl_xfs_bulkstat (2).

