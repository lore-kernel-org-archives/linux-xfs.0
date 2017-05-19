Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28747 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754048AbdESAUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 20:20:36 -0400
Date: Thu, 18 May 2017 17:20:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170519002032.GA21202@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Apparently, there users out there with a single gigantic journalled
rootfs and some gnarly system software.  If the user reboots into
"offline system update" mode to install a kernel update, the system
control software has no provision to kick the cute splash screen off its
writable file descriptor down in /var/log somewhere before unmounting,
remount-ro'ing, and thus reboots the system... with a live rw rootfs!

Since the journal may not have been checkpointed immediately prior to
the reboot, a subsequent invocation of the hapless user's grubby
bootloader sees obsolete metadata because the newest data is safely in
the log, but the log needs to be replayed.  Weirdly, the bootloader is
fine with reading files off a dirty filesystem (though really, can you
imagine log replay in x86 real mode?) but still tries to read files and
the boot fails until someone intervenes to replay the journal.

Therefore, add a reboot hook to freeze all filesystems (which in general
will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
This is an unfortunate and insufficient workaround for multiple layers
of inadequate external software, but at least it will reduce boot time
surprises for the "OS updater failed to disengage the filesystem before
rebooting" case.

Seeing as the world has been drifting towards grubbiness (except for
those booting straight off a flabby unjournalled fs via firmware), this
seems like the least crappy solution to this problem.  Yes, you're still
screwed in grub if the system crashes. :)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/super.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index adb0c0d..4a9deaa 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -34,6 +34,7 @@
 #include <linux/fsnotify.h>
 #include <linux/lockdep.h>
 #include <linux/user_namespace.h>
+#include <linux/reboot.h>
 #include "internal.h"
 
 
@@ -1529,3 +1530,32 @@ int thaw_super(struct super_block *sb)
 	return 0;
 }
 EXPORT_SYMBOL(thaw_super);
+
+static void fsreboot_freeze_sb(struct super_block *sb, void *priv)
+{
+	int error;
+
+	up_read(&sb->s_umount);
+	error = freeze_super(sb);
+	down_read(&sb->s_umount);
+	if (error && error != -EBUSY)
+		printk(KERN_NOTICE "%s (%s): Unable to freeze, error=%d",
+			sb->s_type->name, sb->s_id, error);
+}
+
+static int fsreboot_freeze(struct notifier_block *nb, ulong event, void *buf)
+{
+	iterate_supers(fsreboot_freeze_sb, NULL);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block fsreboot_notifier = {
+	.notifier_call = fsreboot_freeze,
+	.priority = INT_MAX,
+};
+
+static int __init fsreboot_init(void)
+{
+	return register_reboot_notifier(&fsreboot_notifier);
+}
+__initcall(fsreboot_init);
