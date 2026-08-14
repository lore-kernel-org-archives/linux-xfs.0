Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4B45516F;
	Fri, 14 Aug 2026 09:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699541; cv=none; b=Qgiu5s2SOwtIAVKb+B0VAem96WxLAlEb/aHJgo/3qRqGbYB2fyRqSfxUpkibhnY0HrGMdYPsiQy/0UZRk0qKPj6ha0QzpvBRW7mG3S7ylr2EK45d1zj/WiexbEIWxpGBcWkIO3xzqRnZlWLyoiELIliCiP4CiTV4FbKOCbdx72o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699541; c=relaxed/simple;
	bh=gNzjl4zWpkZJaicQjAemkaolWXKfIV765MdaOnGpKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2EHAzMY9Tu6/xuuixHeu3dArin8yLZ1jofJRvKAR/SrjLwWhWJTiba7/HVn0BcXY09lG/pGvJYmehFtOYaT2wFIRH0Bgv/KPzpf/x2DUm7pxBZ8dbLq4Tf6ImChDZ96hiJ3sSzG8bDutJc3QttxMQRKW3hVhzjbYLLvSwa35V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvpkhK8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvpkhK8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B34D1F00A3A;
	Fri, 14 Aug 2026 09:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699539;
	bh=DLKRiRyzKQ3SHGS6qPdEtB2Y8TKgDvD/nkziuhY4NXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvpkhK8d9Rb0ituZhS+ssgDfXy/u7OvmDO6CnEArJtBe038/Jbpw2sYv58JOzj8vH
	 Ab8n53fWQNWOvHLtJ42pNOFTfTchetR7SeYEayxYm5NyOaglugbLTNe5xKFCrjcvMp
	 H63dMBw6Ck/h9cGWZCiNzgUFSyvDDEORaRr1EMse2qMZhk37QPX8D0xP5e1PWqIsqr
	 SXHa6bA4LrDIiXUqg3Lil/bvtakGrir7JaeYTC3gG6fPORuBKp/jxgwoWbdL0hEA7S
	 w2qK6Fk/H7v7YewI7FtSFShliT6+7uyFgC2dL1PYx8XyrsO4U2ca28Qug4FKS8ps3V
	 F9KdVBN5W3YkQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 01/25] fsverity: report validation errors through fserror to fsnotify
Date: Fri, 14 Aug 2026 11:24:18 +0200
Message-ID: <20260814092448.1818082-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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

