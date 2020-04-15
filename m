Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92418C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 14:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5672076D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586961205;
	bh=tZEaf3VXusol79yiStwC6vmB24JiKcfIqq+xUsDyCP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rXturFKh5jvsf4MA3yKE5Xx1sVo2u6QfiM84IK8zwAgSyx8FKbHQWk5UoWYJHTCNk
	 fn/2OFdWt4/FcoiMTAQ14ppljPmMpT3yEWJ3u3HpKyRbym6vB8anZ89bJwYTWxtfhe
	 YvEY3mIZJw3Uqz3fixcjd2Javv9tme7K1ESlQKTs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394104AbgDOOdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 10:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394098AbgDOOdN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 10:33:13 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13F5F22200;
        Wed, 15 Apr 2020 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586961172;
        bh=tZEaf3VXusol79yiStwC6vmB24JiKcfIqq+xUsDyCP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVjnPctcaWeLc8zV/sotemxwD5+YQauN/fCC6/LP5ysIMqcsv5LnBu6lxD+ZfmsEr
         D5lXM713ewZblvWqixpOG3xFVXatY72Y1sq4yN807jA9CBc4F6GZTmoPvRn4DPg36p
         ODQ18XeJc0CrEMCmrgZMiIAeUd7KcXIvF/FYzE1U=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jOj5u-006kQP-99; Wed, 15 Apr 2020 16:32:50 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 34/34] docs: filesystems: convert xfs-self-describing-metadata.txt to ReST
Date:   Wed, 15 Apr 2020 16:32:47 +0200
Message-Id: <8d1a6c3feb1f3ce662c101276145ca5ae28cb0d0.1586960617.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1586960617.git.mchehab+huawei@kernel.org>
References: <cover.1586960617.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

- Add a SPDX header;
- Adjust document and section titles;
- Some whitespace fixes and new line breaks;
- Mark literal blocks as such;
- Add it to filesystems/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/filesystems/index.rst           |   1 +
 ...a.txt => xfs-self-describing-metadata.rst} | 182 +++++++++---------
 MAINTAINERS                                   |   2 +-
 3 files changed, 94 insertions(+), 91 deletions(-)
 rename Documentation/filesystems/{xfs-self-describing-metadata.txt => xfs-self-describing-metadata.rst} (83%)

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 70c0e0b29e74..61d5be3f6f9a 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -122,4 +122,5 @@ Documentation for filesystem implementations.
    virtiofs
    vfat
    xfs-delayed-logging-design
+   xfs-self-describing-metadata
    zonefs
diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.rst
similarity index 83%
rename from Documentation/filesystems/xfs-self-describing-metadata.txt
rename to Documentation/filesystems/xfs-self-describing-metadata.rst
index 8db0121d0980..51cdafe01ab1 100644
--- a/Documentation/filesystems/xfs-self-describing-metadata.txt
+++ b/Documentation/filesystems/xfs-self-describing-metadata.rst
@@ -1,8 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================
 XFS Self Describing Metadata
-----------------------------
+============================
 
 Introduction
-------------
+============
 
 The largest scalability problem facing XFS is not one of algorithmic
 scalability, but of verification of the filesystem structure. Scalabilty of the
@@ -34,7 +37,7 @@ required for basic forensic analysis of the filesystem structure.
 
 
 Self Describing Metadata
-------------------------
+========================
 
 One of the problems with the current metadata format is that apart from the
 magic number in the metadata block, we have no other way of identifying what it
@@ -142,7 +145,7 @@ modification occurred between the corruption being written and when it was
 detected.
 
 Runtime Validation
-------------------
+==================
 
 Validation of self-describing metadata takes place at runtime in two places:
 
@@ -183,18 +186,18 @@ error occurs during this process, the buffer is again marked with a EFSCORRUPTED
 error for the higher layers to catch.
 
 Structures
-----------
+==========
 
-A typical on-disk structure needs to contain the following information:
+A typical on-disk structure needs to contain the following information::
 
-struct xfs_ondisk_hdr {
-        __be32  magic;		/* magic number */
-        __be32  crc;		/* CRC, not logged */
-        uuid_t  uuid;		/* filesystem identifier */
-        __be64  owner;		/* parent object */
-        __be64  blkno;		/* location on disk */
-        __be64  lsn;		/* last modification in log, not logged */
-};
+    struct xfs_ondisk_hdr {
+	    __be32  magic;		/* magic number */
+	    __be32  crc;		/* CRC, not logged */
+	    uuid_t  uuid;		/* filesystem identifier */
+	    __be64  owner;		/* parent object */
+	    __be64  blkno;		/* location on disk */
+	    __be64  lsn;		/* last modification in log, not logged */
+    };
 
 Depending on the metadata, this information may be part of a header structure
 separate to the metadata contents, or may be distributed through an existing
@@ -214,24 +217,24 @@ level of information is generally provided. For example:
 	  well. hence the additional metadata headers change the overall format
 	  of the metadata.
 
-A typical buffer read verifier is structured as follows:
+A typical buffer read verifier is structured as follows::
 
-#define XFS_FOO_CRC_OFF		offsetof(struct xfs_ondisk_hdr, crc)
+    #define XFS_FOO_CRC_OFF		offsetof(struct xfs_ondisk_hdr, crc)
 
