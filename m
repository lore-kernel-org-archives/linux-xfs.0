Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2E9C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90F1206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cw6VMreT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404438AbfIFDfN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:35:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733034AbfIFDfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:35:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xu3l074308;
        Fri, 6 Sep 2019 03:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Qm6EWx6d8TIyzmFvr4u8JctQdWZ+za9q0dMLaFPGt+w=;
 b=Cw6VMreTIaB3lSgQY6TihJOLEnTEOZIpjYfg5Cs0zco3TfWx1gGGcOctMWUqUYnPX/Bd
 4zA6lSulU69qmXdM1ml3flEwuW8L+QOfaojQj/aQBfmNUV+aileI7tb0Ng1Z15xSQloN
 aAgt/E7+tg+h8SIJ01Bls80aNn4m3W0UBQ6l5pOr9Ni84AwxRJGCflbarPzwP9YbEcR9
 7BNDqEYOhTkflHFPThG6O8dH2coy9ioDoAhhMmyVU4hTFJ8Jg8SPK0LLUhsxQxR0NBNr
 Yp5IoRcrBmsLE7TCzW513gJ3GhmO0Wne3Qv/8ASpx0n2sNBJs5PyqG/1Lf5IS5yOS/BE Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuf51g32v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YUp8103595;
        Fri, 6 Sep 2019 03:35:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uud7p2qgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863ZAJc019202;
        Fri, 6 Sep 2019 03:35:10 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:35:09 -0700
Subject: [PATCH 2/6] man: add documentation for v5 inumbers ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:35:09 -0700
Message-ID: <156774090939.2643497.6505275402139227224.stgit@magnolia>
In-Reply-To: <156774089024.2643497.2754524603021685770.stgit@magnolia>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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

