Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:43 -0400
Subject: [PATCH 4/6] xfs/270: use _scratch_xfs_set_metadata_field to fuzz
 rocompat bits
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:33 -0700
Message-ID: <153869877319.26648.6762297729048228417.stgit@magnolia>
In-Reply-To: <153869874763.26648.516233620615833277.stgit@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the helper to set the metadata field so that we can bypass write
verifier checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/270 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/270 b/tests/xfs/270
index da66bc33..fb72ba7c 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -44,8 +44,8 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
 # change this case.
-$XFS_DB_PROG -x -c "sb 0" -c "write -d features_ro_compat $((2**31))" \
-	$SCRATCH_DEV | grep -v "Allowing write of corrupted data"
+_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
+	grep 'features_ro_compat'
 
 # rw mount with unknown ro-compat feature should fail
 echo "rw mount test"
