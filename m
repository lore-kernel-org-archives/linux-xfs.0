Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56364 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:12:09 -0400
Subject: [PATCH 3/7] xfs_buflock: record line number of trace where we
 locked the buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:11:55 -0700
Message-ID: <152728631542.22515.4825509736346292149.stgit@magnolia>
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
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

