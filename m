Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41319 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdA1RiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 12:38:24 -0500
Subject: [PATCH 2/3] xfs/299: don't chmod the underlying mountpoints prior
 to mounting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 28 Jan 2017 09:38:19 -0800
Message-ID: <148562509908.30594.7838088688242443797.stgit@birch.djwong.org>
In-Reply-To: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
References: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It's silly to make $SCRATCH_MNT world writable just prior to mounting
the scratch device; instead, do it after the mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/299 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/299 b/tests/xfs/299
index d2670f8..997c5dc 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -203,9 +203,6 @@ cat $tmp.mkfs >>$seqres.full
 # keep the blocksize and data size for dd later
 . $tmp.mkfs
 
-# non-root users need to be able to write to this filesystem
-chmod 777 $SCRATCH_MNT
-
 cat >$tmp.projects <<EOF
 1:$SCRATCH_MNT
 EOF
@@ -220,6 +217,10 @@ projid_file="$tmp.projid"
 echo "*** user, group, and project"
 _qmount_option "uquota,gquota,pquota"
 _qmount
+
+# non-root users need to be able to write to this filesystem
+chmod 777 $SCRATCH_MNT
+
 _exercise p
 _exercise g
 _exercise u

