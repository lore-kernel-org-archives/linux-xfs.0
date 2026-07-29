Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15FF449ED6
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319599; cv=none; b=kgdBINCG5+YWfxOeGd6nq6yAQV+L+rIBhZVl7aSgogy/b5sIZPL7Np2uPf5D28/XN3EzEeFRD2ak/01bIS/FlTSsWVcGHQVQDfiXPTusHOCKZB1dKJciFZ9qP6mJsaTvXTYf6JmeHbv/XAd6RRwIg81QGfoJP0ydrjQCQtL/Tvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319599; c=relaxed/simple;
	bh=dYRwZdiX1VPUqtzVZGsem2OLDoG1bSb//Lr1tGa+Yok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mk2Ld1ZZ33URr+BbxNQWIlm6OwVA8ApYhdRFvS53xsMU6nZhRYtbCDqBbJ4nOlegH9fDpIHLGvXkGo3KCIykudKz873UdAmWSogTYmS5uxTdVQMfVVIJ2z54d82deg+BEANiIQkFVWrYCSv+a6T3f09ynNSg/eL8Ygm/UGQWn2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpAlsEgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpAlsEgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4911F000E9;
	Wed, 29 Jul 2026 10:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319598;
	bh=mDENXRXFlSmHqPxA6UBv4A0GyFD1ajLxMUK5z38aJKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpAlsEgz/1krTkwHUPKluCBxU7/fRw8ouaNHPnDmrDmMhDwpjL0EFGoEhD/hGa936
	 XmFdqzddWpjcWtRtGTD47URrZ1XuSIyOPZ3bFiFLntbJb22cQCSqeW0w9SWjf7nhtW
	 q1Q61fDtbyqJB/P6+FOvBWf0/12eMZTJI4uyFqHCkFDJA4osLxDKlE/XWvYfVXiF9Y
	 qJGqsqyelDojK6FO9w0vZLlyehIHyU1B4QIAHroX9JLd5dGqkMkWhTruAwoc7t3OUl
	 ffqjI6LXWGqxKhkL3gsu0SkHYMTXoeSS7CR/ahAG6tGD4/4AiCMWnDvW3W3XSu71jN
	 gp02Inp7AYZ5g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 03/33] xfs: fix block reservation for zoned RT extent remapping
Date: Wed, 29 Jul 2026 20:01:47 +1000
Message-ID: <20260729100629.1943710-4-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xfs_zoned_end_io() uses XFS_EXTENTADD_SPACE_RES() for its block
reservation, which only covers bmbt splits. However, the remap
operation in xfs_zoned_map_extent() generates deferred rmap and
refcount btree updates that also need blocks for btree splits
when they are processed.

The code used XFS_TRANS_RES_FDBLKS as a workaround to recycle
freed data blocks back into the transaction's block reservation.
This is fragile — it depends on freed blocks being large enough
to cover the metadata btree needs, and conflates data block
recycling with metadata reservation.

Fix this by introducing XFS_RTEXTENTADD_SPACE_RES() which computes
the correct reservation for any RT data extent modification: the
bmbt split cost plus the rt rmap btree split cost plus the rt
refcount btree cost. This covers all the deferred operations that
are generated when an RT extent is mapped or unmapped.

Drop XFS_TRANS_RES_FDBLKS from xfs_zoned_end_io() since the
reservation now correctly covers all btree costs.

Note: XFS_RTEXTENTADD_SPACE_RES() should eventually be folded
into XFS_EXTENTADD_SPACE_RES() so that all callers operating on
RT inodes automatically get the correct reservation. There are
approximately 11 sites that use XFS_EXTENTADD_SPACE_RES either
directly or via XFS_DIOSTRAT_SPACE_RES that have the same
under-reservation issue for RT inodes.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h | 12 ++++++++++++
 fs/xfs/xfs_zone_alloc.c         |  5 ++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index d89b570aafcc..4cfc29ac764f 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -55,6 +55,18 @@
 	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
 	  XFS_EXTENTADD_SPACE_RES(mp,w))
 
+/*
+ * Blocks needed to add or remove a realtime data extent: the bmbt split plus
+ * rt rmap btree and rt refcount btree updates deferred from the bmbt operation.
+ *
+ * TODO: this should be folded into XFS_EXTENTADD_SPACE_RES() so that all
+ * callers that operate on RT inodes automatically get the correct reservation.
+ */
+#define XFS_RTEXTENTADD_SPACE_RES(mp)	\
+	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
+	 (xfs_has_rmapbt(mp) ? XFS_RTRMAPADD_SPACE_RES(mp) : 0) + \
+	 (xfs_has_reflink(mp) ? 2 * (mp)->m_rtrefc_maxlevels - 1 : 0))
+
 /* Blocks we might need to add "b" mappings & rmappings to a file. */
 #define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)\
 	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w)) + \
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d13fa7ab30a..7e3456ca28ac 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -330,8 +330,7 @@ xfs_zoned_end_io(
 		.br_startblock	= xfs_daddr_to_rtb(mp, daddr),
 		.br_state	= XFS_EXT_NORM,
 	};
-	unsigned int		resblks =
-		XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	unsigned int		resblks = XFS_RTEXTENTADD_SPACE_RES(mp);
 	struct xfs_trans	*tp;
 	int			error;
 
@@ -342,7 +341,7 @@ xfs_zoned_end_io(
 		new.br_blockcount = end_fsb - new.br_startoff;
 
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-				XFS_TRANS_RESERVE | XFS_TRANS_RES_FDBLKS, &tp);
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-- 
2.55.0

