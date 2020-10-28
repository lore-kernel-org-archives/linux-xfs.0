Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FBAC55179
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01B221582
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nz4X7SQl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgJ1Vmk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:42:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgJ1Vm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:42:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S193NX170013
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=urEXcrPvgyz9ZyUpkNET4+FtLnwSZhjRByK8l+YARzg=;
 b=nz4X7SQl2WIwGX0aPIH2OhsZfXl/IZO+z01u3Xon13tZLf3/YZ96T5jQTu6ZRmGYNRVs
 SIK4O3HqNH+kOD9iMIBhARl6t5XJR/n4HvzdRW3KA+bvIVSmYGezqOHCbXMfGGmV8a7W
 b9UO2o/frv4sful39AjPD64h5cbO5tB70jEBeQ36rK3dspyoJtjwVFaurC1w6JKEOBZJ
 pTKlXHOwEDQhWgsKeufZAF5l27pvMoupCLDaXMV05/7jxekyjvj1p2492rBYNQzKXqbC
 FAjAswX7i29B/fNzh89D3nV56/tqIo32H0cpUF37KlfwBgK77ifL1z6gDHYy0GvGY5X9 gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kvxae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S15KAx007695
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6wmp0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09S1APXL009640
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:25 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 18:10:25 -0700
Subject: [PATCH 2/2] design: document changes for the bigtime feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 27 Oct 2020 18:10:24 -0700
Message-ID: <160384742449.1365004.183534023194389095.stgit@magnolia>
In-Reply-To: <160384741244.1365004.6341029408891306870.stgit@magnolia>
References: <160384741244.1365004.6341029408891306870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280002
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Document the changes to the ondisk format when we enable the bigtime
feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    6 ++
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 ++++
 .../internal_inodes.asciidoc                       |    5 ++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    4 +
 .../XFS_Filesystem_Structure/timestamps.asciidoc   |   65 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 6 files changed, 96 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/timestamps.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 2e78f56..2eaab02 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -443,6 +443,12 @@ See the chapter on xref:Sparse_Inodes[Sparse Inodes] for more information.
 Metadata UUID.  The UUID stamped into each metadata block must match the value
 in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
 without having to rewrite the entire filesystem.
+
+| +XFS_SB_FEAT_INCOMPAT_BIGTIME+ |
+Large timestamps.  Inode timestamps and quota expiration timers are extended to
+support times through the year 2486.  See the section on
+xref:Timestamps[timestamps] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 29ffbb5..d7374b0 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -184,4 +184,18 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1415926</revnumber>
+		<date>October 2020</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>darrick.wong@oracle.com</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Document the bigtime and inobtcount features.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 45eeb8b..84e4cb9 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -128,6 +128,11 @@ limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_itimer+ value. When d_icount goes back below +d_ino_softlimit+, +d_itimer+
 is reset back to zero.
 
+If the +XFS_SB_FEAT_INCOMPAT_BIGTIME+ feature is enabled, the 32 bits used by
+the timestamp field are interpreted as the upper 32 bits of an 34-bit unsigned
+seconds counter.  See the section about xref:Quota_Timers[quota expiration
+timers] for more details.
+
 *d_btimer*::
 Specifies the time when the ID's +d_bcount+ exceeded +d_blk_softlimit+. The soft
 limit will turn into a hard limit after the elapsed time exceeds ID zero's
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 02d44ac..1922954 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -200,6 +200,10 @@ struct xfs_timestamp {
 };
 ----
 
+If the +XFS_SB_FEAT_INCOMPAT_BIGTIME+ feature is enabled, the 64 bits used by
+the timestamp field are interpreted as a flat 64-bit nanosecond counter.
+See the section about xref:Inode_Timestamps[inode timestamps] for more details.
+
 *di_mtime*::
 Specifies the last time the file was modified.
 
diff --git a/design/XFS_Filesystem_Structure/timestamps.asciidoc b/design/XFS_Filesystem_Structure/timestamps.asciidoc
new file mode 100644
index 0000000..08baa1e
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/timestamps.asciidoc
@@ -0,0 +1,65 @@
+[[Timestamps]]
+= Timestamps
+
+XFS needs to be able to persist the concept of a point in time.  This chapter
+discusses how timestamps are represented on disk.
+
+[[Inode_Timestamps]]
+== Inode Timestamps
+
+The filesystem preserves up to four different timestamps for each file stored
+in the filesystem.  These quantities are: the time when the file was created
+(+di_crtime+), the last time the file metadata were changed (+di_ctime+), the
+last time the file contents were changed (+di_mtime+), and the last time the
+file contents were accessed (+di_atime+).  The filesystem epoch is aligned with
+the Unix epoch, which is to say that a value of all zeroes represents 00:00:00
+UTC on January 1st, 1970.
+
+Prior to the introduction of the bigtime feature, inode timestamps were
+laid out as as segmented counter of seconds and nanoseconds:
+
+[source, c]
+----
+struct xfs_legacy_timestamp {
+     __int32_t                 t_sec;
+     __int32_t                 t_nsec;
+};
+----
+
+The smallest date this format can represent is 20:45:52 UTC on December 31st,
+1901, and the largest date supported is 03:14:07 UTC on January 19, 2038.
+
+With the introduction of the bigtime feature, the format is changed to
+interpret the timestamp as a 64-bit count of nanoseconds since the smallest
+date supported by the old encoding.  This means that the smallest date
+supported is still 20:45:52 UTC on December 31st, 1901; but now the largest
+date supported is 20:20:24 UTC on July 2nd, 2486.
+
+[[Quota_Timers]]
+== Quota Grace Period Expiration Timers
+
+XFS' quota control allows administrators to set a soft limit on each type of
+resource that a regular user can consume: inodes, blocks, and realtime blocks.
+The administrator can establish a grace period after which the soft limit
+becomes a hard limit for the user.  Therefore, XFS needs to be able to store
+the exact time when a grace period expires.
+
+Prior to the introduction of the bigtime feature, quota grace period
+expirations were unsigned 32-bit seconds counters, with the magic value zero
+meaning that the soft limit has not been exceeded.  Therefore, the smallest
+expiration date that can be expressed is 00:00:01 UTC on January 1st, 1970; and
+the largest is 06:28:15 on February 7th, 2106.
+
+With the introduction of the bigtime feature, the ondisk field now encodes the
+upper 32 bits of an unsigned 34-bit seconds counter.  Zero is still a magic
+value that means the soft limit has not been exceeded.  The smallest quota
+expiration date is now 00:00:04 UTC on January 1st, 1970; and the largest is
+20:20:24 UTC on July 2nd, 2486.  The format can encode slightly larger
+expiration dates, but it was decided to end support for both timers at exactly
+the same point.
+
+The default grace periods are stored in the timer fields of the quota record
+for id zero.  Since this quantity is an interval, these fields are always
+interpreted as an unsigned 32 bit quantity.  Therefore, the longest possible
+grace period is approximately 136 years, 29 weeks, 3 days, 6 hours, 28 minutes
+and 15 seconds.
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 5c1642c..a95a580 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -72,6 +72,8 @@ include::btrees.asciidoc[]
 
 include::dabtrees.asciidoc[]
 
+include::timestamps.asciidoc[]
+
 include::allocation_groups.asciidoc[]
 
 include::rmapbt.asciidoc[]

