Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0F73D891E;
	Thu, 19 Mar 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939763; cv=none; b=mfK/1/XAXux+Zrjk89cT3NaYjZC01Qt5lkuQjaAXydslRhbRJHhLOia+jZlHrrGzgh5Ra5nBi7c66OeyHnhe9JDGFilUdvLXQfa8fG8bIfY2vLKthnmkw7uNK7kEKW8zBzEafv+74biUzs/sDxo08HnFu8rmiAZOax/10zxdGTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939763; c=relaxed/simple;
	bh=1+F7FUyyPtQv6AnDaCaQYOUoe9C0/OM2XaO+4qMrhCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeBHfE7/CpGDhsAwiDhILT4owkjtaIBHuWI149cqiANAtMQFIRtWPueNiFEUJxlXWXi2Ic0HyoMWvQwisZ4SkLjAe/ARLLV6/sBZ4Bg3FDqQki92OZFL2hNxsOr/iKepzy/aAKqelnxgL5dr4ccem7AJEwXHKohA+XpCBvWqbaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMnivIH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMnivIH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D15C2BCB0;
	Thu, 19 Mar 2026 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939762;
	bh=1+F7FUyyPtQv6AnDaCaQYOUoe9C0/OM2XaO+4qMrhCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMnivIH57WViMWKRuyFrPz8MkHi3nNIuQwGIkU2qPhrthXhRW81M5TTIaBWkEuTVV
	 ITYXnULmAP5IA/gtTn1RisgKrsh1OvXEssQ11slT39a7LoAFM55TFVyFY3MzPgXvTX
	 QeeySVLHtQwA7aphzl+ueqim1wNBqHNvvatl7xwY69QhT6Usk1jepl1MpAGb42weP6
	 3sKEwPOPmbukO97p+EHwQ2M1iKUQlvYSS86tATNoqLI25QrXZshDjl62LBIZuC4V+S
	 MjtdlHO4qjiwBKEoDF/Dg1gUUaxDXnoOKul/dUU7zpLr7OxwTmMRPi/old6RENDuWC
	 Bf8jSaN12rf7Q==
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
Subject: [PATCH v5 01/25] fsverity: report validation errors through fserror to fsnotify
Date: Thu, 19 Mar 2026 18:01:48 +0100
Message-ID: <20260319170231.1455553-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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

