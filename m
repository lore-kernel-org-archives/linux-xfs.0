Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647C63D3490;
	Thu,  9 Apr 2026 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740460; cv=none; b=kUTvUf7wNjFN9p65hWhqBsGDeJhDQa91cIorOI11s32uHdF5voCdHSqqNa5zxVeBjzM8yZlboavm88caoNglXWIgzZfMh1SVZV4TJtcI+nvw15l1ZaNEk3yNMABM8ZBqru7lCQJfozHt9S+7n10IzGv1XjaMzREUpMaIZhLAc9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740460; c=relaxed/simple;
	bh=AbS2Yqdj6XUOqI6/cjToB96OIoO0+yHzdJktpA4Z80Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8Zhu2tvoMJvCtbn5Oo/xE0lK6gALQikyilvYDgXtykt0iAxlQNhzBbHHZ5QfvK2LUcNAkFIKXexsRJip3toBT4ipzuSzIDCEGG4BnLuHHypHOUm+nE0jAi4k36HlSW04T5B12ogBXJLuITjuqeL1eVyPRpdWJv9XTTpih76JdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X++ACa7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X++ACa7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0810C4CEF7;
	Thu,  9 Apr 2026 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740460;
	bh=AbS2Yqdj6XUOqI6/cjToB96OIoO0+yHzdJktpA4Z80Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X++ACa7DLl+MgBznlPIGUiklF6Chxrh9ZHMM4gerK3mUvoBHd+CbxfV5DkLtfzux5
	 KOp7SmaabkjjnQdnMDRS2OEysOZd34tZ8pvFstTX+YAaIC61xJ2EExX5XPBfwuH8As
	 YmLYuVldzi9E1Nj4SiNbv7K7CfgEyrrfft5eV5WoySY0yHbYgmdK1lRVTYhmphy/03
	 oO8fb1WGpGapxlB0ulw55D/rukwTDNDvgmhVF00hdZ7N2w/VCfwVJ/rghg0wchXRne
	 Gg+c3M5e/Qxp76TJVhox2uKf99wuaCXBoL9xqCFqtQoRUNgElMw9/qaqjsr13/bWnX
	 rA8ICZpvK3gKA==
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
Subject: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
Date: Thu,  9 Apr 2026 15:13:35 +0200
Message-ID: <20260409131404.1545834-4-aalbersh@kernel.org>
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

fsverity now exposes fsverity_ensure_verity_info() which could be used
instead of opening file to ensure that fsverity info is loaded and
attached to inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/overlayfs/util.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 2ea769f311c3..8bde5dc31d7d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include <linux/overflow.h>
+#include <linux/fsverity.h>
 #include "overlayfs.h"
 
 /* Get write access to upper mnt - may fail if upper sb was remounted ro */
@@ -1377,18 +1378,9 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 int ovl_ensure_verity_loaded(const struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
-	struct file *filp;
 
-	if (!fsverity_active(inode) && IS_VERITY(inode)) {
-		/*
-		 * If this inode was not yet opened, the verity info hasn't been
-		 * loaded yet, so we need to do that here to force it into memory.
-		 */
-		filp = kernel_file_open(datapath, O_RDONLY, current_cred());
-		if (IS_ERR(filp))
-			return PTR_ERR(filp);
-		fput(filp);
-	}
+	if (fsverity_active(inode))
+		fsverity_ensure_verity_info(inode);
 
 	return 0;
 }
-- 
2.51.2

