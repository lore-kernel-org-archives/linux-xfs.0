Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbeGDEv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:51:29 -0400
Subject: [PATCH 6/7] generic/338: don't check fs after crashing it
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:51:25 -0700
Message-ID: <153067988515.28393.2889741998889842120.stgit@magnolia>
In-Reply-To: <153067984748.28393.1595618163831671652.stgit@magnolia>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test tries to make the filesystem go down by setting up dm-error
and committing metadata updates.  Since the test doesn't remount the fs
after it goes down to recover the log, this can result in a dirty log
being presented to the post-test filesystem check if the filesystem is
xfs and quotas are enabled.

Since this is a regression test for a NULL pointer dereference in the
kernel after the fs goes down, simply skip the post-test fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/338 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/338 b/tests/generic/338
index 6d701e83..81122e2d 100755
--- a/tests/generic/338
+++ b/tests/generic/338
@@ -36,7 +36,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck # fs went down with a dirty log, don't check it
 _require_dm_target error
 # If SCRATCH_DEV is not a valid block device, FSTYP cannot be mkfs'ed either
 _require_block_device $SCRATCH_DEV

