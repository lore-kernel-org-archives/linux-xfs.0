Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF01340410;
	Mon,  8 Jun 2026 05:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780894937; cv=none; b=QQKw2W4jZXvqIRA4Q8o9VgmpffoYo/KkT9t6YJm4GGUfcMi2822BPQQo3R7m12y1EmkFcdWOrBZyDOxjjL0umPbgARJ0fIo8DbVYnKFvBef8Q/WzaTxCgWSOKAj3xKkhmf2PnJW9pltJfwqQUn63a32iXg6fgRVS6y+d+qvozfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780894937; c=relaxed/simple;
	bh=uvwSqiH+WqChYPpNZ0rJX0SQYPniBrlkWF8DqYIyRTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+yJaPqxYsH/LrWNftgt+p+YSOVuZAjMI1U6cUCQVA9D3Gctft42f8cHNGGo+4Kz7N/xizOwOMyaOsGwqoy1C/Sj8wwhg7CdXu8T1DLE6W/jofdsm4fMlz8fuk+8WKyUqYxY1BvEDyqHv9jzAzWbeHITOdZS/Y76zm0dgzAmbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZtRpl5d9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZtRpl5d9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ntdINcV/MtFDkQvCBTRmJMDU8OdksVLywgaGQ7MRh9o=; b=ZtRpl5d9SBawu8lH/M85daAxNt
	pg2zNs0P6weYoR/I+EBIC20dF3RqurNAkrhJgp8OQxLkj8ekKRuAs3RUfqnbPrGdnR9EShfhTOuLn
	O4bVTcKmuPkrpV7QvFpK9mp5iQVpnD/4RdI5JWc1Vl/39mo9++JSMly8JydeKE93UUHfSXWKwsmyb
	ofA7JJI7YfpMz0orOMK7uK8kkZApvKCXUplBv8S/YQyDAjarOtXMbGzSH9ZH30IpjfV5nxh7aUxjG
	3ZHGcVGPpvYZtDL5+nuB2ETjQqI3ecs/w/58C6m3uXz1T9Bz1a8KnxczxCOI7S5GhUdAyqaKghJo8
	AxdF2DJg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWS7q-00000002ocu-0jzo;
	Mon, 08 Jun 2026 05:02:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] xfs: pass back updated nb from xfs_growfs_compute_deltas
Date: Mon,  8 Jun 2026 07:01:55 +0200
Message-ID: <20260608050207.1203276-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608050207.1203276-1-hch@lst.de>
References: <20260608050207.1203276-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_growfs_compute_deltas can update nb for corner cases like a number
of blocks that would create a less the minimal sized AG, or running
past the max AG limit.  Pass back the calculated value to the caller,
as it relies on to calculate the new numeber of perag structures.

Note that the grown file system size is not affected by this
miscaculation as it uses the passed back delta value.

Fixes: a49b7ff63f98 ("xfs: Refactoring the nagcount and delta calculation")
Cc: <stable@vger.kernel.org> # v7.0
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 10 +++++-----
 fs/xfs/libxfs/xfs_ag.h |  2 +-
 fs/xfs/xfs_fsops.c     |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index dcd2f93b6a6c..0c5f0548021f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -866,7 +866,7 @@ xfs_ag_shrink_space(
 void
 xfs_growfs_compute_deltas(
 	struct xfs_mount	*mp,
-	xfs_rfsblock_t		nb,
+	xfs_rfsblock_t		*nb,
 	int64_t			*deltap,
 	xfs_agnumber_t		*nagcountp)
 {
@@ -874,19 +874,19 @@ xfs_growfs_compute_deltas(
 	int64_t		delta;
 	xfs_agnumber_t	nagcount;
 
-	nb_div = nb;
+	nb_div = *nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
 		nb_div++;
 	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 
 	if (nb_div > XFS_MAX_AGNUMBER + 1) {
 		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 	}
 	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
+	delta = *nb - mp->m_sb.sb_dblocks;
 	*deltap = delta;
 	*nagcountp = nagcount;
 }
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 16a9b43a3c27..8aa4266c5571 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -330,7 +330,7 @@ int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
 void
-xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
 			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8d64d904d73c..436857356a0a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -124,7 +124,7 @@ xfs_growfs_data_private(
 			mp->m_sb.sb_rextsize);
 	if (error)
 		return error;
-	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
+	xfs_growfs_compute_deltas(mp, &nb, &delta, &nagcount);
 
 	/*
 	 * Reject filesystems with a single AG because they are not
-- 
2.53.0

