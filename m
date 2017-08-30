Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35033 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdH3OvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:25 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 03/14] fsx: fixes to random seed
Date: Wed, 30 Aug 2017 17:51:35 +0300
Message-Id: <1504104706-11965-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Not sure why, but with initstate()/setstate(), sfx generates
same events regadless of the input seed argument.

Change to use srandom() to fix the problem.

Add pid to auto random seed, so parallel fsx executions with auto
seed will use different seed values.

At this time there are 6 tests that use sfx, out of which:
2 use -S 0 as seed (gettime()) - generic/{075,112}
2 do not specify seed (default = 1) - generic/{091,263}
1 uses explicit constant seed - generic/127
1 uses explicit $RANDOM seed - generic/231

This change affects all those tests.
The tests that intended to randomize the seed will now really
randomize the seed.
The tests that intended to use a constant seed will still use
a constant seed, but resulting event sequence will be different
than before this change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 3713bbe..572df75 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -116,7 +116,6 @@ int	fd;				/* fd for our test file */
 blksize_t	block_size = 0;
 off_t		file_size = 0;
 off_t		biggest = 0;
-char		state[256];
 unsigned long	testcalls = 0;		/* calls to function "test" */
 
 unsigned long	simulatedopcount = 0;	/* -b flag */
@@ -1909,8 +1908,10 @@ main(int argc, char **argv)
                         break;
 		case 'S':
                         seed = getnum(optarg, &endp);
-			if (seed == 0)
+			if (seed == 0) {
 				seed = time(0) % 10000;
+				seed += (int)getpid();
+			}
 			if (!quiet)
 				fprintf(stdout, "Seed set to %d\n", seed);
 			if (seed < 0)
@@ -1948,8 +1949,7 @@ main(int argc, char **argv)
 	signal(SIGUSR1,	cleanup);
 	signal(SIGUSR2,	cleanup);
 
-	initstate(seed, state, 256);
-	setstate(state);
+	srandom(seed);
 	fd = open(fname,
 		O_RDWR|(lite ? 0 : O_CREAT|O_TRUNC)|o_direct, 0666);
 	if (fd < 0) {
-- 
2.7.4

