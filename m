Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755336AbeEHQhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:37:39 -0400
Subject: [PATCH 1/4] xfs_buflock: ignore if buffer already locked
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 May 2018 09:37:20 -0700
Message-ID: <152579744028.10641.16598118261670192337.stgit@magnolia>
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

If the trace data says we ran trylock but we were already locked, don't
record another lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/xfsbuflock.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
index 82b6e01f..cc15f582 100755
--- a/tools/xfsbuflock.py
+++ b/tools/xfsbuflock.py
@@ -87,7 +87,8 @@ class Buffer:
 		self.waiters = set()
 
 	def trylock(self, process, time):
-		self.lockdone(process, time)
+		if not self.locked:
+			self.lockdone(process, time)
 
 	def lockdone(self, process, time):
 		if self.locked:

