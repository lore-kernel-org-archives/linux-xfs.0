Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35135 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937513AbdD0I7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:30 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/5] ext4: set the super block SB_I_HAVE_UUID flag
Date: Thu, 27 Apr 2017 11:59:31 +0300
Message-Id: <1493283574-1497-3-git-send-email-amir73il@gmail.com>
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
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2e03a0a..98e8fb0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3925,6 +3925,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
+	sb->s_iflags |= SB_I_HAVE_UUID;
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
-- 
2.7.4

