Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128634611C9
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786713769; cv=none; b=T0DzMVFGL446ue8k0pKzf3d4gXEjRUMftiBQXhusnR2x0t9QARs4BPj8YMnacnz4y5MvDHet342IgFaAn0HPIinR3cHzcWfBwOaMfGS72VUM4nsXXGZM6GczAuF2muwYNhrSlzTGUVP/S20+ZH9016qbX2z9jF1pNBLWI1+94pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786713769; c=relaxed/simple;
	bh=oIVw1E0Y/W+WP4Z9z62UeHYAhcNLU35i/pNdVAD4LvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V53PGRqg5g+9pg5dL22L/fEKbotdP5Kt/534R18ZWbjq5C5l8TMwLLVgHCr7bfUfHqm6DvowATpNBJCLzUX9iA80TMsYnEGKtARo1V+Zc8Ch64FOxt9QjMkzNYWwzHW8rTM2OTYcIAUTsz6zitH+vnl/d+7/91SxRPMzdleiLcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HbzBC6JZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbzBC6JZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786713766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9fFU+cg8rX4Q3A6IRvwLlprp226/fXfQ6pKVnxUrZ8=;
	b=HbzBC6JZM1HtSUNhI6NV+7QLz9n+amdTjvbnDc009wSio95AN0BFRf3aXtBJ8EFGqzSq5D
	vLDkHZJxAbFwLcBKWfqBXcwFEKwRd6gEarWi5EWuKLdUgvuJwwE60INKh8BHl4pe2MhkCo
	b9UFU367F+rprIB2FQdUSamh69jxGLs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-z19hqayEN5axTG_x1UblLg-1; Fri,
 14 Aug 2026 09:22:43 -0400
X-MC-Unique: z19hqayEN5axTG_x1UblLg-1
X-Mimecast-MFC-AGG-ID: z19hqayEN5axTG_x1UblLg_1786713762
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7838E1800145;
	Fri, 14 Aug 2026 13:22:42 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.105])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E46FE195608A;
	Fri, 14 Aug 2026 13:22:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH v2 2/3] xfs: support additional levels in the agfl minimum calculation
Date: Fri, 14 Aug 2026 09:22:38 -0400
Message-ID: <20260814132239.271492-3-bfoster@redhat.com>
In-Reply-To: <20260814132239.271492-1-bfoster@redhat.com>
References: <20260814132239.271492-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

xfs_alloc_min_freelist() calculates the worst case AGFL block
requirement for a full split plus partial refill for each alloc
btree. An upcoming patch needs to calculate the requirement for
multiple level increases, so add an optional extra levels parameter
and factor out a wrapper function for the common case of a single
split. No functional changes.

Assisted-by: LLM
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d99602bcc16f..dbb85fb6314b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2439,17 +2439,22 @@ xfs_alloc_longest_free_extent(
 
 /*
  * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
- * return the largest possible minimum length.
+ * return the largest possible minimum length. The base calculation accounts
+ * for a single full split per btree. @extra_levels adds additional split
+ * levels to compute the prospective AGFL requirement increase for
+ * multi-allocation transactions.
  */
-unsigned int
-xfs_alloc_min_freelist(
+static unsigned int
+__xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	unsigned int		extra_levels)
 {
 	/* AG btrees have at least 1 level. */
 	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
 	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
 	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
+	const unsigned int	levels = 1 + extra_levels;
 	unsigned int		min_free;
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
@@ -2476,15 +2481,25 @@ xfs_alloc_min_freelist(
 	 */
 
 	/* space needed by-bno freespace btree */
-	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
+	min_free = min(bno_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
-	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
+	min_free += min(cnt_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
-	if (xfs_has_rmapbt(mp))
-		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
+	if (xfs_has_rmapbt(mp)) {
+		min_free += min(rmap_level + levels,
+				mp->m_rmap_maxlevels) * 2 - 2;
+	}
 	return min_free;
 }
 
+unsigned int
+xfs_alloc_min_freelist(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
+{
+	return __xfs_alloc_min_freelist(mp, pag, 0);
+}
+
 /*
  * Check if the operation we are fixing up the freelist for should go ahead or
  * not. If we are freeing blocks, we always allow it, otherwise the allocation
-- 
2.55.0

