Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36756 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030941AbdD0I7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:39 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/5] ocfs2: set the super block SB_I_HAVE_UUID flag
Date: Thu, 27 Apr 2017 11:59:33 +0300
Message-Id: <1493283574-1497-5-git-send-email-amir73il@gmail.com>
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
 fs/ocfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ca1646f..9c5e701 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2064,6 +2064,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
 	memcpy(sb->s_uuid, di->id2.i_super.s_uuid,
 	       sizeof(di->id2.i_super.s_uuid));
+	sb->s_iflags |= SB_I_HAVE_UUID;
 
 	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
 
-- 
2.7.4

