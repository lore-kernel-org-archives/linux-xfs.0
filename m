Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB31B2BE027
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820040; cv=none; b=ZLSjGuksIM1J/Ym85Sz1jk949bg85XXamhwcpXUKc797sde6REnujUnKHW1Q3mZS+7uQIIh5q77TFVhGRwPb+KFlCenm+AHYWJ6BHX5x5Hsy0Z7ZnubTBeL4m3jYvd0EGdSw8xkep23Rx52WbDURH21UxyKwE5G+S4zwaqdCat4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820040; c=relaxed/simple;
	bh=T9zIFpDnJzUoZVamDsPqLWHTrnJC1gpoYyszcb/BEgY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jv1PqsSfiAYkIvTv6sVIkVvi4Aw0llb+yIUs5BH9YU73ub0tXJ2NChEXc1ZNtU5k4wzIh2WFJLVWNt5kh9bfv/EFBNafoTiwdcjCa2z3AlZ4YZ3envNPK26CsSiU+dOkkrMyKWUmlRM8P69yBR/OPxPvYEj7EV+x6+Z/u8dUeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHGDtgW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHGDtgW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE7C4CEF7;
	Tue, 29 Jul 2025 20:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820039;
	bh=T9zIFpDnJzUoZVamDsPqLWHTrnJC1gpoYyszcb/BEgY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RHGDtgW85amWWodkTgBP2/LFVFsFPRSwe8d8KAVc2xzvg6lJos8Z8KfpdzyB1j0ZX
	 6TR7okONvGHcSp/Vl/JvGShQF8ZW4nP9JXrnHd5aCZBcV6YbUvlhLZzOfBymKctHBO
	 DE96SohpX1H8dc7teAgV0UBcxt+iO41HGDl+T9GUvSofoXfPw96mHaWhkPURs2b86J
	 OiTPKZ0/8AfGIbJ9WVhbH4GDuUxbRjmFUgsCd3JLjxKEkFIq1kq7uRzOYQZEH0MrlC
	 mTNw/MLzmlsjHmr7IsrDNWC2cd6hx7VSqkFvmoV395TaxbdW8MUCpPFOxDXLqmuEIh
	 Rj8+e/iZdcKZQ==
Date: Tue, 29 Jul 2025 13:13:59 -0700
Subject: [PATCH 2/2] xfs: don't allocate the xfs_extent_busy structure for
 zoned RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175381998816.3030433.5519105974751924380.stgit@frogsfrogsfrogs>
In-Reply-To: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
References: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 5948705adbf1a7afcecfe9a13ff39221ef61e16b

Busy extent tracking is primarily used to ensure that freed blocks are
not reused for data allocations before the transaction that deleted them
has been committed to stable storage, and secondarily to drive online
discard.  None of the use cases applies to zoned RTGs, as the zoned
allocator can't overwrite blocks before resetting the zone, which already
flushes out all transactions touching the RTGs.

So the busy extent tracking is not needed for zoned RTGs, and also not
called for zoned RTGs.  But somehow the code to skip allocating and
freeing the structure got lost during the zoned XFS upstreaming process.
This not only causes these structures to unnecessarily allocated, but can
also lead to memory leaks as the xg_busy_extents pointer in the
xfs_group structure is overlayed with the pointer for the linked list
of to be reset zones.

Stop allocating and freeing the structure to not pointlessly allocate
memory which is then leaked when the zone is reset.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
[cem: Fix type and add stable tag]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_group.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 80b6993cc9916e..b7ac9dbd8e79d6 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -161,7 +161,8 @@ xfs_group_free(
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 
 	if (uninit)
@@ -187,9 +188,11 @@ xfs_group_insert(
 	xg->xg_type = type;
 
 #ifdef __KERNEL__
-	xg->xg_busy_extents = xfs_extent_busy_alloc();
-	if (!xg->xg_busy_extents)
-		return -ENOMEM;
+	if (xfs_group_has_extent_busy(mp, type)) {
+		xg->xg_busy_extents = xfs_extent_busy_alloc();
+		if (!xg->xg_busy_extents)
+			return -ENOMEM;
+	}
 	spin_lock_init(&xg->xg_state_lock);
 	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
@@ -208,7 +211,8 @@ xfs_group_insert(
 out_drain:
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 	return error;
 }

