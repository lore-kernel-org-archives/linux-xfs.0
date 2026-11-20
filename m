Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190331;
	b=qGEahanQchMclfTdcJZ2KA2e0EafND3Kl+oU6Z5QMTtU7n9F7keisttx9wocbH6lpuJx
	 nVBv44FWuzXpubb0AcNseaKHqTZH0jmaJeRfqJNdyN131hJiKhGFb+/BXKCFw+G9jhUtB
	 RrAUv4gIx3Fhl4cLMvpEfj/2H7Nx7zZIwIPAUwFJ6A8YD8AH0wRQQzhwAkwlX2brYLD9f
	 dbHB47JWEaHqyObl9Ej6palq0nWOP19yu0ElQN7lxpbI/zeUxOxkfwHNL71p5imliXK6j
	 3jAP+jqFDhaX5Fv+76mgc2dhHfNvVpJ3XlDNU1WnHV4/lc+eJhFYPywrmdQBKfhaS0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2WPQVUYZvUdIxaKgiNTH7bti6DRxAsvvFMcWeztADhI=;
	b=2vmMHg/Ir7JzkzGRKAYb4AcJxiBTXcBs4GIuJypZiaIEBl7O3by4icJx0yiMDxbsPvEX
	 Xl9sgkrVFJBkYEaZei7UH7NqgxPDBjFlQeCW29QM5WEwqRlTT+GSE71TJJ38rNeNPIgzc
	 l++AKAGrvEsVQNAcC6Mjbf57zMxQal/B0dYXzUnod8diGbEVkT3ro3RWv4mepblf0AI7F
	 9vYQFSunPI3nzBn3W6I06vmxre48R8vq5hgEHI+EHNVJmz08gGF87QsNi9UDp6H8O+/2x
	 VA2G197CYZ/FfDuO4WvJtuRl5D6qbM94deUdNXvM2zqRMSdGpgqvkkKvdb+jSGvWA2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYiBV2FE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED39606A330;
	Fri, 20 Nov 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYiBV2FE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6114C1F00AD3;
	Fri, 20 Nov 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190331;
	bh=2WPQVUYZvUdIxaKgiNTH7bti6DRxAsvvFMcWeztADhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYiBV2FEmzPRtZQFH9h/H1kbJgrE0dD+AdZWMkOvHxYsIh94ta6t1xLqbB/9DJuIQ
	 BC0ZZNkqo49b7gcDHT52OtA5mQWy3eCiFFU9MlB4bbyeEBQ70x0/GVcIYm6zvuB9ao
	 xdYUHxuOmQDrLnQqWSDr/NgE7VGyx8xD5aya2FHvUK9nt2zREBkSpMrvhDI7O9/GiJ
	 eq6Q9shMMpvCopu+1WasNShrDJx0bA2BZN0+It5m3YM2ijzcI1eRxXPiLBGu3+kLg2
	 ftnaPZSC/PpTvjxUi21Q8gBE6lt/jW7YPq52tI1UZCEN9Cs/bm3mgWylIBjTBcR41u
	 oW/LROC8l5Zmw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v19 12/15] xfs: advertise fs-verity being available on filesystem
Date: Fri, 20 Nov 2026 16:57:46 +0100
Message-ID: <20261120155752.192025-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..c80133784419 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7629fc3f499f..3323b8dcc793 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1546,6 +1546,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.54.0

