Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfCTAor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:44:47 -0400
Subject: [PATCH 01/12] check: improve test list randomization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:44:42 -0700
Message-ID: <155304268284.31707.10338119992472996728.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

awk doesn't have a particularly good random number generator -- it seeds
from the Unix epoch time in seconds, which means that the run order
across a bunch of VMs started at exactly the same time are unsettlingly
predictable.  Therefore, at least try to seed it with bash's $RANDOM,
which is slightly less predictable.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check         |   12 ++++++------
 randomize.awk |   12 ++++++++----
 2 files changed, 14 insertions(+), 10 deletions(-)


diff --git a/check b/check
index 20e95302..ecd1d39a 100755
--- a/check
+++ b/check
@@ -242,13 +242,13 @@ _prepare_test_list()
 	done
 
 	# sort the list of tests into numeric order
-	list=`sort -n $tmp.list | uniq`
-	rm -f $tmp.list
-
-	if $randomize
-	then
-		list=`echo $list | awk -f randomize.awk`
+	if $randomize; then
+		sorter="awk -v seed=$RANDOM -f randomize.awk"
+	else
+		sorter="cat"
 	fi
+	list=`sort -n $tmp.list | uniq | $sorter`
+	rm -f $tmp.list
 }
 
 # Process command arguments first.
diff --git a/randomize.awk b/randomize.awk
index 0a8ad71a..d979fb03 100644
--- a/randomize.awk
+++ b/randomize.awk
@@ -15,10 +15,14 @@ function randomize(array, N) {
 return
 }
 
+BEGIN {
+	srand(seed)
+}
 {
-    srand()
-    for (i = 0; i < NF; i++ ) array[i] = $(i+1)
-    randomize(array, NF)
-    for (i = 0; i < NF; i++) printf("%s ", array[i])
+	array[NR - 1] = $0
+}
+END {
+    randomize(array, NR)
+    for (i = 0; i < NR; i++) printf("%s ", array[i])
 }
 
