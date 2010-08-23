Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7N0FUZv102030 for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 19:15:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86CED1504A
	for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 17:16:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	uXymGZpcjGXZKoC6 for <xfs@oss.sgi.com>;
	Sun, 22 Aug 2010 17:16:02 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24591227-1927428
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 09:46:00 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OnKhj-0003Uw-1i
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:59 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OnKha-000241-Si
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: improve buffer cache hash scalability
Date: Mon, 23 Aug 2010 10:15:46 +1000
Message-Id: <1282522546-7892-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1282522546-7892-1-git-send-email-david@fromorbit.com>
References: <1282522546-7892-1-git-send-email-david@fromorbit.com>
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

When doing large parallel file creates on a 16p machines, large amounts of
time is being spent in _xfs_buf_find(). A system wide profile with perf top
shows this:

          1134740.00 19.3% _xfs_buf_find
           733142.00 12.5% __ticket_spin_lock

The problem is that the hash contains 45,000 buffers, and the hash table width
is only 256 buffers. That means we've got around 200 buffers per chain, and
searching it is quite expensive. The hash table size needs to increase.

Secondly, every time we do a lookup, we promote the buffer we find to the head
of the hash chain. This is causing cachelines to be dirtied and causes
invalidation of cachelines across all CPUs that may have walked the hash chain
recently. hence every walk of the hash chain is effectively a cold cache walk.
Remove the promotion to avoid this invalidation.

The results are:

          1045043.00 21.2% __ticket_spin_lock
           326184.00  6.6% _xfs_buf_find

A 70% drop in the CPU usage when looking up buffers. Unfortunately that does
not result in an increase in performance underthis workload as contention on
the inode_lock soaks up most of the reduction in CPU usage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    8 +-------
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ea79072..d72cf2b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -440,12 +440,7 @@ _xfs_buf_find(
 		ASSERT(btp == bp->b_target);
 		if (bp->b_file_offset == range_base &&
 		    bp->b_buffer_length == range_length) {
-			/*
-			 * If we look at something, bring it to the
-			 * front of the list for next time.
-			 */
 			atomic_inc(&bp->b_hold);
-			list_move(&bp->b_hash_list, &hash->bh_list);
 			goto found;
 		}
 	}
@@ -1443,8 +1438,7 @@ xfs_alloc_bufhash(
 {
 	unsigned int		i;
 
-	btp->bt_hashshift = external ? 3 : 8;	/* 8 or 256 buckets */
-	btp->bt_hashmask = (1 << btp->bt_hashshift) - 1;
+	btp->bt_hashshift = external ? 3 : 12;	/* 8 or 4096 buckets */
 	btp->bt_hash = kmem_zalloc_large((1 << btp->bt_hashshift) *
 					 sizeof(xfs_bufhash_t));
 	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index d072e5f..2a05614 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -137,7 +137,6 @@ typedef struct xfs_buftarg {
 	size_t			bt_smask;
 
 	/* per device buffer hash table */
-	uint			bt_hashmask;
 	uint			bt_hashshift;
 	xfs_bufhash_t		*bt_hash;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