-static void
-xfs_foo_read_verify(
-	struct xfs_buf	*bp)
-{
-       struct xfs_mount *mp = bp->b_mount;
+    static void
+    xfs_foo_read_verify(
+	    struct xfs_buf	*bp)
+    {
+	struct xfs_mount *mp = bp->b_mount;
 
-        if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-             !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					XFS_FOO_CRC_OFF)) ||
-            !xfs_foo_verify(bp)) {
-                XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-                xfs_buf_ioerror(bp, EFSCORRUPTED);
-        }
-}
+	    if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+		!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					    XFS_FOO_CRC_OFF)) ||
+		!xfs_foo_verify(bp)) {
+		    XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		    xfs_buf_ioerror(bp, EFSCORRUPTED);
+	    }
+    }
 
 The code ensures that the CRC is only checked if the filesystem has CRCs enabled
 by checking the superblock of the feature bit, and then if the CRC verifies OK
@@ -239,83 +242,83 @@ by checking the superblock of the feature bit, and then if the CRC verifies OK
 
 The verifier function will take a couple of different forms, depending on
 whether the magic number can be used to determine the format of the block. In
-the case it can't, the code is structured as follows:
+the case it can't, the code is structured as follows::
 
-static bool
-xfs_foo_verify(
-	struct xfs_buf		*bp)
-{
-        struct xfs_mount	*mp = bp->b_mount;
-        struct xfs_ondisk_hdr	*hdr = bp->b_addr;
+    static bool
+    xfs_foo_verify(
+	    struct xfs_buf		*bp)
+    {
+	    struct xfs_mount	*mp = bp->b_mount;
+	    struct xfs_ondisk_hdr	*hdr = bp->b_addr;
 
-        if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
-                return false;
+	    if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
+		    return false;
 
-        if (!xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
-			return false;
-		if (bp->b_bn != be64_to_cpu(hdr->blkno))
-			return false;
-		if (hdr->owner == 0)
-			return false;
-	}
+	    if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		    if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
+			    return false;
+		    if (bp->b_bn != be64_to_cpu(hdr->blkno))
+			    return false;
+		    if (hdr->owner == 0)
+			    return false;
+	    }
 
-	/* object specific verification checks here */
+	    /* object specific verification checks here */
 
-        return true;
-}
+	    return true;
+    }
 
 If there are different magic numbers for the different formats, the verifier
-will look like:
+will look like::
 
-static bool
-xfs_foo_verify(
-	struct xfs_buf		*bp)
-{
-        struct xfs_mount	*mp = bp->b_mount;
-        struct xfs_ondisk_hdr	*hdr = bp->b_addr;
+    static bool
+    xfs_foo_verify(
+	    struct xfs_buf		*bp)
+    {
+	    struct xfs_mount	*mp = bp->b_mount;
+	    struct xfs_ondisk_hdr	*hdr = bp->b_addr;
 
-        if (hdr->magic == cpu_to_be32(XFS_FOO_CRC_MAGIC)) {
-		if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
-			return false;
-		if (bp->b_bn != be64_to_cpu(hdr->blkno))
-			return false;
-		if (hdr->owner == 0)
-			return false;
-	} else if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
-		return false;
+	    if (hdr->magic == cpu_to_be32(XFS_FOO_CRC_MAGIC)) {
+		    if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
+			    return false;
+		    if (bp->b_bn != be64_to_cpu(hdr->blkno))
+			    return false;
+		    if (hdr->owner == 0)
+			    return false;
+	    } else if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
+		    return false;
 
-	/* object specific verification checks here */
+	    /* object specific verification checks here */
 
-        return true;
-}
+	    return true;
+    }
 
 Write verifiers are very similar to the read verifiers, they just do things in
-the opposite order to the read verifiers. A typical write verifier:
+the opposite order to the read verifiers. A typical write verifier::
 
-static void
-xfs_foo_write_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+    static void
+    xfs_foo_write_verify(
+	    struct xfs_buf	*bp)
+    {
+	    struct xfs_mount	*mp = bp->b_mount;
+	    struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
-	if (!xfs_foo_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-		return;
-	}
+	    if (!xfs_foo_verify(bp)) {
+		    XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		    xfs_buf_ioerror(bp, EFSCORRUPTED);
+		    return;
+	    }
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
+	    if (!xfs_sb_version_hascrc(&mp->m_sb))
+		    return;
 
 
-	if (bip) {
-		struct xfs_ondisk_hdr	*hdr = bp->b_addr;
-		hdr->lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_FOO_CRC_OFF);
-}
+	    if (bip) {
+		    struct xfs_ondisk_hdr	*hdr = bp->b_addr;
+		    hdr->lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	    }
+	    xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_FOO_CRC_OFF);
+    }
 
 This will verify the internal structure of the metadata before we go any
 further, detecting corruptions that have occurred as the metadata has been
@@ -324,7 +327,7 @@ update the LSN field (when it was last modified) and calculate the CRC on the
 metadata. Once this is done, we can issue the IO.
 
 Inodes and Dquots
------------------
+=================
 
 Inodes and dquots are special snowflakes. They have per-object CRC and
 self-identifiers, but they are packed so that there are multiple objects per
@@ -347,4 +350,3 @@ XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
 the unlinked list modifications check or update CRCs, neither during unlink nor
 log recovery. So, it's gone unnoticed until now. This won't matter immediately -
 repair will probably complain about it - but it needs to be fixed.
-
diff --git a/MAINTAINERS b/MAINTAINERS
index c52991586853..9f9454f12e06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18552,7 +18552,7 @@ T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 F:	Documentation/ABI/testing/sysfs-fs-xfs
 F:	Documentation/admin-guide/xfs.rst
 F:	Documentation/filesystems/xfs-delayed-logging-design.rst
-F:	Documentation/filesystems/xfs-self-describing-metadata.txt
+F:	Documentation/filesystems/xfs-self-describing-metadata.rst
 F:	fs/xfs/
 F:	include/uapi/linux/dqblk_xfs.h
 F:	include/uapi/linux/fsmap.h
-- 
2.25.2

