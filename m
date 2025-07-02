Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE326253B7B;
	Wed,  2 Jul 2025 09:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751449227; cv=none; b=qTN16uUMydAnk2v1EuG5zqll9sE2wJiGcSRH/zAqA4pfqosXU7Qmv75RP1Fw4rcJSmvu7t/XiFwLR3LQ2VoJOUdp0JKg+T625tcUHuoh2TL2W+9tadaN1CNJzKjOz2FV+Syr27VmQxHFo/EsWiRzLy5d+6pnBCcG8ohqStYhHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751449227; c=relaxed/simple;
	bh=SWBV92Aw9D0MuSpaoBqozv/60pjWKAg+MXiW9xCAc6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV/pggfOenwEoFWvcOMXvuKD1oh2nWHldP073fziR3V1v1tP73otHw1XQf4/5Gm7EvlLm7+gPGMHPkAJ4kRUZ7ppb37iXXyttg0jy4paDp7GD997KWhx/CttP1k666XmR6FZFWMMNV616JhW53/d24YO0b46qlqIaVRdpjDisak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=PrMjVQDO; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="PrMjVQDO"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id F0A1F40777A0;
	Wed,  2 Jul 2025 09:40:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru F0A1F40777A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751449215;
	bh=qJ+yQ7bGSosbW+GSIN8nYNUzz74OZS3bFx3ImJMdxjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrMjVQDOuV6INje+Bv9Z+cGrKOK8S9K8eyZArGjs0VJivj5duZuvSefw9+t4C6GVw
	 Q3gByugtGFN3jiyRiYpDWL1aiZzOQ2n7iEDH2KhIeDsbDjvsHHIeutJ5JmtTu5EKyA
	 PLheMnJmGL/ZeyMdsIMxtIQjhO/3biVkyIkNmm6E=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2 6/6] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()
Date: Wed,  2 Jul 2025 12:39:33 +0300
Message-ID: <20250702093935.123798-7-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702093935.123798-1-pchelkin@ispras.ru>
References: <20250702093935.123798-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use cmp_int() to yield the result of a three-way-comparison instead of
performing subtractions with extra casts. Thus also rename the function
to make its name clearer in purpose.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---

v2: rename the "diff_two_ptrs" part (Darrick)

 fs/xfs/libxfs/xfs_btree.c | 8 ++++----
 fs/xfs/libxfs/xfs_btree.h | 6 +++---
 fs/xfs/scrub/btree.c      | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d3591728998e..a61211d253f1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5353,15 +5353,15 @@ xfs_btree_count_blocks(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1bf20d509ac9..60e78572e725 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -519,9 +519,9 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
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
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index fe678a0438bc..cd6f0ff382a7 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -306,7 +306,7 @@ xchk_btree_block_check_sibling(
 	if (pbp)
 		xchk_buffer_recheck(bs->sc, pbp);
 
-	if (xfs_btree_diff_two_ptrs(cur, pp, sibling))
+	if (xfs_btree_cmp_two_ptrs(cur, pp, sibling))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 out:
 	xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
-- 
2.50.0

