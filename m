Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 421637F5D
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6B0EAC00E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HFVRRcF0LhF4vn2v for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PM-E9
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000oH-D5
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: remove dmapi tests from the auto group
Date: Wed, 23 Apr 2014 08:04:33 +1000
Message-Id: <1398204274-2113-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There is no mainline kernel support for DMAPI in XFS, and so every
time the xfstests auto group is run it throws a large number of
"[not run] Assuming DMAPI modules are not loaded". I've noted that
people are excluding the dmapi group to avoid this, so rather than
inflict pain on everyone, make hose few that need to do dmapi
testing include it specifically.

IOWs, remove the DMAPI tests from the auto group.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/group | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index f907d9b..426dd58 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -93,48 +93,48 @@
 138 metadata log auto
 139 metadata log auto
 140 metadata log auto
-142 dmapi auto
-143 dmapi auto
-144 dmapi auto
-145 dmapi auto
-146 dmapi auto
-147 dmapi auto
+142 dmapi
+143 dmapi
+144 dmapi
+145 dmapi
+146 dmapi
+147 dmapi
 148 repair auto
 149 repair auto
-150 dmapi auto
-151 dmapi auto
-152 dmapi auto
-153 dmapi auto
-154 dmapi auto
-155 dmapi auto
-156 dmapi auto
-157 dmapi auto
-158 dmapi auto
-159 dmapi auto
-160 dmapi auto
-161 dmapi auto
-162 dmapi auto
-163 dmapi auto
+150 dmapi
+151 dmapi
+152 dmapi
+153 dmapi
+154 dmapi
+155 dmapi
+156 dmapi
+157 dmapi
+158 dmapi
+159 dmapi
+160 dmapi
+161 dmapi
+162 dmapi
+163 dmapi
 164 rw pattern auto prealloc quick
 165 rw pattern auto prealloc quick
 166 rw metadata auto quick
 167 rw metadata auto stress
-168 dmapi auto
+168 dmapi
 170 rw filestreams auto quick
 171 rw filestreams
 172 rw filestreams
 173 rw filestreams
 174 rw filestreams auto
-175 dmapi auto
-176 dmapi auto
-177 rw other auto
+175 dmapi
+176 dmapi
+177 dmapi
 178 mkfs other auto
 179 metadata rw auto
 180 metadata rw auto
 181 log auto quick
 182 metadata rw auto
 183 rw other auto quick
-185 dmapi auto
+185 dmapi
 186 attr auto quick
 187 attr auto quick
 188 ci dir auto
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
