Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40608C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178E92245A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZpdIVYEy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfIZTKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 15:10:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbfIZTKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 15:10:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QJ8fBo136555;
        Thu, 26 Sep 2019 19:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FQTyLC0Ii6JeSnWptlJl+NGIIsF0HySe3K/wNznC5eg=;
 b=ZpdIVYEynxGapCBu7usSjefbrcsnh0Kq15vTAEozvu4K+/NgRmE4IAMXro4VfwglDs4u
 030HRtpp2CTBdeUdVQcF5boyGC7eMahfxc17rMKJ/YIgNR4Gm5IFf7YxvhQqhnoRMdW0
 SEI0MBWWoCySgSm6kNq07wMngyKPK6HETtN+5shM7DWR+hZEEpm3Ymlvm3Zfw8ErNL8U
 BPR8sMObQqkzj/QZVh8ycOvz42s6GF9ENW9wFuS+prNkY+heK7OnYXwqa8T5YFNmUa+I
 Fr9OtNfq7GtFifYee/LC/pHyuvqQuHvxt0Qkr7Sc4X6UsXXyfHLP6Nz2MJcGUueEaW3h Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgrds7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:10:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QIt0sF163787;
        Thu, 26 Sep 2019 19:10:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v8yjx91qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:10:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QJAHcx011563;
        Thu, 26 Sep 2019 19:10:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 12:10:16 -0700
Date:   Thu, 26 Sep 2019 12:10:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/4] man: add documentation for v5 inumbers ioctl
Message-ID: <20190926191016.GJ9916@magnolia>
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
 engine=8.0.1-1908290000 definitions=main-1909260151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260152
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
