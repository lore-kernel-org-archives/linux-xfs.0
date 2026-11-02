Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630548;
	b=OBOCX9wPBGK23L1bzfYCVPa5eq3TzzWTqm+lva1Os9at2lVTasKNLhX8ebsexp5mUJfP
	 pgceywc1PlII1A2WH68UMq+0yfcw2YBQ34UfHQC0w0YmsKNHjuQS6w/VIdjvNllSs8bRz
	 OWpynTp+O8YOamnJwaGXqWCOWBq+P2MH/NDSubYGmtIhLPyR7GfB7B5Dffz40qTQDajEO
	 Gbv8FdfDKqu99z3iEQ/aiJ+2BbZAqNvxhOMZeA6q5MHRupOtld1e3mLXMhDm7waUYy1HH
	 3OUjglI8FN9/7kRGqRr61VHc5x5Viy/J0lNbWQ+3XxUrxpL7Rhn/9HMf5eylo1uOyOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qd13v2RUTF342dW9ZSY0F09ZXMTvV25aQrZ1Kj+DhRs=;
	b=mBDUl+ZuDDtdDTGMTDBUs4farSXEqi/lsPjJkOLTDDhtf4xzSiAtg3efw/0iXFVqIwf/
	 8Dp7cRB87+Cx7vZr9kR59/3xy4skaw50DtYdXqWI4FBibN8mfVRK7SrffEYsULR4feB80
	 vzJR5QXogCkgtnTurJRcmnVt+zpLTqpwn4aFtpgd1P8mICsSfuQtdtT++Gp0Cm4VEiFHe
	 Fxn+SBCRBDyUaj7ijJx49a2zB+L4vhtHIGM7kttNbIniKJrVwwGScuZqTQVwgrKBU9kDq
	 s1UdYztT/L28LUCe63u852P05UulIUYmgnG81/AVRxLrf1HlH4CLo0OMC7S+LXTMscA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmYl9oWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E91606FB7B;
	Mon,  2 Nov 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmYl9oWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9D31F00A18;
	Mon,  2 Nov 2026 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630547;
	bh=qd13v2RUTF342dW9ZSY0F09ZXMTvV25aQrZ1Kj+DhRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmYl9oWporlhGm9opyZVxTVYkp4bB82VQFRMgukakRcySMwItxHEjkO/bgpzgByA3
	 71iq5smYUnkbmbsJILcr2IgwO3iRUA1C0BgKjIr0pjuUu2HXTs4t3xHs/YrB/dqLdR
	 UsosavjbkaIM/RdCYldN05QScgXX/m16ejLRky4N04pRqsq5SeaRiPuMOa/u39ltWa
	 ZGxmwfSlGDBkvThIxbwVjf8P2YpWo+KCBrA0KhcOcVi5uJRM1KaLeuOxkra0QO/DXf
	 jwtTrYxpIAzjyETxfONRWousxFKs2iUzed8MFYE4/qk6tZLTmJSuEMDZa/+9rjlE7U
	 NqHAKLXmBmz4g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
Date: Mon,  2 Nov 2026 15:41:37 +0100
Message-ID: <20261102144147.2393369-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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
index a35a44cf8c63..706f2ead42f5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5279,6 +5279,10 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
+		if ((flags & XFS_BMAPI_UNWRITTEN) &&
+		    del.br_state != XFS_EXT_UNWRITTEN)
+			goto skip;
+
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
@@ -5413,7 +5417,7 @@ __xfs_bunmapi(
 			if (error)
 				goto error0;
 		}
-
+skip:
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e9f5416e4c05..25b24ff8e4de 100644
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

