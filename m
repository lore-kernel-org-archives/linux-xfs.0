Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36723 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968297AbdD0I73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:29 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/5] vfs: define a flag to indicate sb->s_uuid is available
Date: Thu, 27 Apr 2017 11:59:30 +0300
Message-Id: <1493283574-1497-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Overlayfs would like to make use of underlying filesystem's
sb->s_uuid, but not all filesytems fill this field.

Define a flag to be set by filesystems that do fill the s_uuid
field, so let consumers like overlayfs know that the content
of this field is valid.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 80daadf..de913b4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1272,6 +1272,9 @@ struct mm_struct;
 /* sb->s_iflags to limit user namespace mounts */
 #define SB_I_USERNS_VISIBLE		0x00000010 /* fstype already mounted */
 
+/* sb->s_iflags for optional information available in super_block struct */
+#define SB_I_HAVE_UUID			0x00000100 /* s_uuid */
+
 /* Possible states of 'frozen' field */
 enum {
 	SB_UNFROZEN = 0,		/* FS is unfrozen */
-- 
2.7.4

