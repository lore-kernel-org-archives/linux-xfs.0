Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664C333F59A
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110364; cv=none; b=nufiqySz+bjWUSo0WMDGm5JdZ0qlkauGksR23xq1B+OgwHFT42edfivbmAT56LoPjXj/kRt6Rbghl8kxXmFp/S+xehjWIv8IMPBtEFy/ekM+LHvswVKXRMFvf4zq3ZC4gbM2H0N+LRFkCKsZFdqCU93M70XSJl8b5WjZ72t9Epg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110364; c=relaxed/simple;
	bh=nt4IeR0v+d5axrLu/adB+zlBbfbzBdzBQcTIglMHmds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zqn07UJGWG79899BVSeODLD0mOLVo1tmm64Rsws81kOCvsRtvKT88wZRWJQd1tlzYXHMb7bMWojEm2tOi/28Hqo2tiYsY0Lx9gdRwprBCcHTkHRXavdZmX01UuHHydk+CqiBpAn+fshV53BW+A8Um4Bl8NBwx74bR6t2cQuRzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QgakN6+Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QgakN6+Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TCz7nVjMxWFz4PKR2lsJu1e9uKSRHXlEvPIVq5v0/+k=; b=QgakN6+Q5uZa9BxQud8nB7KIxa
	oWcv+Ik4cxRkgarK2rt7x8MxNmxqq5EPh4N0o7/VM3Q3osZfz1HnB9VJI4OfLcc0uzf+sMFpShZik
	pCWU//9bq9WFCZ1Tlr+nO+GfKLDAYlPmAGZSCmQBy+VpHYBnykH1Z+W6xB1ipkbc0E8tB9aI/miSo
	6r0lKokKwQngP54BzP7+OCAsj182dK/TpfCQNZ4Ld8t+7sPPrnoYwdv8BL8XWjtMCVlT6azuCxuFM
	P/2f2siDFIiK0SJA4OCaw4CbZvXVphrDqh2hvy8bTw8PUU9+mHN3dIA2NSZP4sOiosU+HokmjVIni
	7jaqFUPg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vKY-0000000Fzqf-2ggZ;
	Fri, 11 Sep 2026 07:05:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] repair: remove the ip variable in ensure_rtgroup_file
Date: Fri, 11 Sep 2026 09:05:48 +0200
Message-ID: <20260911070548.1760348-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The values is never used after the first initialization, and only twice
after the second one.  Open code the dereferences for those to remove
the dead assignment and to keep the code simple.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 326fdfa3afb4..f3951a3d0709 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -622,7 +622,6 @@ ensure_rtgroup_file(
 	enum xfs_rtg_inodes	type)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	const char		*name = libxfs_rtginode_name(type);
 	int			error;
 
@@ -651,11 +650,10 @@ ensure_rtgroup_file(
 _("Couldn't create rtgroup %u %s inode, error %d\n"),
 			rtg_rgno(rtg), name, error);
 
-	ip = rtg->rtg_inodes[type];
-
 	/* Mark the inode in use. */
-	mark_ino_inuse(mp, I_INO(ip), S_IFREG, I_INO(mp->m_rtdirip));
-	mark_ino_metadata(mp, I_INO(ip));
+	mark_ino_inuse(mp, I_INO(rtg->rtg_inodes[type]), S_IFREG,
+			I_INO(mp->m_rtdirip));
+	mark_ino_metadata(mp, I_INO(rtg->rtg_inodes[type]));
 	return true;
 }
 
-- 
2.53.0

