Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527842D978C;
	Mon,  9 Mar 2026 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084297; cv=none; b=JPlG6uWTp1tZakILqiBPRnpqrZg9+mfhjPz+iG+Ztsz8Gd0yAdxArUm1Y1VwsEnkmN6w5Trf5g+sKEHlKmU3zvQo0kDxKj5EfLoEoSJL3+TlCdBpcTLNQfLsTpuFwIgG7Rz+v++S5zEQ9fqSkoFpEwpX5LsGLUJDcjPCxBIbotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084297; c=relaxed/simple;
	bh=s36P9QLO9GzyT4MQJjm1imoOYbBZv4qo+rih8qa1TLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNXn/VpEsr6ZSgBCxCs/ev3S1F1/7LY7XHlIhZLH+OdFpYB/wqat4sX5tbitDn2+mmNws4+5ah//k3hmWYFj85PNVdj9Ud+CoO0XKzZGBgrrS7fi0W+8QLCYK9UnQZTvr8Jvg6LldtTkkYwJS9XmjQQ8TAlMcKNIyiR2WJYohRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmlOH6t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmlOH6t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0188CC4CEF7;
	Mon,  9 Mar 2026 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084297;
	bh=s36P9QLO9GzyT4MQJjm1imoOYbBZv4qo+rih8qa1TLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmlOH6t/AYMMSVzn7e2cKoH+NFkC/02o+EZCSm0XQ+Vj4VMLTVkjwkssNON5py85C
	 By+P6uYfsYaodWWbsNRBHl+aQEEce/Kbfs4miq3/yl3YbcxaObroqv+dt2ZLeyUxq9
	 LEkq/Moi6rslxLIXVImO/H0xVuSQhhMncBgRf1e9CBzeFB3BgK+DI1ELxXj4MEzcfN
	 T4zEdXyG2Fer9x1BXxlV5y6gArwyxu7Ylwom3sMT16iOD4QQEaoHjKtLvGbV7ggycv
	 3/SKTnrPjCsJHMuf4/utaYFxyw7197MTO88/iLs4MfoxlOOv2LXTip4fyBVTy3QUKx
	 +eui7uEXxzVCw==
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
Subject: [PATCH v4 14/25] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Mon,  9 Mar 2026 20:23:29 +0100
Message-ID: <20260309192355.176980-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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

