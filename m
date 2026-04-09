Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB093D1715;
	Thu,  9 Apr 2026 13:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740454; cv=none; b=A8TPX7X9GzoLlhCtvYYORwal0DULQ/H5DvTy3QplAuMTLiEATvhGouiQv/DuFlvX0RGEbgD7w0DbbV/25fep4qwLkazYI4CXAA0gAMaYBrdUKnqmOjASx5UogFUKBqOa8SVf3FUoCCazfT/vj4hG0e0ORy9esNy2mLOtt/mmsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740454; c=relaxed/simple;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIvRY8gRWxDSXba6x4/2/C89bEPZoRB6CFxmq6BlAOf8UbXErGW6dOey1UwmrECpBOj85SIKKowlGBx3r57fR1kbsagH7aDhuqs74vRO+L5V+2ToZ0A5pgnRRFIDmLmD4bWYfZFULqXMOj5+EFUu1gS5oNitBJTZAsmhA0AQXII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPY5R3Wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPY5R3Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFEAC19424;
	Thu,  9 Apr 2026 13:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740454;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPY5R3WxTA74zuJ59XeoTmq8o3/BVhncWzfEcp5OjO6fNKZwW2TbhlFkyQS84NDyh
	 NXr2Fre9D6rGanbhDcJHcL8iUE8KgHAwM4rWFY5dEsEEg3+JDYs7CIw8fQ9CWvCYso
	 6Y4zUkr6vsxrd4ekvFceZvRTi2/Sv7PU11qKLXaiLpMbN7SnY/BH1KFfNFw3NO4VOp
	 NxRhoLQKVOEujue5uyS6tnYOuEePMwzXSwP5CEYOiR67L43h3s5akmPqKV+vxfolnK
	 goIwyXxaqd6kaa8DfGo6xOqytFHBI8g0oIPy06A8Yy7EpIEmKBObxVTzfGADIfSdjo
	 tONdt5ZY2YOnw==
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
Subject: [PATCH v7 01/22] fsverity: report validation errors through fserror to fsnotify
Date: Thu,  9 Apr 2026 15:13:33 +0200
Message-ID: <20260409131404.1545834-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

