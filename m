Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A0EAD24;
	Tue, 28 Apr 2026 08:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365238; cv=none; b=R9+sHsqUYXUHbEKCwMhjTrCtXNdt+ecxLb0fi+pJT4CZ5MgX8zXEZteSVR9piM5XGSbjYs/6Ys8hdSToDhn8GKquI+/J8EMyalLyb97LlYRiDlAYpUwUt3zol8HRhge9akheNhypQ+anNK0R5kNLD0hDIDgKxkCOwTMRoU+TPZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365238; c=relaxed/simple;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc9ncXmBvZaNG4ut4bWB5AbGiZ1wt98FO84Cmz/Wuc21VzD86W6EIOcK6lb3Zzvg1ezHLDyLytTTEFx4sL+X1Jrca3SunOqs6QhY+iGEInT09DCFogY3p8tYw1JCpPRl5EIEaem1YsaOd9vRoBVt00Gh5LADQhr8k+PCFnMKBHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojbNuxPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojbNuxPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AB4C2BCC6;
	Tue, 28 Apr 2026 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365237;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojbNuxPphsyZ8HTdoGBHp75YXhvdjhHRFllJFwGaRUsTdPgahL+YYPuRJpxFWpJFY
	 nj7fZ93YVXV5Xp1MPs1uWNBM04QafiDgJVASb9cmjW1zKf40idIp90p2iCPKrgmt9E
	 R/x6chOm337GJGH4oH2CnyngHdKg3yqxnObUYffupEjPXWt9ysZ/8C3HzsP+bc+bK7
	 DxVc84nh/gvLvhv/9eHXlzKV8GmbakbRmUFcRyfTqBwfwSIoHpsiMMhXGEETgP7lC0
	 YLHUa+NnnS1fcjfs18Ls+WqfE7HEuwohAV1fv4o0lzcCQ2Ia0V2GL3CaQ/H+cCKsKf
	 iZlaHaf13QZzw==
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
Subject: [PATCH v9 01/22] fsverity: report validation errors through fserror to fsnotify
Date: Tue, 28 Apr 2026 10:33:07 +0200
Message-ID: <20260428083332.768693-2-aalbersh@kernel.org>
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
2.51.2

