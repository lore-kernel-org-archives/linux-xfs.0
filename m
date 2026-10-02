Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65823C4555;
	Fri,  2 Oct 2026 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980680; cv=none; b=qEKqXLtIqYv185tsHj24roqx3V4rOFIXiJYsdX+MAovISqA7+kJwS5F4CYZ+Q5XNw8xrgn9Q7fG9aZz4OcICeSJ9QjbF5+I9uXzbtAbK43a/yoHraJX9ChDskupoS6b7xYazX3M/8DeUXi/etCqKOXBHzVRFW+1/YxMMAJrsU6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980680; c=relaxed/simple;
	bh=y+uj4hLo41KsmlJYth0ubMz10AxJigq0sof3plHv6qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMTIyAQJv/VEq00P0taCAllvPdjkb8jyR3rvsXrhJwXG362o8LLDMwtfNX4ibMWEcO4c87FDAG1ALVD3mv5vJKCp3HUEzcw/cg2UGM67TLwO56G5TlR3DdCaBd+oeyGbg1y2V4K/Vg9Jy3IiBZGwYK6JFHjIDgKnwEG6IhzCJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONU7QUY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONU7QUY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800FB1F00898;
	Fri,  2 Oct 2026 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980678;
	bh=aAXU3AobDu5QtwLxj6kfPLMsQwMacpv2rFmEyWNfcHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONU7QUY39Iqo4VNtD3neA0lRuGuW+5hkdI0Sm+F3jR2/Fq1xzsCy4uTZUx/Z/gmiZ
	 Z05ApZbFgH3J8BS/t005BwdVwRv9Sl9g9F5Xw9ARv9GjnfDc82PkZQStI8Z70hNb0k
	 wm2gMKCSPc9ouzyoc+cGwSMZEJGDNfvLhWn9xztCE1rdMyWmSJy2zX0ChdrtUiLDwY
	 PV2eOY38JL0NIe69I2A8WES8eTCQl+1F7IXvmLNaZB4inkTszFU99qAet5MprsKC5C
	 GjmAb6usLkcehbe2hE4x7bimPMvWodr1DBoFcuXqVumRjBekYzwgoclWdxwvw8a4Yl
	 xZ6UcYVVeXZZg==
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
Subject: [PATCH v17 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
Date: Sat,  3 Oct 2026 00:36:54 +0200
Message-ID: <20261002223705.2175542-14-aalbersh@kernel.org>
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

The __xfs_bunmapi() is used to remove all extents past EOF. Add
XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
written ones in place. This will be used in following patch to clean up
unwritten extents on fsverity inodes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++++-
 fs/xfs/libxfs/xfs_bmap.h | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9dc96a4edea6..6f0094445cea 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5278,6 +5278,10 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
+		if ((flags & XFS_BMAPI_UNWRITTEN) &&
+		    del.br_state != XFS_EXT_UNWRITTEN)
+			goto skip;
+
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
@@ -5412,7 +5416,7 @@ __xfs_bunmapi(
 			if (error)
 				goto error0;
 		}
-
+skip:
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fa..0f36431d9936 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -90,6 +90,9 @@ struct xfs_bmalloca {
 /* Try to align allocations to the extent size hint */
 #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
 
+/* Process unwritten extents only. Used for unmapping */
+#define XFS_BMAPI_UNWRITTEN	(1u << 12)
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -102,7 +105,8 @@ struct xfs_bmalloca {
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
-	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
+	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
 
 
 static inline int xfs_bmapi_aflag(int w)
-- 
2.54.0

