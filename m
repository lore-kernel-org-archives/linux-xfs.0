Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbeIKDUg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Sep 2018 23:20:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E30AF86641
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 22:24:24 +0000 (UTC)
Subject: [PATCH 2/2 V2] xfs: verify size-vs-format for symlinks & dirs
References: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d2648726-e4f9-a5a7-c9b1-560ad03d3e67@redhat.com>
Date: Mon, 10 Sep 2018 17:24:17 -0500
MIME-Version: 1.0
In-Reply-To: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Today, xfs_ifork_verify_data() will simply skip verification if the inode
claims to be in non-local format.  However, nothing catches the case where
the size for the format is too small to be non-local.  xfs_repair tests
for this mismatch in process_check_inode_sizes(), so do the same in this
verifier.

Reported-by: Xu, Wen <wen.xu@gatech.edu>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200925
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: restructure code & tests per Dave's suggestion on the V1 patch.

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 183ec0cb8921..d6a137f5e207 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -732,12 +732,32 @@ xfs_ifork_verify_data(
 	struct xfs_inode	*ip,
 	struct xfs_ifork_ops	*ops)
 {
-	/* Non-local data fork, we're done. */
-	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+	struct xfs_mount	*mp = ip->i_mount;
+	int			mode = VFS_I(ip)->i_mode;
+
+	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
+		/*
+		 * types that can be in local form need size checks
+		 * to ensure they have the right amount of data in
+		 * them to be in non-local form
+		 */
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
+				return __this_address;
+			break;
+		case S_IFLNK:
+			if (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))
+				return __this_address;
+			break;
+		default:
+			break;
+		}
 		return NULL;
+	}
 
 	/* Check the inline data fork if there is one. */
-	switch (VFS_I(ip)->i_mode & S_IFMT) {
+	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		return ops->verify_dir(ip);
 	case S_IFLNK:
