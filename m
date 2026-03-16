Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEB42BE655
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661564; cv=none; b=hfu2l+xFLSALXR6hQ0dku+dtdEhNUDchXshxK/CPKDh3kkuFm04FtH54tha1hPhtEC6t31N4VywwtQkRW2jtfnhQgSiGV89TvNJqu8COy5C8qZ++eXFDoqQn7jwPNg7jQR3FBPBVbTmfsk8ekNcJ16pNGDeZQ5TJv9d51Tn0piI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661564; c=relaxed/simple;
	bh=HRNvG3V2cDzssZjFo/tvZ1rnczZmzdwjyr12sNN/I/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGlqlKXxRvPXsZeiTdVWLCwyietkRukiVGRbWCgLUoRuVznlAeR5otnz18Hv2ITnPPxvI5piCozaKEuHKr7aDtPjGs9YxbfnnzSCus7E10YsDpC9uRsfcbX3IJobaP5IlHy6dz0z9ZMA2/FmM/gutPnYzrAWX+F3HFL1X7Wueaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bO9VkEFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bO9VkEFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80029C19425;
	Mon, 16 Mar 2026 11:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773661564;
	bh=HRNvG3V2cDzssZjFo/tvZ1rnczZmzdwjyr12sNN/I/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bO9VkEFzwQ/XAE570E0iOOtNAPN6WOUmaJ5IE/EXRvh87eXBPO920tKz5gDukepaM
	 yVsl62KM7Xtw5G4hE5f5JRquMQlSoszCmALToMEIrlyMhbnYdTsIa9p0sy1IAkgw3t
	 2INe3BjzPAxQbYFrse2l3kCGGHUHM4tGbXL5AWUlQiUxNxkHBBVTDK9zej9OSqJ7O0
	 BWGAyjnHt+jMYUWv7WbsBxMSK8gBAY6QMhE70dMmiDjQM5ACgMHB4jW1wUG7LJn8+s
	 A+5JYIiZ615aNZ4/OApGJ/tXfb+9j1M+wzH+cljp7PGvRhuI1qcb1OZh9jsXGGJcjG
	 ZU9FyAdiGakTw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 3/4] xfs: display more zone related information in mountstats
Date: Mon, 16 Mar 2026 20:40:19 +0900
Message-ID: <20260316114020.753228-4-dlemoal@kernel.org>
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

Modify xfs_zoned_show_stats() to add to the information displayed with
/proc/self/mountstats the total number of zones (RT groups) and the
number of open zones together with the maximum number of open zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_info.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 53eabbc3334c..a2af44011654 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -90,9 +90,14 @@ xfs_zoned_show_stats(
 	seq_printf(m, "\tRT GC required: %d\n",
 		xfs_zoned_need_gc(mp));
 
+	seq_printf(m, "\ttotal number of zones: %u\n",
+		mp->m_sb.sb_rgcount);
 	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
-	seq_puts(m, "\topen zones:\n");
+
 	spin_lock(&zi->zi_open_zones_lock);
+	seq_printf(m, "\tnumber of open zones: %u / %u\n",
+		zi->zi_nr_open_zones, mp->m_max_open_zones);
+	seq_puts(m, "\topen zones:\n");
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
 		xfs_show_open_zone(m, oz);
 	if (zi->zi_open_gc_zone) {
-- 
2.53.0

