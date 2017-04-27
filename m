Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36745 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968301AbdD0I7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:32 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/5] f2fs: set the super block SB_I_HAVE_UUID flag
Date: Thu, 27 Apr 2017 11:59:32 +0300
Message-Id: <1493283574-1497-4-git-send-email-amir73il@gmail.com>
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
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 96fe8ed..9dca352 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1911,6 +1911,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);
 	memcpy(sb->s_uuid, raw_super->uuid, sizeof(raw_super->uuid));
+	sb->s_iflags |= SB_I_HAVE_UUID;
 
 	/* init f2fs-specific super block info */
 	sbi->valid_super_block = valid_super_block;
-- 
2.7.4

