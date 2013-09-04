Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB4EE29DFC
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA61D8F8033
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pzfbr47RWpRsGTEh for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:27 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDB-0007e0-7v
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003uB-7G
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 38/55] xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
Date: Thu,  5 Sep 2013 08:05:42 +1000
Message-Id: <1378332359-14737-39-git-send-email-david@fromorbit.com>
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

It's actually an ifndef section, which means it is only included in
userspace. however, it's deep within the libxfs code, so it's
unlikely that the condition checked in userspace can actually occur
(search an empty leaf) through the libxfs interfaces. i.e. if it can
happen in usrspace, it can happen in the kernel, so remove it from
userspace too....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_dir2_leaf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8c20b9e..55b7d05 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1568,10 +1568,6 @@ xfs_dir2_leaf_search_hash(
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 
-#ifndef __KERNEL__
-	if (!leafhdr.count)
-		return 0;
-#endif
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
 	 * Binary search the leaf entries looking for our hash value.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
