Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51740 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbeFUScj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:32:39 -0400
Subject: [PATCH 1/4] xfs/365: fuzz inobt in ag 1
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:32:35 -0700
Message-ID: <152960595573.26479.7571844369482432726.stgit@magnolia>
In-Reply-To: <152960594943.26479.1457883867468749220.stgit@magnolia>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In kernel patch "xfs: verify root inode more thoroughly", we strengthen
the root inode mount checks to make sure that the inobt agrees that the
root inode exists and is in use.  Unfortunately, that makes this whole
test useless because we can't even mount the filesystem to run scrub.
So, redirect it to AG1's inobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/365 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/365 b/tests/xfs/365
index 64e910ed..bd29b2a3 100755
--- a/tests/xfs/365
+++ b/tests/xfs/365
@@ -37,7 +37,7 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz inobt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agi 0' 'addr root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  'agi 1' 'addr root' >> $seqres.full
 echo "Done fuzzing inobt"
 
 # success, all done

