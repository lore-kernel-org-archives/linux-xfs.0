Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417EE78685
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751382; cv=pass; b=Zh9+6gl7XETxF1xpahmAOjZU7gyHQeHKmsTrkK/YJCfc7dci2XOPMPmP4A7f5xvgHn6aGCzhtCJd1ruSLetEYAYBGtW+mXjyLszfANpwtnA6k3mr4alPUEKtgx0J9Isc2r4pmtSukvLoFhlRnvLaBKw4jxnU+GcIRS7vdNOAZYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751382; c=relaxed/simple;
	bh=/CPRIjMvII+TbwmuGj/+mnilyM+arOek2XLIAmyk2Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQhjl6dDRmkSXBFi5I2UBYb6XlepRDSfaIdf8km/Pm4Mv/sqYyUmVRles0IIXkQ7TgbKqFX1WCTWI7agm7uL/ZTbNwCxGUzewPs/zoTirx7r67BrVXRh2XghXj+cCuey5QR5f0hkj/diEaQlwzT8vUo4vAMfMx/4A3NaTvANIiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=K73OHGq4; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="K73OHGq4"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E9E68847545
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:33:46 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9EDC58473F3
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:33:46 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750426; a=rsa-sha256;
	cv=none;
	b=JqwhOML2z6MTLIz/3QPLXWhe6JfwiBPdSUnLFnszSaiCPtncXeiaXYv6NlHbQ25mssJK28
	YRn0U8T3qUCKL26lGS/GnrEj91r1vohFKT1tJjv3O0nS7jIefhnhkjPR3a7drMNd4pf2bh
	PnVpGBtCPD2w1hGGOcxpP93aBfX8jlivoITZI59Vv7NXeUICv+Ta5Hecxs6bqGf7qqsVJo
	zi53iywgQFKrrZahXNMRxzpvhMZPjzU3HYNVVQSzQGTd5Jb/IgUZaL/CSKc6NqAZ8fBYEx
	XWtA+dt0pplImF1Ha41FYfpXmIUItowJNzjW2+fMXqX8nwLshcLn0piTsLaoFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuInn/XU5MHEybIS4Kct0LUrS5pmFt9IS2xy5Q8W7t4=;
	b=gzfNeVVVOKqvdsTxwgUC7Yr/O95ZcIpGGFH1gNbdrJxYqWMoyr7qc3EbKed3P4utKh6Vvf
	2XBu899T+8Jy+lJLjppk4wq+rju2bIeaT/1BqddmswH8jOi8HgQhY+zC+Kfim+6R3ZuUjy
	Rf14HyyXjW3VpkAieM9P8Tx+VCK+GytSiqtUzphOH+BptpniyufVG/50jNPOpwf2FJbhU3
	JDnYeMw4u10VcFmlZn8k3bYQPKmefrhGFS90oSq4j4FEBrz8IvZBG3hQxInoyEB1dFrsiX
	mzMCH8kc/g3jtQL2YRUTBvSbKOXMWxG+srlYp4RaI4nf8Von0/L2PE+svKy3ag==
ARC-Authentication-Results: i=1;
	rspamd-c4b59d8dc-5b9hm;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Shrill-Desert: 179b3b8a54be8784_1723750426866_3341267120
X-MC-Loop-Signature: 1723750426866:3263779452
X-MC-Ingress-Time: 1723750426866
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.82.146 (trex/7.0.2);
	Thu, 15 Aug 2024 19:33:46 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFff3GV5z9v
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750426;
	bh=nuInn/XU5MHEybIS4Kct0LUrS5pmFt9IS2xy5Q8W7t4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=K73OHGq4s+23hkurvqgkSbHTBbVpx7hmVTwN1OJhZvEOuMHDgBBaOLiNrFJWHuc7E
	 mp2np+NLJxG1QgISge9epiv0dv38CR4YEuRSfx0Rp5TBDR1O7QQyQ1lN5bQqY+9uyS
	 3U6Libm6Sm0Y8f+mGHxamyFRESGtgd+HWjZZif0RberUkbnGG6l4byyc12m+aDpwh3
	 FVO8W24YnQgejCcuoobskuX5+i0mQ9Qc2wCdh9nWctqE6mJWU6VGnPzuXcjQmDnqAu
	 cr9Db6cdlu+hJHefvtIWW4ou3GnZJKgOLi7hqRTPHeARgFKmr/ZVY8GS2gs1I0O7h6
	 ykcv0JKxxPavg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:33:45 -0700
