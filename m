Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C5631A80F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113466; cv=none; b=UwM/xmoIsHG5FkzsTHL9OiKbRbEXfLoZuZ+Z/b3fHNeMiRdJecpAtG/uY2Pj73jKpvg6mAX0Tjl4x0FvqhnWMWis7LOXhANO/4rV5N7fx0DQ8KeVK1pL/gKMWTxpBDsS3ytz7P/EhQQjbJFAJ+BkuW0xxsOOvzSHzOz0uLIdJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113466; c=relaxed/simple;
	bh=7/jM9gXI6PUs4G+y2M63n1rJwb5MMNzEG0YOG2T6dHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOkBgnOTKt78VklXpttmtpH80irSZF1Dw1WaTqDOmX6deIl6dmQpS3cXaeymoItdLjRkXjSGX+vmj5s/mXOwGvEmOuwC7g9WJjO3ActIw0J+fz3L5vzDvvPZUET1XBqDzcwc0hLskZyYjDaaHaKTUc1j73E44sK+6/V/aqYE5G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeW5xgD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeW5xgD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4435DC4CEFB;
	Wed, 17 Sep 2025 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758113465;
	bh=7/jM9gXI6PUs4G+y2M63n1rJwb5MMNzEG0YOG2T6dHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeW5xgD8XIXXgnIs/5pGgDmQE7pr4q/njGZa6WQOJvWLiJl+WNeU4yTYDGcxGZkVp
	 98HrQZUvQTSOKfiJPATT4voJvHKSyRvkHqjUXyccSiNkrZP9G0Z9V1rAIkM4D3Ol2p
	 N5pq2HuSvDz4UkgICk1l1djXekzaP1As5DI3/Y703R3n5oKV5pxh3emLRkq3923UQA
	 VibqUMVCN+RYHRzzFo7x8gBbizpZBmhJGtjt8K6Pu0dbBSF85WEDOW4yw+q9L8VaQA
	 /IM8sr1KwSz1VXFS6BpQo6cTcAlsqS0ZZ1k+7DtLrfWHxgS03TLYjPDUkLhqDqMu5f
	 RH7pR0S/oELTA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: Improve default maximum number of open zones
Date: Wed, 17 Sep 2025 21:48:02 +0900
Message-ID: <20250917124802.281686-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917124802.281686-1-dlemoal@kernel.org>
References: <20250917124802.281686-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For regular block devices using the zoned allocator, the default
maximum number of open zones is set to 1/4 of the number of realtime
groups. For a large capacity device, this leads to a very large limit.
E.g. with a 26 TB HDD:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks size (23959 max open)

In turn such large limit on the number of open zones can lead, depending
on the workload, on a very large number of concurrent write streams
which devices generally do not handle well, leading to poor performance.

Introduce the default limit XFS_DEFAULT_MAX_OPEN_ZONES, defined as 128
to match the hardware limit of most SMR HDDs available today, and use
this limit to set mp->m_max_open_zones in xfs_calc_open_zones() instead
of calling xfs_max_open_zones(), when the user did not specify a limit
with the max_open_zones mount option.

For the 26 TB HDD example, we now get:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (128 max open zones)

This change does not prevent the user from specifying a lareger number
for the open zones limit. E.g.

mount -o max_open_zones=4096 /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (4096 max open zones)

Finally, since xfs_calc_open_zones() checks and caps the
mp->m_max_open_zones limit against the value calculated by
xfs_max_open_zones() for any type of device, this new default limit does
not increase m_max_open_zones for small capacity devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/libxfs/xfs_zones.h | 7 +++++++
 fs/xfs/xfs_zone_alloc.c   | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index c4f1367b2cca..6005f5412363 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -29,6 +29,13 @@ struct xfs_rtgroup;
 #define XFS_OPEN_GC_ZONES	1U
 #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
 
+/*
+ * For zoned device that do not have a limit on the number of open zones, and
+ * for reguilar devices using the zoned allocator, use this value as the default
+ * limit on the number of open zones.
+ */
+#define XFS_DEFAULT_MAX_OPEN_ZONES	128
+
 bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
 	xfs_rgblock_t *write_pointer);
 
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index f152b2182004..1147bacb2da8 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1131,7 +1131,7 @@ xfs_calc_open_zones(
 		if (bdev_open_zones)
 			mp->m_max_open_zones = bdev_open_zones;
 		else
-			mp->m_max_open_zones = xfs_max_open_zones(mp);
+			mp->m_max_open_zones = XFS_DEFAULT_MAX_OPEN_ZONES;
 	}
 
 	if (mp->m_max_open_zones < XFS_MIN_OPEN_ZONES) {
-- 
2.51.0

