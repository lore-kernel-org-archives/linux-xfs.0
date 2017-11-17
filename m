Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19580 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760110AbdKQU2g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:28:36 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 2/4] dm-log-writes: only replay log to marks that exist
Date: Fri, 17 Nov 2017 13:28:26 -0700
Message-Id: <20171117202828.25472-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

The 'replay-log' executable will replay the dm-log-writes log until the
given mark, or until the end of the log if the mark isn't found.

This means that if the mark you're looking for was never inserted in the
log or if you give garbage to _log_writes_replay_log() the entire log will
be replayed.  This can cause unexpected test results.

Fix this by making sure that the mark we're given actually exists in the
log before we allow the replay.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 common/dmlogwrites | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 247c744..80ed4fc 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -72,6 +72,10 @@ _log_writes_replay_log()
 {
 	_mark=$1
 
+	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --find \
+		--end-mark $_mark >> $seqres.full 2>&1
+	[ $? -ne 0 ] && _fail "mark does not exist"
+
 	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
 		--end-mark $_mark >> $seqres.full 2>&1
 	[ $? -ne 0 ] && _fail "replay failed"
-- 
2.9.5

