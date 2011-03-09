Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p29NZMf3067862 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 17:35:28 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75037336354
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 15:38:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oj9Ch8xrGw7rWBao for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 15:38:01 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxSwu-0002s2-RM
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 10:37:48 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxSx2-00021T-LV
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 10:37:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: flush vmap aliases when mapping fails
Date: Thu, 10 Mar 2011 10:37:56 +1100
Message-Id: <1299713876-7747-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

On 32 bit systems, vmalloc space is limited and XFS can chew through
it quickly as the vmalloc space is lazily freed. This can result in
failure to map buffers, even when there is apparently large amounts
of vmalloc space available. Hence, if we fail to map a buffer, purge
the aliases that have not yet been freed to hopefuly free up enough
vmalloc space to allow a retry to succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 3cc671c..a5a260f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -455,9 +455,17 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-					-1, PAGE_KERNEL);
-		if (unlikely(bp->b_addr == NULL))
+		int retried = 0;
+
+		do {
+			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
+						-1, PAGE_KERNEL);
+			if (bp->b_addr)
+				break;
+			vm_unmap_aliases();
+		} while (retried++ <= 1);
+
+		if (!bp->b_addr)
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
