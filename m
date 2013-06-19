Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75CEB29E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 653148F8035
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YbAf9f7wEAAN0GYY for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:41 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANf-00030O-W7
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:28 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANf-00006o-Sz
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 41/60] xfs: kill __KERNEL__ check for debug code in allocation
	code
Date: Wed, 19 Jun 2013 14:50:49 +1000
Message-Id: <1371617468-32559-42-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Userspace running debug builds is relatively rare, so there's need
to special case the allocation algorithm code coverage debug switch.
As it is, userspace defines random numbers to 0, so  invert the
logic of the switch so it is effectively a no-op in userspace.
This kills another couple of __KERNEL__ users.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 71596e5..5a1393f 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -878,7 +878,7 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
 	int		forced = 0;
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
 	 */
@@ -938,8 +938,8 @@ restart:
 		xfs_extlen_t	blen=0;
 		xfs_agblock_t	bnew=0;
 
-#if defined(DEBUG) && defined(__KERNEL__)
-		if (!dofirst)
+#ifdef DEBUG
+		if (dofirst)
 			break;
 #endif
 		/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
