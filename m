Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DD27C179;
	Tue, 22 Apr 2025 11:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745322158; cv=none; b=BLwvbSyhiF5ytTbOotvIjkRTAxFcO4pOqhM+NE5kiwBasD/u0hLWX5f2834s9XG7NxushEYHWA1OG+7Sb0JcWZ4hPSoYzf9I42/qZE3oNg4qDuT1bgbxqFrlMT+lxZxcNI0XtzwPoMKjv3I90Rt6yEc6ThAH29PEbG0we4ReQlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745322158; c=relaxed/simple;
	bh=guD+pmTen+SJhmKQrtY4L3C2tvnC0Lj1veqlQl2WMC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFQR31dvL+/6Wshwf3Ks5f4hwEMDyo3dWf+sRJMc5k3RkfgN4R4TFiMBi16g0vaik6trVrLiD+SZj9XKHcokPwWW8pRBDhSI8AWb+UM4JjUA+izWeO50j9170wUToAilbTj0yzEVf+g0IAebnam+DKpOtSqukBjkyxkmSHZI/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRpxmNO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRpxmNO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35E0C4CEEC;
	Tue, 22 Apr 2025 11:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745322157;
	bh=guD+pmTen+SJhmKQrtY4L3C2tvnC0Lj1veqlQl2WMC4=;
	h=From:To:Cc:Subject:Date:From;
	b=bRpxmNO1M2nP5dfnzGb0w1KqKO0WeB86nRdQwtwoLB2BGAEO4qd/HSzg7pA+K19gz
	 KbDt7rX6WSZ0pn7PuEg+rvTS7ZFAoCD7HBmuTS9TUkqnvXke2tFBW3LJfzm7AAv83H
	 83IhDe6l02jJ6oRjFgnV4dovZM6LJmLr9fbWXjm66hRCFdrJcUkbQfLjW41lp7nuTe
	 IysQD3uOJoe4Oe7JMpNSzpFwmw1oTHTbeJ0ZB02IDAyxCr8jBMdqx2pAPVV7MwNGKu
	 JW0eMAIHQLR54qol3YSCy+DAIyYsAOkXwwoUQQXAJ97ZwLqUW150LC05PZXf4O1SQ9
	 GBMgG/vlSBB8w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	Hans.Holmberg@wdc.com,
	linux@roeck-us.net,
	linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev
Subject: [PATCH] XFS: fix zoned gc threshold math for 32-bit arches
Date: Tue, 22 Apr 2025 13:42:23 +0200
Message-ID: <20250422114231.1012462-1-cem@kernel.org>
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

 fs/xfs/xfs_zone_gc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 8c541ca71872..b0e8915ef733 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -171,6 +171,7 @@ xfs_zoned_need_gc(
 	struct xfs_mount	*mp)
 {
 	s64			available, free;
+	s32			threshold, remainder;
 
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

