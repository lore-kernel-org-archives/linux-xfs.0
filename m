Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39660 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdKPBWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:22:36 -0500
Subject: [PATCH 2/5] generic/45[34]: add emoji to the unusual fs naming test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:31 -0800
Message-ID: <151079535171.25590.681833633382669392.stgit@magnolia>
In-Reply-To: <151079533937.25590.1037061486182471724.stgit@magnolia>
References: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we have a test to make sure that we can use Unicode points in
filesystem names, enhance it to check emoji names too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/453 |    5 +++++
 tests/generic/454 |    5 +++++
 2 files changed, 10 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index fc07978..38adc8d 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -106,6 +106,9 @@ setf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\xd
 # Fake slash?
 setf "urk\xc0\xafmoo" "FAKESLASH"
 
+# Emoji: octopus butterfly owl giraffe
+setf "emoji_\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89\xf0\x9f\xa6\x92.txt" "octopus butterfly owl giraffe emoji"
+
 ls -la $testdir >> $seqres.full
 
 echo "Test files"
@@ -125,6 +128,8 @@ testf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\x
 
 testf "urk\xc0\xafmoo" "FAKESLASH"
 
+testf "emoji_\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89\xf0\x9f\xa6\x92.txt" "octopus butterfly owl giraffe emoji"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
diff --git a/tests/generic/454 b/tests/generic/454
index 7fa8ac5..f77ab77 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -104,6 +104,9 @@ setf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\xd
 # Fake slash?
 setf "urk\xc0\xafmoo" "FAKESLASH"
 
+# Emoji: octopus butterfly owl giraffe
+setf "emoji_\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89\xf0\x9f\xa6\x92.txt" "octopus butterfly owl giraffe emoji"
+
 $GETFATTR_PROG --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -123,6 +126,8 @@ testf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\x
 
 testf "urk\xc0\xafmoo" "FAKESLASH"
 
+testf "emoji_\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89\xf0\x9f\xa6\x92.txt" "octopus butterfly owl giraffe emoji"
+
 echo "Uniqueness of keys?"
 crazy_keys="$($GETFATTR_PROG --absolute-names -d "${testfile}" | egrep -c '(french_|chinese_|greek_|arabic_|urk)')"
 expected_keys=11

