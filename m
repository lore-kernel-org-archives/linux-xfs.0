Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35655 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030923AbdD0I7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:35 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/5] xfs: set the super block SB_I_HAVE_UUID flag
Date: Thu, 27 Apr 2017 11:59:34 +0300
Message-Id: <1493283574-1497-6-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Let consumers (i.e. overlayfs) know that the content of the field
sb->s_uuid is valid.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29e45a0..bb1d325 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -103,6 +103,7 @@ xfs_uuid_mount(
 	/* Publish UUID in struct super_block */
 	BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
 	memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
+	mp->m_super->s_iflags |= SB_I_HAVE_UUID;
 	return 0;
 
  out_duplicate:
-- 
2.7.4

