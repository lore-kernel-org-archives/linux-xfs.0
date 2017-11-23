Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbdKWLKz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 06:10:55 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3 2/3] overlay/036: filter busy mount message
Date: Thu, 23 Nov 2017 19:10:30 +0800
Message-Id: <20171123111031.6550-3-eguan@redhat.com>
In-Reply-To: <20171123111031.6550-1-eguan@redhat.com>
References: <20171123111031.6550-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org, amir73il@gmail.com, Eryu Guan <eguan@redhat.com>

util-linux v2.30 changed error message of a busy mount and caused
overlay/036 to fail. e.g.

 - mount: <device> is already mounted or <mountpoint> busy
 + mount: <mountpoint>: <device> already mounted or mount point busy.

Filter the mount output by a newly introduced _filter_busy_mount
into a unified format.

   mount: device already mounted or mount point busy

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v3:
- filter out $SCRATCH_DEV/MNT too and use a consistent output
- update regexp in sed as suggested by Amir

 common/filter         | 12 ++++++++++++
 tests/overlay/036     |  4 ++--
 tests/overlay/036.out |  4 ++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/common/filter b/common/filter
index 0d3875cc6cdc..a212c09aa138 100644
--- a/common/filter
+++ b/common/filter
@@ -423,6 +423,18 @@ _filter_error_mount()
 	sed -e "s/mount:\(.*failed:\)/mount:/" | _filter_ending_dot
 }
 
+# Similar to _filter_error_mount, filter a busy mount output.
+# Turn both old (prior to util-linux v2.30) and new (v2.30 and later) format to
+# a simple one. e.g.
+# old: mount: <device> is already mounted or <mountpoint> busy
+# new: mount: <mountpoint>: <device> already mounted or mount point busy.
+# filtered: mount: device already mounted or mount point busy
+_filter_busy_mount()
+{
+	sed -e "s/.*: .* already mounted or .* busy/mount: device already mounted or mount point busy/" | \
+		_filter_ending_dot
+}
+
 _filter_od()
 {
 	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
diff --git a/tests/overlay/036 b/tests/overlay/036
index 544d4e4eaa87..e0c13ae88c92 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -103,12 +103,12 @@ _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
 # Try to mount another overlay with the same upperdir
 # with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
-		    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+	    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
 # Try to mount another overlay with the same workdir
 # with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
-		    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+	    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
 
 # success, all done
diff --git a/tests/overlay/036.out b/tests/overlay/036.out
index 51746114db1c..0d266f1b216e 100644
--- a/tests/overlay/036.out
+++ b/tests/overlay/036.out
@@ -1,3 +1,3 @@
 QA output created by 036
-mount: overlay2 is already mounted or SCRATCH_MNT busy
-mount: overlay3 is already mounted or SCRATCH_MNT busy
+mount: device already mounted or mount point busy
+mount: device already mounted or mount point busy
-- 
2.14.3

