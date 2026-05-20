Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9123E00B6;
	Wed, 20 May 2026 12:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280652; cv=none; b=jGHXjpLzbwKhmCEvk/YJUGPpc5lhBlogmwx29BktXWSvMgCtAOV0aXx5CiV1IV3BWsEaiW/FKzDtRi1NK/Mk2QkyMf3MgDQb2YHM0mkt5I5ubUAUYs/Ij4dWkIw1HOLf/CZf79uwvJkxCQqCa7I3dnri/gqLilnRsvnGH0s2G7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280652; c=relaxed/simple;
	bh=xdJuXteL2kuBB7E/JnTWxaOughFhLnHqfW8AFjBOmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvC0l2h/7WRTSdE+y8aJXdM19t2tZaMH8MlnASELxC+F5dh9LKmlbx0i1dusy1k6b9EWcOBgmQ7mr6NeY6ng/h+O9i2Xkv9CiKU8DYfOmCAosJmFVbdVeyHePYgITtiM7aByva9u4rnCT4xW6OHGqDW5TDoZxHipxdrtQIYMrfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqZX9nsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqZX9nsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B481F00894;
	Wed, 20 May 2026 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280650;
	bh=Q24umAnIhjJWMMv84GCWO2VASOQlpvqwGDh+ApTBnaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqZX9nsE8QFNLXuhluue/cW4JgOHY2OtHyA5kgBjSDYIE5nUSDoTviEarvXRjvasL
	 om8I8YRDVTAntoEST6h/tUqAJYIEVbqfZicYvfU+jIGsMvXMzjZlhJhj67Ng5Wzu0r
	 5cSxBlerB1F6e7DR0jAQicjnNrvuvqTzPL+WUuSIvGLBKxmvdPBXVDZyIv4KK55uRU
	 sXi78jEf29W4JUO/ylFRmqIcTXig74tdF/NCJZMecJLWFXpPxyM1VN4sMfz+baQLmB
	 /tOhc3UPIDQGZb9RDiU3333CZ2RGQk4q835ARjQPh+Hmgi6+Mw+umyula3/eVResjN
	 4h0gGg7jXowpA==
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
Subject: [PATCH v10 01/22] fsverity: report validation errors through fserror to fsnotify
Date: Wed, 20 May 2026 14:36:59 +0200
Message-ID: <20260520123722.405752-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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

