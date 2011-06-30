Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U5Lhbk183988 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:21:43 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 627664C28A6
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:43 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id DyIS0hrZcLxnIXbA for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:43 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5U4rOIT024160
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:53:24 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5U5LgCO1585370
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5U5Lg1H031731 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:42 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 3/4 v3] XFS TESTS: Fix 252 Failure: Update 242 Golden Output
Date: Wed, 29 Jun 2011 22:24:00 -0700
Message-Id: <1309411441-2491-4-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

New filtered golden output for test 242. Another patch
has been sumbitted that also modifies the 242 output, and
this set has been adjusted to apply on top of it.

This patch requires Christoph's
"[PATCH] xfstests: update test 042 golden output" (06/20/2011)

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 e69382c... 649ac04... M	242.out
 242.out |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/242.out b/242.out
index e69382c..649ac04 100644
--- a/242.out
+++ b/242.out
@@ -3,58 +3,75 @@ QA output created by 242
 0: [0..7]: hole
 1: [8..23]: unwritten
 2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: unwritten
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..7]: hole
 1: [8..23]: unwritten
 2: [24..31]: data
 3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
 0: [0..7]: hole
 1: [8..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: data
 1: [8..23]: unwritten
 2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
 0: [0..23]: unwritten
 1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
 0: [0..23]: unwritten
 1: [24..31]: data
 2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
 0: [0..7]: hole
 1: [8..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: unwritten
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: unwritten
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: unwritten
+56819989ef2d9f40785adce8c06b64d0
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
