Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB753A8FEE;
	Fri, 10 Jul 2026 08:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673632; cv=none; b=eDTMKf2raAwahTfIQ3nJSjoX9pY7/BaFXkk5rBR/O0UZw6A6J0jb9vfsCbeD4fHOAWbLiFOW3q+GSiuMNG+zmJFIGS9zqkBCOghTZGa7mKMnYixYnV40zUrNFjeGD8Ug8tBkEWU6oxog16uRJzWcY5B+imJBEypZgQjaVU6XpAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673632; c=relaxed/simple;
	bh=gHl4HQg4dFPXM12xo/VO+LNovevHv2UmpG8XKevlUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0vU9yEeSKtMNvu/9WO7xh4yJiE4V5iOOnSvXkYBA9qFAfnBDLwA2WvF7no1q2QyxVvRXXQ5j68QXOR+cZTjd8yQeLMGsAn2IDUm6P75IJkSXtV4NlaHeag3c4NswfodWdlHd+h9xelFQwjJ5R4Z0l9cFGT4DXiacNL/ArBDnos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpHW8/4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpHW8/4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7001F000E9;
	Fri, 10 Jul 2026 08:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673631;
	bh=AufMkm+nEeCieeEcnf+ZJSfHdxMb9GSGIeKul87lEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpHW8/4hhlbrsOcO6ZafXnA0IDkVXTol2jQ+7eP1XhicYKgQ4BBeBoPDTrWRPpV+z
	 eljExR63J378GwzWaRjDyM/2IFg8M9htrY7Jy9LSRYn/bL+6wBls7zlJd1ILn0tb9z
	 pAR8zGRiHnf/C03iQUvczhznYye1P6MUfvuesYlsJ0GaMcaKTkgjlEE/CDh7gNZBKh
	 jSj/ZHIXtN550HH+qoCZAkld8wrv+5/WowazTHsQ+7ZT5uRZ2u4i9Hzhg+rUMPQvth
	 8ar40ri19VQKYIrP53v00eKCTJzAh0oYO3vPksc2wwaZJ3EiDGWm0sfkxePJEQER2+
	 sVjS+S1Y38Mjw==
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
Subject: [PATCH v11 09/20] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Fri, 10 Jul 2026 10:52:37 +0200
Message-ID: <20260710085256.3464201-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

