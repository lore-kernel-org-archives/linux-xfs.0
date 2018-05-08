Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755462AbeEHQhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:37:46 -0400
Subject: [PATCH 2/4] xfs_buflock: record line number of trace where we
 locked the buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 May 2018 09:37:26 -0700
Message-ID: <152579744648.10641.11507614128194757487.stgit@magnolia>
In-Reply-To: <152579743411.10641.4577883761846454290.stgit@magnolia>
References: <152579743411.10641.4577883761846454290.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enhance the debug output by reporting at which line in the trace output
we locked a particular buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/xfsbuflock.py |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
index cc15f582..954f0954 100755
--- a/tools/xfsbuflock.py
+++ b/tools/xfsbuflock.py
@@ -85,6 +85,7 @@ class Buffer:
 		self.locktime = None
 		self.owner = None
 		self.waiters = set()
+		self.lockline = 0
 
 	def trylock(self, process, time):
 		if not self.locked:
@@ -92,7 +93,8 @@ class Buffer:
 
 	def lockdone(self, process, time):
 		if self.locked:
-			print('Buffer already locked on line %d?!' % nr)
+			print('Buffer 0x%x already locked at line %d? (line %d)' % \
+					(self.bno, self.lockline, nr))
 		#	process.dump()
 		#	self.dump()
 		#	assert False
@@ -101,6 +103,7 @@ class Buffer:
 		self.locked = True
 		self.owner = process
 		self.locktime = time
+		self.lockline = nr
 		process.locked_bufs.add(self)
 		process.bufs.add(self)
 		locked_buffers.add(self)
@@ -118,7 +121,8 @@ class Buffer:
 
 	def dump(self):
 		if self.owner is not None:
-			pid = '%s@%f' % (self.owner.pid, self.locktime)
+			pid = '%s@%f (line %d)' % \
+				(self.owner.pid, self.locktime, self.lockline)
 		else:
 			pid = ''
 		print('dev %s bno 0x%x nblks 0x%x lock %d owner %s' % \

