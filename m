Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC612D0614;
	Tue, 28 Apr 2026 08:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365244; cv=none; b=RgJTG4lPsn9bXEFOUNYebOsiFwOy10P5SowYa9mDrC5VoSZPmVsxMZUf/K3czOuNipt2u0s0cQ3JOG6J7+dWAlpZbPz3XO/1DxQYxgYMxGr6jRqTsbwD0O65SqjHMbCYTi+1TAEIe1ZDxw5QWtwP+uVZfVrCZJ7LnqbCoeR69iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365244; c=relaxed/simple;
	bh=079Sd9B0THqZauyTaA39ffFEl5GJG+gEUoXDQzKrZpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YN39U54CG+OfyfF+uL/PfAmhprQN+26iiUxZwIOzT0uw/ScJO7eGBUOb7w0yz5dQVQHnT3ipprJFw3Yrg/z33p9y20Gmdgc5lks3C9PFd/kyCUKj56Y82KU2sCV6zBld0DxzCy+DZQBL/c5xZH2Yst9my5PpGXzb8QnAwPwvimQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH0LlJbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH0LlJbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550B8C2BCB5;
	Tue, 28 Apr 2026 08:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365244;
	bh=079Sd9B0THqZauyTaA39ffFEl5GJG+gEUoXDQzKrZpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH0LlJbglvlNFHEpiAiX4MDWUMzoJqoSIfpxZ/W52r+Rx+4kfCDouWrHsbWCC2lIg
	 SdFbfgGezV7eN0vGp14jxshCv6OFDR5rklii1/aH5t4NNk4yp0rT9XJqPRf4liUwuy
	 25Ou05DBsp+s35wTA8J4GAa0E/wRTICGDKTT3PwfkLIFJIlWwQHEGora2D6kZeEZHd
	 FrC/GMGOiHFUJHF/l+6cNYLVjNIRW5BvlFdjZCWQF/gnbzeUgWRqOME/HNrQS+pfeH
	 t+CIcf+kcsTcZWxJ0IbJbamRToK77Jb6BT9sgpxh+DMFoe9xl/rnWdpqpigtAx2LY1
	 JkA2DROiZ7SgA==
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
	djwong@kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 03/22] ovl: use core fsverity ensure info interface
Date: Tue, 28 Apr 2026 10:33:09 +0200
Message-ID: <20260428083332.768693-4-aalbersh@kernel.org>
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

fsverity now exposes fsverity_ensure_verity_info() which could be used
instead of opening file to ensure that fsverity info is loaded and
attached to inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 2ea769f311c3..dd2e81022e4f 100644
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
+		return fsverity_ensure_verity_info(inode);
 
 	return 0;
 }
-- 
2.51.2

