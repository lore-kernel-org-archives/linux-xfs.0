Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACE0C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24DE022CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qiwRhMon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfIDEhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfIDEhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844b4IJ040918;
        Wed, 4 Sep 2019 04:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=naKZTg7i9AuCCzSSAZXnH3OTQlA8RJPx2xYVrMYGFhU=;
 b=qiwRhMonFsuNpb1E4UaIcfczFjdNPsw/vfCifWelLLiV161aqmErMsTfEpSHdNuQ4WBo
 EYVm+jFEJZ4sJSjS9ccdweOmOZBaptL+W4qnoApC+qv39FVONxZiGhGSHVOhtYp4qhYb
 W8jOqkLtI/hoV2Q20UIzXiH+XFL0KYBz3dV+WnFaeMBlFILTsu5sKB5ebrTtzHMR3A8S
 VzqlOoqKQNmYq1789lkN62pWo5G5umQ/gDAc4naVAY3xYGoXVcdFKq4u1YwYFFyoNsp7
 XCVU6jNR1kloMr+kpzCliYtPNyQvSAoiwPObNziVNh9h9K3KHh8t/hqpiKPYr2wM6ALE OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ut6d1r09h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844WtGx022791;
        Wed, 4 Sep 2019 04:37:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2usu51c50n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844bT85016277;
        Wed, 4 Sep 2019 04:37:29 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:28 -0700
Subject: [PATCH 04/10] man: document the new health reporting fields in
 various ioctls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:37:27 -0700
Message-ID: <156757184781.1838441.4746750117807426676.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the manpages to conver the new health reporting fields in the
fs geometry, ag geometry, and bulkstat ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 man/man2/ioctl_xfs_ag_geometry.2   |   48 +++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2    |   52 +++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsop_geometry.2 |   56 +++++++++++++++++++++++++++++++++++-
 3 files changed, 154 insertions(+), 2 deletions(-)


diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
index ddd54265..80ebcb76 100644
--- a/man/man2/ioctl_xfs_ag_geometry.2
+++ b/man/man2/ioctl_xfs_ag_geometry.2
@@ -57,6 +57,54 @@ Currently no flags are defined, so this field must be zero.
 .TP
 .IR ag_reserved
 All reserved fields will be set to zero on return.
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

