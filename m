Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50691 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdF3E6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 00:58:18 -0400
Date: Thu, 29 Jun 2017 21:58:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 12/8] ext4: don't online scrub ever
Message-ID: <20170630045812.GI5871@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170630041331.GG5871@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630041331.GG5871@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The ext4 online scrub program is no longer under active development,
so remove all the test code that tried to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Fix the description to match what it does now
---
 common/fuzzy       |    2 +-
 tests/ext4/023     |    7 ++++---
 tests/ext4/023.out |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/common/fuzzy b/common/fuzzy
index 304268e..686cf77 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -70,7 +70,7 @@ _require_scrub() {
 # Scrub the scratch filesystem metadata (online)
 _scratch_scrub() {
 	case "${FSTYP}" in
-	"xfs"|"ext4"|"ext3"|"ext2")
+	"xfs")
 		$XFS_SCRUB_PROG -d -T -v "$@" $SCRATCH_MNT
 		;;
 	*)
diff --git a/tests/ext4/023 b/tests/ext4/023
index 4f5cf3e..7ca3d7d 100755
--- a/tests/ext4/023
+++ b/tests/ext4/023
@@ -1,7 +1,9 @@
 #! /bin/bash
 # FS QA Test No. 023
 #
-# Populate a ext4 filesystem and ensure that scrub and repair are happy.
+# Ensure that the populate helpers actually /can/ populate a ext4
+# filesystem with all types of metadata and create an image of the
+# metadata.  Check that fsck is happy with the resulting fs.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
@@ -51,9 +53,8 @@ _require_scrub
 echo "Format and populate"
 _scratch_populate_cached > $seqres.full 2>&1
 
-echo "Scrub"
+echo "Mount"
 _scratch_mount >> $seqres.full 2>&1
-_scratch_scrub >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/ext4/023.out b/tests/ext4/023.out
index da2bd60..8a7659b 100644
--- a/tests/ext4/023.out
+++ b/tests/ext4/023.out
@@ -1,3 +1,3 @@
 QA output created by 023
 Format and populate
-Scrub
+Mount
