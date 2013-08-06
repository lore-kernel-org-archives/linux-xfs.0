Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2F9B29DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 07:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDED8304039
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 05:57:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id GDasDiYgApNR8or7 for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 05:57:24 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D42DFA5359
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 14:57:23 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xftests: renumber existing btrfs tests to start with 1
Date: Tue,  6 Aug 2013 14:57:21 +0200
Message-Id: <1375793841-25114-1-git-send-email-dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: David Sterba <dsterba@suse.cz>

Current numbering is inheried from the single testsuite series. There
are only 6 btrfs-specific tests and it makes more sense to start adding
new ones at a more natural place than 300-something. There's no overlap
with the old and new numbers and I hope there' will be no confusion when
referencing them.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/btrfs/{254 => 001}         |  2 +-
 tests/btrfs/{254.out => 001.out} |  2 +-
 tests/btrfs/{264 => 002}         |  2 +-
 tests/btrfs/002.out              |  2 ++
 tests/btrfs/{265 => 003}         |  2 +-
 tests/btrfs/003.out              |  2 ++
 tests/btrfs/{276 => 004}         |  2 +-
 tests/btrfs/{276.out => 004.out} |  2 +-
 tests/btrfs/{284 => 005}         |  2 +-
 tests/btrfs/{284.out => 005.out} |  2 +-
 tests/btrfs/{307 => 006}         |  2 +-
 tests/btrfs/{307.out => 006.out} | 10 +++++-----
 tests/btrfs/264.out              |  2 --
 tests/btrfs/265.out              |  2 --
 tests/btrfs/group                | 12 ++++++------
 15 files changed, 24 insertions(+), 24 deletions(-)
 rename tests/btrfs/{254 => 001} (99%)
 rename tests/btrfs/{254.out => 001.out} (96%)
 rename tests/btrfs/{264 => 002} (99%)
 create mode 100644 tests/btrfs/002.out
 rename tests/btrfs/{265 => 003} (99%)
 create mode 100644 tests/btrfs/003.out
 rename tests/btrfs/{276 => 004} (99%)
 rename tests/btrfs/{276.out => 004.out} (57%)
 rename tests/btrfs/{284 => 005} (99%)
 rename tests/btrfs/{284.out => 005.out} (95%)
 rename tests/btrfs/{307 => 006} (99%)
 rename tests/btrfs/{307.out => 006.out} (88%)
 delete mode 100644 tests/btrfs/264.out
 delete mode 100644 tests/btrfs/265.out

diff --git a/tests/btrfs/254 b/tests/btrfs/001
similarity index 99%
rename from tests/btrfs/254
rename to tests/btrfs/001
index 7ce09e1..9aa2431 100755
--- a/tests/btrfs/254
+++ b/tests/btrfs/001
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. 254
+# FS QA Test No. btrfs/001
 #
 # Test btrfs's subvolume and snapshot support
 #
diff --git a/tests/btrfs/254.out b/tests/btrfs/001.out
similarity index 96%
rename from tests/btrfs/254.out
rename to tests/btrfs/001.out
index d4b5346..c782bde 100644
--- a/tests/btrfs/254.out
+++ b/tests/btrfs/001.out
@@ -1,4 +1,4 @@
-QA output created by 254
+QA output created by 001
 Creating file foo in root dir
 List root dir
 foo
diff --git a/tests/btrfs/264 b/tests/btrfs/002
similarity index 99%
rename from tests/btrfs/264
rename to tests/btrfs/002
index b08667a..03e9137 100755
--- a/tests/btrfs/264
+++ b/tests/btrfs/002
@@ -1,5 +1,5 @@
 #!/bin/bash
-# FS QA Test No. 264
+# FS QA Test No. btrfs/002
 #
 # Extented btrfs snapshot test cases
 #
diff --git a/tests/btrfs/002.out b/tests/btrfs/002.out
new file mode 100644
index 0000000..61705c7
--- /dev/null
+++ b/tests/btrfs/002.out
@@ -0,0 +1,2 @@
+QA output created by 002
+Silence is golden
diff --git a/tests/btrfs/265 b/tests/btrfs/003
similarity index 99%
rename from tests/btrfs/265
rename to tests/btrfs/003
index 79a9ddf..3790935 100755
--- a/tests/btrfs/265
+++ b/tests/btrfs/003
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. 265
+# FS QA Test No. btrfs/003
 #
 # btrfs vol tests
 #
