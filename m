Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AA27CCF2;
	Tue, 22 Apr 2025 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745326510; cv=none; b=T+cI8xe1W/6n4l7lFVf33xcJ5vak6nosTVuu8dSvB6w5liWA7fbvzwjIHkCo8anTq1ZmyrpWyRhEXjYwQNgHbww21d+D9xSAK2j1KxguUeX3e8CFsk6V7PPxl5C82sRbsKjZ72fin+bs3yDcqBRa12BdtkyyQlo3sdYlhnv1Ads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745326510; c=relaxed/simple;
	bh=9eY2p3AoVVE/RwV6sYc7vAydiIMq5lj6Va+B4VUVhcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pAPVu/zGIdpJOhFFMjONCSig20Q95FDRbmhlevoIOwEeNFzWJO3WCxzq1wXASnE1/QvSq/rtdo2svdpO7LsdPnvWrzHavDP75TKANQatAzmFTrlQ5unX9cc9+iiYSy8EIeE+nFShc+WB8IgL7dwNuISt90Od/Q0qTmP5F2JOy/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nv6u7BTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nv6u7BTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE501C4CEE9;
	Tue, 22 Apr 2025 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745326509;
	bh=9eY2p3AoVVE/RwV6sYc7vAydiIMq5lj6Va+B4VUVhcg=;
	h=From:To:Cc:Subject:Date:From;
	b=nv6u7BThTTDhR7LRNoQXG5IOolQaewgte5dM2M+gj5MKLC9jfx/RNfKDx+lCUbotz
	 aCQlNPEFDqIUIUxDDflxc+73vXGERd8RGbIssmhjQQmaagZ6DGCu+rhjEH6LZIhkc/
	 CxOYZzBva40YEOTD5K4AZg8h9zjIEy15P+NkOPU/FeL2W411e4Qva2RAT0+kN7w295
	 MxHxqLAW5/umIqspjWPdA5180b7xq+Smt/CteZr9Kfd3mMs62uoywp4nKwQirUeW1D
	 J9jBv0M7VQGrUY+THESONOdnjJJlGeV6swfznf9L2UXQY7qV4XpbsHB9hdmmDwUMsN
	 Umrovm67b5b6w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	Hans.Holmberg@wdc.com,
	linux@roeck-us.net,
	linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev
Subject: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
Date: Tue, 22 Apr 2025 14:54:54 +0200
Message-ID: <20250422125501.1016384-1-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

xfs_zoned_need_gc makes use of mult_frac() to calculate the threshold
for triggering the zoned garbage collector, but, turns out mult_frac()
doesn't properly work with 64-bit data types and this caused build
failures on some 32-bit architectures.

Fix this by essentially open coding mult_frac() in a 64-bit friendly
way.

Notice we don't need to bother with counters underflow here because
xfs_estimate_freecounter() will always return a positive value, as it
leverages percpu_counter_read_positive to read such counters.

Fixes: 845abeb1f06a ("xfs: add tunable threshold parameter for triggering zone GC")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504181233.F7D9Atra-lkp@intel.com/
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- threshold should be a s64, not s32

 fs/xfs/xfs_zone_gc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 8c541ca71872..81c94dd1d596 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -170,7 +170,8 @@ bool
 xfs_zoned_need_gc(
 	struct xfs_mount	*mp)
 {
-	s64			available, free;
+	s64			available, free, threshold;
+	s32			remainder;
 
 	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
 		return false;
@@ -183,7 +184,12 @@ xfs_zoned_need_gc(
 		return true;
 
 	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
-	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
+
+	threshold = div_s64_rem(free, 100, &remainder);
+	threshold = threshold * mp->m_zonegc_low_space +
+		    remainder * div_s64(mp->m_zonegc_low_space, 100);
+
+	if (available < threshold)
 		return true;
 
 	return false;
-- 
2.49.0

