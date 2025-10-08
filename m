Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359042EC0A6
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942612; cv=none; b=AyHFLqhGu3FxJBWLWRDVh/atpCo6XjWx7+OeR4wv9Tv4JDLo1tGyH9ymvQdHwgdU9wkGke7i2iAttEXwN/MDKtrqp3QVK608YElVQUgfxNMvLvoMnKy6W+kNgcNnTW28wHaWtL8a4gBEiLSwSo8Jq211QHGSgIYiMmuZi/lnyeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942612; c=relaxed/simple;
	bh=B3mguV1N2CoPmB7dsC6sNRG/h3xg92cfg4ymHYbxgz4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVUPQ6xYPfQQ3ZCA9hSnZDwCINtxjpLUiKDOaBREqxyC4LH+ZoqqAIHwoHRt+DRQd3jY3OS+o3rRR0BlRkrsgnKBYIatl5B2c3BA67JIs56E/HaVX2WquRUZsBNnycN9AQFrSgHNcJfiCCakxhthAyseDihqOAKoab5PzuQECkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4097C4CEE7;
	Wed,  8 Oct 2025 16:56:49 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:56:47 +0200
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 9/11] [PATCH] fs/xfs: replace strncpy with memtostr_pad()
Message-ID: <p5364j3qrivtddri7frc234op7rxehirovdt6f3xnitb5yfpfl@gx67re25nhgv>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

Source kernel commit: f4a3f01e8e451fb3cb444a95a59964f4bc746902

Replace the deprecated strncpy() with memtostr_pad(). This also avoids
the need for separate zeroing using memset(). Mark sb_fname buffer with
__nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
sb_fname.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 db/metadump.c           | 2 +-
 include/platform_defs.h | 6 ++++++
 libxfs/xfs_format.h     | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 34f2d61700..24eb99da17 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2989,7 +2989,7 @@
 		if (metadump.obfuscate) {
 			struct xfs_sb *sb = iocur_top->data;
 			memset(sb->sb_fname, 'L',
-			       min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
+			       strnlen(sb->sb_fname, sizeof(sb->sb_fname)));
 			iocur_top->need_crc = 1;
 		}
 		if (write_buf(iocur_top))
diff --git a/include/platform_defs.h b/include/platform_defs.h
index fa66551d99..7b4a1a6255 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -296,4 +296,10 @@
 
 #define cmp_int(l, r)		((l > r) - (l < r))
 
+#if __has_attribute(__nonstring__)
+# define __nonstring                    __attribute__((__nonstring__))
+#else
+# define __nonstring
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9566a76233..779dac59b1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -112,7 +112,7 @@
 	uint16_t	sb_sectsize;	/* volume sector size, bytes */
 	uint16_t	sb_inodesize;	/* inode size, bytes */
 	uint16_t	sb_inopblock;	/* inodes per block */
-	char		sb_fname[XFSLABEL_MAX]; /* file system name */
+	char		sb_fname[XFSLABEL_MAX] __nonstring; /* file system name */
 	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
 	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
 	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */
