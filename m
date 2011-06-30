Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U5LgC6183970 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:21:42 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 725301E56F35
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:42 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id QLsmUeCRN6sdirzV for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:42 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5U4rNDm024153
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:53:23 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5U5Lfxk118720 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:41 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5U5LfAI031707 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:41 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/4 v3] XFS TESTS: Fix 252 Failure: Update 252 Golden Output
Date: Wed, 29 Jun 2011 22:23:59 -0700
Message-Id: <1309411441-2491-3-git-send-email-achender@linux.vnet.ibm.com>
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

New filtered golden output for test 252

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 930c924... 3caf9d6... M	252.out
 252.out |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/252.out b/252.out
index 930c924..3caf9d6 100644
--- a/252.out
+++ b/252.out
@@ -1,239 +1,307 @@
 QA output created by 252
 	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..7]: unwritten
 1: [8..23]: hole
 2: [24..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..23]: hole
 1: [24..31]: data
 2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
 0: [0..23]: hole
 1: [24..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: data
 1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..31]: unwritten
 3: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
 0: [0..7]: unwritten
 1: [8..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
 0: [0..7]: unwritten
 1: [8..23]: hole
 2: [24..31]: data
 3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..7]: unwritten
 1: [8..31]: hole
 2: [32..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
+13535fd4d496bf0b74bb2335aa4d1b31
 	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..7]: unwritten
 1: [8..23]: hole
 2: [24..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	4. hole -> data
 0: [0..23]: hole
 1: [24..31]: data
 2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	5. hole -> unwritten
 0: [0..23]: hole
 1: [24..31]: unwritten
 2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	6. data -> hole
 0: [0..7]: data
 1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..31]: unwritten
 3: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
 	8. unwritten -> hole
 0: [0..7]: unwritten
 1: [8..39]: hole
+daa100df6e6711906b61c9ab5aa16032
 	9. unwritten -> data
 0: [0..7]: unwritten
 1: [8..23]: hole
 2: [24..31]: data
 3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..7]: unwritten
 1: [8..31]: hole
 2: [32..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
+13535fd4d496bf0b74bb2335aa4d1b31
 	1. into a hole
 0: [0..7]: data
 1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	4. hole -> data
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	5. hole -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	6. data -> hole
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	8. unwritten -> hole
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	9. unwritten -> data
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	10. hole -> data -> hole
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
+13535fd4d496bf0b74bb2335aa4d1b31
 	1. into a hole
 0: [0..7]: data
 1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	3. into unwritten space
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	4. hole -> data
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	5. hole -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	6. data -> hole
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	7. data -> unwritten
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	8. unwritten -> hole
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	9. unwritten -> data
 0: [0..7]: data
 1: [8..23]: hole
 2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
 	10. hole -> data -> hole
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	12. unwritten -> data -> unwritten
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	13. data -> unwritten -> data
 0: [0..7]: data
 1: [8..31]: hole
 2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
 	14. data -> hole @ EOF
 0: [0..23]: data
 1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
 	15. data -> hole @ 0
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	16. data -> cache cold ->hole
 0: [0..15]: hole
 1: [16..39]: data
+eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
+13535fd4d496bf0b74bb2335aa4d1b31
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
