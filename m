Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB401DF724
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393161; cv=none; b=abDhzPJoaPx8pu8KgNlOS39OlIag3LMVUx3ZciO6nqGV3Yw2r1Vaar26XbiVc5y6Iwa//8VPR4Ga1NzHStRWuEuWK1BvKoxuhs6F3ykgxbiQzLYbhuX1DhxgZNlO1o9ap2XtJYaOk5iw/ylf4t1hZMMJZBKDvti8K4JatFCA46s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393161; c=relaxed/simple;
	bh=A9d3YbDlFpVoVmfCqHG5vyYLWAokbLZrXDxD/4ddOw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uusIuZ89LyUToG+58mBYgG2KI5OohfVcpb0wBGbRkw7SaorsGZTokvnkUv1fumFMcyebfJrtAqDA1e6STrJi4Sdfm2+eJGO5Yi+TfDTP2yBEv9rKrBKlcr1tO6rWa4HnW/qf0ThsoOKkRBkG3nXaVQbJ3UILaryMELKygX1m7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MzTO1uxs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MzTO1uxs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8RZv//V+dBGpG3JlqV80/E8nyvqMnJU3q3p26cnuGvw=;
	b=MzTO1uxsVIiZ8FoFv23mSlkhUSbBWuW4Al08NPwLqXrhXEDxuuyZOHE/ZkMRnZyK3733i+
	opbcYASyHEcRXdjzsNSatgfQPzJ0EZiRTNMA3ejfklMQ4w5otQ54+0qPHOfF9xk08eS6/4
	67w7gFqTMsTupThfvBVXarDL3hy9B94=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-YjNSmY9tNlyXRRrCxgin9g-1; Tue,
 08 Oct 2024 09:12:36 -0400
X-MC-Unique: YjNSmY9tNlyXRRrCxgin9g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 222E01956064;
	Tue,  8 Oct 2024 13:12:35 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4AB5519560AA;
	Tue,  8 Oct 2024 13:12:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFC 3/4] xfs: factor out a helper to calculate post-growfs agcount
Date: Tue,  8 Oct 2024 09:13:47 -0400
Message-ID: <20241008131348.81013-4-bfoster@redhat.com>
In-Reply-To: <20241008131348.81013-1-bfoster@redhat.com>
References: <20241008131348.81013-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Factor out the new agcount calculation logic into a helper.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6401424303c5..3b95a368584e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -80,6 +80,33 @@ xfs_resizefs_init_new_ags(
 	return error;
 }
 
+/*
+ * Calculate new AG count based on provided AG size. May adjust final nblocks
+ * count if necessary for a valid AG count.
+ */
+static xfs_agnumber_t
+xfs_growfs_calc_agcount(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		nagblocks,
+	xfs_rfsblock_t		*nblocks)
+{
+	xfs_rfsblock_t		nb_div, nb_mod;
+
+	nb_div = *nblocks;
+	nb_mod = do_div(nb_div, nagblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		*nblocks = nb_div * nagblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		*nblocks = nb_div * nagblocks;
+	}
+
+	return nb_div;
+}
+
 /*
  * growfs operations
  */
@@ -93,7 +120,7 @@ xfs_growfs_data_private(
 	xfs_agblock_t		nagblocks;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod;
+	xfs_rfsblock_t		nb;
 	int64_t			delta;
 	bool			lastag_extended = false;
 	xfs_agnumber_t		oagcount;
@@ -117,18 +144,7 @@ xfs_growfs_data_private(
 
 	nagblocks = mp->m_sb.sb_agblocks;
 
-	nb_div = nb;
-	nb_mod = do_div(nb_div, nagblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		nb = nb_div * nagblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * nagblocks;
-	}
-	nagcount = nb_div;
+	nagcount = xfs_growfs_calc_agcount(mp, nagblocks, &nb);
 	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
-- 
2.46.2

