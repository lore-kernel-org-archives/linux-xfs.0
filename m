Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881B138423A;
	Mon, 20 Apr 2026 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685658; cv=none; b=pYaKWw3xtwAm2Z9MAoNCv6a+q9IyuCc3aG07G1Dij55D+EuLrb2QyajlqZlR45RATCFUcQRemRNIqivQ4rE5kLljR99te6F/rV8RCdrwZJJJgka3691+LyeUDo4cKa4hHyrGYM2NbdsUbcPowdtSbnjZjq/V/F82nh+8MXWsXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685658; c=relaxed/simple;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzNAbTmGoYpXOa+hneqOGZd4hGinCz468Z7N2p7+h0hoKaI0Rr3y3aC5BS4b8ndd+6hVhqqHnTEXxMcxAcduk9sSTV6G4X1XOjTLO3aVZymQR4cjgE/8g4NAVkh07HSLacE3+VsCADrk9icI/Ck5JrAgyVkQGWpzUutaZgj5eUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBF//Xyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBF//Xyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA527C2BCB4;
	Mon, 20 Apr 2026 11:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685658;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBF//XywCr8BGCIuJa3b76GrPWC/8+zEONRFrtGV1d1TBbYA6kscx5jC7NRw/wF7b
	 Vru688576PvEEAG8YKzIkBIcClu2teEGqwQeLZTQB+eYiMt891X9czT7FNjelIyThM
	 Gy9PGHHhEHMYXYYwyg9Uggl1KrhuN7Xw2301dA4IZcvQSGC5b251/JDaB7RzvbQrkr
	 cdQ01kwTHwF+Am+GaY0DeMZ7yH3f8terH+fgDqTktnnOrzmweY4ZkRV853n1Z7G5AI
	 b8Dw978Zfl5EX7e91JjRWsapdjYJuJ07w+9mNd3yOv9Bw9c+t2kiYkf+DKBJYvPXVG
	 4O5AI07vjX9eQ==
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
Subject: [PATCH v8 01/22] fsverity: report validation errors through fserror to fsnotify
Date: Mon, 20 Apr 2026 13:46:48 +0200
Message-ID: <20260420114714.1621982-2-aalbersh@kernel.org>
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

