Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B22C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C461C206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFRC7Fg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgAABJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x46091245
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Kvdm9DMPbKzcKvnysSUMGB9l7wwhqfyMHNalF/nklEs=;
 b=NFRC7Fg2fED+hpyaErGc5xdwvm6RTca5/RNesbQ8us+/sXkQ4q20fixQu89Zv13n5Ejd
 UYVDBB7kuaTiKqDxEJc8H0KWe+aZxFkOGLwRXDdrTfJqdZt3g3Mat/ZD6XZoo+iaM0Ei
 3SrlCyzbtAZF6EspN6USMu1F4OmdziDGa1rxtGbhkDSai/TdRyi6Bcm29SoIZMFtV8gA
 RtVSAm3gucO0lyOYavL+X7lPkzE1Mm0lad042O7DF4hdtwvS3eABzTBhwG2MJu8sEdM2
 L0Lv5uxaMNZm8yJ8+crm9ERWFA3SdR2CtLkuOa6xC947DdL4RtS0BWKYdKTuDJ62cZkR tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v1m190248
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfy8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00118tPl031345
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:55 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:54 -0800
Subject: [PATCH 02/10] xfs: track unlinked inactive inode fs summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:52 -0800
Message-ID: <157784093263.1362752.14373360314662413051.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Set up counters to track the number of inodes and blocks that will be
freed from inactivating unlinked inodes.  We'll use this in the deferred
inactivation patch to hide the effects of deferred processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |    7 +++++++
 fs/xfs/xfs_super.c |   31 +++++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 097a89826ba7..2fe8f030ebb8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1806,6 +1806,60 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/*
+ * Play some accounting tricks with deferred inactivation of unlinked inodes so
+ * that it looks like the inode got freed immediately.  The superblock
+ * maintains counts of the number of inodes, data blocks, and rt blocks that
+ * would be freed if we were to force inode inactivation.  These counts are
+ * added to the statfs free counters outside of the regular fdblocks/ifree
+ * counters.  If userspace actually demands those "free" resources we'll force
+ * an inactivation scan to free things for real.
+ *
+ * Note that we can safely skip the block accounting trickery for complicated
+ * situations (inode with blocks on both devices, inode block counts that seem
+ * wrong) since the worst that happens is that statfs resource usage decreases
+ * more slowly.
+ *
+ * Positive @direction means we're setting up the accounting trick and
+ * negative undoes it.
+ */
+static inline void
+xfs_inode_iadjust(
+	struct xfs_inode	*ip,
+	int			direction)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		iblocks;
+	int64_t			inodes = 0;
+	int64_t			dblocks = 0;
+	int64_t			rblocks = 0;
+
+	ASSERT(direction != 0);
+
+	if (VFS_I(ip)->i_nlink == 0) {
+		inodes = 1;
+
+		iblocks = max_t(int64_t, 0, ip->i_d.di_nblocks +
+					    ip->i_delayed_blks);
+		if (!XFS_IS_REALTIME_INODE(ip))
+			dblocks = iblocks;
+		else if (!XFS_IFORK_Q(ip) ||
+			 XFS_IFORK_FORMAT(ip, XFS_ATTR_FORK) ==
+					XFS_DINODE_FMT_LOCAL)
+			rblocks = iblocks;
+	}
+
+	if (direction < 0) {
+		inodes = -inodes;
+		dblocks = -dblocks;
+		rblocks = -rblocks;
+	}
+
+	percpu_counter_add(&mp->m_iinactive, inodes);
+	percpu_counter_add(&mp->m_dinactive, dblocks);
+	percpu_counter_add(&mp->m_rinactive, rblocks);
+}
+
 /*
  * Returns true if we need to update the on-disk metadata before we can free
  * the memory used by this inode.  Updates include freeing post-eof
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 296223c2b782..d203c922dc51 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -85,6 +85,13 @@ typedef struct xfs_mount {
 	 */
 	struct percpu_counter	m_delalloc_blks;
 
+	/* Count of inodes waiting for inactivation. */
+	struct percpu_counter	m_iinactive;
+	/* Count of data device blocks waiting for inactivation. */
+	struct percpu_counter	m_dinactive;
+	/* Coult of realtime device blocks waiting for inactivation. */
+	struct percpu_counter	m_rinactive;
+
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 03d95bf0952c..ed10ba2cd087 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -784,6 +784,8 @@ xfs_fs_statfs(
 	uint64_t		icount;
 	uint64_t		ifree;
 	uint64_t		fdblocks;
+	uint64_t		iinactive;
+	uint64_t		binactive;
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
@@ -797,6 +799,7 @@ xfs_fs_statfs(
 	icount = percpu_counter_sum(&mp->m_icount);
 	ifree = percpu_counter_sum(&mp->m_ifree);
 	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	iinactive = percpu_counter_sum(&mp->m_iinactive);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -820,7 +823,7 @@ xfs_fs_statfs(
 					sbp->sb_icount);
 
 	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (icount - ifree);
+	ffree = statp->f_files - (icount - ifree) + iinactive;
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
 
@@ -834,7 +837,12 @@ xfs_fs_statfs(
 		statp->f_blocks = sbp->sb_rblocks;
 		statp->f_bavail = statp->f_bfree =
 			sbp->sb_frextents * sbp->sb_rextsize;
+		binactive = percpu_counter_sum(&mp->m_rinactive);
+	} else {
+		binactive = percpu_counter_sum(&mp->m_dinactive);
 	}
+	statp->f_bavail += binactive;
+	statp->f_bfree += binactive;
 
 	return 0;
 }
@@ -1024,8 +1032,26 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	error = percpu_counter_init(&mp->m_iinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc;
+
+	error = percpu_counter_init(&mp->m_dinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_iinactive;
+
+	error = percpu_counter_init(&mp->m_rinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_dinactive;
+
 	return 0;
 
+free_dinactive:
+	percpu_counter_destroy(&mp->m_dinactive);
+free_iinactive:
+	percpu_counter_destroy(&mp->m_iinactive);
+free_delalloc:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1054,6 +1080,9 @@ xfs_destroy_percpu_counters(
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
+	percpu_counter_destroy(&mp->m_iinactive);
+	percpu_counter_destroy(&mp->m_dinactive);
+	percpu_counter_destroy(&mp->m_rinactive);
 }
 
 static void

