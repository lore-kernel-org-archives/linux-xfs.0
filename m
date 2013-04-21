Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78E2129E03
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 17:51:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1129AAC001
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 15:51:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LoEaZBmUD75IYZC7 for <xfs@oss.sgi.com>;
	Sun, 21 Apr 2013 15:51:55 -0700 (PDT)
Message-ID: <51746D8A.60707@sandeen.net>
Date: Sun, 21 Apr 2013 17:51:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfstests: fix common filter include in filter.btrfs
References: <517386CC.8010406@redhat.com> <51746D07.5090300@sandeen.net>
In-Reply-To: <51746D07.5090300@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Not sure how this happened, but filter.btrfs including
itself leads to immense sadness for any file that includes it.
(I got a segfault when I tried to run 307)

It should be including ./common/filter not ./common/filter.btrfs

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

cripes, I'm sorry that took 3 times to get right :/

diff --git a/common/filter.btrfs b/common/filter.btrfs
index b1aa733..e9a2bc2 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,6 +1,6 @@
 # Filters for btrfs command output
 
-. ./common/filter.btrfs
+. ./common/filter
 
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
