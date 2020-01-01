Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6D2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713CA206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xj628vxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAABPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ESv2112743
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pdZXULU3XMv2U5P+r08rIpCcIJCp1859WgPeEQKYQj0=;
 b=Xj628vxD7B4q1ZwJii7SFia2JIfMdTimrE0FtYG1+QfXYxzAemTChHL68DKlBDfZzPvs
 vl7U4ITCmGUiOE0kGaRP6I2aW4EqS/ZKPbPol8AiDUHYzztbU9TYJSkdQggEOsYhA3Zl
 VHkKASi2QyjO/uw2XKD6wvluBfD9PRAHN6EnV6C4LZxmEVOlzuVatND1LY0aP3xR2qBV
 BuV7r8Dbg7BuP0mAaT/Pp6/pW6lYbKvF4fiGMpip4+e+NyBqpsliz3aI8sQQuPSnPlAz
 VyEad/CEFyadxcWrPzd5VXcAtJhDj1to94GqqtKhvabBxWoap+wA17ZwHqRyY4EHEWSW LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xHc012482
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guef89c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011FnTk001377
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:50 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:49 -0800
Subject: [PATCH 09/13] xfs: enforce metadata inode flag
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:47 -0800
Message-ID: <157784134734.1366873.6655382977839344049.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=990
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    5 +++++
 fs/xfs/scrub/common.c         |    3 ++-
 fs/xfs/scrub/inode_repair.c   |    3 +++
 fs/xfs/scrub/scrub.c          |    1 +
 fs/xfs/xfs_icache.c           |    4 +++-
 fs/xfs/xfs_inode.c            |   10 ++++++++++
 fs/xfs/xfs_itable.c           |   11 +++++++++++
 7 files changed, 35 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d0084f47f246..6823e6eeec2c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -548,6 +548,11 @@ xfs_dinode_verify(
 
 	flags2 = be64_to_cpu(dip->di_flags2);
 
+	/* don't allow the metadata iflag if we don't have metadir */
+	if ((flags2 & XFS_DIFLAG2_METADATA) &&
+	    !xfs_sb_version_hasmetadir(&mp->m_sb))
+		return __this_address;
+
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
 	     !xfs_sb_version_hasreflink(&mp->m_sb))
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 71f49f2478d7..68fa5ab8c52b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -732,7 +732,8 @@ xchk_get_inode(
 				error, __return_address);
 		return error;
 	}
-	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+	if (VFS_I(ip)->i_generation != sc->sm->sm_gen ||
+	    xfs_is_metadata_inode(ip)) {
 		xfs_irele(ip);
 		return -ENOENT;
 	}
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index bd4374f49035..0cd2e1e7616d 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -171,6 +171,9 @@ xrep_dinode_flags(
 		flags2 &= ~XFS_DIFLAG2_DAX;
 	if (!xfs_sb_version_hasbigtime(&mp->m_sb))
 		flags2 &= ~XFS_DIFLAG2_BIGTIME;
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb) &&
+	    (flags2 & XFS_DIFLAG2_METADATA))
+		flags2 &= ~XFS_DIFLAG2_METADATA;
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9a7a040ab2c0..54a524d19948 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -166,6 +166,7 @@ xchk_teardown(
 		if (sc->ilock_flags)
 			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
+		    !xfs_is_metadata_inode(sc->ip) &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index adf5a63129c6..57f2f46afb13 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -891,7 +891,9 @@ xfs_imeta_iget(
 	if (error)
 		return error;
 
-	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	if ((xfs_sb_version_hasmetadir(&mp->m_sb) &&
+	     !xfs_is_metadata_inode(ip)) ||
+	    ftype == XFS_DIR3_FT_UNKNOWN ||
 	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
 		xfs_irele(ip);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 00c633ce1013..bac26f793746 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -605,8 +605,15 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	if (xfs_is_metadata_inode(*ipp)) {
+		error = -EINVAL;
+		goto out_irele;
+	}
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kmem_free(ci_name->name);
@@ -2912,6 +2919,9 @@ void
 xfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_sb_version_hasmetadir(&ip->i_mount->m_sb) ||
+	       xfs_is_metadata_inode(ip));
+
 	xfs_irele(ip);
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4b31c29b7e6b..5d0612e35d18 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -75,6 +75,17 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	/*
+	 * Inodes marked as being metadata are treated the same as "internal"
+	 * metadata inodes (which are rooted in the superblock).
+	 */
+	if (xfs_is_metadata_inode(ip)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+		error = -EINVAL;
+		goto out_advance;
+	}
+
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);