diff --git a/tests/btrfs/003.out b/tests/btrfs/003.out
new file mode 100644
index 0000000..6895fc8
--- /dev/null
+++ b/tests/btrfs/003.out
@@ -0,0 +1,2 @@
+QA output created by 003
+Silence is golden
diff --git a/tests/btrfs/276 b/tests/btrfs/004
similarity index 99%
rename from tests/btrfs/276
rename to tests/btrfs/004
index 9d68b54..6e58b03 100755
--- a/tests/btrfs/276
+++ b/tests/btrfs/004
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FSQA Test No. 276
+# FSQA Test No. btrfs/004
 #
 # Run fsstress to create a reasonably strange file system, make a
 # snapshot and run more fsstress. Then select some files from that fs,
diff --git a/tests/btrfs/276.out b/tests/btrfs/004.out
similarity index 57%
rename from tests/btrfs/276.out
rename to tests/btrfs/004.out
index 5113164..643b934 100644
--- a/tests/btrfs/276.out
+++ b/tests/btrfs/004.out
@@ -1,3 +1,3 @@
-QA output created by 276
+QA output created by 004
 *** test backref walking
 *** done
diff --git a/tests/btrfs/284 b/tests/btrfs/005
similarity index 99%
rename from tests/btrfs/284
rename to tests/btrfs/005
index 67161a3..81badf6 100755
--- a/tests/btrfs/284
+++ b/tests/btrfs/005
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. 284
+# FS QA Test No. btrfs/005
 #
 # Btrfs Online defragmentation tests
 #
diff --git a/tests/btrfs/284.out b/tests/btrfs/005.out
similarity index 95%
rename from tests/btrfs/284.out
rename to tests/btrfs/005.out
index c942271..f0574d6 100644
--- a/tests/btrfs/284.out
+++ b/tests/btrfs/005.out
@@ -1,4 +1,4 @@
-QA output created by 284
+QA output created by 005
 defrag object | defragment range | defragment compress
 a single file | default | off
 a single file | default |  on
diff --git a/tests/btrfs/307 b/tests/btrfs/006
similarity index 99%
rename from tests/btrfs/307
rename to tests/btrfs/006
index 87314c6..9f7beff 100755
--- a/tests/btrfs/307
+++ b/tests/btrfs/006
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. 307
+# FS QA Test No. btrfs/006
 #
 # run basic btrfs information commands in various ways
 # sanity tests: filesystem show, label, sync, and device stats
diff --git a/tests/btrfs/307.out b/tests/btrfs/006.out
similarity index 88%
rename from tests/btrfs/307.out
rename to tests/btrfs/006.out
index ea9a621..ab33b7e 100644
--- a/tests/btrfs/307.out
+++ b/tests/btrfs/006.out
@@ -1,15 +1,15 @@
-== QA output created by 307
-== Set filesystem label to TestLabel.307
+== QA output created by 006
+== Set filesystem label to TestLabel.006
 == Get filesystem label
-TestLabel.307
+TestLabel.006
 == Mount.
 == Show filesystem by label
-Label: 'TestLabel.307'  uuid: <UUID>
+Label: 'TestLabel.006'  uuid: <UUID>
 	Total devices <EXACTNUM> FS bytes used <SIZE>
 	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
 == Show filesystem by UUID
-Label: 'TestLabel.307'  uuid: <EXACTUUID>
+Label: 'TestLabel.006'  uuid: <EXACTUUID>
 	Total devices <EXACTNUM> FS bytes used <SIZE>
 	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
diff --git a/tests/btrfs/264.out b/tests/btrfs/264.out
deleted file mode 100644
index eca790b..0000000
--- a/tests/btrfs/264.out
+++ /dev/null
@@ -1,2 +0,0 @@
-QA output created by 264
-Silence is golden
diff --git a/tests/btrfs/265.out b/tests/btrfs/265.out
deleted file mode 100644
index 9fa4eb0..0000000
--- a/tests/btrfs/265.out
+++ /dev/null
@@ -1,2 +0,0 @@
-QA output created by 265
-Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..6f9325e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -3,9 +3,9 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-254 auto quick
-264 auto
-265 auto
-276 auto rw metadata
-284 auto
-307 auto quick
+001 auto quick
+002 auto
+003 auto
+004 auto rw metadata
+005 auto
+006 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
