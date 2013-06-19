Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D9B177FB0
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 854D6AC005
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7BjyClMKomVUmijn for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4j-0003CG-JK
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4e-0000G0-Fe
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/50] xfs: kill __KERNEL__ check for debug code in allocation
	code
Date: Wed, 19 Jun 2013 15:35:57 +1000
Message-Id: <1371620173-712-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_alloc.c |    6 +++---
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
