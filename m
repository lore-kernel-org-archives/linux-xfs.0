Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35605 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968294AbdD0I71 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:59:27 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/5] VFS API for getting filesystem's UUID
Date: Thu, 27 Apr 2017 11:59:29 +0300
Message-Id: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

As you observed, the sb->s_uuid field is not always filled by filesystems.

Consumers, like overlayfs, that wish to use this field can check if is
zeroed out as an indication for valid value.

Christoph suggested to make the test more explicit and require the
filesystems that fill the s_uuid field to set a super block flag.

Do you agree with the proposed API?

The first patch in the series defines the flag.
If you push this patch through your tree to Al or Linus, then filesystem
maintainers could later pick the individual patches to their trees.

The xfs patch is based on a patch I already sent to Darrick for filling
out the s_uuid field.

Thanks,
Amir.

Amir Goldstein (5):
  vfs: define a flag to indicate sb->s_uuid is available
  ext4: set the super block SB_I_HAVE_UUID flag
  f2fs: set the super block SB_I_HAVE_UUID flag
  ocfs2: set the super block SB_I_HAVE_UUID flag
  xfs: set the super block SB_I_HAVE_UUID flag

 fs/ext4/super.c    | 1 +
 fs/f2fs/super.c    | 1 +
 fs/ocfs2/super.c   | 1 +
 fs/xfs/xfs_mount.c | 1 +
 include/linux/fs.h | 3 +++
 5 files changed, 7 insertions(+)

-- 
2.7.4

