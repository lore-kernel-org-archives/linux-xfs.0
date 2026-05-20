Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A423DD518;
	Wed, 20 May 2026 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280657; cv=none; b=a40jFzJpLdFw9EHJlrsaDcN60qKvmJ5Bi959hnvUwFcks1HxEqhz9FSxgf5w8XlCv/di2JVMO84PhbYDEC1QUyuWkTH1ytfWOkXhtEYCwNffNaG6aH/54ooDTFjNbk/6ZXonkaiK5n1iZxU/LNXlzMYtq6rPMGtIbn9qvJmaWeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280657; c=relaxed/simple;
	bh=aQ949vdqN+2VaRoZc//9SuDMmlCcOxHdwGdimTwSIGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTAoo1AQ/+t4MEdd82Szyks6v/9zkOsdGNqXyiZHlTD636f+c5de2n2U3JL7opO0mHdN7pcPfdVcseVS9mWmpXyi9wYwnOT86rARJQa8eGgDfSm4pGigS/06thbAyqRyCZIlhRXRrz7o46LgYq/yEPWw9P/SJR28uua5PD6KT7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz1mjG/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz1mjG/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E21F00893;
	Wed, 20 May 2026 12:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280655;
	bh=S6DVheQpRL47ADeu0p23U/KgTF/b8n3o4ctQu4PeRXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bz1mjG/igVr51QMf/GX/vNogqKcrJsXkQsKiEc99VZY6J2rrwZ6r3ZTbJo0LxzBfp
	 Wlls8sWGix1E+yEsVg3oFeYVDMBe7iENfCopFYq/BPqeBL8KGAQQB7QkmrMdNKDR2U
	 lnTvzFuLeF3AAKPT0trN9C2lz0REmoKiIMRD+n+kH5R01CpW9B0Ih/FUEMy0gtjYMo
	 uVzSGkapGiUfQwPiuLTQ7P4N7xCDCof8Kai1n/SKcSQCOBfX2PNFflCw2Oekjzcpaa
	 3MLnlE2qiGHaVcWDSsDIFxYyR0n+rQp4rDFDKEOGEroEg9EqLPOjxhhZUhp9eOMbAY
	 ovRmwD0AoY94g==
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
Subject: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Date: Wed, 20 May 2026 14:37:01 +0200
Message-ID: <20260520123722.405752-4-aalbersh@kernel.org>
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

fsverity now exposes fsverity_ensure_verity_info() which could be used
instead of opening file to ensure that fsverity info is loaded and
attached to inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b41f4788e4f0..1e783cab4fbf 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include <linux/overflow.h>
+#include <linux/fsverity.h>
 #include "overlayfs.h"
 
 /* Get write access to upper mnt - may fail if upper sb was remounted ro */
@@ -1352,18 +1353,9 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 int ovl_ensure_verity_loaded(const struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
-	struct file *filp;
 
-	if (IS_VERITY(inode) && fsverity_get_info(inode) == NULL) {
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

