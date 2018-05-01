Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33600 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754749AbeEAPjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:39:48 -0400
Subject: [PATCH 4/9] generic/45[34]: check unicode names only if xfs_scrub
 linked against libicu
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:39:45 -0700
Message-ID: <152518918522.23023.14015169259875311012.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we've rewriting the xfs_scrub Unicode name scanner to use libicu
to detect potential spoof names, change our check for unicode-enabled
name scanning xfs_scrub to look for libicu instead of libunistring,
adjust the golden output to reflect the new library's detection
capabilities and make sure we get all the scrub output by invoking with
-v.

Note that this requires xfsprogs 4.16 or newer; since xfs_scrub is (for
now) an experimental program, we don't care about breaking backwards
compatibility.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/453 |    5 ++---
 tests/generic/454 |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/tests/generic/453 b/tests/generic/453
index f2cd81fb..6cb2a296 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -158,7 +158,7 @@ check_xfs_scrub() {
 
 	# We only care if xfs_scrub has unicode string support...
 	if ! type ldd > /dev/null 2>&1 || \
-	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libunistring; then
+	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libicui18n; then
 		return 1
 	fi
 
@@ -166,9 +166,8 @@ check_xfs_scrub() {
 }
 
 if check_xfs_scrub; then
-	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
+	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
-	echo "${output}" | grep -q "chinese_" || echo "No complaints about chinese width-different?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
 	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
 	echo "Actual xfs_scrub output:" >> $seqres.full
diff --git a/tests/generic/454 b/tests/generic/454
index c6530290..ec4fb997 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -154,7 +154,7 @@ check_xfs_scrub() {
 
 	# We only care if xfs_scrub has unicode string support...
 	if ! type ldd > /dev/null 2>&1 || \
-	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libunistring; then
+	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libicui18n; then
 		return 1
 	fi
 
@@ -162,9 +162,8 @@ check_xfs_scrub() {
 }
 
 if check_xfs_scrub; then
-	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
+	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
-	echo "${output}" | grep -q "chinese_" || echo "No complaints about chinese width-different?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
 	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
 	echo "Actual xfs_scrub output:" >> $seqres.full

