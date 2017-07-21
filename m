Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36339 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdGUEkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:16 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 08/15] tests: remove generic/099
Date: Thu, 20 Jul 2017 21:38:46 -0700
Message-Id: <20170721043853.364-9-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

This IRIX-specific ACL test was nearly identical to shared/051, which
has been better maintained and will be made a generic test in the next
commit.  Therefore, remove the existing generic/099.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/attr           |  12 --
 tests/generic/099     | 331 --------------------------------------------------
 tests/generic/099.out | 215 --------------------------------
 tests/generic/group   |   1 -
 4 files changed, 559 deletions(-)
 delete mode 100755 tests/generic/099
 delete mode 100644 tests/generic/099.out

diff --git a/common/attr b/common/attr
index c840ce42..fae367f0 100644
--- a/common/attr
+++ b/common/attr
@@ -117,18 +117,6 @@ _acl_ls()
     _ls_l -n $* | awk '{ print $1, $3, $4, $NF }' | _acl_filter_id
 } 
 
-#
-_acl_list()
-{
-    _file1=$1
-
-    if [ $HOSTOS = "IRIX" ]; then
-	ls -dD $_file1 | _acl_filter_id
-    else 
-        chacl -l $_file1 | _acl_filter_id
-    fi
-}
-
 # create an ACL with n ACEs in it
 #
 _create_n_aces()
diff --git a/tests/generic/099 b/tests/generic/099
deleted file mode 100755
index 4af588c8..00000000
diff --git a/tests/generic/099.out b/tests/generic/099.out
deleted file mode 100644
index 3f4f663f..00000000
diff --git a/tests/generic/group b/tests/generic/group
index 20c278cc..93a7378b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -101,7 +101,6 @@
 096 auto prealloc quick zero
 097 attr auto quick
 098 auto quick metadata
-099 udf auto
 100 udf auto
 101 auto quick metadata
 102 auto rw
-- 
2.13.3

