Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32878 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdJZFwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:52:02 -0400
Subject: [PATCH 4/6] generic/45[34]: force UTF-8 codeset to enable utf-8
 namer checks in xfs_scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Oct 2017 22:51:58 -0700
Message-ID: <150899711812.18389.9335385495519220150.stgit@magnolia>
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The upcoming xfs_scrub tool will have the ability to warn about
suspicious UTF-8 normalization collisions.  We want generic/45[34] to be
able to test this functionality, but to do that we have to forcibly set
the codeset to UTF-8 via LC_ALL since the rest of xfstests only uses
LC_ALL=C.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/453 |    2 +-
 tests/generic/454 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/453 b/tests/generic/453
index 40fae91..16589d1 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -148,7 +148,7 @@ check_xfs_scrub() {
 }
 
 if check_xfs_scrub; then
-	output="$(${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
+	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
 	echo "${output}" | grep -q "chinese_" || echo "No complaints about chinese width-different?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
diff --git a/tests/generic/454 b/tests/generic/454
index 462185a..efac860 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -144,7 +144,7 @@ check_xfs_scrub() {
 }
 
 if check_xfs_scrub; then
-	output="$(${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
+	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
 	echo "${output}" | grep -q "chinese_" || echo "No complaints about chinese width-different?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"

