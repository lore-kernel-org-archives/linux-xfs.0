Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1109F3081DB
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758200654; cv=none; b=i8muKQ9v4V1bC8daSvSMOlPmFLhK773fVBEwNcgide89YYFHmgSMhsQDVVQq+Zgc45AfGWFU0DTF9fpBODA9CpYnX3dPlx66/k3+zYpVwhHnPkozrv72c9vZ/DRmnMZWrDNjs7cWKTYAXelLKXDQcJvRq4baWRMczqyqTUDt3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758200654; c=relaxed/simple;
	bh=chPFWJ8KfpbmLmpNVLbhulnAFfPV1b4U87sOv2Mzlzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXzu7iWvYk/lPLLAGOI3N3pvA5384F+loBE2/5MdY8UTtjQ2AovpWNL502qnnRpGgpM9J8VbLkvPVk7WYbCVmHaj+oc8TQt2yQtXzLuC9Pj3m8If8m7LBCUOiH9dIMibfrS41CfEt8STIN4u+fph5zZtbi1wP3YrzfXr/jGOLFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MBFj2uqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MBFj2uqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A27C4CEEB;
	Thu, 18 Sep 2025 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758200653;
	bh=chPFWJ8KfpbmLmpNVLbhulnAFfPV1b4U87sOv2Mzlzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBFj2uqbC71RrW82i8cw9NZ5GYvNmqIl+78kaVDPlC6fIbVAIbgqQKp5Nyd5Payuh
	 z2vhP8F9Oe7LZAEsPZA9cgQUKIAJJdWj0Q7BhKJBlhYheVM8kj1VPf3yFp6HWNPacx
	 ky8lII08VYkRvdgOH+2Cccb9fmcRufXf6K6VnSL9OEDi8LzxEWrIM96wjOWZ0K2tAX
	 ndwtlS1YwSL7t6mc7YFLoByqlSYaYmbULaR8zYhhEBOFej0Wz+VJvPHRO5DVOIK1kA
	 2tq1oBWJmqjSLX8mdl6B/hzhKFXVSosrppPPFNeFQogc+mjI1cJzFx6xMHFzZNEvFP
	 jhsMyreWG/7VA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 2/2] xfs: improve default maximum number of open zones
Date: Thu, 18 Sep 2025 22:01:11 +0900
Message-ID: <20250918130111.324323-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918130111.324323-1-dlemoal@kernel.org>
References: <20250918130111.324323-1-dlemoal@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_zones.h | 7 +++++++
 fs/xfs/xfs_zone_alloc.c   | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index c4f1367b2cca..5fefd132e002 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -29,6 +29,13 @@ struct xfs_rtgroup;
 #define XFS_OPEN_GC_ZONES	1U
 #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
 
+/*
+ * For zoned devices that do not have a limit on the number of open zones, and
+ * for regular devices using the zoned allocator, use the most common SMR disks
+ * limit (128) as the default limit on the number of open zones.
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

