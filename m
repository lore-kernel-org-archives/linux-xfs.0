Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E244534B3;
	Tue, 31 Mar 2026 21:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992518; cv=none; b=CcmbBPqss+kS2h7SMtdVyP8RKFjcw7WM9J1mxzgNcK55CaoLd8jB5PTA0sdSQ4f5zvR5yYhdynh6BdGCPgmrbBIZSWN20LZ4rigcZgrLbLWdDR8u25oeRaOomaXCbaJ1FPD89rdQpIXb/MOzROCIC979k6hi0J4LfzFs31CuTjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992518; c=relaxed/simple;
	bh=eEsDt5UPcnWAGREsZ+GTXv/Fu/DqiBIJrko1OcjenmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5JcQCBcOFUfrhldGuMQJToQAj/v1HYrKcb4NqJT1SAZ/tngYazFk6vLuU4j0XJ0lZrtYijAI2Z2ePKAEPvwRVBhfUfCW+Z35syVekZcmgUI4Fb/UPflPxdw4wglCUsO7Bvr6jGpLuwwz4RT1pMh50E4AGeeOzXEBSkOwbtMKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF0cyWLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF0cyWLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B096DC19423;
	Tue, 31 Mar 2026 21:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992518;
	bh=eEsDt5UPcnWAGREsZ+GTXv/Fu/DqiBIJrko1OcjenmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aF0cyWLPlUI2IDqKP+3waVZOpUCCNJmbSvz42CEwFDRWonIsq74ZNyIFcq9OD4cwL
	 4DN+PK4plFK6j2EZv30QoOAN3Ah8D1571D7JcucKRGrB/U9OitC8BtHR13H7MRj3RF
	 1TDLquEs+c2UJyyNJbqfyFVkAwgHNQwhpRQgDhq2gFh+/aYPIfit964RbH8O4Z5y6M
	 4Jd3hISVxGIjxiw0x56ZzV+tbBXcxAYsXdDEEuC8ZFZobGvQf8Ugv/6GX7AkQCOKV0
	 rDOXvWn/e+uWRZZUiupwLgoqJ05p91ezS0ijosVoPwvGH+VDEKHAbt6jRwnLnTGx4/
	 +OaCSczNfF7YA==
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
Subject: [PATCH v6 01/22] fsverity: report validation errors through fserror to fsnotify
Date: Tue, 31 Mar 2026 23:28:02 +0200
Message-ID: <20260331212827.2631020-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported verification errors to fsnotify through recently added fserror
interface.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/verity/verify.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4004a1d42875..4ea494da694f 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,6 +9,7 @@
 
 #include <linux/bio.h>
 #include <linux/export.h>
+#include <linux/fserror.h>
 
 #define FS_VERITY_MAX_PENDING_BLOCKS 2
 
@@ -203,6 +204,8 @@ static bool verify_data_block(struct fsverity_info *vi,
 		 * to verify that any data blocks fully past EOF are all zeroes.
 		 */
 		if (memchr_inv(dblock->data, 0, params->block_size)) {
+			fserror_report_data_lost(inode, data_pos,
+						 params->block_size, GFP_NOFS);
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
 			return false;
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

