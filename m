Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A5AC4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4249320872
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UIqL15RG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfI0Do5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 23:44:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfI0Do5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 23:44:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3dNBJ108586;
        Fri, 27 Sep 2019 03:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=uLESoYMMVyvaTKeeuB/L/v4tYNxyG8nQZZB2ZFWzQSM=;
 b=UIqL15RGgrncWuWQw11d/vTPay55kQe3VpibpNLYxan/gcGYo/Pi/ES3SWC3Mx1510Xk
 3lw6zU9Rf6ckfCASb0QwlTeECLzCXOwuuhEX/7w30/E14gDHR/oyRO4QpwfGoRgg2Owd
 cSpMY3vln1f1OnTiGIeIjXKouEhoI+W0JN5Ug0z3bCrS6WF1VVYP2sFbN2HL5kTtJwXN
 cyseldOAEWcSM1FGCt0hfaCPmRLB7yLl6NlkEf+bE5W7XA84oDWHb40pTms98n6x+Fku
 tI9DUlUqSxCYT0m3Js2tOOnmoNhIPo1SaLxkBunTU59CwpG6IB1cDLgSfuI7gldMYsPT YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgrff04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:44:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3hwf9067283;
        Fri, 27 Sep 2019 03:44:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v8yjxp94v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:44:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8R3iq34001384;
        Fri, 27 Sep 2019 03:44:52 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 20:44:52 -0700
Date:   Thu, 26 Sep 2019 20:44:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/4] man: add documentation for v5 inumbers ioctl
Message-ID: <20190927034451.GM9916@magnolia>
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
 <156944715928.297379.7728068992247988597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944715928.297379.7728068992247988597.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270034
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a manpage describing the new v5 XFS_IOC_INUMBERS ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_inumbers.2 |  128 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_inumbers.2

diff --git a/man/man2/ioctl_xfs_inumbers.2 b/man/man2/ioctl_xfs_inumbers.2
new file mode 100644
index 00000000..f495e73c
--- /dev/null
+++ b/man/man2/ioctl_xfs_inumbers.2
@@ -0,0 +1,128 @@
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
+to set up a bulk transfer from the kernel:
+.PP
+.in +4n
+.nf
+struct xfs_inumbers_req {
+	struct xfs_bulk_ireq    hdr;
+	struct xfs_inumbers     inumbers[];
+};
+.fi
+.in
+.PP
+See below for the
+.B xfs_inumbers
+structure definition.
+.PP
+.in +4n
+.nf
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
+This will be set to
+.I XFS_INUMBERS_VERSION_V5
+by the kernel.
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
