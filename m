Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43656 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbeIMHCv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Sep 2018 03:02:51 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CCE4E33C2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 20:55:08 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <bf6e7f18-25fa-2b41-9532-78bffe33a241@sandeen.net>
Date: Wed, 12 Sep 2018 20:55:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The commit:

 db1327b1 xfs: report shared extent mappings to userspace correctly

disabled FIBMAP on reflinked files, with this very clear rationale
regarding swapfiles:

"Have xfs_vm_bmap return zero for reflinked files because the
bmap-based swap code requires static block mappings, which is
incompatible with copy on write."

However, this broke the FIBMAP interface for existing userspace
apps, including bootloaders.  The net effect of this is systems
that won't boot, because various and sundry utilities which prepare
files in /boot actually do use reflink and FICLONE.  reflink is an
RO-compat feature, and bootloaders simply want to read these blocks.

The swapfile concern can be addressed directly by rejecting reflinked
files in xfs_iomap_swapfile activate.  Once this is done, we can
continue to allow FIBMAP queries on reflinked files.

FIBMAP is a horrible interface, yes. It is no more horrible for
reflinked files than for non-reflinked files.  Other objections cite
inability to control what userspace may do with the mapping; this
is true of every mapping interface today, FIEMAP and GETBMAP
included.  There is no valid excuse to randomly and undetectably
fail FIBMAP requests on reflinked inodes.

The user asked for a mapping in one of several ways available to them.
We should give them the answer as we have done until now.

As an example of how capricious and random this can be:

# filefrag -Be file
Filesystem type is: 58465342
File size of file is 4 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:     845909..    845909:      1:             merged,eof
file: 1 extent found

# cp --reflink file reflink

# rm -f reflink

# filefrag -Be file
Filesystem type is: 58465342
File size of file is 4 (1 block of 4096 bytes)
file: 0 extents found

# filefrag -e file
Filesystem type is: 58465342
File size of file is 4 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:     845909..    845909:      1:             last,eof
file: 1 extent found

# xfs_bmap -v file
file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          6767272..6767279  1 (214184..214191)     8 000000

A file with NO shared extents, easily mappable via other methods, fails
undetectably with FIBMAP.  This is unnecessary and actively harmful.

Don't break userspace.

"We know that people use old binaries for years and years, and that
making a new release doesn't mean that you can just throw that out.
You can trust us."

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Yes, I'm resending this.  I've made my arguments above, and I'm not
going to re-argue unless some new concern or question comes up.  Maintainers
can ake it or leave it, but I feel very strongly that the decision to break
FIBMAP on these files was random, actively harmful, and completely unnecessary.

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8eb3ba3d4d00..b75a7f37bdd9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1382,15 +1382,10 @@ xfs_vm_bmap(
 	trace_xfs_vm_bmap(ip);
 
 	/*
-	 * The swap code (ab-)uses ->bmap to get a block mapping and then
-	 * bypasses the file system for actual I/O.  We really can't allow
-	 * that on reflinks inodes, so we have to skip out here.  And yes,
-	 * 0 is the magic code for a bmap error.
-	 *
 	 * Since we don't pass back blockdev info, we can't return bmap
-	 * information for rt files either.
+	 * information for rt files.
 	 */
-	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip))
 		return 0;
 	return iomap_bmap(mapping, block, &xfs_iomap_ops);
 }
@@ -1477,7 +1472,13 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_find_bdev_for_inode(file_inode(swap_file));
+	struct inode			*inode = file_inode(swap_file);
+
+	/* Cannot allow swap to write directly to reflinked files/blocks */
+	if (xfs_is_reflink_inode(XFS_I(inode)))
+		return -EOPNOTSUPP;
+
+	sis->bdev = xfs_find_bdev_for_inode(inode);
 	return iomap_swapfile_activate(sis, swap_file, span, &xfs_iomap_ops);
 }
 
