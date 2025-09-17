Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E131BC88
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113465; cv=none; b=OFB6rtspNHjgvozCC8KykvaoLEgwsQR5tN4IMMdEAnnfQuozSF9NO4C3LNdeVAbAjYzCXwtnzIbC6I1RL+JvCuneG5ns1X7jVNQhuBAOn+q/ET8uNFKfcCAV+x22c/rdJtzaD7VX1hzHoXnZYgf5klj+C3rWHu5paUQXuBcNAvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113465; c=relaxed/simple;
	bh=b/4UVrhX/GC8d5UvPj25zW81QAxq1s66H+xB5LMklQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJO4Sg/DZEMESMJ7p8pYM50yOrOuTpIRiGrx3sscXA3whvleUNXq6lUQ5X2aevjRqvuMA14/AXvmPCoBw+gi3D2sOB+h7VCKK8mB+MtP3rzJXVtPPwQpJOEOtDYDZ3JGLRn9Jqcq7DMWoG3PjaxuNx05GdpG//QOGmF+0in5GyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo15Yrdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo15Yrdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6506BC4CEF5;
	Wed, 17 Sep 2025 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758113464;
	bh=b/4UVrhX/GC8d5UvPj25zW81QAxq1s66H+xB5LMklQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo15YrdpqOLhSX6CsSO3AeyLzLTspgsFS7ixGhQJa4lDHZcnawZvNFIktMs1b/OF8
	 /Ud7x8BnZ3ZQ/S6JpWtdkUVvEqcPNMtRTc3BjZ8n1XX9dgDcmBanKGOVAKy4NAxx8X
	 6/FHIhoEX2gh3oGOWOmVsVYBhHXCmY2/VLxhKLrI/Ij/Ceg+9+8IMoxkX7VbM4VfL6
	 h55r9SoUKzHMadBiPo7K2NFCyQ51jG8/7HPg7MAoB+SC2wFpufdeQ4cUIObbsJXhf9
	 KrjmEGBoW7p7Wc2gI6aR+I/tQB/T0FWjR6fElps31laCKzh/w9Rji/co+E7A/ExESj
	 cEFRywi+fQ3Nw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs: Improve zone statistics message
Date: Wed, 17 Sep 2025 21:48:01 +0900
Message-ID: <20250917124802.281686-2-dlemoal@kernel.org>
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

Reword the information message displayed in xfs_mount_zones()
indicating the total zone count and maximum number of open zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 23a027387933..f152b2182004 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1244,7 +1244,7 @@ xfs_mount_zones(
 	if (!mp->m_zone_info)
 		return -ENOMEM;
 
-	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
+	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
 		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
 		 mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
-- 
2.51.0

