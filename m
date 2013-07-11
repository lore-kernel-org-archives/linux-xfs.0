Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E55627F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC6D18F8035
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EZJ5r8wdb9fzFV2H for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:13 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcDUZ022832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:13 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 01/10 v2] xfstests: Run all tests when nothing is specified
Date: Thu, 11 Jul 2013 12:37:56 +0200
Message-Id: <1373539085-8577-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com

Currently when no tests or test groups is specified xfstests will
silently test nothing. Interestingly enough when test groups to exclude
is specified the rest of the tests will be run.

This commit changes that to run all possible tests (for a given file
system) when no specific tests has been specified. This matches the old
xfstests behaviour.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check | 6 +++---
 group | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)
 delete mode 100644 group

diff --git a/check b/check
index ff8fbcf..71b179b 100755
--- a/check
+++ b/check
@@ -115,7 +115,7 @@ get_all_tests()
 	for d in $SRC_GROUPS $FSTYP; do
 		ls $SRC_DIR/$d/* | \
 			grep -v "\..*" | \
-			grep -v group >> $tmp.list 2>/dev/null
+			grep -v "group\|Makefile" >> $tmp.list 2>/dev/null
 	done
 }
 
@@ -263,8 +263,8 @@ elif $have_test_arg; then
 	# had test numbers, but none in group file ... do nothing
 	touch $tmp.list
 else
-	# no test numbers, do everything from group file
-	sed -n -e '/^[0-9][0-9][0-9]*/s/[ 	].*//p' <group >$tmp.list
+	# no test numbers, do everything
+	get_all_tests
 fi
 
 # sort the list of tests into numeric order
diff --git a/group b/group
deleted file mode 100644
index 4e01f0c..0000000
--- a/group
+++ /dev/null
@@ -1,5 +0,0 @@
-# QA groups control file
-# Defines test groups and nominal group owners
-# - do not start group names with a digit
-# - comment line before each group is "new" description
-#
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
