Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6496 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753233AbdLFAhw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 19:37:52 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v5 1/2] dm-log-writes: only replay log to marks that exist
Date: Tue,  5 Dec 2017 17:37:43 -0700
Message-Id: <20171206003744.28587-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
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
index 247c7442..05829dbc 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -72,6 +72,10 @@ _log_writes_replay_log()
 {
 	_mark=$1
 
+	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --find \
+		--end-mark $_mark >> $seqres.full 2>&1
+	[ $? -ne 0 ] && _fail "mark '$_mark' does not exist"
+
 	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
 		--end-mark $_mark >> $seqres.full 2>&1
 	[ $? -ne 0 ] && _fail "replay failed"
-- 
2.14.3

