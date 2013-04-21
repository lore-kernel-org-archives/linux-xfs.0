Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03E4F29DFA
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 01:27:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9EA3304032
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 23:27:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UAv04SUqOK0iB9E4 for
	<xfs@oss.sgi.com>; Sat, 20 Apr 2013 23:27:21 -0700 (PDT)
Message-ID: <517386CC.8010406@redhat.com>
Date: Sun, 21 Apr 2013 01:27:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: remove recursive include in filter.btrfs
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
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>

Not sure how this happened, but filter.btrfs including
itself leads to immense sadness for any file that includes it.
(I got a segfault when I tried to run 307)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter.btrfs b/common/filter.btrfs
index b1aa733..99d04a6 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,7 +1,5 @@
 # Filters for btrfs command output
 
-. ./common/filter.btrfs
-
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
