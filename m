Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51454 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753397AbdERBcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2017 21:32:46 -0400
Date: Wed, 17 May 2017 18:32:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170518013242.GW4519@birch.djwong.org>
References: <20170518012618.GT4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518012618.GT4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

Apparently there are certain system software configurations that do odd
things like update the kernel and reboot without umounting the /boot fs
or remounting it readonly, either of which would push all the AIL items
out to disk.  As a result, a subsequent invocation of something like
grub (which has a frightening willingness to read a fs with a dirty log)
can read stale disk contents and/or miss files the metadata for which
have been written to the log but not checkpointed into the filesystem.

Granted, most of the time /boot is a separate partition and
systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
This "fix" is only needed for people who have one giant filesystem.

Therefore, add a reboot hook to freeze the rw filesystems (which
checkpoints the log) just prior to reboot.  This is an unfortunate and
insufficient workaround for multiple layers of inadequate external
software, but at least it will reduce boot time surprises for the "OS
updater failed to disengage the filesystem before rebooting" case.

Seeing as grub is unlikely ever to learn to replay the XFS log (and we
probably don't want it doing that), *LILO has been discontinued for at
least 18 months, and we're not quite to the point of putting kernel
files directly on the EFI System Partition, this seems like the least
crappy solution to this problem.

Yes, you're still screwed in grub if the system crashes. :)  I don't
anticipate this patch will make it upstream, but the idea could get at
least a single hearing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575..415b1e8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,6 +61,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/reboot.h>
 
 static const struct super_operations xfs_super_operations;
 struct bio_set *xfs_ioend_bioset;
@@ -1982,6 +1983,38 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
+STATIC void
+xfs_reboot_fs(
+	struct super_block	*sb,
+	void			*priv)
+{
+	int			error;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+	xfs_info(XFS_M(sb), "Freezing prior to reboot.");
+	up_read(&sb->s_umount);
+	error = freeze_super(sb);
+	down_read(&sb->s_umount);
+	if (error && error != -EBUSY)
+		xfs_info(XFS_M(sb), "Unable to freeze, error=%d", error);
+}
+
+STATIC int
+xfs_reboot(
+	struct notifier_block	*nb,
+	ulong			event,
+	void			*buf)
+{
+	iterate_supers_type(&xfs_fs_type, xfs_reboot_fs, NULL);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xfs_reboot_notifier = {
+	.notifier_call = xfs_reboot,
+	.priority = INT_MAX,
+};
+
 STATIC int __init
 init_xfs_fs(void)
 {
@@ -2056,8 +2089,14 @@ init_xfs_fs(void)
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_qm_exit;
+
+	error = register_reboot_notifier(&xfs_reboot_notifier);
+	if (error)
+		goto out_register_fs;
 	return 0;
 
+ out_register_fs:
+	unregister_filesystem(&xfs_fs_type);
  out_qm_exit:
 	xfs_qm_exit();
  out_remove_dbg_kobj:
@@ -2089,6 +2128,7 @@ init_xfs_fs(void)
 STATIC void __exit
 exit_xfs_fs(void)
 {
+	unregister_reboot_notifier(&xfs_reboot_notifier);
 	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
 #ifdef DEBUG
