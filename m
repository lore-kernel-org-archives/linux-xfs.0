Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728A411A03;
	Fri,  2 Oct 2026 22:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980662; cv=none; b=cGxSEqMXofp5l63Q1E3EYjip/9r2YpoMYSdGvpijvwWQRSLUS8IdyukoazK+a0+DwPIsrRPBUrD5Z6bn4cUfylFS166MikXj6zRKlaHo/LB72Dz4PSCHJZ44atzZWEtphipgLs1msSd3q+3Zgp5zX5LryH2E1XySwFwhSDPfda8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980662; c=relaxed/simple;
	bh=H/e0P+UlJBXIJCMWsp5bxESKBgwV9KeCad/muhyUdmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubcyZoHHN2UCZh7YhHopAoMGVbY2JDn29M29vhLc/f+ocN4f9lVZ3+97ORNYI5YBg0yt6X+68unlRB6TYtJvGp+jP3eEHpOTIq/j7MU0P905FkaGfl2IJRgC+m2gToXm+0prSYGphmxjUfES9jLHQTwosDS4EEEco3eihICbM70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Is6rdJmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Is6rdJmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFA1F000FF;
	Fri,  2 Oct 2026 22:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980661;
	bh=tyN8+gtU92vgNY5ULImxmqhPQNG/e7/IRfFO6L6Bczg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is6rdJmm0F740AinrlD2eXqyQ7AnNrjuP5QcPizteoY4fErQuf4b372wSufcyTpwG
	 DfD+ogqXcOEEIPLqRu0Xk0Q0cVs0mDcylKHW1kpe0MeZA38YSOM7QGzEd0oBIGxk5E
	 XKJCJgZOqTviIv0Kj0/07h3MT0BfC2AVswMpbecJ1bnTwWIWMqpMBPB+nbzbYmA6/y
	 jUmZvZ4AghOwsfooqgtmHwV10fPRswe04TVonX12wfSorIksJk1tCl5zRUzl7ZhIPs
	 874hWB8sD2Y7C6+h+JOurBcKXIph4D5k65eIlzYgko16vJfHbLuleABmueEyMx+Uap
	 hynN3EuS5Zovg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 08/21] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Sat,  3 Oct 2026 00:36:49 +0200
Message-ID: <20261002223705.2175542-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c7ecbb3d258a..b07ca2a33c64 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1369,6 +1369,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0

