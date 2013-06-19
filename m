Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E745329E99
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 848E3AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PDVA3GAzlMUWFhOw for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANr-00030b-0d
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANg-000074-0A
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 44/60] xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
Date: Wed, 19 Jun 2013 14:50:52 +1000
Message-Id: <1371617468-32559-45-git-send-email-david@fromorbit.com>
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

It's actually an ifndef section, which means it is only included in
userspace. however, it's deep within the libxfs code, so it's
unlikely that the condition checked in userspace can actually occur
(search an empty leaf) through the libxfs interfaces. i.e. if it can
happen in usrspace, it can happen in the kernel, so remove it from
userspace too....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 005a6b3..853ebdf 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1587,10 +1587,6 @@ xfs_dir2_leaf_search_hash(
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
