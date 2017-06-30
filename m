Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20494 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdF3ENi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 00:13:38 -0400
Date: Thu, 29 Jun 2017 21:13:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/8] ext4: don't online scrub ever
Message-ID: <20170630041331.GG5871@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The ext4 online scrub program is no longer under active development,
so remove all the test code that tried to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy   |    2 +-
 tests/ext4/023 |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

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
index 4f5cf3e..4491936 100755
--- a/tests/ext4/023
+++ b/tests/ext4/023
@@ -53,7 +53,6 @@ _scratch_populate_cached > $seqres.full 2>&1
 
 echo "Scrub"
 _scratch_mount >> $seqres.full 2>&1
-_scratch_scrub >> $seqres.full
 
 # success, all done
 status=0
