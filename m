Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03E967F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E871C304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IQgMSxv6qGsbqs0a for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007e0-6f
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003u1-66
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 36/55] xfs: kill __KERNEL__ check for debug code in allocation
	code
Date: Thu,  5 Sep 2013 08:05:40 +1000
Message-Id: <1378332359-14737-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 757b43d..e4fb1ad 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -856,7 +856,7 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
 	int		forced = 0;
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
 	 */
@@ -916,8 +916,8 @@ restart:
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
