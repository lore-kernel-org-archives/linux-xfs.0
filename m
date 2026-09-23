Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A6F52D2D6
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180135; cv=none; b=rINh+DJ6LDlRtvjypfR7YUL5eUqRlnI6hcF2ibIyAYtK4ifXbJ/m1j2sMH5HJAQHFg6sk0eoXQl1ngOcn1eWnRpTzHVfFOapmQAocRHmdDE1uOllgkHo5PaFKVflwjf9b829s1k7BpYyuEG7ufoAtHhEvNuejarPoTD0Jn+0Rw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180135; c=relaxed/simple;
	bh=6Lj8wvoE28FWEUbr+u/7F1aYhRgfyw3YQWCchXGDEFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nhNw3t/r8A+QXsNMy9ieRo6m8WfZky5ViEmWay8PanHv3j7ZaCHtsdwOAFwhocvvKvlakw1dUZyXwZvVwCELnebqBF+sZePslWD2Gm4gmtB8w+tJ27pcRUrW6YVk4GU6EaecmUEzSwC+LKpOMDpQ+hXlRpH4MYMMG+ziwLAdoA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CcJMn2ht; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CcJMn2ht"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790180131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqGzUyXPv4WgTgOXBUIV3ZGF+AWAI8GTQ57reh7Aupg=;
	b=CcJMn2htgGNmPSMGmbDGPJKqpH/hEUEvnAv0Yr3lu2c1OoeN3tP6+LzTqrcNkfIy7Jv3kS
	XR0A6FI22oQXE8m+9yiDKp46jyKTJ84fxbFDllwzVYQp6Tzk9gE8bIR4PBNQD9mZBS84gL
	Ay8cDp23QVsEfoQoHJGsOZZiyeKziv4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-v3vDN4xDNgiZY2_GzAOA1g-1; Wed,
 23 Sep 2026 12:15:28 -0400
X-MC-Unique: v3vDN4xDNgiZY2_GzAOA1g-1
X-Mimecast-MFC-AGG-ID: v3vDN4xDNgiZY2_GzAOA1g_1790180127
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F35219775FB;
	Wed, 23 Sep 2026 16:15:27 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C24523000223;
	Wed, 23 Sep 2026 16:15:26 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v4 2/4] xfs: support additional levels in the agfl minimum calculation
Date: Wed, 23 Sep 2026 12:15:22 -0400
Message-ID: <20260923161524.416059-3-bfoster@redhat.com>
In-Reply-To: <20260923161524.416059-1-bfoster@redhat.com>
References: <20260923161524.416059-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

xfs_alloc_min_freelist() calculates the worst case AGFL block
requirement for a full split plus partial refill for each alloc
btree. An upcoming patch needs to calculate the requirement for
multiple level increases, so add an optional extra levels parameter
and factor out a wrapper function for the common case of a single
split. No functional changes.

Assisted-by: LLM
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f762dcce8d13..b2525c58051b 100644
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

