Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208B5C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2D82332A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHuY6sEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfHTUb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43506 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbfHTUb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT1Ib165933;
        Tue, 20 Aug 2019 20:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4uKhtbd+qizFfa6vZxLzkxuZlnU1dqqYB5ij1qL4O3Y=;
 b=jHuY6sEQK8Zn7QaXr9l81lsxpr9RS2/A9l2HSRn4sIeNBbc5CodcSMjQsfAdgFQ5sGWZ
 e4py3VzAiLbO6k9XhdUsqzf58xTUadhBTDCT3DtRX7wfPhSuNSGOeAC8Ha1NFav1Ckp1
 iY0Em47ScW6jcq0OQMavHm+RsxdvyWPkA0AoWX5xlo8GadlEnnXihKnoaTSsPX/4K30z
 hxiHYVwOwk6dEiZuvVDolqlxAltBrqnGx4/y2JUkr/b+KGCVPzYi2+cCtP+23o2ofdsl
 CboOzPReJzuo3161yabZwdMn7GmyOfQ3Am8YNophDi+O8p3S7qdQdl4Mg2PACfkrE2t/ dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7qs0jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTSYt104732;
        Tue, 20 Aug 2019 20:31:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ug269648r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKVtRx020009;
        Tue, 20 Aug 2019 20:31:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:55 -0700
Subject: [PATCH 07/12] man: document the new health reporting fields in
 various ioctls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:54 -0700
Message-ID: <156633311435.1215978.5608220966246380465.stgit@magnolia>
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

Update the manpages to conver the new health reporting fields in the
fs geometry, ag geometry, and bulkstat ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_ag_geometry.2   |   48 +++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2    |   52 +++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsop_geometry.2 |   56 +++++++++++++++++++++++++++++++++++-
 3 files changed, 154 insertions(+), 2 deletions(-)


diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
index 5dfe0d08..cf6aec1d 100644
--- a/man/man2/ioctl_xfs_ag_geometry.2
+++ b/man/man2/ioctl_xfs_ag_geometry.2
@@ -49,6 +49,54 @@ group.
 .TP
 .IR ag_reserved " and " ag_reserved32
 Will be set to zero.
+.PP
+The fields
+.IR ag_sick " and " ag_checked
+indicate the relative health of various allocation group metadata:
+.IP \[bu] 2
+If a given sick flag is set in
+.IR ag_sick ,
+then that piece of metadata has been observed to be damaged.
+The same bit will be set in
+.IR ag_checked .
+.IP \[bu]
+If a given sick flag is set in
+.I ag_checked
+and is not set in
+.IR ag_sick ,
+then that piece of metadata has been checked and is not faulty.
+.IP \[bu]
+If a given sick flag is not set in
+.IR ag_checked ,
+then no conclusion can be made.
+.PP
+The following flags apply to these fields:
+.RS 0.4i
+.TP
+.B XFS_AG_GEOM_SICK_SB
+Allocation group superblock.
+.TP
+.B XFS_AG_GEOM_SICK_AGF
+Free space header.
+.TP
+.B XFS_AG_GEOM_SICK_AGFL
+Free space reserve list.
+.TP
+.B XFS_AG_GEOM_SICK_AGI
+Inode header.
+.TP
+.BR XFS_AG_GEOM_SICK_BNOBT " or " XFS_AG_GEOM_SICK_CNTBT
+Free space btrees.
+.TP
+.BR XFS_AG_GEOM_SICK_INOBT " or " XFS_AG_GEOM_SICK_FINOBT
+Inode btrees.
+.TP
+.B XFS_AG_GEOM_SICK_RMAPBT
+Reverse mapping btree.
+.TP
+.B XFS_AG_GEOM_SICK_REFCNTBT
+Reference count btree.
+.RE
 .SH RETURN VALUE
 On error, \-1 is returned, and
 .I errno
diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
index a8b22dc4..3e13cfa8 100644
--- a/man/man2/ioctl_xfs_fsbulkstat.2
+++ b/man/man2/ioctl_xfs_fsbulkstat.2
@@ -94,7 +94,9 @@ struct xfs_bstat {
 	__u16             bs_projid_lo;
 	__u16             bs_forkoff;
 	__u16             bs_projid_hi;
-	unsigned char     bs_pad[6];
+	uint16_t          bs_sick;
+	uint16_t          bs_checked;
+	unsigned char     bs_pad[2];
 	__u32             bs_cowextsize;
 	__u32             bs_dmevmask;
 	__u16             bs_dmstate;
@@ -184,6 +186,54 @@ is unused on Linux.
 .I bs_aextents
 is the number of storage mappings associated with this file's extended
 attributes.
+.PP
+The fields
+.IR bs_sick " and " bs_checked
+indicate the relative health of various allocation group metadata:
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
 .SH RETURN VALUE
 On error, \-1 is returned, and
 .I errno
diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
index 365bda8b..a35bbaeb 100644
--- a/man/man2/ioctl_xfs_fsop_geometry.2
+++ b/man/man2/ioctl_xfs_fsop_geometry.2
@@ -47,7 +47,9 @@ struct xfs_fsop_geom {
 	__u32         logsunit;
 	/* struct xfs_fsop_geom_v4 stops here. */
 
-	__u64         reserved[18];
+	__u32         sick;
+	__u32         checked;
+	__u64         reserved[17];
 };
 .fi
 .in
@@ -130,6 +132,13 @@ This field is meaningful only if the flag
 .B  XFS_FSOP_GEOM_FLAGS_LOGV2
 is set.
 .PP
+The fields
+.IR sick " and " checked
+indicate the relative health of various whole-filesystem metadata.
+Please see the section
+.B XFS METADATA HEALTH REPORTING
+for more details.
+.PP
 .I reserved
 is set to zero.
 .SH FILESYSTEM FEATURE FLAGS
@@ -203,6 +212,51 @@ Filesystem stores reverse mappings of blocks to owners.
 .B XFS_FSOP_GEOM_FLAGS_REFLINK
 Filesystem supports sharing blocks between files.
 .RE
+.SH XFS METADATA HEALTH REPORTING
+.PP
+The online filesystem checking utility scans metadata and records what it
+finds in the kernel incore state.
+The following scheme is used for userspace to read the incore health status
+of the filesystem:
+
+.IP \[bu] 2
+If a given sick flag is set in
+.IR sick ,
+then that piece of metadata has been observed to be damaged.
+The same bit should be set in
+.IR checked .
+.IP \[bu]
+If a given sick flag is set in
+.I checked
+but is not set in
+.IR sick ,
+then that piece of metadata has been checked and is not faulty.
+.IP \[bu]
+If a given sick flag is not set in
+.IR checked ,
+then no conclusion can be made.
+.PP
+The following flags apply to these fields:
+.RS 0.4i
+.TP
+.B XFS_FSOP_GEOM_SICK_COUNTERS
+Inode and space summary counters.
+.TP
+.B XFS_FSOP_GEOM_SICK_UQUOTA
+User quota information.
+.TP
+.B XFS_FSOP_GEOM_SICK_GQUOTA
+Group quota information.
+.TP
+.B XFS_FSOP_GEOM_SICK_PQUOTA
+Project quota information.
+.TP
+.B XFS_FSOP_GEOM_SICK_RT_BITMAP
+Free space bitmap for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_RT_SUMMARY
+Free space summary for the realtime device.
+.RE
 
 .SH RETURN VALUE
 On error, \-1 is returned, and

