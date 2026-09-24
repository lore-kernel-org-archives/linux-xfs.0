Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD0F45A28E;
	Thu, 24 Sep 2026 10:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244071; cv=none; b=bdyYA0uSZg+/fjQQWVV3oqg3aw5JaFfaJxZOSr9k6w78uDp710Uedpo//41Y0BwbA0A7atPWeputCzMNYVngN2MJjsd+jEZbf75G2tNKMHeNf6UX90L6DGwk8Sb9pcJbBpcIKgxZiYit9GObohtJdqnwiaquE6Nhx6x8lavrR38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244071; c=relaxed/simple;
	bh=lgNXwVZLhE1qQW4N9Ymv0RqritSiVK0yNVUlNNrMeWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKn/mJJUP3FOtMPHc26/aeLYeh27ua+KLMPvSSaXchPOqNV5ibFKRcB8FJHMc8GQZAiRYHCejxvjGJowalaIbjRhGxbYJdHYVEjRAyj2if8mBWE5giZp8GB4mngNIGrxGLStko639Ve9lH0EAG6p5J406/ERWxTiB9EANBdQe94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m1uEA6ah; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m1uEA6ah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I54XiT4KEMa9iMQq20G0pD+lMh31x0gES6r9nO4rFhg=; b=m1uEA6ahGTMf7pwnE3T/yJ5vlg
	mGqa7nij0gfs6haz9gbgM5/OFySwfzXCK3Ah5Q7tKP9xPYBFTgj0R0m9jGTCEO4rYzxjws7aNKBzq
	4LjbkURC8w7Qy966u9CR2/VG54w/QjzELIk5fUi+goiT7a0+c/A1PjpuSepbAaI7el1yBl+Hi8joR
	IQ+9iB6dY9m8X/rLc0YCGmaQ/jDb5lJc3BTeYmIerj6dMDSY4IBhXt+5O5/cxzmS1h8Tk+5haTWyT
	NdNFMYbE5zklDyhO5jRZfND3KFbeZLfUFUg9cp5M9G8cTOXNY43PFlyQVYcDQDlOvtO1cD019mTYZ
	2H/IHbBA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gG7-0000000AeTR-0kE8;
	Thu, 24 Sep 2026 10:00:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 04/21] xfs: add xfs_daddr_to_rgno and xfs_daddr_to_rgbno helpers
Date: Thu, 24 Sep 2026 11:59:36 +0200
Message-ID: <20260924100032.2733101-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Translate from a disk address to the realtime group and group-relative
block numbers.  This will be needed by the data checksumming code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index fca2eb74908c..f26e324f0de3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -390,4 +390,24 @@ xfs_rtgroup_raw_size(
 	return g->blocks;
 }
 
+static inline xfs_rgnumber_t
+xfs_daddr_to_rgno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return div_u64(rbno, xfs_rtgroup_raw_size(mp));
+}
+
+static inline xfs_rgblock_t
+xfs_daddr_to_rgbno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return do_div(rbno, xfs_rtgroup_raw_size(mp));
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
-- 
2.53.0

