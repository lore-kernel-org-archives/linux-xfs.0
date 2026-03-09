Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B823EF0AB;
	Mon,  9 Mar 2026 19:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084262; cv=none; b=SyhSe2OBrkGOWIdyH/FAEmoU08JHvv0S42MOdDYSaT/ItZhteEMYA4/QTxCBvN32JFF79ecj7e05e+TI74kaRdPXUoh7P7fguvFrPmb0f+b54uRdxvAK6AR++yyUNZEG2iXqixlOnv7fNrO/99f3FUMInEyXEDRWajtdnNgoA14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084262; c=relaxed/simple;
	bh=M2taI9xKx9InHswY76UfTZw5e95o47rk27RlgquvrNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsYjpbahJ2YDlh1778mAYDcWHba9fIThQ+nb+ak4vKA3VsxXba6wxM6BGy0BB8nvxUvBTYBCAkEIyCI6Xk0btobRdxFvJb/DnvIzMs1xIv7XjzKxItWMYs2+r/v5AEhF8JuKT2/Bu0pUFo5I92wRP479/nix9Ex+LDXbv3C7yhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tRRcmxic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tRRcmxic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AE9C2BCB4;
	Mon,  9 Mar 2026 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084262;
	bh=M2taI9xKx9InHswY76UfTZw5e95o47rk27RlgquvrNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRRcmxictnFJy7Kp+as1IWBkvQkjyZpKI/zedpr+/jKMT/kdkdcpFD1hs5FE1wxiv
	 nACJXw1tIeUKPX8iHyyvB0AzDO/ThTq6HS2VYTepCJ4xz54OGAMwhOe8xr1ItKb/+v
	 MmAKnw/S9t2LcGnqos4dT7BeRt+vEpK1EudDAS3/hUVVDq0ecXxarswFa7B0Phc0R3
	 U86FYaTO27QAAJsX3jpFt3nVMowH1bWLTJFme96aN3i6/UxMRA+OuhGqEmpVNcSrhH
	 DG5ipiiyceKF2D0hVju/ySQM7MFGMQmirA72JA5JVFctaYeUCabe/33NmL+yGCNsRT
	 eV7v22shO3kZQ==
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
Subject: [PATCH v4 01/25] fsverity: report validation errors through fserror to fsnotify
Date: Mon,  9 Mar 2026 20:23:16 +0100
Message-ID: <20260309192355.176980-2-aalbersh@kernel.org>
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

Reported verification errors to fsnotify through recently added fserror
interface.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/verify.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4004a1d42875..99276053d3bb 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,6 +9,7 @@
 
 #include <linux/bio.h>
 #include <linux/export.h>
+#include <linux/fserror.h>
 
 #define FS_VERITY_MAX_PENDING_BLOCKS 2
 
@@ -312,6 +313,7 @@ static bool verify_data_block(struct fsverity_info *vi,
 		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
 		params->hash_alg->name, hsize,
 		level == 0 ? dblock->real_hash : real_hash);
+	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
-- 
2.51.2

