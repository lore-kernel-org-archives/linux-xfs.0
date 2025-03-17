Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B714A0A8
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190320; cv=none; b=YiJ9ms8xaQT1J1DdagussBeEXa7yfphlmsQcIZ4Mi3pwdPbJsny+GLnYT86rs0Z896qEy4WamD9YLz2OBbqJkKjC9Xdex5RuAtQb+5/1fO/nFguzulL64GZBktYPWZVIDocaHcYdMFt+KzIaHP1OICSdVm7/QbqDM7UlNTl7opc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190320; c=relaxed/simple;
	bh=n0cV9ItDVVoMoh8QfjmznGd/8w2VVimHxww4zWuDgsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAXlFbM5Rck4VfeeJT0aLD2cE4T3+n3VvXWz38m8Ig6nK0lCUyKlCbQGXMIvlouAEMYkZoNeQKdDhD3DwykgF3/2OpoZTjWEeORSzlB+e0vgP6HdSxQBA4Kc89s7i/JyGgEzfv7939xYUVwVX9K1TwUthZ063TYe0CtQVItDSlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sOpAssbX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sOpAssbX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Vn0u7Ea63cebEyUv0H2kRY7Sn+nVHt9uzFUjWqwjlXI=; b=sOpAssbX7l2GoHnIGkaXNYpRMD
	bVaq+lgH7wwDG3ea3S2/HDghItXAe8RTcuAXJUoOr1cfcWGybUx4q6GcKFBGquTFVk7ih41DJGdx+
	PpDQHbE8Onxtkv7bOkesVU2OqCtCUj7vetAsO4hriuV4oKOaWHGcjcEdF6fgs9RY0392EaLiPBs5u
	IrzTeD27x081jL0REZRZWhYjwJmh+58WAe/CY0SceAaLLMfmUF8kWxXPTDqSqe6xCX2K7HMjEEeEh
	G3IRJ0wxJo3krvhhKpzMddS0diIeqUXmc4P17zYUjcsirhgkWPpvFcA+dCaGyPPX4k7KU5wAy/2tA
	/xsrqkug==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3Hp-00000001IVp-3L1w;
	Mon, 17 Mar 2025 05:45:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: fix a missing unlock in xfs_growfs_data
Date: Mon, 17 Mar 2025 06:44:52 +0100
Message-ID: <20250317054512.1131950-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054512.1131950-1-hch@lst.de>
References: <20250317054512.1131950-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The newly added check for the internal RT device needs to unlock
m_growlock just like all ther other error cases.

Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ee2cefbd5df8..d7658b7dcdbd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -301,7 +301,7 @@ xfs_growfs_data(
 	struct xfs_mount	*mp,
 	struct xfs_growfs_data	*in)
 {
-	int			error = 0;
+	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -309,8 +309,10 @@ xfs_growfs_data(
 		return -EWOULDBLOCK;
 
 	/* we can't grow the data section when an internal RT section exists */
-	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
-		return -EINVAL;
+	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart) {
+		error = -EINVAL;
+		goto out_error;
+	}
 
 	/* update imaxpct separately to the physical grow of the filesystem */
 	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
-- 
2.45.2

