Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38C2360EEE
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370837; cv=none; b=frCSJPxkFJZSI00YAsr05ukUQ6gldEr3UKSO6xEnv+CRUY7wJhcrRFK3nM9TQ7knadR1Mgo/DaZLBQwv+38cWm7d2pUD2F2J+u45BG5b+em32Ga8KqMwQebg8JPAzmjDhqEZlYf2YXXXKcuQM/5Sy+D+NMKBBOW3cvcdo/V7Yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370837; c=relaxed/simple;
	bh=h+9/pYynAtGy+Ct6r6nu/iE/jQfiV/XH6RTHvGA7Bq4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyspPt52U3fWzmPQX0bEELRNaCinWc2AZpMJuDsm1ZJion0LjBxXeb5F6+tAQJ1puuDyhZ4w4xlu8YDoPsBN8E68MtF/HZICvK/JLfOZJfmpC6gQWrQ28dupSMTptBNRjBaos/bASWm5XvP6M/+V+bK07IXH5DflIEFhbTYHfsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezaR6uSd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezaR6uSd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FknVGBkBix2brSCB2MWQbrBTv94WqMACH+rEBSO0//E=;
	b=ezaR6uSdlL2A60VM2pSEJsOi+lMO7ySlfnxnT51aKdl+L+2Ovjs4l9w/YhyhwcftQIkJ44
	Pf1bRE+9OsUJ7HhCo00zzaKCvx0SHlYnrL9knHrsQjJB8VMP8AqeCUicC8KaG8dKL1Gtnz
	OyvsbeasrM60CWE/kULMdCv2XPV72dw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-3nK-9igtPYKyIeP6rxtKOQ-1; Wed,
 02 Sep 2026 13:40:33 -0400
X-MC-Unique: 3nK-9igtPYKyIeP6rxtKOQ-1
X-Mimecast-MFC-AGG-ID: 3nK-9igtPYKyIeP6rxtKOQ_1788370832
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 414E61955D7A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:32 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D768B1800765
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/4] xfs: support additional levels in the agfl minimum calculation
Date: Wed,  2 Sep 2026 13:40:23 -0400
Message-ID: <20260902174025.284387-3-bfoster@redhat.com>
In-Reply-To: <20260902174025.284387-1-bfoster@redhat.com>
References: <20260902174025.284387-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

xfs_alloc_min_freelist() calculates the worst case AGFL block
requirement for a full split plus partial refill for each alloc
btree. An upcoming patch needs to calculate the requirement for
multiple level increases, so add an optional extra levels parameter
and factor out a wrapper function for the common case of a single
split. No functional changes.

Assisted-by: LLM
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

