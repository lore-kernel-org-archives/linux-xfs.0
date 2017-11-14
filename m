Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754114AbdKNKyw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 05:54:52 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/3] overlay/036: filter busy mount message
Date: Tue, 14 Nov 2017 18:54:00 +0800
Message-Id: <20171114105401.10542-3-eguan@redhat.com>
In-Reply-To: <20171114105401.10542-1-eguan@redhat.com>
References: <20171114105401.10542-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

util-linux v2.30 changed error message of a busy mount and caused
overlay/036 to fail. e.g.

 - mount: <device> is already mounted or <mountpoint> busy
 + mount: <mountpoint>: <device> already mounted or mount point busy.

Filter the mount output by a newly introduced _filter_busy_mount
into a unified format.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter         | 12 ++++++++++++
 tests/overlay/036     |  9 +++++++--
 tests/overlay/036.out |  4 ++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/common/filter b/common/filter
index d1bb94818e3d..b1cd558ab0e1 100644
--- a/common/filter
+++ b/common/filter
@@ -420,6 +420,18 @@ _filter_error_mount()
 	sed -e "s/mount:\(.*failed:\)/mount:/" | _filter_ending_dot
 }
 
+# Similar to _filter_error_mount, filter a busy mount output.
+# Turn both old (prior to util-linux v2.30) and new (v2.30 and later) format to
+# a simple one. e.g.
+# old: mount: <device> is already mounted or <mountpoint> busy
+# new: mount: <mountpoint>: <device> already mounted or mount point busy.
+# filtered: mount: <device> already mounted or mount point busy
+_filter_busy_mount()
+{
+	sed -e "s/.*: \([^ ]*\).* already mounted.*busy/mount: \1 already mounted or mount point busy/" | \
+		_filter_ending_dot
+}
+
 _filter_od()
 {
 	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
diff --git a/tests/overlay/036 b/tests/overlay/036
index 544d4e4eaa87..4c4b56ff9817 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -63,6 +63,11 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 
+filter_mount()
+{
+	_filter_scratch | _filter_busy_mount
+}
+
 # remove previous $seqres.full before test
 rm -f $seqres.full
 
@@ -103,12 +108,12 @@ _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
 # Try to mount another overlay with the same upperdir
 # with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
-		    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+		    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | filter_mount
 
 # Try to mount another overlay with the same workdir
 # with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
-		    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+		    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | filter_mount
 
 
 # success, all done
diff --git a/tests/overlay/036.out b/tests/overlay/036.out
index 51746114db1c..fbe224e1bac7 100644
--- a/tests/overlay/036.out
+++ b/tests/overlay/036.out
@@ -1,3 +1,3 @@
 QA output created by 036
-mount: overlay2 is already mounted or SCRATCH_MNT busy
-mount: overlay3 is already mounted or SCRATCH_MNT busy
+mount: overlay2 already mounted or mount point busy
+mount: overlay3 already mounted or mount point busy
-- 
2.13.6

