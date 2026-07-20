Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CFA3D3310;
	Mon, 20 Jul 2026 09:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538298; cv=none; b=UxVgUbqK6snb8vGqwklF17JD+3+CTF4QdP2Ylk8OPeL5Mw3eeq3Ds/cGteQRJl2MxWDljcKmjUK5nmc3l5txbRPjq3unnG/sqzDIQwE9Jm3SJHMBXDel6jRuhmpEpnXFKXIgT5YA5+RuUKGMZ4WfQ2KHd1SlBaD0rRV8bIBi7d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538298; c=relaxed/simple;
	bh=gNzjl4zWpkZJaicQjAemkaolWXKfIV765MdaOnGpKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBc4u1wqzWmtgZn8dzoOUXMAh98baofmMBs4GN1dce6wEszleqLunZD3B4i0j2h6gO+EfaDrKldQ7G+TC1Tm1T/QH0S6FgUDydq5Nsp6zJAMaNsUshBQ1SfbY4g+oBdDMOo+rKRJgLXtEueuEdky+3KagXLxqfJgZEQQuhjJwQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFDAmq/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFDAmq/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04351F00A3A;
	Mon, 20 Jul 2026 09:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538297;
	bh=DLKRiRyzKQ3SHGS6qPdEtB2Y8TKgDvD/nkziuhY4NXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFDAmq/O751nHlfU/ysdhZmnBEWGVNmgKL/GJ0Hsmsgp6bGK0JW8eyw6HE4D71qt+
	 KX6NFjlIn4w7Z/kbfcrk8a+97KBN0dDhVXBrF0c0jH5AYgqn+yRtP9iomFIB1AiLFi
	 XDsLi5FRHMh/JGHyKUoUQ/DQzREaC047TUlHNQXJRqmIRiJ6hr7X/7pmJs56gf8ffJ
	 F9KSkf5dE0ni1nbEYf4oA0uKO/ZgWDyM5tkqqwXS2iV/T0R3OhUJJbueRwhr7GZ3hE
	 ZKg1fdUn+EjoVCQadALnHZ6K5hE8FbpZlneVpK8LG7TIAS6FTJMy7FWPdGyTEYRw5G
	 k36r96HzKlXgQ==
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
Subject: [PATCH v12 01/21] fsverity: report validation errors through fserror to fsnotify
Date: Mon, 20 Jul 2026 11:03:29 +0200
Message-ID: <20260720090410.3487990-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported verification errors to fsnotify through recently added fserror
interface.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/verify.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4004a1d42875..db8c350234bb 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,6 +9,7 @@
 
 #include <linux/bio.h>
 #include <linux/export.h>
+#include <linux/fserror.h>
 
 #define FS_VERITY_MAX_PENDING_BLOCKS 2
 
@@ -205,6 +206,8 @@ static bool verify_data_block(struct fsverity_info *vi,
 		if (memchr_inv(dblock->data, 0, params->block_size)) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
+			fserror_report_data_lost(inode, data_pos,
+						 params->block_size, GFP_NOFS);
 			return false;
 		}
 		return true;
@@ -312,6 +315,7 @@ static bool verify_data_block(struct fsverity_info *vi,
 		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
 		params->hash_alg->name, hsize,
 		level == 0 ? dblock->real_hash : real_hash);
+	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
-- 
2.54.0

