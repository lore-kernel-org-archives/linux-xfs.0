Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547DE19343E
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 00:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773532849; cv=none; b=W1A/fyjfGWjJgd28A2D1oSJFHA8JO8LWC268VxBy6TF4tXU0GiaxyONjc5PYN47KwLaAMVw3hVoFxJpcmpVoziFi4Xv8X3cvgpacWwBMvW1nn8F19lEGJplGPRKdN4virJguNh4EsI3zL29UqgCsTuNJHbhTYylT8RCaVxOKVtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773532849; c=relaxed/simple;
	bh=h+87hQuyl6UpELTdK12nlsc71JtQ2KMfVDPBw9CIQfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvYrOAMwUHRvvktUzHpovOvO5nRJrDB/UAOzDuU0PiFE/HRyNUohHVNIbQf0kKY1TwWCNHhy0Rg14h65sJZ2T5d72Ssab0TrueshtpQIYz2CNfIvq06Ir0lEkShHIPK03TpDHqbgkohZmz9snfsJ/2MZTsLB64Ibo2QhoXXKciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4XPbxyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4XPbxyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4C1C116C6;
	Sun, 15 Mar 2026 00:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773532849;
	bh=h+87hQuyl6UpELTdK12nlsc71JtQ2KMfVDPBw9CIQfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4XPbxyjLGTCd1ZOal2EwAoYoiul5pXWAmHg4LDv7jBeIfjdciVy2BkgvHbt65Jv1
	 4jmiSHEsJhA+cAICsSVLUB7A+XeOFkTGlBD3IkvWYs5OcPkd89QC3CQzQa5sj/rdn4
	 CF0riP/5UasVBKN4rDipc2K0CoNcZyySjpJwqA6a1ezH9gH4PfnAUOzHqCEJ8fEogL
	 w9LLIIRqlhYz3q6NgBQv5CYBszJJ16/H2mLF1qNRqlFzEw8IwTLGDHAL1Ytq5wy29d
	 wga6OmLf6O/L1KIm9sg/qY3KdH/vpUczHE5BEuBgIojUQGDSQwOCfvxFtJ348aDX0I
	 ug4XvjUltPoLw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 3/3] xfs: improve xfs_zoned_need_gc()
Date: Sun, 15 Mar 2026 08:55:08 +0900
Message-ID: <20260314235508.183984-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314235508.183984-1-dlemoal@kernel.org>
References: <20260314235508.183984-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If zonegc_low_space is set to zero (which is the default), the second
condition in xfs_zoned_need_gc() that triggers GC never evaluates to
true, so there is no need to calculate the test threshold and to
evaluate that condition.

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

