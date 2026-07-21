Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B570C471264;
	Tue, 21 Jul 2026 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659465; cv=none; b=N3qIsqzlO3XN1Yx8P33W3aPQy0ujyphgXGPGIrsxocsSQ0XMy8ioSFAA0wFdHW0+yIzz8HZUwlsh9u2yVW6/WVNu8jLwuuv5XP3cDGpZfcULwW9DauAeRMUGmRrzlpFaOjCg1gpYS0dgaC1eVc5qxSyBBDSgBdPxfA6LJHWNvCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659465; c=relaxed/simple;
	bh=gHl4HQg4dFPXM12xo/VO+LNovevHv2UmpG8XKevlUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1v8ZGVqtzOkB2ixCSeyzjuPQ34/cmxGU7Mr7u0SyzYXUGIlEwAsveM1YCNEJxhmysxVZmIEcwhd5pw5orY4Z2/4/R6xYppM/cjeoPVttevKBOlIBdJYJP8bDmZrr+Az+ieHgdUMXskptsbvfYlrBF79XItXf3SDjRw306XhBDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VI8QXyrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VI8QXyrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BA1F000E9;
	Tue, 21 Jul 2026 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659464;
	bh=AufMkm+nEeCieeEcnf+ZJSfHdxMb9GSGIeKul87lEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VI8QXyrtqShahK7xudE6bynn5yytRJCy/Ch1rexov6aQhbV1FcM1eubLjeZVRXyMb
	 3Ws0UK49pp1ZQFTzOh+Dwa73FnshywWaypODoUpSt/jVneZGKElQlbmriVB7w1tdfd
	 Rc6utKZnknd9FxtIWD0GNveZu7y5ovicZgOwJ7Doyi8gtExLsHRb4L5WQXav07IFhd
	 ZtWYdPI5uSIS3gVRgM6rA0KvNDx1Xx1cCaKeVp3/0/hx4yiHKxmib9roobdJWh7NzD
	 mbB1j854JdsqVtYsmsEAK/32SNBEMuX8cgdMPfa9PHMTFadKWJUq3FaTHB3bKDWzAI
	 oOU3GEW+QHwCg==
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
Subject: [PATCH v13 10/23] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Tue, 21 Jul 2026 20:40:47 +0200
Message-ID: <20260721184346.416657-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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
index 11dc1a485ca7..55667cc762f8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1370,6 +1370,8 @@ xfs_inode_should_enable_dax(
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