Date: Thu, 15 Aug 2024 12:33:45 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 3/5] xfs: make alloc_set_aside and friends aware of per-AG
 reservations
Message-ID: <4d4b1e18ffb159d167e239cb66ccaf5e3a27236c.1723688622.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
 <cover.1723688622.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723688622.git.kjlx@templeofstupid.com>

The code in xfs_alloc_set_aside and xfs_alloc_ag_max_usable assumes that
the amount of free space that remains when a filesystem is at ENOSPC
corresponds to the filesystem actually having consumed almost all the
available free space.  These functions control how much space is set
aside to refill the AGFL when a filesystem is almost out of space.

With per-AG reservations, an AG has more space available at ENOSPC than
it did in the past.  This leads to situations where the reservation code
informs callers that an ENOSPC condition is present, yet the filesystem
isn't fully empty.  As a result, under certain edge cases, allocations
that need to refill the AGFL at a reservation-induced ENOSPC may not
have enough space set aside to complete that operation successfully.
This is because there is more free-space metadata to track than there
used to be.  The result is ENOSPC related shutdowns in paths that
only partially succeed at satsifying their allocations.

Fix this by determining the size of the free space that remains when a
filesystem's reservation is unused but all remaining blocks have been
consumed.  Use this remaining space to determine the size of the b-trees
that manage the space, and correspondingly, the number of blocks needed
to refill the AGFL if we have a split at or near ENOSPC.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 85 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.c        | 16 ++++++++
 2 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 17e029bb1b6d..826f527d20f2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_health.h"
 #include "xfs_extfree_item.h"
 
