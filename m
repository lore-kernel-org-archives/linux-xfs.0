Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAB82BEC57;
	Thu, 19 Mar 2026 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939797; cv=none; b=qdvE9mzoR+cSzNm5uFJmR3VCyihhzIjtzGkVnTSyGTVDynhaAB6ZJckMICvZl8ifD55RoKn6fWUReoc+X9RFZtnCW38tRoZOoOFLxvGxsMU8Vy4h31aeAuQLfYcjUnk1jl8Rk5VN7rqf7hznEDV2fm9Vn7H+mc4/XNTylJVfys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939797; c=relaxed/simple;
	bh=s36P9QLO9GzyT4MQJjm1imoOYbBZv4qo+rih8qa1TLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk2be4tfRg1b1jGSEK1WGk497M9CjHYo0kP4Xqbp8EiEs1bui2kAmG4pd6rL2ya+CPVKGARhQfJVSiDJePg/kHdT863U75a+TqLbhmq1zv4pevJ7ewNG/YTfO/IjrW31SLf+bpUHpzGSOn2Wh9psOuj6Ol1Ma0IPnMet9s79nlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9kO058N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9kO058N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA5C2BCB5;
	Thu, 19 Mar 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939796;
	bh=s36P9QLO9GzyT4MQJjm1imoOYbBZv4qo+rih8qa1TLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9kO058NfDCusHyTyG1DgKcXwDeiFFv/WA30KSEvb4t9/RZzYDbpTeqRAJjMR1J1+
	 LiInizcGOD2fZdss8Tg/5ZFjC12hxScN0tQ5IJ3arW3lPpfjgVpVc1yWE2OhQPphlo
	 VjWd4ELPC3fhcQzs5xUAipzzN89dxTSm/Srmphw9OXg/GU0vyXjLDC7sayfOeIaJRX
	 4UgmKPtJrnbGT1ytnGAtc4Vuix8O/RRzC1PA59FDbDr6lq4NddNcB6yJK7F8yEutlK
	 6/f+zxd7i4jLmvhAhEtbpdZ/pk9pGnk7/CTLVL9d+RYZRoDDx8ygpL4AhDPfqFzIRg
	 tRbHU7Bmy9LaQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v5 14/25] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Thu, 19 Mar 2026 18:02:01 +0100
Message-ID: <20260319170231.1455553-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
[djwong: fix typo in subject]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ca369eb96561..17efc83a86ed 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1387,6 +1387,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.51.2

