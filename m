Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37235 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdGUEkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:18 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 09/15] tests: make shared/051 a generic test
Date: Thu, 20 Jul 2017 21:38:47 -0700
Message-Id: <20170721043853.364-10-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

The ACL test shared/051 was very similar to generic/099 which was not
being run and was just removed; most likely the script was copy+pasted
at some point.  Since shared/051 has been getting maintained+run and is
not really XFS and UDF-specific, move it to generic, reusing the old
number of 099.  One change was required for it to work on other
filesystems: the output of 'find' must be sorted.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/{shared/051 => generic/099}         |  8 ++++----
 tests/{shared/051.out => generic/099.out} | 18 +++++++++---------
 tests/generic/group                       |  1 +
 tests/shared/group                        |  1 -
 4 files changed, 14 insertions(+), 14 deletions(-)
 rename tests/{shared/051 => generic/099} (98%)
 rename tests/{shared/051.out => generic/099.out} (99%)

diff --git a/tests/shared/051 b/tests/generic/099
similarity index 98%
rename from tests/shared/051
rename to tests/generic/099
index 298838e7..f65c53f1 100755
--- a/tests/shared/051
+++ b/tests/generic/099
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. 051
+# FS QA Test No. 099
 #
 # Test out ACLs.
 #
@@ -67,7 +67,7 @@ _cleanup()
 #
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os Linux
 _require_test
 _require_runas
@@ -292,10 +292,10 @@ popd >/dev/null
 chown -R 12345.54321 root
 echo "Change #1..."
 _runas -u 12345 -g 54321 -- chacl -r u::rwx,g::-w-,o::--x root
-find root -print | xargs chacl -l
+find root -print | sort | xargs chacl -l
 echo "Change #2..."
 _runas -u 12345 -g 54321 -- chacl -r u::---,g::---,o::--- root
-find root -print | xargs chacl -l
+find root -print | sort | xargs chacl -l
 
 #-------------------------------------------------------
 
diff --git a/tests/shared/051.out b/tests/generic/099.out
similarity index 99%
rename from tests/shared/051.out
rename to tests/generic/099.out
index 2b5220f7..94172420 100644
--- a/tests/shared/051.out
+++ b/tests/generic/099.out
@@ -1,4 +1,4 @@
-QA output created by 051
+QA output created by 099
 
 === Test minimal ACE ===
 Setup file
@@ -111,6 +111,8 @@ acldir/file2 [u::r--,g::r--,o::---]
 Change #1...
 root [u::rwx,g::-w-,o::--x]
 root/a [u::rwx,g::-w-,o::--x]
+root/a/0 [u::rwx,g::-w-,o::--x]
+root/a/0/mumble [u::rwx,g::-w-,o::--x]
 root/a/1 [u::rwx,g::-w-,o::--x]
 root/a/1/mumble [u::rwx,g::-w-,o::--x]
 root/a/2 [u::rwx,g::-w-,o::--x]
@@ -129,9 +131,9 @@ root/a/8 [u::rwx,g::-w-,o::--x]
 root/a/8/mumble [u::rwx,g::-w-,o::--x]
 root/a/9 [u::rwx,g::-w-,o::--x]
 root/a/9/mumble [u::rwx,g::-w-,o::--x]
-root/a/0 [u::rwx,g::-w-,o::--x]
-root/a/0/mumble [u::rwx,g::-w-,o::--x]
 root/b [u::rwx,g::-w-,o::--x]
+root/b/c0 [u::rwx,g::-w-,o::--x]
+root/b/c0/0 [u::rwx,g::-w-,o::--x]
 root/b/c1 [u::rwx,g::-w-,o::--x]
 root/b/c1/1 [u::rwx,g::-w-,o::--x]
 root/b/c2 [u::rwx,g::-w-,o::--x]
@@ -150,11 +152,11 @@ root/b/c8 [u::rwx,g::-w-,o::--x]
 root/b/c8/8 [u::rwx,g::-w-,o::--x]
 root/b/c9 [u::rwx,g::-w-,o::--x]
 root/b/c9/9 [u::rwx,g::-w-,o::--x]
-root/b/c0 [u::rwx,g::-w-,o::--x]
-root/b/c0/0 [u::rwx,g::-w-,o::--x]
 Change #2...
 root [u::---,g::---,o::---]
 root/a [u::---,g::---,o::---]
+root/a/0 [u::---,g::---,o::---]
+root/a/0/mumble [u::---,g::---,o::---]
 root/a/1 [u::---,g::---,o::---]
 root/a/1/mumble [u::---,g::---,o::---]
 root/a/2 [u::---,g::---,o::---]
@@ -173,9 +175,9 @@ root/a/8 [u::---,g::---,o::---]
 root/a/8/mumble [u::---,g::---,o::---]
 root/a/9 [u::---,g::---,o::---]
 root/a/9/mumble [u::---,g::---,o::---]
-root/a/0 [u::---,g::---,o::---]
-root/a/0/mumble [u::---,g::---,o::---]
 root/b [u::---,g::---,o::---]
+root/b/c0 [u::---,g::---,o::---]
+root/b/c0/0 [u::---,g::---,o::---]
 root/b/c1 [u::---,g::---,o::---]
 root/b/c1/1 [u::---,g::---,o::---]
 root/b/c2 [u::---,g::---,o::---]
@@ -194,8 +196,6 @@ root/b/c8 [u::---,g::---,o::---]
 root/b/c8/8 [u::---,g::---,o::---]
 root/b/c9 [u::---,g::---,o::---]
 root/b/c9/9 [u::---,g::---,o::---]
-root/b/c0 [u::---,g::---,o::---]
-root/b/c0/0 [u::---,g::---,o::---]
 
 === Test out error messages for ACL text parsing  ===
 Note: Old interface gave more informative error msgs
diff --git a/tests/generic/group b/tests/generic/group
index 93a7378b..ee9a7539 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -101,6 +101,7 @@
 096 auto prealloc quick zero
 097 attr auto quick
 098 auto quick metadata
+099 acl auto quick
 100 udf auto
 101 auto quick metadata
 102 auto rw
diff --git a/tests/shared/group b/tests/shared/group
index fab93315..b3663a03 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -11,7 +11,6 @@
 006 auto enospc
 007 dangerous_fuzzers
 032 mkfs auto quick
-051 acl udf auto quick
 272 auto enospc rw
 289 auto quick
 298 auto trim
-- 
2.13.3

