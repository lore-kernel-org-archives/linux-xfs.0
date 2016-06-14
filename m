Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A45BF7CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 07:59:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 651F08F8035
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 05:59:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cEYrGe09zXof7lI7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2016 05:59:01 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0908F1393C0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 12:59:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-81.bos.redhat.com [10.18.41.81])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5ECx0lr006933
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 08:59:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: refactor xfs_reserve_blocks() to handle ENOSPC correctly
Date: Tue, 14 Jun 2016 08:58:59 -0400
Message-Id: <1465909139-36329-1-git-send-email-bfoster@redhat.com>
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

xfs_reserve_blocks() is responsible to update the XFS reserved block
pool count at mount time or based on user request. When the caller
requests to increase the reserve pool, blocks must be allocated from the
global counters such that they are no longer available for general
purpose use. If the requested reserve pool size is too large, XFS
reserves what blocks are available. The implementation requires looking
at the percpu counters and making an educated guess as to how many
blocks to try and allocate from xfs_mod_fdblocks(), which can return
-ENOSPC if the guess was not accurate due to counters being modified in
parallel.

xfs_reserve_blocks() retries the guess in this scenario until the
allocation succeeds or it is determined that there is no space available
in the fs. While not easily reproducible in the current form, the retry
code doesn't actually work correctly if xfs_mod_fdblocks() actually
fails. The problem is that the percpu calculations use the m_resblks
counter to determine how many blocks to allocate, but unconditionally
update m_resblks before the block allocation has actually succeeded.
Therefore, if xfs_mod_fdblocks() fails, the code jumps to the retry
label and uses the already updated m_resblks value to determine how many
blocks to try and allocate. If the percpu counters previously suggested
that the entire request was available, fdblocks_delta could end up set
to 0. In that case, m_resblks is updated to the requested value, yet no
blocks have been reserved at all.

Refactor xfs_reserve_blocks() to use an explicit loop and make the code
easier to follow. Since we have to drop the spinlock across the
xfs_mod_fdblocks() call, use a delta value for m_resblks as well and
only apply the delta once allocation succeeds.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is something I had laying around from the thin block device
reservation stuff. That work introduced a more common xfs_mod_fdblocks()
failure scenario that isn't as much of a problem with the current code,
but the current xfs_reserve_blocks() retry code is clearly broken and so
should probably be fixed up.

Brian

 fs/xfs/xfs_fsops.c | 105 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b4d7582..003d180 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -667,8 +667,11 @@ xfs_reserve_blocks(
 	__uint64_t              *inval,
 	xfs_fsop_resblks_t      *outval)
 {
-	__int64_t		lcounter, delta, fdblks_delta;
+	__int64_t		lcounter, delta;
+	__int64_t		fdblks_delta = 0;
 	__uint64_t		request;
+	__int64_t		free;
+	int			error = 0;
 
 	/* If inval is null, report current values and return */
 	if (inval == (__uint64_t *)NULL) {
@@ -682,24 +685,23 @@ xfs_reserve_blocks(
 	request = *inval;
 
 	/*
-	 * With per-cpu counters, this becomes an interesting
-	 * problem. we needto work out if we are freeing or allocation
-	 * blocks first, then we can do the modification as necessary.
+	 * With per-cpu counters, this becomes an interesting problem. we need
+	 * to work out if we are freeing or allocation blocks first, then we can
+	 * do the modification as necessary.
 	 *
-	 * We do this under the m_sb_lock so that if we are near
-	 * ENOSPC, we will hold out any changes while we work out
-	 * what to do. This means that the amount of free space can
-	 * change while we do this, so we need to retry if we end up
-	 * trying to reserve more space than is available.
+	 * We do this under the m_sb_lock so that if we are near ENOSPC, we will
+	 * hold out any changes while we work out what to do. This means that
+	 * the amount of free space can change while we do this, so we need to
+	 * retry if we end up trying to reserve more space than is available.
 	 */
-retry:
 	spin_lock(&mp->m_sb_lock);
 
 	/*
 	 * If our previous reservation was larger than the current value,
-	 * then move any unused blocks back to the free pool.
+	 * then move any unused blocks back to the free pool. Modify the resblks
+	 * counters directly since we shouldn't have any problems unreserving
+	 * space.
 	 */
-	fdblks_delta = 0;
 	if (mp->m_resblks > request) {
 		lcounter = mp->m_resblks_avail - request;
 		if (lcounter  > 0) {		/* release unused blocks */
@@ -707,54 +709,67 @@ retry:
 			mp->m_resblks_avail -= lcounter;
 		}
 		mp->m_resblks = request;
-	} else {
-		__int64_t	free;
+		if (fdblks_delta) {
+			spin_unlock(&mp->m_sb_lock);
+			error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
+			spin_lock(&mp->m_sb_lock);
+		}
+
+		goto out;
+	}
 
+	/*
+	 * If the request is larger than the current reservation, reserve the
+	 * blocks before we update the reserve counters. Sample m_fdblocks and
+	 * perform a partial reservation if the request exceeds free space.
+	 */
+	error = -ENOSPC;
+	while (error == -ENOSPC) {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
 							XFS_ALLOC_SET_ASIDE(mp);
 		if (!free)
-			goto out; /* ENOSPC and fdblks_delta = 0 */
+			break;
 
 		delta = request - mp->m_resblks;
 		lcounter = free - delta;
-		if (lcounter < 0) {
+		if (lcounter < 0)
 			/* We can't satisfy the request, just get what we can */
-			mp->m_resblks += free;
-			mp->m_resblks_avail += free;
-			fdblks_delta = -free;
-		} else {
-			fdblks_delta = -delta;
-			mp->m_resblks = request;
-			mp->m_resblks_avail += delta;
-		}
-	}
-out:
-	if (outval) {
-		outval->resblks = mp->m_resblks;
-		outval->resblks_avail = mp->m_resblks_avail;
-	}
-	spin_unlock(&mp->m_sb_lock);
+			fdblks_delta = free;
+		else
+			fdblks_delta = delta;
 
-	if (fdblks_delta) {
 		/*
-		 * If we are putting blocks back here, m_resblks_avail is
-		 * already at its max so this will put it in the free pool.
-		 *
-		 * If we need space, we'll either succeed in getting it
-		 * from the free block count or we'll get an enospc. If
-		 * we get a ENOSPC, it means things changed while we were
-		 * calculating fdblks_delta and so we should try again to
-		 * see if there is anything left to reserve.
+		 * We'll either succeed in getting space from the free block
+		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
+		 * things changed while we were calculating fdblks_delta and so
+		 * we should try again to see if there is anything left to
+		 * reserve.
 		 *
 		 * Don't set the reserved flag here - we don't want to reserve
 		 * the extra reserve blocks from the reserve.....
 		 */
-		int error;
-		error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
-		if (error == -ENOSPC)
-			goto retry;
+		spin_unlock(&mp->m_sb_lock);
+		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
-	return 0;
+
+	/*
+	 * Update the reserve counters if blocks have been successfully
+	 * allocated.
+	 */
+	if (!error && fdblks_delta) {
+		mp->m_resblks += fdblks_delta;
+		mp->m_resblks_avail += fdblks_delta;
+	}
+
+out:
+	if (outval) {
+		outval->resblks = mp->m_resblks;
+		outval->resblks_avail = mp->m_resblks_avail;
+	}
+
+	spin_unlock(&mp->m_sb_lock);
+	return error;
 }
 
 int
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
