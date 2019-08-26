Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0EDC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9A22186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g37bAYuh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfHZVW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:22:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfHZVW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKG162597;
        Mon, 26 Aug 2019 21:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Qm6EWx6d8TIyzmFvr4u8JctQdWZ+za9q0dMLaFPGt+w=;
 b=g37bAYuh7s8C0F4ug6wTXfsrfB2TuYd6kA051g3x5ypWk4X1kxbku0EveNuEKeu69+bn
 AVTsmn/p9r4thc/gSxNAo3fLe8AiaOcukfTq0456yqzbMegc9fTcT+WvuLAQ6qngd9sF
 UAfR9MOMpX0Q6tT9lsLETKE05luG/PdLAsQ75Yt+IAftHdd0/1wli3GDiO+fF0Lwz6Mt
 dCKafsaSff5yEG5Vzr8GBYHiEfkdZw+4VwS5yFR8feh6hH/g9n5g2Bx+zOeth2Zb3jFn
 /js0t/dBnk5n3nyE2/RS1H78tGu3hHkpi50V7a7z6eZlPt9NWOE4v+BYczvlvMc7dxTj 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t812p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIQZ5024956;
        Mon, 26 Aug 2019 21:22:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tjxqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLMP64002387;
        Mon, 26 Aug 2019 21:22:25 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:22:25 -0700
Subject: [PATCH 2/5] man: add documentation for v5 inumbers ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:22:24 -0700
Message-ID: <156685454401.2840332.2689052873122428637.stgit@magnolia>
In-Reply-To: <156685453125.2840332.15645173323964762232.stgit@magnolia>
References: <156685453125.2840332.15645173323964762232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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

