Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12298330D38;
	Tue, 16 Dec 2025 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906229; cv=none; b=C5S0uBq9LMQgvDyu8BqOJSZVzdrq+BIGm0lj48OAPIFr51XnuolrRprCPVAtbcBWDiWRHpQW4C3E7PWUmAzf5nPYbdTk9hSfx2FAeZAMznwUe+ZqMbzbsbXMgSDx6dmPA5kDtl3bnZ0HAnucu15aq7+J+YPSUIiyb6fJVM35Z1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906229; c=relaxed/simple;
	bh=U0qOInL5Of5lvkwXNQKN4PxqBOAnH0WmPuAceQtGuYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDNse+y4L9luIwCjaB61iEA1dD5Fp+Jy+9Pg/8R4NLaNHQyRSLbu1gDvSJvQqypRkM5jy5nT9X+dXCvz6rSjABm3Qp6JQYNOwCYUp+LCRbnmgBOd68tNpJxa4+cFdm3Jnf3qgbcOrzFCRXe0BQaVvzOGX60rK0TvKcTmY3n9dxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2+QGmr8Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2+QGmr8Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uL3GCnv3KJi25Oj5L4+fxPAZNUtzjRkCYqMlQumkCgE=; b=2+QGmr8Y4V/xxw9YQjxt85h1rL
	/zUQkWlQ8dT/3v7cyHbQWI+N3n5pynFpvcyWvAnFpqD8R7X/J4Itz479H+MKr9jw5UeD9Gi9og5KO
	lqY7wJCJZ8Lx8WM4lVHX3DsDrQXDrif3+RIolvFR07gJ6yKWD9ivpZJ6t4Ynlv2ILzR8upBm54W3A
	CJ2VyBtpQhqwrsrG1GcQYfoS4d86fz/efrF2pmYvVLR87JMtlz8GXVEEQQ/sUqLvAxk0+GMnItQMR
	LdYyzK7iRDFjWLKjEwKO243ilAhenh/w4Y1max5KIi3i4s5Km8Mac9A8Ytn3wTUWridYpPJ11t2Y0
	Xy4cpA4Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVYsT-00000005cCy-1PwR;
	Tue, 16 Dec 2025 17:30:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] xfs: validate that zoned RT devices are zone aligned
Date: Tue, 16 Dec 2025 18:30:08 +0100
Message-ID: <20251216173014.844835-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216173014.844835-1-hch@lst.de>
References: <20251216173014.844835-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but make the kernel check it as well
to avoid getting into trouble due to fuzzers or mkfs bugs.

Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: <stable@vger.kernel.org> # v6.15
---
 fs/xfs/libxfs/xfs_sb.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cdd16dd805d7..94c272a2ae26 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -301,6 +301,21 @@ xfs_validate_rt_geometry(
 	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		uint32_t		mod;
+
+		/*
+		 * Zoned RT devices must be aligned to the RT group size,
+		 * because garbage collection assumes that all zones have the
+		 * same size to avoid insane complexity if that weren't the
+		 * case.
+		 */
+		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
+		if (mod)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.47.3

