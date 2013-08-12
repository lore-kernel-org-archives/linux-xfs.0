Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F09CF29E37
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:51:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEAB2304032
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:51:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FremoFIDCpEMPGoi for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YV-AO
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00062w-9T
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 31/50] xfs: remove __KERNEL__ check
	from xfs_dir2_leaf.c
Date: Mon, 12 Aug 2013 20:49:52 +1000
Message-Id: <1376304611-22994-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dir2_leaf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 5505edb..591eaf2 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1586,10 +1586,6 @@ xfs_dir2_leaf_search_hash(
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
