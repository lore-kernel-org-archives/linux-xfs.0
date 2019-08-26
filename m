Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF91FC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C3C2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AOxQj0Z5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfHZVWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:22:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfHZVWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDms9000886;
        Mon, 26 Aug 2019 21:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vOvmZSwrnhJWdeB7AucKkR3As9vfS9DSQJQy2DAsTmU=;
 b=AOxQj0Z59S0PkioPkQjvBgPPm3/8ygggO3n702zjx2pC1cU7DVNsw9nyZCfDRltJiHO7
 fvAag/V7lgdoIRKHoQUp81rgZgfz9PHmA1UrjkPq+RgUOpTN4IaK4YZHFPy0eeG5AR6K
 DHmKWKqjCVK/WoquTTNVoZrB3TDj9W8l5Ge1KdaOJwWISxH8atVPX1C/5ftenPymFwRL
 ni+hR1AohbD8xMbPc9TFvc76d4Sn3qhJ+aS5sqf6G8j8D7Rj7IYXSFlKEE/rNn3t44hi
 z0jeYiBDkygg4svzHKCK8Lfl3BkMQk/GBr5vWapfufaSZ65XN9wti+9UHKdRmCGWsVtV uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2umpxx04b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIJqZ169955;
        Mon, 26 Aug 2019 21:22:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj277uja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLMJ2Y002347;
        Mon, 26 Aug 2019 21:22:19 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:22:18 -0700
Subject: [PATCH 1/5] man: add documentation for v5 bulkstat ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:22:17 -0700
Message-ID: <156685453775.2840332.17792325799461085474.stgit@magnolia>
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

Add a new manpage describing the V5 XFS_IOC_BULKSTAT ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_bulkstat.2   |  330 +++++++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2 |    6 +
 2 files changed, 336 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_bulkstat.2


diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
new file mode 100644
index 00000000..f687cfe8
--- /dev/null
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -0,0 +1,330 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-BULKSTAT 2 2019-05-23 "XFS"
+.SH NAME
+ioctl_xfs_bulkstat \- query information for a batch of XFS inodes
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_BULKSTAT, struct xfs_bulkstat_req *" arg );
+.SH DESCRIPTION
+Query stat information for a group of XFS inodes.
+This ioctl uses
+.B struct xfs_bulkstat_req
+to set up a bulk transfer with the kernel:
+.PP
+.in +4n
+.nf
+struct xfs_bulkstat_req {
+	struct xfs_bulk_ireq    hdr;
+	struct xfs_bulkstat     bulkstat[];
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
+.I hdr.ino
+should be set to the number of the first inode for which the caller wants
+information, or zero to start with the first inode in the filesystem.
+Note that this is a different semantic than the
+.B lastip
+in the old
+.B FSBULKSTAT
+ioctl.
+After the call, this value will be set to the number of the next inode for
+which information could supplied.
+This sets up the next call for an iteration loop.
+.PP
+If the
+.B XFS_BULK_REQ_SPECIAL
+flag is set, this field is interpreted as follows:
+.RS 0.4i
+.TP
+.B XFS_BULK_IREQ_SPECIAL_ROOT
+Return stat information for the root directory inode.
+.RE
+.PP
+.PP
+.I hdr.flags
+is a bit set of operational flags:
+.RS 0.4i
+.TP
+.B XFS_BULK_REQ_AGNO
+If this is set, the call will only return results for the allocation group (AG)
+set in
+.BR hdr.agno .
+If
+.B hdr.ino
+is set to zero, results will be returned starting with the first inode in the
+AG.
+This flag may not be set at the same time as the
+.B XFS_BULK_REQ_SPECIAL
+flag.
+.TP
+.B XFS_BULK_REQ_SPECIAL
+If this is set, results will be returned for only the special inode
+specified in the
+.B hdr.ino
+field.
+This flag may not be set at the same time as the
+.B XFS_BULK_REQ_AGNO
+flag.
+.RE
+.PP
+.I hdr.icount
+is the number of inodes to examine.
+.PP
+.I hdr.ocount
+will be set to the number of records returned.
+.PP
+.I hdr.agno
+is the number of the allocation group (AG) for which we want results.
+If the
+.B XFS_BULK_REQ_AGNO
+flag is not set, this field is ignored.
+.PP
+.I hdr.reserved
+must be set to zero.
+
+.PP
+.I bulkstat
+is an array of
+.B struct xfs_bulkstat
+which is described below.
+The array must have at least
+.I icount
+elements.
+.PP
+.in +4n
+.nf
+struct xfs_bulkstat {
+	uint64_t                bs_ino;
+	uint64_t                bs_size;
+
+	uint64_t                bs_blocks;
+	uint64_t                bs_xflags;
+
+	uint64_t                bs_atime;
+	uint64_t                bs_mtime;
+
+	uint64_t                bs_ctime;
+	uint64_t                bs_btime;
+
+	uint32_t                bs_gen;
+	uint32_t                bs_uid;
+	uint32_t                bs_gid;
+	uint32_t                bs_projectid;
+
+	uint32_t                bs_atime_nsec;
+	uint32_t                bs_mtime_nsec;
+	uint32_t                bs_ctime_nsec;
+	uint32_t                bs_btime_nsec;
+
+	uint32_t                bs_blksize;
+	uint32_t                bs_rdev;
+	uint32_t                bs_cowextsize_blks;
+	uint32_t                bs_extsize_blks;
+
+	uint32_t                bs_nlink;
+	uint32_t                bs_extents;
+	uint32_t                bs_aextents;
+	uint16_t                bs_version;
+	uint16_t                bs_forkoff;
+
+	uint16_t                bs_sick;
+	uint16_t                bs_checked;
+	uint16_t                bs_mode;
+	uint16_t                bs_pad2;
+
+	uint64_t                bs_pad[7];
+};
+.fi
+.in
+.PP
+.I bs_ino
+is the inode number of this record.
+.PP
+.I bs_size
+is the size of the file, in bytes.
+.PP
+.I bs_blocks
+is the number of filesystem blocks allocated to this file, including metadata.
+.PP
+.I bs_xflags
+tell us what extended flags are set this inode.
+These flags are the same values as those defined in the
+.B XFS INODE FLAGS
+section of the
+.BR ioctl_xfs_fsgetxattr (2)
+manpage.
+.PP
+.I bs_atime
+is the last time this file was accessed, in seconds.
+.PP
+.I bs_mtime
+is the last time the contents of this file were modified, in seconds.
+.PP
+.I bs_ctime
+is the last time this inode record was modified, in seconds.
+.PP
+.I bs_btime
+is the time this inode record was created, in seconds.
+.PP
+.I bs_gen
+is the generation number of the inode record.
+.PP
+.I bs_uid
+is the user id.
+.PP
+.I bs_gid
+is the group id.
+.PP
+.I bs_projectid
+is the the project id.
+.PP
+.I bs_atime_nsec
+is the nanoseconds component of the last time this file was accessed.
+.PP
+.I bs_mtime_nsec
+is the nanoseconds component of the last time the contents of this file were
+modified.
+.PP
+.I bs_ctime_nsec
+is the nanoseconds component of the last time this inode record was modified.
+.PP
+.I bs_btime_nsec
+is the nanoseconds component of the time this inode record was created.
+.PP
+.I bs_blksize
+is the size of a data block for this file, in units of bytes.
+.PP
+.I bs_rdev
+is the encoded device id if this is a special file.
+.PP
+.I bs_cowextsize_blks
+is the Copy on Write extent size hint for this file, in units of data blocks.
+.PP
+.I bs_extsize_blks
+is the extent size hint for this file, in units of data blocks.
+.PP
+.I bs_nlink
+is the number of hard links to this inode.
+.PP
+.I bs_extents
+is the number of storage mappings associated with this file's data.
+.PP
+.I bs_aextents
+is the number of storage mappings associated with this file's extended
+attributes.
+.PP
+.I bs_version
+is the version of this data structure.
+Currently, only 1 or 5 are supported.
+.PP
+.I bs_forkoff
+is the offset of the attribute fork in the inode record, in bytes.
+.PP
+The fields
+.IR bs_sick " and " bs_checked
+indicate the relative health of various allocation group metadata.
+Please see the section
+.B XFS INODE METADATA HEALTH REPORTING
+for more information.
+.PP
+.I bs_mode
+is the file type and mode.
+.PP
+.I bs_pad[7]
+is zeroed.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH XFS INODE METADATA HEALTH REPORTING
+.PP
+The online filesystem checking utility scans inode metadata and records what it
+finds in the kernel incore state.
+The following scheme is used for userspace to read the incore health status of
+an inode:
+.IP \[bu] 2
+If a given sick flag is set in
+.IR bs_sick ,
+then that piece of metadata has been observed to be damaged.
+The same bit should be set in
+.IR bs_checked .
+.IP \[bu]
+If a given sick flag is set in
+.I bs_checked
+but is not set in
+.IR bs_sick ,
+then that piece of metadata has been checked and is not faulty.
+.IP \[bu]
+If a given sick flag is not set in
+.IR bs_checked ,
+then no conclusion can be made.
+.PP
+The following flags apply to these fields:
+.RS 0.4i
+.TP
+.B XFS_BS_SICK_INODE
+The inode's record itself.
+.TP
+.B XFS_BS_SICK_BMBTD
+File data extent mappings.
+.TP
+.B XFS_BS_SICK_BMBTA
+Extended attribute extent mappings.
+.TP
+.B XFS_BS_SICK_BMBTC
+Copy on Write staging extent mappings.
+.TP
+.B XFS_BS_SICK_DIR
+Directory information.
+.TP
+.B XFS_BS_SICK_XATTR
+Extended attribute data.
+.TP
+.B XFS_BS_SICK_SYMLINK
+Symbolic link target.
+.TP
+.B XFS_BS_SICK_PARENT
+Parent pointers.
+.RE
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
+.BR ioctl_xfs_fsgetxattr (2)
diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
index 3e13cfa8..81f9d9bf 100644
--- a/man/man2/ioctl_xfs_fsbulkstat.2
+++ b/man/man2/ioctl_xfs_fsbulkstat.2
@@ -15,6 +15,12 @@ ioctl_xfs_fsbulkstat \- query information for a batch of XFS inodes
 .BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT_SINGLE, struct xfs_fsop_bulkreq *" arg );
 .SH DESCRIPTION
 Query stat information for a group of XFS inodes.
+.PP
+NOTE: This ioctl has been superseded.
+Please see the
+.BR ioctl_xfs_bulkstat (2)
+manpage for information about its replacement.
+.PP
 These ioctls use
 .B struct xfs_fsop_bulkreq
 to set up a bulk transfer with the kernel:

