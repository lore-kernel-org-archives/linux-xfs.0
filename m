Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2333B6CC;
	Wed, 30 Sep 2026 08:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758014; cv=none; b=eBoIqa4T69o8UlRRMZWRJmJqcWnn55kr0KmvTsD9zcNrvOHj30/mIHHZLZzUFpOYb5VzsDjvyTNbstPKri7j/vWAtLquhcr/r3gstynDtcvSf7x37rYPGVjOz3PfpI7pZ96Y78VFEhq2haH3U/oKb6p6gu5SNIMF7d1ceOuAiuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758014; c=relaxed/simple;
	bh=/nExjtFOB1NJy6jRDr8sZrjF6CsiYeOHyUbVkiivmeA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NnOhQRyXgmFytqSTb2YNcyw9H0HB7tsUlpBL51ZNwJOBQN1zt0wodTqrM6T7nFc92UJjHGjz3HqZ+hHCnWZdm7sf7kjhbjZxl6IoxtI4d4g/D9pCs1eolAzPbIgjT8bh4dWD/VJ0+hecS+c91MwAAuIe7fqqf775XmoWlmnViRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WfXQ7Ix3; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WfXQ7Ix3"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bVhdAoM2COTEkAP0RD5u/K6CVzP2pUfmVGht00hp+hs=;
	b=WfXQ7Ix3NN9xeyiFf49tVq6I/4Kaodtsfq1E9mnVEOG4HhRsDFP9dZddpOVlg6OFagJME68xJ
	92nAHDZkx1tFnxJXQ8ufJNyf9ipWQZ3MIwaf3arOIVExFGSj73PcY2PU0IYoEFz6C8lx47eVXTY
	a8sLduIXp9ZBqIHlimxsdaU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hvpHs3HcWzmVCD;
	Wed, 30 Sep 2026 16:34:33 +0800 (CST)
Received: from kwepemf100015.china.huawei.com (unknown [7.202.181.14])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F74C4048B;
	Wed, 30 Sep 2026 16:46:42 +0800 (CST)
Received: from dggphicprd10024.huawei.com (10.243.6.112) by
 kwepemf100015.china.huawei.com (7.202.181.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 30 Sep 2026 16:46:41 +0800
From: Abbott Liu <liuwenliang@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<pliard@google.com>, <akpm@linux-foundation.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<phillip@squashfs.org.uk>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>,
	<liuwenliang@huawei.com>
CC: <yangzhuohao1@huawei.com>, <douzhaolei@huawei.com>,
	<wangbing6@huawei.com>, <nixiaoming@huawei.com>, <liaohua4@huawei.com>,
	<chenjie6@huawei.com>, <chengzhihao1@huawei.com>, <heyuqiang1@huawei.com>
Subject: [PATCH] initrd: flush deferred fput() before mounting root
Date: Wed, 30 Sep 2026 16:46:32 +0800
Message-ID: <20260930084632.2965573-1-liuwenliang@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100015.china.huawei.com (7.202.181.14)

Booting an old-style initrd, i.e. a bare filesystem image rather than a
cpio archive, with "root=/dev/ram rootfstype=squashfs" can fail to
mount the root filesystem and panic:

    RAMDISK: squashfs filesystem found at block 0
    RAMDISK: Loading 68449KiB [1 disk] into ram disk... done.
    No filesystem could mount root, tried:
     squashfs
    Kernel panic - not syncing: VFS: Unable to mount root fs on
    "/dev/ram" or unknown-block(1,0)

The panic requires three conditions to hold simultaneously:

 1. The initrd is a filesystem image, so initrd_load() copies it into
    /dev/ram with rd_load_image() instead of unpacking a cpio archive
    into rootfs.
 2. The root filesystem is mounted from that ramdisk and reads it with
    bios that bypass the block device page cache. Squashfs has done so
    for every read since commit 93e72b3c612a ("squashfs: migrate from
    ll_rw_block usage to BIO").
 3. The ramdisk's block size equals squashfs's device block size:
    inode->i_blkbits == blksize_bits(SQUASHFS_DEVBLK_SIZE).  The first
    open of /dev/ram computes i_blkbits in set_init_blocksize() from
    the queue's logical block size (512 for brd) and the ramdisk size,
    capped at 12 (blksize_bits(PAGE_SIZE)).  When the ramdisk size is
    aligned to PAGE_SIZE, inode->i_blkbits = blksize_bits(PAGE_SIZE).
    The ramdisk size comes from CONFIG_BLK_DEV_RAM_SIZE at build time
    and can be overridden on the kernel command line with ramdisk_size=
    (or the rd_size module parameter when brd is built as a module);
    all sizes are in kibibytes.

When the conditions hold, the boot races as follows:

 1. rd_load_image() opens /dev/ram for buffered writing; the first open
    fixes i_blkbits as described above.
 2. Its copy loop writes the image with kernel_write(), which leaves
    all of the data dirty in the block device page cache.  Nothing has
    reached the ramdisk's backing store yet.
 3. rd_load_image() then drops the ramdisk file with fput() and no
    explicit sync.  The final __fput() - and with it blkdev_put() ->
    blkdev_flush_mapping() -> sync_blockdev(), the writeback that would
    push the dirty pages into the ramdisk - is asynchronous.  While
    init was a kernel thread, __fput() ran as delayed fput work at
    least a jiffy later; since commit 343f4c49f243 ("kthread: Don't
    allocate kthread_struct for init and umh") init is a user mode
    task, so __fput() is deferred via task_work and only runs once init
    returns to user space, i.e. after mount_root().
 4. prepare_namespace() calls mount_root() right after initrd_load().
    squashfs_fill_super() starts with
    sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE), which ultimately calls
    set_blocksize().  That function reconfigures the device only when
    the requested block size differs from the device's current block
    size, and it calls sync_blockdev() and kill_bdev() first - a page
    cache geometry change that incidentally flushes the dirty pages.
    With both block sizes equal, this incidental rescue is skipped, and
    the mount path contains no other writeback point.
 5. squashfs reads the superblock via squashfs_bio_read(), which builds
    BIOs on its own pages and submits them with submit_bio_wait() -
    raw I/O that bypasses the block device page cache completely.  brd
    has no backing page for that range yet and zero-fills the result,
    so the "hsqs" magic check fails and the mount returns -EINVAL.
 6. mount_root_generic() calls init_flush_fput() only after the failed
    mount.  Since rootfstype= names a single filesystem type and the
    root device is read-only by default, no candidate is left to retry
    with.  It panics.

The failure is intermittent because most geometries get the incidental
sync from step 4: the race only surfaces when both block sizes match.
Such a geometry arises when CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y.  The
ramdisk size is normally aligned to PAGE_SIZE, so on the first open of
/dev/ram the ramdisk block size equals PAGE_SIZE (4K on typical
systems).  Without CONFIG_SQUASHFS_4K_DEVBLK_SIZE, SQUASHFS_DEVBLK_SIZE
is 1K and differs from the ramdisk block size, so set_blocksize()
calls sync_blockdev() and kill_bdev() and flushes the dirty pages.
With CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y, SQUASHFS_DEVBLK_SIZE is 4K and
matches the ramdisk block size, the flush in set_blocksize() is
skipped, and the mount panics.

Several ways to close this window were considered.

Fixing the reader, e.g. by syncing in squashfs_fill_super(), addresses
the wrong end of the race.  Reading a block device with bios that
bypass the page cache is not a squashfs peculiarity: of the 28
block-backed filesystems in the tree, 26 do it in at least one read
stage.  squashfs, xfs, gfs2, zonefs, hfsplus and ntfs read their
superblock with raw bios; btrfs, f2fs and jfs read their metadata that
way; and the file data of ext4 and 20 more filesystems is read through
mpage, iomap or block_read_full_folio into the file's own address
space instead of the block device cache.  Only romfs and cramfs
consult bd_mapping at every stage.  A squashfs-only fix would leave
the same race in place everywhere else, where it usually does not even
fail loudly - the mount succeeds and file data silently reads back as
zeros - and repeating a sync in every filesystem would scatter the
same barrier across the tree.

That leaves the producer, rd_load_image(), with two candidates:

 1. Call vfs_fsync(out_file, 0) once the copy loop is done.  This
    pushes the ramdisk's dirty pages into the backing store and waits
    for them, costs a single batched writeback, and returns an error
    that can be checked.

 2. Keep fput(out_file) and follow it with init_flush_fput(), which
    drains both deferral mechanisms - the delayed fput work and the
    task_work - so the final __fput() and its
    blkdev_put() -> blkdev_flush_mapping() -> sync_blockdev() run to
    completion before rd_load_image() returns.  The ramdisk then
    reaches the mount closed, synced and with its page cache dropped,
    i.e. in the state it would have in without the deferral.

Both options complete the writeback before the mount and either one
fixes the race.  Take the second one, which matches the established
use of the helper in the boot path: mount_root_generic() already
calls init_flush_fput() before retrying the mount with another
filesystem type, and flush_delayed_fput() documents the boot as its
only user.  Draining the deferred closes here is also well contained,
as at this point in the boot they all belong to files the boot itself
created: the ramdisk file just written, the /initrd.image it was
copied from, and the files unpacked into rootfs.

Flush the deferred __fput() right after dropping the last reference to
the ramdisk file, so the writeback completes before mount_root() runs.

Verified on arm64 QEMU with an openEuler Embedded rootfs image packed
as squashfs: the boot panics as shown above without the fix and boots
to userspace with it.

Fixes: 93e72b3c612a ("squashfs: migrate from ll_rw_block usage to BIO")
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
---
 init/do_mounts_rd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 48bfab2fc62f..24e57f30e167 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -258,6 +258,17 @@ int __init rd_load_image(void)
 	fput(in_file);
 noclose_input:
 	fput(out_file);
+	/*
+	 * The image data is still dirty in the ramdisk's block device page
+	 * cache and only reaches the ramdisk once the final __fput() of
+	 * out_file runs blkdev_put() -> blkdev_flush_mapping() ->
+	 * sync_blockdev().  That __fput() is deferred (delayed fput work,
+	 * or task_work that runs when init returns to user mode), while
+	 * mount_root() runs right after this and may read the ramdisk with
+	 * bios bypassing the page cache (e.g. squashfs).  Flush it now so
+	 * the ramdisk is up to date before it gets mounted.
+	 */
+	init_flush_fput();
 out:
 	kfree(buf);
 	init_unlink("/dev/ram");
-- 
2.43.0

