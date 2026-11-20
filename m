Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190316;
	b=3CFKxI9DdfnLNhDgpKu4Z8wzz+3gRrkhwqHU4nASf7j1lhFOLGN4cFpyMhCOeVlFIMBy
	 w5vnsvGljy4A0bUdET+0rcDskpmJwbtjIWH3zpZ/3353Vr+p2SoC4iL7B9c7lgArXKjuZ
	 UQwpz4npjY8sXiwccqkpftBfuEp/8eZf+Iu2jiRIfduJb7fxmcrleYSn9SHdU47IlGmrZ
	 qcwwSqCo0kDX3dq2ls+4WCgbFpnLAocCtDFRPeK4IdtVugFVsCQsxql8G+0jG/VAxTgHo
	 ErNeQ7hWAPHJfHB7GaH58R5tPrq4VOB4AsDxOLoowd86pIjFhVChumuFwY8s6EzTxCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0GRF4szdTQx2tPRYFJ4gnZN+nH74SF0ck2Adu/0U3S0=;
	b=l6O52/uIqaMPT/ySuqpGUDfGgDwsFtFmYXIpbGiLjeyPYXPd2rFhwpxjvgDwYISgLABQ
	 iQfasVPPaLPGQtvqisFnViB+PfS8Gyi01cCqOWuhd6vMj1VCgYq045yGc5135PK8/B/Bh
	 A6BTgAelarH6k4rB2kP+T4LqCB69Rn/qXsesAWrlG6L0UBxYnq9Mh6nzPL/Tcaz1u0zNS
	 JHSF9TIkH9RaYkIt+B+wbMXhoWEqEbn8VA5WC79cBd+kt+Lt9gIJq4MJilzUWSCs3V+8J
	 I5PJBPQSxGMzHfDkvNd1b4L1bSVc4ERBWDrf8tODwLjmAC645+OyOo7CqpNN1zSg5Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wx51WsQ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE260A2603;
	Fri, 20 Nov 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wx51WsQ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69251F00ADE;
	Fri, 20 Nov 2026 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190315;
	bh=0GRF4szdTQx2tPRYFJ4gnZN+nH74SF0ck2Adu/0U3S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wx51WsQ80d4JonKHfzQCrX/+tM/1blH/Dq7eZhhu0jj5rRH0FDmgKaCp1xg5VU4gv
	 9f1SNC6S9M93Ze8nTuuHfXziH/cZ/hibmcd64Bx6NqsUhdDOOg729HD8bnEyoDt8KE
	 QGDD5ATsQ9fCgNyKn6IZIb/okSU7fiMPDhqlqYqYjaD7ErbThQUMxiG4PISXUdxCk3
	 foOxWyujIM7g254AdLky15ZHXhvhM5jpwvcI8X63VDdn+2lQULAzE/yq6gJ75g5XkC
	 Z5Db4hRI9pIHAwBoLZ+ifNu6GDkY4iU8vCivCMgK2CYNP9oJbFLb+Av+x8iDyRvjed
	 cU+U3RSV1uY8w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
Date: Fri, 20 Nov 2026 16:57:41 +0100
Message-ID: <20261120155752.192025-8-aalbersh@kernel.org>
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

The __xfs_bunmapi() is used to remove all extents past EOF. Add
XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
written ones in place. This will be used in following patch to clean up
unwritten extents on fsverity inodes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 +++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h |  6 +++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f74411312901..667b693aacb8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5220,6 +5220,22 @@ __xfs_bunmapi(
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
+	/*
+	 * XFS_BMAPI_UNWRITTEN is only used by fs-verity to drop unwritten
+	 * blocks past EOF while keeping written ones (fsverity metadata).
+	 *
+	 * The XFS_BMAPI_UNWRITTEN could not be used with realtime inodes with
+	 * realtime extent larger than 1 filesystem block. This is because the
+	 * realtime inode with larger extents could have EOF in the middle of
+	 * the extent. Removing these unwritten extent beyond EOF could lead to
+	 * removal of data before EOF.
+	 *
+	 * fs-verity is not allowed to be enabled on realtime files whose
+	 * extent size is larger than 1.
+	 */
+	ASSERT(!((flags & XFS_BMAPI_UNWRITTEN) &&
+		 xfs_inode_has_bigrtalloc(ip)));
+
 	error = xfs_iread_extents(tp, ip, whichfork);
 	if (error)
 		return error;
@@ -5281,6 +5297,10 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
+		if ((flags & XFS_BMAPI_UNWRITTEN) &&
+		    del.br_state != XFS_EXT_UNWRITTEN)
+			goto skip;
+
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
@@ -5415,7 +5435,7 @@ __xfs_bunmapi(
 			if (error)
 				goto error0;
 		}
-
+skip:
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fb7481e8190c..f1df6b4b695e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -97,6 +97,9 @@ struct xfs_bmalloca {
  */
 #define XFS_BMAPI_CONVERT_ONLY	(1u << 12)
 
+/* Process unwritten extents only. Used for unmapping */
+#define XFS_BMAPI_UNWRITTEN	(1u << 13)
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -110,7 +113,8 @@ struct xfs_bmalloca {
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
 	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
-	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }
+	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }, \
+	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
 
 
 static inline int xfs_bmapi_aflag(int w)
-- 
2.54.0

