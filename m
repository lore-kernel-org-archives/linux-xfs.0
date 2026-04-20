Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E861ADFE4;
	Mon, 20 Apr 2026 11:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685691; cv=none; b=H3AWFVRuaCbvf+fRREkBfPZdcA7+Bo+VJovT+RU7//WD2/ENELELFkw/dpE+fmO0e6/7UhW07mZyiRpBLsPt0o0esM5hqtzpwKqpDTgCs9rp58nCBDV6tH9h24emokofGuw1NE/4Gcdvn+tRAS3lCPDxL5EXIlwXircTz8gkOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685691; c=relaxed/simple;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbSwmecyXDJX+nUgHItEwFodmAWFLC1Crp9AaGLEcmzZts1Ul4lRcsJsm5yhA7VOHG00ZBbFyFyLA+fULqdllmUIGoXbmWSvtN0NvCQg2F0+2uoRYeRayn+XYdvLoTkbr0KO/Ubh6PJFf0QRUpA5KECX3jYISNO3sMcyobszZLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoVamUM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoVamUM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A683C19425;
	Mon, 20 Apr 2026 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685690;
	bh=60UpzLwPFsE/OH5uzd9+hLYE021xyutp1l0GCWgkWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoVamUM9pS1DOnTInr5BB8va/ZhkdEZykl70IWr4syzFZW8mpej5TV+ISGE6nhlWJ
	 5Q7c5l5usieSIEuXOjc8mkQxG9mLF+Kzn+px1IFvFvG/eGtn0z17Aj0YvvdySsq8yb
	 CvBsbrYlyR8jiPgvtUSh3ihIymP84bYKpKGtlTjpejfGvPNjjvUewZ/WuT93smBgcR
	 acG1co253dMIb1XO9Fj9iEUN9zvxS7HovZ3ySkYBOzqwxnehLkX49qoTcSdqgzcipa
	 dxW5JGN5P3UAnwNjg7+dLz4KiQsWK69ZUL3Y+uXZPNyU+tJRcDbBNYJMigKeedO/Uj
	 vg3q0n7v1sMzQ==
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
Subject: [PATCH v8 12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Mon, 20 Apr 2026 13:46:59 +0200
Message-ID: <20260420114714.1621982-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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

