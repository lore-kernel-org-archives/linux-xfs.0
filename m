Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 158FD801B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC4268F8052
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MiHEuOWaRPbxbjLT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:00 -0700 (PDT)
Subject: [PATCH 001/145] xfs_buflock: add a tool that can be used to find
	buffer deadlocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:51 -0700
Message-ID: <146612705189.16048.16879115408286697572.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Add a (rough) python script that can parse the output of:
# trace-cmd -e xfs_buf_*lock*' <other tracepoints>
to identify xfs_buf deadlocks between XFS threads.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/xfsbuflock.py |  205 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 205 insertions(+)
 create mode 100755 tools/xfsbuflock.py


diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
new file mode 100755
index 0000000..f307461
--- /dev/null
+++ b/tools/xfsbuflock.py
@@ -0,0 +1,205 @@
+#!/usr/bin/env python3
+
+# Read ftrace input, looking for XFS buffer deadlocks.
+#
+# Copyright (C) 2016 Oracle.  All Rights Reserved.
+#
+# Author: Darrick J. Wong <darrick.wong@oracle.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+#
+# Rough guide to using this script:
+# Collect ftrace data from a deadlock:
+#
+# # trace-cmd record -e 'xfs_buf_*lock*' <other traces> &
+# <run command, hang system>^Z
+# # killall -INT trace-cmd
+# <wait for trace-cmd to spit out trace.dat>
+#
+# Now analyze the captured trace data:
+#
+# # trace-cmd report | xfsbuflock.py
+# === fsx-14956 ===
+# <trace data>
+# 3732.005575: xfs_buf_trylock_fail: dev 8:16 bno 0x1 nblks 0x1 hold 4 \
+#		pincount 1 lock 0 flags DONE|KMEM caller 0xc009af36s
+# Locked buffers:
+# dev 8:16 bno 0x64c371 nblks 0x1 lock 1 owner fsx-14956@3732.005567
+#   waiting: fsx-14954
+# dev 8:16 bno 0x64c380 nblks 0x8 lock 1 owner fsx-14956@3732.005571
+# dev 8:16 bno 0x64c378 nblks 0x8 lock 1 owner fsx-14956@3732.005570
+# === fsx-14954 ===
+# <trace data>
+# 3732.005592: xfs_buf_trylock_fail: dev 8:16 bno 0x64c371 nblks 0x1 hold 4 \
+#		pincount 1 lock 0 flags ASYNC|DONE|KMEM caller 0xc009af36s
+# Locked buffers:
+# dev 8:16 bno 0x8 nblks 0x8 lock 1 owner fsx-14954@3732.005583
+# dev 8:16 bno 0x1 nblks 0x1 lock 1 owner fsx-14954@3732.005574
+#   waiting: fsx-14956
+#   waiting: fsx-14957
+#   waiting: fsx-14958
+# dev 8:16 bno 0x10 nblks 0x8 lock 1 owner fsx-14954@3732.005585
+#
+# As you can see, fsx-14596 is locking AGFs in violation of the locking
+# order rules.
+
+import sys
+import fileinput
+from collections import namedtuple
+
+NR_BACKTRACE = 50
+
+class Process:
+	def __init__(self, pid):
+		self.pid = pid;
+		self.bufs = set()
+		self.locked_bufs = set()
+		self.backtrace = []
+
+	def dump(self):
+		print('=== %s ===' % self.pid)
+		for bt in self.backtrace:
+			print('%f: %s' % (bt.time, bt.descr))
+		print('Locked buffers:')
+		for buf in self.locked_bufs:
+			buf.dump()
+
+class Buffer:
+	def __init__(self, dev, bno, blen):
+		self.dev = dev
+		self.bno = int(bno, 0)
+		self.blen = int(blen, 0)
+		self.locked = False
+		self.locktime = None
+		self.owner = None
+		self.waiters = set()
+
+	def trylock(self, process, time):
+		self.lockdone(process, time)
+
+	def lockdone(self, process, time):
+		if self.locked:
+			print('Buffer already locked on line %d?!' % nr)
+		#	process.dump()
+		#	self.dump()
+		#	assert False
+		if process in self.waiters:
+			self.waiters.remove(process)
+		self.locked = True
+		self.owner = process
+		self.locktime = time
+		process.locked_bufs.add(self)
+		process.bufs.add(self)
+		locked_buffers.add(self)
+
+	def waitlock(self, process):
+		self.waiters.add(process)
+
+	def unlock(self):
+		self.locked = False
+		if self in locked_buffers:
+			locked_buffers.remove(self)
+		if self.owner is not None and \
+		   self in self.owner.locked_bufs:
+			self.owner.locked_bufs.remove(self)
+
+	def dump(self):
+		if self.owner is not None:
+			pid = '%s@%f' % (self.owner.pid, self.locktime)
+		else:
+			pid = ''
+		print('dev %s bno 0x%x nblks 0x%x lock %d owner %s' % \
+			(self.dev, self.bno, self.blen, self.locked, \
+			pid))
+		for proc in self.waiters:
+			print('  waiting: %s' % proc.pid)
+
+Event = namedtuple('Event', 'time descr')
+
+# Read ftrace input, looking for events and for buffer lock info
+processes = {}
+buffers = {}
+locked_buffers = set()
+
+def getbuf(toks):
+	if int(toks[7], 0) == 18446744073709551615:
+		return None
+	bufkey = ' '.join(toks[4:10])
+	if bufkey in buffers:
+		return buffers[bufkey]
+	buf = Buffer(toks[5], toks[7], toks[9])
+	buffers[bufkey] = buf
+	return buf
+
+nr = 0
+for line in fileinput.input():
+	nr += 1
+	toks = line.split()
+	if len(toks) < 4:
+		continue
+	pid = toks[0]
+	time = float(toks[2][:-1])
+	fn = toks[3][:-1]
+
+	if pid in processes:
+		proc = processes[pid]
+	else:
+		proc = Process(pid)
+		processes[pid] = proc
+
+	if fn == 'xfs_buf_unlock' or fn == 'xfs_buf_item_unlock_stale':
+		buf = getbuf(toks)
+		if buf is not None:
+			buf.unlock()
+	elif fn == 'xfs_buf_lock_done':
+		buf = getbuf(toks)
+		if buf is not None:
+			buf.lockdone(proc, time)
+	elif fn == 'xfs_buf_lock':
+		buf = getbuf(toks)
+		if buf is not None:
+			buf.waitlock(proc)
+	elif fn == 'xfs_buf_trylock':
+		buf = getbuf(toks)
+		if buf is not None:
+			buf.trylock(proc, time)
+	elif fn == 'xfs_buf_item_unlock':
+		pass
+	else:
+		e = Event(time, ' '.join(toks[3:]))
+		proc.backtrace.append(e)
+		if len(proc.backtrace) > NR_BACKTRACE:
+			proc.backtrace.pop(0)
+
+deadlocked = set()
+for buf in locked_buffers:
+	deadlocked.add(buf.owner)
+
+for proc in deadlocked:
+	proc.dump()
+	
+sys.exit(0)
+
+for key in buffers:
+	buf = buffers[key]
+	if buf.locked:
+		print('dev %s bno 0x%x len 0x%x owner %s' % (buf.dev, buf.bno, buf.blen, buf.owner.pid))
+	else:
+		print('dev %s bno 0x%x len 0x%x' % (buf.dev, buf.bno, buf.blen))
+
+sys.exit(0)
+
+for pid in processes:
+	proc = processes[pid]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
