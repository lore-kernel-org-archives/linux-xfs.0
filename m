Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03C947CC7
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 840AFAC006
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1VRejwcIgS0sn88i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:39 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 4/9] dm thin: update reserve space func to allow reduction
Date: Thu, 17 Mar 2016 10:30:32 -0400
Message-Id: <1458225037-24155-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
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
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

The dm-thin set_reserve_count() function is designed to control the
current block reservation for a thin pool. It currently only provides
the ability to increase the reservation.

Clients such as XFS will rely on over-reservation and thus require the
ability to release excess reservation back to the pool. Update
set_reserve_count() to return reserved blocks back to the pool.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 drivers/md/dm-thin.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 31d36da..ac770d89 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1429,7 +1429,8 @@ static bool dec_reserve_count(struct thin_c *tc, dm_block_t free_blocks)
 static int set_reserve_count(struct thin_c *tc, dm_block_t count)
 {
 	int r;
-	dm_block_t free_blocks, delta;
+	dm_block_t free_blocks;
+	int64_t delta;
 	unsigned long flags;
 
 	r = get_free_blocks(tc->pool, &free_blocks);
@@ -1437,8 +1438,6 @@ static int set_reserve_count(struct thin_c *tc, dm_block_t count)
 		return r;
 
 	spin_lock_irqsave(&tc->pool->lock, flags);
-	if (count <= tc->reserve_count)
-		goto out_unlock; /* nothing to do */
 	delta = count - tc->reserve_count;
 	if (tc->pool->reserve_count + delta > free_blocks)
 		r = -ENOSPC;
@@ -1446,7 +1445,6 @@ static int set_reserve_count(struct thin_c *tc, dm_block_t count)
 		tc->reserve_count = count;
 		tc->pool->reserve_count += delta;
 	}
-out_unlock:
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 
 	return r;
@@ -4369,7 +4367,7 @@ static int thin_reserve_space(struct dm_target *ti, sector_t nr_sects)
 	 * @nr_sects must always be a factor of the pool's blocksize;
 	 * upper layers can rely on the bdev's minimum_io_size for this.
 	 */
-	if (!nr_sects || !is_factor(nr_sects, pool->sectors_per_block))
+	if (!is_factor(nr_sects, pool->sectors_per_block))
 		return -EINVAL;
 
 	blocks = nr_sects;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
