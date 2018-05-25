Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:12:12 -0400
Subject: [PATCH 4/7] xfs_buflock: record buffer initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:12:01 -0700
Message-ID: <152728632163.22515.2423877809843536137.stgit@magnolia>
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

Buffers are created locked, so we have to factor that into the buffer
state machine that the script utilizes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/xfsbuflock.py |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
index 954f0954..8f38f9f0 100755
--- a/tools/xfsbuflock.py
+++ b/tools/xfsbuflock.py
@@ -91,6 +91,13 @@ class Buffer:
 		if not self.locked:
 			self.lockdone(process, time)
 
+	def init(self, process, time):
+		# Buffers are initialized locked, but we could be allocating
+		# a surplus buffer while trying to grab a buffer that may or
+		# may not already exist.
+		if not self.locked:
+			self.lockdone(process, time)
+
 	def lockdone(self, process, time):
 		if self.locked:
 			print('Buffer 0x%x already locked at line %d? (line %d)' % \
@@ -183,6 +190,10 @@ for line in fileinput.input():
 		buf = getbuf(toks)
 		if buf is not None:
 			buf.trylock(proc, time)
+	elif fn == 'xfs_buf_init':
+		buf = getbuf(toks)
+		if buf is not None:
+			buf.init(proc, time)
 	elif fn == 'xfs_buf_item_unlock':
 		pass
 	else:

