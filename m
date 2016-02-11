Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2ED97FE9
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9561E8F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:59 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Qx5z906WKYgmiKyy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:57 -0800 (PST)
Subject: [PATCH 32/32] reflink: kick the slow tests out of the 'quick' group
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:54 -0800
Message-ID: <20160211234254.2202.90445.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Since 'quick' tests are supposed to run in < 15s, kick out the ones
that can't finish that soon even on fast storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/group |   34 +++++++++++++++++-----------------
 tests/xfs/group     |    6 +++---
 2 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/tests/generic/group b/tests/generic/group
index e3c4e8a..5f699ce 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -139,7 +139,7 @@
 134 auto quick clone
 135 metadata auto quick
 136 auto quick clone dedupe
-137 auto quick clone dedupe
+137 auto clone dedupe
 138 auto quick clone
 139 auto quick clone
 140 auto quick clone
@@ -166,19 +166,19 @@
 161 auto quick clone
 162 auto quick clone dedupe
 163 auto quick clone dedupe
-164 auto quick clone
-165 auto quick clone
-166 auto quick clone
-167 auto quick clone
-168 auto quick clone
+164 auto clone
+165 auto clone
+166 auto clone
+167 auto clone
+168 auto clone
 169 rw metadata auto quick
-170 auto quick clone
+170 auto clone
 171 auto quick clone
 172 auto quick clone
 173 auto quick clone
 174 auto quick clone
-175 auto quick clone
-176 auto quick clone
+175 auto clone
+176 auto clone
 177 auto quick prealloc metadata
 178 auto quick clone
 179 auto quick clone
@@ -188,8 +188,8 @@
 183 auto quick clone
 184 metadata auto quick
 185 auto quick clone
-186 auto quick clone
-187 auto quick clone
+186 auto clone
+187 auto clone
 188 auto quick clone
 189 auto quick clone
 190 auto quick clone
@@ -244,8 +244,8 @@
 239 auto aio rw
 240 auto aio quick rw
 241 auto
-242 auto quick clone
-243 auto quick clone
+242 auto clone
+243 auto clone
 244 auto quick quota
 245 auto quick dir
 246 auto quick rw
@@ -299,8 +299,8 @@
 294 auto quick
 295 auto quick clone
 296 auto quick clone
-297 auto quick clone
-298 auto quick clone
+297 auto clone
+298 auto clone
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
 301 auto quick clone
@@ -335,5 +335,5 @@
 330 auto quick clone
 331 auto quick clone
 332 auto quick clone
-333 auto quick clone
-334 auto quick clone
+333 auto clone
+334 auto clone
diff --git a/tests/xfs/group b/tests/xfs/group
index 4fb7618..eadc212 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -137,7 +137,7 @@
 137 auto metadata v2log
 138 auto quick quota
 139 auto quick clone
-140 auto quick clone
+140 auto clone
 141 auto log metadata
 142 dmapi
 143 dmapi
@@ -166,7 +166,7 @@
 166 rw metadata auto quick
 167 rw metadata auto stress
 168 dmapi
-169 auto quick clone
+169 auto clone
 170 rw filestreams auto quick
 171 rw filestreams
 172 rw filestreams
@@ -233,7 +233,7 @@
 233 auto quick rmap
 234 auto quick rmap
 235 fuzzers rmap
-236 auto quick rmap
+236 auto rmap
 237 auto quick clone
 238 auto quick metadata ioctl
 239 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
