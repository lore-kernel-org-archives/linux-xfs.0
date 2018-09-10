Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbeIKDSb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Sep 2018 23:18:31 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91E35C0467D6
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 22:22:20 +0000 (UTC)
Subject: [PATCH 1/2] xfs: validate inode di_forkoff
References: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <da670f4a-6ae7-fbe7-94db-b6a4e6bb0c9e@redhat.com>
Date: Mon, 10 Sep 2018 17:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Verify the inode di_forkoff, lifted from xfs_repair's
process_check_inode_forkoff().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 30d1d60f1d46..8d76637a49a7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -415,6 +415,31 @@ xfs_dinode_verify_fork(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_forkoff(
+	struct xfs_dinode	*dip,
+	struct xfs_mount	*mp)
+{
+	if (dip->di_forkoff == 0)
+		return NULL;
+
+	switch (dip->di_format)  {
+	case XFS_DINODE_FMT_DEV:
+		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
+	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
+	case XFS_DINODE_FMT_BTREE:
+		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+			return __this_address;
+		break;
+	default:
+		return __this_address;
+	}
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -470,6 +498,11 @@ xfs_dinode_verify(
 	if (mode && (flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
 		return __this_address;
 
+	/* check for illegal values of di_forkoff */
+	fa = xfs_dinode_verify_forkoff(dip, mp);
+	if (fa)
+		return fa;
+
 	/* Do we have appropriate data fork formats for the mode? */
 	switch (mode & S_IFMT) {
 	case S_IFIFO:
