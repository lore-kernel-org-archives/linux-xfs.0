Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09139EF06;
	Mon, 20 Apr 2026 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685666; cv=none; b=TSF5xJ0RSOhN6Z2whXKx3tEyJrIkPf+bNX7a8c3ZTcXWlPJpQkxk8XJ2Mjnvl93Zjyjoz2Ra24ciIb64UhTVbZ6CjTpzgyovXfX9BDdJ1oHYjTnY99nEJoOKvZjd4saN4dW5dsBqRHziyWdYafX+Mb/j0KZKTfEzHNh+SG5cKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685666; c=relaxed/simple;
	bh=079Sd9B0THqZauyTaA39ffFEl5GJG+gEUoXDQzKrZpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6YQlseFsLin5DLVl3Q2I5n2Z+KrQSt4Dg4f4KS+7jzDrhCw39aWpnqoQTNmWTEAODeQPJ9Rdo3Z7IkXD84Rfz0LMAdRyyClggoVn2sQ1UyLhsHJbK/x8IcZ50rj0+UqLOH4JKZHX17OKao36vgRuiNHDQy9u0fU0g7F3WHtRDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hs2fKTwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hs2fKTwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92866C2BCB4;
	Mon, 20 Apr 2026 11:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685664;
	bh=079Sd9B0THqZauyTaA39ffFEl5GJG+gEUoXDQzKrZpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs2fKTwUNjLyzcf4Gg/boqTc52L2ObmmkOldSQy6U3VerH5A3zs1R7oYoF7W7OQI5
	 CGWPWVZKNDeDrIAdzSLRnTAniNcutZx4TRNeeWvDXNdGDuXkOvzaSfJm0HFAswmbmd
	 spVyBpWzHtGJMCaLhJxn8Y0QYQ2Fv928gX4eUv7vbrBzP/KmaSQFNGSh9wcIDnWIPH
	 DOWJ1YUKXgpgpvM36lK6SfTFggdsRPTONF67YD3NuxX5tVnKZrRDtR2rSsWpOVxUga
	 r29QpZ7aPWnbwTOwHexYMdGtCUF7xabwKdxKehFTFoZjjH/dh4fkyaFjx8TqogKoOp
	 POIUQ50kLWyLw==
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
Subject: [PATCH v8 03/22] ovl: use core fsverity ensure info interface
Date: Mon, 20 Apr 2026 13:46:50 +0200
Message-ID: <20260420114714.1621982-4-aalbersh@kernel.org>
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

