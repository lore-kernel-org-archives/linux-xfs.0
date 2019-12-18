Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A07C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E5D8206A5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TKoG4aH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfLRRJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:09:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfLRRJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 12:09:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIH9EJL001975;
        Wed, 18 Dec 2019 17:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=wLwGQnTnOdeXnt/wkEWQK6QY8ejl2OQMYW8MaHlKpFc=;
 b=TKoG4aH9gh/icp4cxyGZf7ieOItFqxOdBxM62T9Lqbriq+d8q7nCcgmYtEOo5H9vfI3L
 +QLP8JATAxWSH08VN6V6R3FOhBObwKBkdecKVkSLCHmw2ov9MTTjXjloqYSOdJKaBHUt
 QDc9UOb+EWgWpjbE+oJP4oUsOMeYRP4RYyG33IvY8EBHlQSXESC5cfdL1S0Ywvxt6uwx
 +gaMUGVqblGKDvUTG2s0Wuyzx5+aAKi7SlkLr8VEeXUeszRxYm/cZZphsGvAJhi+WmhW
 KaPanLMhHszDhepveL7EjcEwdkXJRlT9eMwMlxNaE0K54WCAKrXUGWKeIdIshLjwFwP1 kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wvrcrewr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 17:09:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIH4fsH189849;
        Wed, 18 Dec 2019 17:09:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wyk3bfu1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 17:09:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBIH9r0M004043;
        Wed, 18 Dec 2019 17:09:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 09:09:52 -0800
Date:   Wed, 18 Dec 2019 09:09:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] man: list xfs_io lsattr inode flag letters
Message-ID: <20191218170951.GN12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The section of the xfs_io manpage for the 'chattr' command says to refer
to xfsctl(3) for information on the flags.  The inode flag information
was moved to ioctl_xfs_fssetxattr(2) ages ago, and it never actually
mapped the inode flag letters to inode flag bits, so add those to the
xfs_io manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_io.8 |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 117 insertions(+), 6 deletions(-)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2f17c64c..26523ab8 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -794,18 +794,129 @@ for all directory entries below the currently open file
 can be used to restrict the output to directories only).
 This is a depth first descent, it does not follow symlinks and
 it also does not cross mount points.
+
+The current inode flag letters are:
+
+.PD 0
+.RS
+.TP 0.5i
+.SM "r (XFS_XFLAG_REALTIME)"
+The file is a realtime file.
+
+.TP
+.SM "p (XFS_XFLAG_PREALLOC)"
+The file has preallocated space.
+
+.TP
+.SM "i (XFS_XFLAG_IMMUTABLE)"
+The file is immutable - it cannot be modified, deleted or renamed, no link can
+be created to this file and no data can be written to the file.
+Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
+can set or clear this flag.
+
+.TP
+.SM "a (XFS_XFLAG_APPEND)"
+The file is append-only - it can only be open in append mode for writing.
+Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
+can set or clear this flag.
+
+.TP
+.SM "s (XFS_XFLAG_SYNC)"
+All writes to the file are synchronous.
+
+.TP
+.SM "A (XFS_XFLAG_NOATIME)"
+When the file is accessed, its atime record is not modified.
+
+.TP
+.SM "d (XFS_XFLAG_NODUMP)"
+The file should be skipped by backup utilities.
+
+.TP
+.SM "t (XFS_XFLAG_RTINHERIT)"
+New files created in this directory will be automatically flagged as realtime.
+New directories created in the directory will inherit the inheritance bit.
+
+.TP
+.SM "P (XFS_XFLAG_PROJINHERIT)"
+New files and directories created in the directory will inherit the parent's
+project ID.
+New directories also inherit the project ID and project inheritance bit.
+
+.TP
+.SM "n (XFS_XFLAG_NOSYMLINKS)"
+Can only be set on a directory and disallows creation of symbolic links in the
+directory.
+
+.TP
+.SM "e (XFS_XFLAG_EXTSIZE)"
+Extent size hint - if a basic extent size value is set on the file then the
+allocator will try allocate in multiples of the set size for this file.
+This only applies to non-realtime files.
+See
+.BR ioctl_xfs_fsgetxattr "(2)"
+for more information.
+
+.TP
+.SM "E (XFS_XFLAG_EXTSZINHERIT)"
+New files and directories created in the directory will inherit the parent's
+basic extent size value (see above).
+Can only be set on a directory.
+
+.TP
+.SM "f (XFS_XFLAG_NODEFRAG)"
+The file should be skipped during a defragmentation operation.
+When applied to a directory, new files and directories created will
+inherit the no\-defrag state.
+
+.TP
+.SM "S (XFS_XFLAG_FILESTREAM)"
+Filestream allocator - allows a directory to reserve an allocation group for
+exclusive use by files created within that directory.
+Files being written in other directories will not use the same allocation group
+and so files within different directories will not interleave
+extents on disk.
+The reservation is only active while files are being created and written into
+the directory.
+
+.TP
+.SM "x (XFS_XFLAG_DAX)"
+If the filesystem lives on directly accessible persistent memory, reads and
+writes to this file will go straight to the persistent memory, bypassing the
+page cache.
+A file with this flag set cannot share blocks.
+If set on a directory, new files and directories created will inherit the
+persistent memory capability.
+
+.TP
+.SM "C (XFS_XFLAG_COWEXTSIZE)"
+Copy on Write Extent size hint - if a CoW extent size value is set on the file,
+the allocator will allocate extents for staging a copy on write operation
+in multiples of the set size for this file.
+See
+.BR ioctl_xfs_fsgetxattr "(2)"
+for more information.
+If the CoW extent size is set on a directory, then new file and directories
+created in the directory will inherit the parent's CoW extent size value.
+
+.TP
+.SM "X (XFS_XFLAG_HASATTR)"
+The file has extended attributes associated with it.
+This flag cannot be changed via chattr.
+.RE
+
 .TP
 .BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
 Change extended inode flags on the currently open file. The
 .B \-R
 and
 .B \-D
-options have the same meaning as above. The mapping between each
-letter and the inode flags (refer to
-.BR xfsctl (3)
-for the full list) is available via the
-.B help
-command.
+options have the same meaning as above.
+
+See the
+.B lsattr
+command above for the list of inode flag letters.
+
 .TP
 .BI "flink " path
 Link the currently open file descriptor into the filesystem namespace.
