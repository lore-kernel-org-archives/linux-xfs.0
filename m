Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35283C4555;
	Fri,  2 Oct 2026 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980637; cv=none; b=GH73VVQOPRoKHsiPH+3LXnggZOIcsq6Svd2GRE+WQUUbbRiJIP6oQdOQTWF2Scd08ox1YpY3n5xoIKTB3ICtbcCOUn7lDDuoF68ab9aTzyZE3vQPI+S45Gl9HTWznH4e80PBoulRmurq4FrOwX02gx72F67DNY4wlEZOmMG+9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980637; c=relaxed/simple;
	bh=gNzjl4zWpkZJaicQjAemkaolWXKfIV765MdaOnGpKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXPLdHZl5HS9kUSzsctWzRoNG3WwVMfuOzFsJS75NYPZK0udEx3Nj9cGDm/9QY4ABgUx8jNdPJp7ez00jqdiR1B2mCTGNKd1wROHj5hJtZUsfRrBs241LW5WiNDSiDuIlOIhVCy8YEgHxKn/ugkTbZ3u7vffX2e89eNkKowMnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEweSho/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEweSho/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481D41F00898;
	Fri,  2 Oct 2026 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980636;
	bh=DLKRiRyzKQ3SHGS6qPdEtB2Y8TKgDvD/nkziuhY4NXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEweSho/Cwzs8/LsKlvQTc806l+Oz7mlND6yQYJfioYraHnXayhEJgpZNG/TvL5Jx
	 rnK1B9nLtK47IFPwqo20gBoXEhnyzaisrJxQQR7QObLFPHT4rLn3EC+OXQb5aHlux6
	 mQADUBJU1Zl31qTt0XipmQlRk8Y2uerVbwMdp+3+bYDkxlUK+dOVVSdaACWBqjXw7n
	 mEnUl/XSJhF5xW0LUgQNu3h8/j8K4o0OeRgEDJ07v+1PLu3we1BdHqSCE4HUsL7r1f
	 DCtunj5aVzhn/Fe60RABJvgfGYuCIiVnIZCJMvC2abqh6LXBdWmfkDYfR5SrawG/Pb
	 tUEVRYEwcmCbA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 01/21] fsverity: report validation errors through fserror to fsnotify
Date: Sat,  3 Oct 2026 00:36:42 +0200
Message-ID: <20261002223705.2175542-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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

