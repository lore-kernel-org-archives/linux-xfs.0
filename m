Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A15238176;
	Thu, 12 Jun 2025 10:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723932; cv=none; b=O8xtVQ6Lo92OX7lkENlwHsXCQ6LnCYIPDtACy2fguCfsuG+WL6hI3H/Wh8wcczhISsMu0JuxqHTsNzlw38qkVprQEEQ0x9RpqVABAWHs+AW43fFjsh7T5SOT73XGFCakq1+jzxNHnXC8WApoI9jI4nQ+tRR0e/zEzlPy/AfgDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723932; c=relaxed/simple;
	bh=IL/Ee0kDLb8vKxIQmMw05p8FdmrpU4ne3hnvCI1+tys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWVHtq3qPPubjycnDvpzNg2EUugEINbI99v71Cb1h+TUADhrlPkGtgDOglbtGB8NZAIHHkM+r+nTy9CNhCnzB7GILvZNVR2GmIKZYwV3oBQIpTXif3w7uVtBK9t6ewLmA1zv532m/0NAEFLieJ17VcdsEyFdNf3xMn+9ULGPj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Omfq8Zw3; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Omfq8Zw3"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 39F7F40737D7;
	Thu, 12 Jun 2025 10:25:26 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 39F7F40737D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749723926;
	bh=PF768aoX4r6yIrDUHf+haREU0cDIObqduX7ooUbbWAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Omfq8Zw32u6QjraRHp/3OS6OO0Dxhf0Sa4NeamJ+9oYx9eHyQG208M+zBiRsfhKv+
	 mRB97JkSyhVBnDm9Ozd3Y6ProVBNRjbbQ8zcDgAv1LiNZ0L0iRxAYTLC+vd203jYVL
	 /Sl7huHw7cP64zYs/MNk44O/F4xltwmypyvkEp3U=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6/6] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()
Date: Thu, 12 Jun 2025 13:24:50 +0300
Message-ID: <20250612102455.63024-7-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612102455.63024-1-pchelkin@ispras.ru>
References: <20250612102455.63024-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use cmp_int() to yield the result of a three-way-comparison instead of
performing subtractions with extra casts.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/xfs/libxfs/xfs_btree.c | 6 +++---
 fs/xfs/libxfs/xfs_btree.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d3591728998e..9a227b6b3296 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5353,15 +5353,15 @@ xfs_btree_count_blocks(
 }
 
 /* Compare two btree pointers. */
-int64_t
+int
 xfs_btree_diff_two_ptrs(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1bf20d509ac9..23598f287af5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -519,9 +519,9 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
 bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr);
-int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
-				const union xfs_btree_ptr *a,
-				const union xfs_btree_ptr *b);
+int xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
+			    const union xfs_btree_ptr *a,
+			    const union xfs_btree_ptr *b);
 void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
 			   struct xfs_btree_block *block,
 			   union xfs_btree_ptr *ptr, int lr);
-- 
2.49.0

