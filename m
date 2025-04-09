Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CFF25A359
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185385; cv=none; b=IHZNfLDVETzUbUh6sDmmRdIfWLxPy2gmZTqWFu8rMSF0cJ1sJh0LxkOqwdmPNZSKSvRL5syV4GJ+TFZXFGel/tptY9bMVoArtionz2uSeGIRUmRcVUzyli+ldBA2hh68jEiYTbRtZv5syuZkTEShqyFALvgWDmdd/9KQhsmNIGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185385; c=relaxed/simple;
	bh=pjSROCc4EaorLF/xvIFjeZi6DRfa84jWF/KnHdjh4iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efdT0Kp71ckZ2oD1OTTvC+4qaJ1aVgYumRuHdmM72FCJxuJd1DvX6fvQKMbNPxeRMIDdUSh9wgxKT0Hjxlox6n4PzfZOkJNOXV1UvPwobZ2h/bT7nEy5xawrf8be4kRX2ORheGMH+dtBtSujKx0bcW/+4hC5UbgAcxIfinrjd90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w31QiAeK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w31QiAeK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Tqp3OvtCgs7ijWJGkgij74HUGPt4xqwlplL3odFloNo=; b=w31QiAeKly/Y6E5A72kXauI6AL
	Ttbs3G30wBwRjmCRZxqMlcSUFd0S1HxAbkLCgK6AM52fgFcxY2JO5uMy/E9JEyHINLkIWm+ry366I
	WnjuVf7EOKlqFj+R26VeEfhdbm1pNf98/+1yHiRWR0iISjuhw+8sbLAZ86jqDVPKHdGutIYCJGjBP
	jK6hE000viIwVAnT6DcP1uqX4oWPajicY/JJCKbgFR0T1LfSfOsKBYVWRsUqyToTuRrLO15x4QQnU
	jiTCSZISZ8Oap9c8vCnfCq1voLwSiC4X9YtmYQKBYghjJpmgGUiwZc58YfDsYuJzCiNmHhitWsEFF
	wzcxo5jQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIJ-00000006UFZ-0nah;
	Wed, 09 Apr 2025 07:56:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/45] xfs: reduce metafile reservations
Date: Wed,  9 Apr 2025 09:55:08 +0200
Message-ID: <20250409075557.3535745-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 272e20bb24dc895375ccc18a82596a7259b5a652

There is no point in reserving more space than actually available
on the data device for the worst case scenario that is unlikely to
happen.  Reserve at most 1/4th of the data device blocks, which is
still a heuristic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_metafile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 1216a0e5169e..6ded87d09ab7 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -258,6 +258,7 @@ xfs_metafile_resv_init(
 	struct xfs_rtgroup	*rtg = NULL;
 	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
+	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
 	int			error = 0;
 
 	if (!xfs_has_metadir(mp))
@@ -295,6 +296,8 @@ xfs_metafile_resv_init(
 	 */
 	if (used > target)
 		target = used;
+	else if (target > dblocks_avail)
+		target = dblocks_avail;
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.47.2

