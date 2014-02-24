Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA54E7F53
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 00:04:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 591D5AC003
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 22:04:39 -0800 (PST)
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]) by cuda.sgi.com with
	ESMTP id FhFHYOeOEfHzXYhO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 22:04:37 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 36F4F3EE1DA
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:04:33 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 24FC845DEBE
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:04:33 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0D01145DEB7
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:04:33 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id ED0C7E08003
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:04:32 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local
	(g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9A5001DB803C
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:04:32 +0900 (JST)
Message-ID: <530AE0E5.1090707@jp.fujitsu.com>
Date: Mon, 24 Feb 2014 15:04:21 +0900
From: sat <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] XFS: fix the description of 'allocsize=' mount option
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
To: xfs@oss.sgi.com, Rob Landley <rob@landley.net>, Dave Chinner <david@fromorbit.com>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

The end-of-file preallocation size is dynamic by default.
So the description about the default size of preallocation
should be removed.

Instead, adding the description about the initial size of
dynamic preallocation is useful for users.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/filesystems/xfs.txt |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 5be51fd..30e57b0 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -23,16 +23,16 @@ default behaviour.
 
   allocsize=size
 	Sets the buffered I/O end-of-file preallocation size when
-	doing delayed allocation writeout (default size is 64KiB).
-	Valid values for this option are page size (typically 4KiB)
-	through to 1GiB, inclusive, in power-of-2 increments.
+	doing delayed allocation writeout. Valid values for this
+	option are page size (typically 4KiB) through to 1GiB,
+	inclusive, in power-of-2 increments.
 
 	The default behaviour is for dynamic end-of-file
-	preallocation size, which uses a set of heuristics to
-	optimise the preallocation size based on the current
-	allocation patterns within the file and the access patterns
-	to the file. Specifying a fixed allocsize value turns off
-	the dynamic behaviour.
+	preallocation size (initial size is 64KiB), which uses a
+	set of heuristics to optimise the preallocation size based
+	on the current allocation patterns within the file and
+	the access patterns to the file. Specifying a fixed
+	allocsize value	turns off the dynamic behaviour.
 
   attr2
   noattr2
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
