Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36530 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753792AbdD0H6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 03:58:22 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs: publish UUID in struct super_block
Date: Thu, 27 Apr 2017 10:58:31 +0300
Message-Id: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Unless mounted with nouuid, copy the uuid of the filesystem to
struct super block s_uuid field, as several other filesystems do.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 3 +++
 1 file changed, 3 insertions(+)

Darrick,

The VFS sb->s_uuid field is needed for a new overlay feature
'constant inode numbers' [1].

We store the filesystem uuid along with encoded file handles, so that
we can verify later that we are encoding file handles from the same
filesystem from which the handles were encoded.

At least the following filesystems set sb->s_uuid: ext4, f2fs, jfs, ocfs2.

Specifically, btrfs does not set sb->s_uuid, I think because it has many
uuid's per super_block struct.

I see no obvious reason for xfs not to set sb->s_uuid so here goes.

I made a choice not to set sb->s_uuid in case xfs was mounted with nouuid,
to maintain a self inflicted rule that sb->s_uuid is unique in a system
for an xfs super_block.  This is an arbitrary decision so others may not
agree with it.

My reasoning in the context of verifying file handles is this -
If a file handle was exported from one copy of an xfs filesystem, I rather
it was not decoded from another copy of the filesystem (i.e. LVM snapshot),
at least not while both copies are mounted on the same system.

I tested the patch is working correctly with and without nouuid with my
overlayfs constant inode tests. I do have xfstests that check overlay
constant inodes, but they are of little use to you without the overlayfs
patches.

Here is what it looks like when running constant inode verification test
for overlayfs above xfs mounted with nouuid:
~/unionmount-testsuite# ./run --ov=0 --samefs hard-link
...
XFS (vdf): Ending clean mount
overlayfs: lower fs needs to report s_uuid.
 ./run --link /mnt/a/foo100 /mnt/a/no_foo100
sh (2748): drop_caches: 3
overlayfs: lower fs needs to report s_uuid.
/mnt/a/no_foo100: inode number wrong (got 442, want 137)

The same test passes with overlayfs over ext4 and with overlay over xfs
mounted without nouuid (and with this patch applied naturally).

I'd appreciate if you could queue this simple patch for v4.12.

Thanks,
Amir.

[1] https://marc.info/?l=linux-unionfs&m=149324252301397&w=2

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 450bde6..29e45a0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -100,6 +100,9 @@ xfs_uuid_mount(
 	xfs_uuid_table[hole] = *uuid;
 	mutex_unlock(&xfs_uuid_table_mutex);
 
+	/* Publish UUID in struct super_block */
+	BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
+	memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
 	return 0;
 
  out_duplicate:
-- 
2.7.4

