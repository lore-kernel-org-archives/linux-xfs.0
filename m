Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F89C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AAE9221ED
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uOqAwMeO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgIKQno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:43:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgIKQnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 12:43:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BGdalb161235;
        Fri, 11 Sep 2020 16:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=YB3Q2v7IZ+OJSNXFVX99LhsJy8Y4hQSuoM7Nzl/SDIk=;
 b=uOqAwMeO/TOk7m+68DPL9R2z10z06Z+B3TwnyIQGveo3KJ3nt/UAStBi7d7THZuEiSxk
 7YTOKOymbFJP0ck6SRVC6D1G/Y8pGtVZTcd1n3VAV8tVzgh5iRuZJKOy3mVeolYXO+OA
 tVbIPPDDTG3QxGhED1p/d1pMBev76xyXOm6Y9kfvLIbodHw9ot045ep7sHk3vngfgxI6
 sUx/2ehSpCdsNu1/uC3b+f1P8XfIpGMxeQjZNyoBJOFkgYPDHNBeBM9coC2jpZATjtm2
 9KA8VWFA4S+8JoslKnWf+grG5r65D8qq+84rDiadxsdnJda1JUZ4/kfQBU7xMi1XmoYx sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23rfc5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 16:43:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BGfRYC070012;
        Fri, 11 Sep 2020 16:43:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmkdf2r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 16:43:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BGhC0H026241;
        Fri, 11 Sep 2020 16:43:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 09:43:12 -0700
Date:   Fri, 11 Sep 2020 09:43:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <20200911164311.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=5 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The V4 filesystem format contains known weaknesses in the on-disk format
that make metadata verification diffiult.  In addition, the format will
does not support dates past 2038 and will not be upgraded to do so.
Therefore, we should start the process of retiring the old format to
close off attack surfaces and to encourage users to migrate onto V5.

Therefore, make XFS V4 support a configurable option.  For the first
period it will be default Y in case some distributors want to withdraw
support early; for the second period it will be default N so that anyone
who wishes to continue support can do so; and after that, support will
be removed from the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: be a little more helpful about old xfsprogs and warn more loudly
about deprecation
v2: define what is a V4 filesystem, update the administrator guide
---
 Documentation/admin-guide/xfs.rst |   23 +++++++++++++++++++++++
 fs/xfs/Kconfig                    |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_super.c                |   13 +++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f461d6c33534..b6deea9ec073 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -210,6 +210,28 @@ When mounting an XFS filesystem, the following options are accepted.
 	inconsistent namespace presentation during or after a
 	failover event.
 
+Deprecation of V4 Format
+========================
+
+The V4 filesystem format lacks certain features that are supported by
+the V5 format, such as metadata checksumming, strengthened metadata
+verification, and the ability to store timestamps past the year 2038.
+Because of this, the V4 format is deprecated.  All users should upgrade
+by backing up their files, reformatting, and restoring from the backup.
+
+Administrators and users can detect a V4 filesystem by running xfs_info
+against a filesystem mountpoint and checking for a string beginning with
+"crc=".  If no such string is found, please upgrade xfsprogs to the
+latest version and try again.
+
+The deprecation will take place in two parts.  Support for mounting V4
+filesystems can now be disabled at kernel build time via Kconfig option.
+The option will default to yes until September 2025, at which time it
+will be changed to default to no.  In September 2030, support will be
+removed from the codebase entirely.
+
+Note: Distributors may choose to withdraw V4 format support earlier than
+the dates listed above.
 
 Deprecated Mount Options
 ========================
@@ -217,6 +239,7 @@ Deprecated Mount Options
 ===========================     ================
   Name				Removal Schedule
 ===========================     ================
+Mounting with V4 filesystem     September 2030
 ===========================     ================
 
 
diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index e685299eb3d2..5422227e9e93 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -22,6 +22,30 @@ config XFS_FS
 	  system of your root partition is compiled as a module, you'll need
 	  to use an initial ramdisk (initrd) to boot.
 
+config XFS_SUPPORT_V4
+	bool "Support deprecated V4 (crc=0) format"
+	default y
+	help
+	  The V4 filesystem format lacks certain features that are supported
+	  by the V5 format, such as metadata checksumming, strengthened
+	  metadata verification, and the ability to store timestamps past the
+	  year 2038.  Because of this, the V4 format is deprecated.  All users
+	  should upgrade by backing up their files, reformatting, and restoring
+	  from the backup.
+
+	  Administrators and users can detect a V4 filesystem by running
+	  xfs_info against a filesystem mountpoint and checking for a string
+	  beginning with "crc=".  If the string "crc=0" is found, the
+	  filesystem is a V4 filesystem.  If no such string is found, please
+	  upgrade xfsprogs to the latest version and try again.
+
+	  This option will become default N in September 2025.  Support for the
+	  V4 format will be removed entirely in September 2030.  Distributors
+	  can say N here to withdraw support earlier.
+
+	  To continue supporting the old V4 format (crc=0), say Y.
+	  To close off an attack surface, say N.
+
 config XFS_QUOTA
 	bool "XFS Quota support"
 	depends on XFS_FS
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index febd61ba071d..e2250c6d7251 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1451,6 +1451,19 @@ xfs_fc_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	/* V4 support is undergoing deprecation. */
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+#ifdef CONFIG_XFS_SUPPORT_V4
+		xfs_warn_once(mp,
+	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
+#else
+		xfs_warn(mp,
+	"Deprecated V4 format (crc=0) not supported by kernel.");
+		error = -EINVAL;
+		goto out_free_sb;
+#endif
+	}
+
 	/*
 	 * XFS block mappings use 54 bits to store the logical block offset.
 	 * This should suffice to handle the maximum file size that the VFS
