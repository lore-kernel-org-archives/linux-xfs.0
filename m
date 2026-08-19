Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B7023D283
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098494; cv=none; b=cKUD7IOfdsdYEI/Lb5Za9+QBuLgJU1J8I9xM1gdB7YiEfezeITN5aywIOx4Pl/irfSzlDH5rv2xqNH0TYfpviMm1VfPRirH2Fp27gxg4Ss/7tGDsuXjJkhgOKlg7k4uq1QTQXNJEQUNI7ek92xhRenZ6kqFXXzrRC/+H297P5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098494; c=relaxed/simple;
	bh=a1Nd2FM03p3JaggKJiqcH8lehvrmectZ5yJ412Ma1Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iD0ylF7qj6RH04elKuz+yEbf2SFSuuuiR33o2oeewzQ/uqpRARjxW/aAdTOHEqsNUR4idnXiTTRZ7jO6osPdh9sqE8vt6sAzvt+3e438IydxoXHq7xmhVq8z3vgx98U/uqzpUg5lDh1pVMY2wEMycSqyX8uDH9F42B8OMr4LsKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0cHVT7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0cHVT7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69B01F000E9;
	Wed, 19 Aug 2026 00:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098492;
	bh=i1dCB6LSQxWEOAtDoUjDEFHt0EkbFQNJ3aAR5xgyFOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0cHVT7dnKaoruGqf1zZAQ7OKt2iiuN7keO/zaJKCo41p5bxryuGdOTbSuXVbmqaU
	 TYj9+gE+DvgWm0oiwdwrjty3PM8CuknGlhl0i98sOZHAEDVKmBv+hWBd2ABVr0VmZP
	 +a4SoIrqn9B0pOiIPnuUOMNp2xZMYH6jSSlkEcfGfS9yMcPYxJNxrFqfTO+WZrcpgs
	 ayz8w8gnNzD5DCdkdjlmzvSb2/JtXrSjDQPBtz98s5y4Ao0CoIMnVwKyWv97HMZ6+5
	 +4tYCBX1TwQCNNw3RTZtJpkZK4axNMrPL36u+qPhDaC9b9TyrdABtKU555/Tg1iBic
	 a5RkJTrJNbp/A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 04/38] xfs: fix block reservation for zoned RT extent remapping
Date: Wed, 19 Aug 2026 10:12:07 +1000
Message-ID: <20260819001442.1451892-5-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
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
 fs/xfs/xfs_zone_alloc.c         |  9 ++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

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
index 7d13fa7ab30a..61b483d24c88 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -330,8 +330,11 @@ xfs_zoned_end_io(
 		.br_startblock	= xfs_daddr_to_rtb(mp, daddr),
 		.br_state	= XFS_EXT_NORM,
 	};
-	unsigned int		resblks =
-		XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	/*
+	 * A remap performs two independent BMBT modifications - an unmap
+	 * of the old extent followed by a map of the new extent.
+	 */
+	unsigned int		resblks = 2 * XFS_RTEXTENTADD_SPACE_RES(mp);
 	struct xfs_trans	*tp;
 	int			error;
 
@@ -342,7 +345,7 @@ xfs_zoned_end_io(
 		new.br_blockcount = end_fsb - new.br_startoff;
 
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-				XFS_TRANS_RESERVE | XFS_TRANS_RES_FDBLKS, &tp);
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-- 
2.55.0