@@ -131,9 +132,81 @@ xfs_alloc_min_freelist_calc(
  * fdblocks to ensure user allocation does not overcommit the space the
  * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
  * withhold space from xfs_dec_fdblocks, so we do not account for that here.
+ *
+ * This value should be used on filesystems that do not have a per-AG
+ * reservation enabled.  If per-AG reservations are on, then this value needs to
+ * be scaled to the size of the metadata used to track the freespace that the
+ * reservation prevents from being consumed.
  */
 #define XFS_ALLOCBT_AGFL_RESERVE	4
 
+/*
+ * Calculate the number of blocks that should be reserved on a per-AG basis when
+ * per-AG reservations are in use.  This is necessary because the per-AG
+ * reservations result in ENOSPC occurring before the filesystem is truly empty.
+ * This means that in cases where the reservations are enabled, additional space
+ * needs to be set aside to manage the freespace data structures that remain
+ * because of space held by the reservation.  This function attempts to
+ * determine how much free space will remain, in a worst-case scenario, and then
+ * how much space is needed to manage the metadata for the space that remains.
+ * Failure to do this correctly results in users getting ENOSPC errors in the
+ * middle of dependent allocations when they are close to hitting the
+ * reservation-induced limits.
+ */
+static unsigned int
+xfs_allocbt_agfl_reserve(
+	struct xfs_mount	*mp)
+{
+	unsigned int	ndependent_allocs, free_height, agfl_resv, dep_alloc_sz;
+	unsigned int	agfl_min_refill;
+
+	if (!mp->m_ag_resblk_count)
+		return XFS_ALLOCBT_AGFL_RESERVE + 4;
+
+	/*
+	 * Worst case, the number of dependent allocations will be a split for
+	 * every level in the BMBT.  Use the max BMBT levels for this filesystem
+	 * to determine how many dependent allocations we'd see at the most.
+	 */
+	ndependent_allocs = XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
+
+	/*
+	 * Assume that worst case, the free space trees are managing
+	 * single-block free records when all per-ag reservations are at their
+	 * maximum size.  Use m_ag_resblk_count, which is the maximum per-AG
+	 * reserved space, to calculate the number of b-tree blocks needed to
+	 * index this free space, and use that to determine the maximum height
+	 * of the free space b-tree in this case.
+	 */
+	free_height = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
+	    mp->m_ag_resblk_count);
+
+	/*
+	 * Assume that data extent can perform a full-height split, but that
+	 * subsequent split from dependent allocations will be (height - 2).
+	 * The these values are multipled by 2, because they count both
+	 * freespace trees (bnobt and cnobt).
+	 */
+	agfl_resv = free_height * 2;
+	dep_alloc_sz = (max(free_height, 2) - 2) * 2;
+
+	/*
+	 * Finally, ensure that we have enough blocks reserved to keep the agfl
+	 * at its minimum fullness for any dependent allocation once our
+	 * freespace tree reaches its maximum height.  In this case we need to
+	 * compute the free_height + 1, and max rmap which would be our worst
+	 * case scenario.  If this function doesn't account for agfl fullness,
+	 * it will underestimate the amount of space that must remain free to
+	 * continue allocating.
+	 */
+	agfl_min_refill = xfs_alloc_min_freelist_calc(
+	    free_height + 1,
+	    free_height + 1,
+	    xfs_has_rmapbt(mp) ? mp->m_rmap_maxlevels : 0);
+
+	return agfl_resv + agfl_min_refill + (ndependent_allocs * dep_alloc_sz);
+}
+
 /*
  * Compute the number of blocks that we set aside to guarantee the ability to
  * refill the AGFL and handle a full bmap btree split.
@@ -150,13 +223,19 @@ xfs_alloc_min_freelist_calc(
  * aside a few blocks which will not be reserved in delayed allocation.
  *
  * For each AG, we need to reserve enough blocks to replenish a totally empty
- * AGFL and 4 more to handle a potential split of the file's bmap btree.
+ * AGFL and 4 more to handle a potential split of the file's bmap btree if no AG
+ * reservation is enabled.
+ *
+ * If per-AG reservations are enabled, then the size of the per-AG reservation
+ * needs to be factored into the space that is set aside to replenish a empty
+ * AGFL when the filesystem is at a reservation-induced ENOSPC (instead of
+ * actually empty).
  */
 unsigned int
 xfs_alloc_set_aside(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
+	return mp->m_sb.sb_agcount * xfs_allocbt_agfl_reserve(mp);
 }
 
 /*
@@ -180,7 +259,7 @@ xfs_alloc_ag_max_usable(
 	unsigned int		blocks;
 
 	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
-	blocks += XFS_ALLOCBT_AGFL_RESERVE;
+	blocks += xfs_allocbt_agfl_reserve(mp);
 	blocks += 3;			/* AGF, AGI btree root blocks */
 	if (xfs_has_finobt(mp))
 		blocks++;		/* finobt root block */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d6ba67a29e3a..ec1f7925b31f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -987,6 +987,22 @@ xfs_mountfs(
 		xfs_qm_mount_quotas(mp);
 	}
 
+	/*
+	 * Prior to enabling the reservations as part of completing a RW mount,
+	 * recompute the alloc_set_aside and ag_max_usable values to account for
+	 * the size of the free space that the reservation occupies.  Since the
+	 * reservation keeps some free space from being utilized, these values
+	 * need to account for the space that must also be set aside to do AGFL
+	 * management during transactions with dependent allocations.  The
+	 * reservation initialization code uses the set_aside value and modifies
+	 * ag_max_usable, which means this needs to get configured before the
+	 * reservation is enabled for real.  The earlier temporary
+	 * enabling of the reservation allows this code to estimate the size of
+	 * the reservation in order to perform its calculations.
+	 */
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
+
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction
-- 
2.25.1

