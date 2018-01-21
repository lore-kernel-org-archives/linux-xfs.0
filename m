Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbeAUHYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 21 Jan 2018 02:24:04 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 1/2] fstests: move expunge test into a helper
Date: Sat, 20 Jan 2018 23:24:00 -0800
Message-Id: <20180121072401.1047-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Move the expunge test into a helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 check | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/check b/check
index f8db3cd6dfab..0ba71d5d2005 100755
--- a/check
+++ b/check
@@ -485,6 +485,18 @@ _check_filesystems()
 	fi
 }
 
+_expunge_test()
+{
+	TEST_ID="$1"
+	if [ -s $tmp.xlist ]; then
+		if grep $TEST_ID $tmp.xlist > /dev/null 2>&1 ; then
+			echo "       [expunged]"
+			return 1
+		fi
+	fi
+	return 0
+}
+
 _prepare_test_list
 
 if $OPTIONS_HAVE_SECTIONS; then
@@ -672,11 +684,9 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		rm -f $seqres.out.bad
 
 		# check if we really should run it
-		if [ -s $tmp.xlist ]; then
-			if grep $seqnum $tmp.xlist > /dev/null 2>&1 ; then
-				echo "       [expunged]"
-				continue
-			fi
+		_expunge_test $seqnum
+		if [ $? -eq 1 ]; then
+			continue
 		fi
 
 		# slashes now in names, sed barfs on them so use grep
-- 
2.15.0

