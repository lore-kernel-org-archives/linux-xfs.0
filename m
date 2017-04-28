Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35491 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423433AbdD1N7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 09:59:54 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] xfs: publish UUID in struct super_block
Date: Fri, 28 Apr 2017 17:00:01 +0300
Message-Id: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Copy the uuid of the filesystem to struct super_block s_uuid field,
as several other filesystems already do.  Copy regardless of the nouuid
mount option, because other filesystems also do not guaranty uniqueness
of the s_uuid field in super_block struct.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 4 ++++
 1 file changed, 4 insertions(+)

Darrick,

Per your request I moved the copy above nouuid check.

Cheers,
Amir.

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 450bde6..4c0d8d7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -73,6 +73,10 @@ xfs_uuid_mount(
 	uuid_t			*uuid = &mp->m_sb.sb_uuid;
 	int			hole, i;
 
+	/* Publish UUID in struct super_block */
+	BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
+	memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
+
 	if (mp->m_flags & XFS_MOUNT_NOUUID)
 		return 0;
 
-- 
2.7.4

