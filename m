Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0A5346AC5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201688; cv=none; b=KaXGYde10cyBc2m8SN3WVds8I20m6GyFr4+VZLsvOTfwKlcJIWAOqm6F0/cF8riHYQcqRVppcGyuzfMe/d2QRA2oqCrIHPUKz41gvncclR+J5b146dRTwFfSw6gRCXuOgMypMjAh6Vg7m8RH3SI/gnQ2pK+HyUdbi+Vmi4FNkY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201688; c=relaxed/simple;
	bh=6Lj8wvoE28FWEUbr+u/7F1aYhRgfyw3YQWCchXGDEFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HldlRF/mVrQW/EAWyjAUQqyfriapqtSRk6qszNwi8zVMdGxIIT1j1zE7fvf+r7xMEDkujzaO3AS8T6x5bRpMVLoU0JUywsYJy7PpWxoJORI+wkHaqo6fnuvOOgAIOUPpS8V1k65LixUQN26klAYbmK4niZyCcfe6ue7lpm80mC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RwrjMXaY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RwrjMXaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791201685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqGzUyXPv4WgTgOXBUIV3ZGF+AWAI8GTQ57reh7Aupg=;
	b=RwrjMXaYtTE8K3X5GyICGEVKLo+3CBj7TpVzcfwhKmv89ikC4S/gt94xqp+7XEh1YVFfvA
	Edsa9abuTErVFGXSXBe6tLCqbrp3UcuEX6N+u462oLWetp4t8hF+JSOa1mMhVowJgqYYbG
	CLSSev1ZAGnZeFvkSAjqI+RQHXxnVI8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-2HIS93AvOpqDPN7OxIz2VA-1; Mon,
 05 Oct 2026 08:01:22 -0400
X-MC-Unique: 2HIS93AvOpqDPN7OxIz2VA-1
X-Mimecast-MFC-AGG-ID: 2HIS93AvOpqDPN7OxIz2VA_1791201681
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DD0F195411D;
	Mon,  5 Oct 2026 12:01:21 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B50CD1956087;
	Mon,  5 Oct 2026 12:01:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v5 2/4] xfs: support additional levels in the agfl minimum calculation
Date: Mon,  5 Oct 2026 08:01:16 -0400
Message-ID: <20261005120118.229086-3-bfoster@redhat.com>
In-Reply-To: <20261005120118.229086-1-bfoster@redhat.com>
References: <20261005120118.229086-1-bfoster@redhat.com>
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

