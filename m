Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62DA329EB9
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37D4A30404E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id V03T8ClocoVev6y0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:10 -0800 (PST)
Subject: [PATCH 11/11] generic: create a dedupe group
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:06 -0800
Message-ID: <20151219091206.15320.10787.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Create a group for just the deduplication tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/group |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/tests/generic/group b/tests/generic/group
index 68853b4..2c18bce 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -123,8 +123,8 @@
 118 auto quick clone
 119 auto quick clone
 120 other auto quick
-121 auto quick clone
-122 auto quick clone
+121 auto quick clone dedupe
+122 auto quick clone dedupe
 123 perms auto quick
 124 pattern auto quick
 125 other auto
@@ -138,8 +138,8 @@
 133 rw auto
 134 auto quick clone
 135 metadata auto quick
-136 auto quick clone
-137 auto quick clone
+136 auto quick clone dedupe
+137 auto quick clone dedupe
 138 auto quick clone
 139 auto quick clone
 140 auto quick clone
@@ -160,12 +160,12 @@
 155 auto quick clone
 156 auto quick clone
 157 auto quick clone
-158 auto quick clone
+158 auto quick clone dedupe
 159 auto quick clone
-160 auto quick clone
+160 auto quick clone dedupe
 161 auto quick clone
-162 auto quick clone
-163 auto quick clone
+162 auto quick clone dedupe
+163 auto quick clone dedupe
 164 auto quick clone
 165 auto quick clone
 166 auto quick clone
@@ -261,7 +261,7 @@
 847 auto quick clone
 848 auto quick clone
 849 auto quick clone
-850 auto quick clone
+850 auto quick clone dedupe
 851 auto quick clone
 852 auto quick clone
 853 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
