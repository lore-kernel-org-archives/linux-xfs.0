Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AC63002DD;
	Tue, 28 Apr 2026 08:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365271; cv=none; b=nJOk+TaNPWqqo+gpIb3Iyc5st7L7kacn34PLe3T4eGmHtXlZoU+6Ncysl59MTyO2wGnAeMYgNAK7np5sy+aIbnhtaKw+92P6yIhLezC9qbUR9nMPxgp/fZ7W3/dUrb1sXe37Zl/TaQ5nkmsa7e1yzPdhDPGkO+NjBrIOPIzTq+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365271; c=relaxed/simple;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWq0ldL4MSnXEFqT4BQ4wD4SeNpn36aJwmpYaVFS1FfrEYNyYQR0P3wKTQHSdxG1UQ5fTjW+pmiHVlNoyiBuyqqheMcG04JigjscZ7tzVrTx6GxN3JFWuWyV4mS/shzGJSg9i8RPNAcgUmSU0HikQEDxiKxDxD6JOgKV47a0+0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uExNpB7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uExNpB7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D48C2BCAF;
	Tue, 28 Apr 2026 08:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365270;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uExNpB7lI5TLuU4iiAvSboz4KLVlP5zUbA9lfKW0aRGF7UG0X8l9xYAp7I6VFbT18
	 CwsJybc0TMAVm6cgCGoAghdhG1lK4Qgn+3L0y6+q4rY9+bIdvZDmyaITu3pQsfZ4im
	 dhRxqs369iOhGhCB4RuHQCOFHoL2YtnocKU/U8BixF2IiaMiIUPqhW6gLqyxg6CAJx
	 CCGmlZ9xky32NRw1lTVRlj6us/SjXfwOfxu1vlO6S+iUvFF4IDd7xPcPJQ5XqRlUPR
	 dtPt8rturOOJQ2b6o/kXgKnPryFRyIF/1dgtGUSiXDBRMVNXAECbth70Ee7RL5aQOi
	 A9w+H0rXfE20Q==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Tue, 28 Apr 2026 10:33:18 +0200
Message-ID: <20260428083332.768693-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
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

