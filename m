Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D67391850
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661565; cv=none; b=kd5cieE8Xmmtn+6/Cs5nDfqXjSpbA4VDx+C2Vwnsb1cMU43Pk3crtM9lIc3ewq37OsM+xDkw9p2Ni/w32B4Vwip85DGvYCp4jhs3QsAWBQQ7FcRntRu0se0IsiLwdo5p9xaxjUcwQpRqcP4KqExnXTvjJX3LQ9QlqCYLdWVfkfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661565; c=relaxed/simple;
	bh=wk2pzrsfhg/Ky5g2F01VRJNnMi4yzkZPnZVGV+yJOHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsI9oZq3ILrNHGhn0Vy9jM4ZC59yfevmIIwcR/CJmDsNGtuf0o3Qh5f6c6EULPn2uSfwtFl7h42xHJ4D4ffx5IYEvfHi/fax8tjNO81lJQ7pKUZNJ6wNJIoS045WO63MX7EGDQOth02Uq7B3LdFUs3rGdu5Ify+8hp+w1ON8yNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HB+ToTcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HB+ToTcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640B7C19421;
	Mon, 16 Mar 2026 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773661565;
	bh=wk2pzrsfhg/Ky5g2F01VRJNnMi4yzkZPnZVGV+yJOHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HB+ToTcp2y0FDbW6U/Ro7fEFNP55laRYZ2wbpk7EC53xsFIP+J2a0DAMrKuJbXYOr
	 p5tlSnQILASnnENBr5o6XS4K6MUCWkbtijVSlzC1iJkKgMUDKqU/YWHkkHut6h2rHf
	 5mCBbarj8aIovXnd3hB/uLtzNhILzjK6xVS6RdRPA1JfhUwWSxvTpEHEX2TbtkEBho
	 D8VGos6HHy+Vfp2aP0jeS2bXUBfLs2Q8LL+8zy2ADJ9GP3/VVAjCTsg3fWsLt/bGyr
	 nTt2sNt/BaSF6mv9ZcwMxMzPo2ItGv50COKAZnKniM1IIC3rB2mpJq7KrazfDtuFMx
	 ovlTuhOQY0FNA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 4/4] xfs: avoid unnecessary calculations in xfs_zoned_need_gc()
Date: Mon, 16 Mar 2026 20:40:20 +0900
Message-ID: <20260316114020.753228-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316114020.753228-1-dlemoal@kernel.org>
References: <20260316114020.753228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If zonegc_low_space is set to zero (which is the default), the second
condition in xfs_zoned_need_gc() that triggers GC never evaluates to
true because the calculated threshold will always be 0. So there is no
need to calculate the threshold and to evaluate that condition. Return
early when zonegc_low_space is zero.

While at it, add comments to document the intent of each of the 3 tests
used to determine the return value to control the execution of garbage
collection.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 309f70098524..0ff710fa0ee7 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -170,25 +170,37 @@ xfs_zoned_need_gc(
 	s64			available, free, threshold;
 	s32			remainder;
 
+	/* If we have no reclaimable blocks, running GC is useless. */
 	if (!xfs_zoned_have_reclaimable(mp->m_zone_info))
 		return false;
 
+	/*
+	 * In order to avoid file fragmentation as much as possible, we should
+	 * make sure that we can open enough zones. So trigger GC if the number
+	 * of blocks immediately available for writes is lower than the total
+	 * number of blocks from all possible open zones.
+	 */
 	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
-
 	if (available <
 	    xfs_rtgs_to_rfsbs(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
 
-	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
+	/*
+	 * For cases where the user wants to be more aggressive with GC,
+	 * the sysfs attribute zonegc_low_space may be set to a non zero value,
+	 * to indicate that GC should try to maintain at least zonegc_low_space
+	 * percent of the free space to be directly available for writing. Check
+	 * this here.
+	 */
+	if (!mp->m_zonegc_low_space)
+		return false;
 
+	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
 	threshold = div_s64_rem(free, 100, &remainder);
 	threshold = threshold * mp->m_zonegc_low_space +
 		    remainder * div_s64(mp->m_zonegc_low_space, 100);
 
-	if (available < threshold)
-		return true;
-
-	return false;
+	return available < threshold;
 }
 
 static struct xfs_zone_gc_data *
-- 
2.53.0

