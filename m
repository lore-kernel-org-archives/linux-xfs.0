Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DA62BDC14
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942553; cv=none; b=BYvuKnC+AtRt7qfGcJVplGJ2S3AQJ4IDSve28qIhNOcvobQpcTHMkZmah64Mb86hm2d1+niI5TdXxBeNS0+k3aqD6mntEwT0CWTwnlLxuZPePmJ93Ho5TcYVLYVUEtk8m7PVVkenE+oS2qe+1/0mg2HKVjhMkpn7mhPkVYE+AGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942553; c=relaxed/simple;
	bh=eslX8DJ3zuROXDDTRFygztmpAnpwEatC+dTXSaOsKno=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N648wKmbQ1RiXEQgN8pYx2Sk+z2UB8vfekTNVlXNWKDZPC3zwv/yYVlqMuZlyL2ZDBH7T4wond3pKe8nv9QRDt3EQnYfiRSYkcA+wbPXBlq85zSJ5/IzdnBk2x2HCDz6wnRbdULFONnYE6MaCiUih8zreueuuafJIAMXIWwsah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E8DC4CEE7;
	Wed,  8 Oct 2025 16:55:50 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:55:48 +0200
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 6/11] [PATCH] xfs: refactor xfs_btree_diff_two_ptrs() to take
 advantage of cmp_int()
Message-ID: <rkk3uohh6dcd5tb4mnavzoucqio7y2bpm7ht3baeakynumt4iy@25ousn6udohw>
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

Source kernel commit: ce6cce46aff79423f47680ee65e8f12191a50605

Use cmp_int() to yield the result of a three-way-comparison instead of
performing subtractions with extra casts. Thus also rename the function
to make its name clearer in purpose.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_btree.c | 8 ++++----
 libxfs/xfs_btree.h | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index facc35401f..8576611994 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5350,15 +5350,15 @@
 }
 
 /* Compare two btree pointers. */
-int64_t
-xfs_btree_diff_two_ptrs(
+int
+xfs_btree_cmp_two_ptrs(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*a,
 	const union xfs_btree_ptr	*b)
 {
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
-	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
+		return cmp_int(be64_to_cpu(a->l), be64_to_cpu(b->l));
+	return cmp_int(be32_to_cpu(a->s), be32_to_cpu(b->s));
 }
 
 struct xfs_btree_has_records {
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1bf20d509a..60e78572e7 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -519,9 +519,9 @@
 		int level, struct xfs_buf **bpp);
 bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr);
-int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
-				const union xfs_btree_ptr *a,
-				const union xfs_btree_ptr *b);
+int xfs_btree_cmp_two_ptrs(struct xfs_btree_cur *cur,
+			   const union xfs_btree_ptr *a,
+			   const union xfs_btree_ptr *b);
 void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
 			   struct xfs_btree_block *block,
 			   union xfs_btree_ptr *ptr, int lr);
