Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA563FF1CB
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313243; cv=none; b=Yc/XUYMuLJgRnpK1ZX/+eaN+cQ/fHndSEm9Ay3RV0e0SaxQvvnwazA9xiVcZ1LNyBMGCe5mjoQvMUgIn2UsK8kNXbUBgsyiUj/NFB2kMUb0BLuKgx6TR4qZbk8asVOhXbtL/G1YYh/k/77Z1pNaoQZb/klGqxRTVhCrPc1YITjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313243; c=relaxed/simple;
	bh=SPjvy1VdPIQkY2TLzSUdRsWExCaRm2l0hIW+KWNYD7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctUI+AD5I6um2U9a+aVz/+Qg//Nya9E48R6fx0XZwZK88YUvKBrIVg0UJCYvXj+GQHO4t5x2euQLvzLgJ91QBzBlyfIPuk58BC3ecxpniav/a6rY87WQRUp7T2xrKeR/CP9nhh57QiBR7t4BfV2dMJsgDLgQiE86itjQApyyo00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q0wmBDQW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q0wmBDQW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Wi0xkmYnlmVwT9aVc/lCb89vKxL46HRLXcJO/TYdiw=; b=q0wmBDQWvRHn7A3nhxdMHQNp5f
	zlWgPd/cvOOuQwZsSMAiKtDSOHTZKf+1rQQptU3/+VKusqvt+JQkz/g1DePEG1qM/vIz+LNK1yGAb
	NlrOIN1v28tZB1Q33svj4j+g3bEkNJn7BQeARYlDZghci8dn48CJpAillIz48gAFrtdljLdhZ8LJf
	Wt0KyuCrGjIZyEo6I/6ecnro9LLprrzZ0gsXMwNZcZNYNfMy2t2dzYhFjvj/QsnHcZgA8OMUsVnoz
	rhql6hcjH3OREqS45xF1tkqWn+vkR4NczQLUPPJiTxcmeLF/RsTbHyLMc1ew3V+2BZBopdx0+VmTA
	jtgPL8eA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFz-0000000CgcX-2azw;
	Fri, 25 Sep 2026 05:13:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] libxfs: fix buftarg initialization for the RT device
Date: Fri, 25 Sep 2026 07:12:53 +0200
Message-ID: <20260925051336.2997014-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

libxfs_buftarg_init currently sets the rtdev targp to the ddev one when
no explicit RT device is provided, which allows tools like repair to
proceed without a specified RT device when they should not, and
potentially can cause data corruption.

Fix this by delaying the RT buftarg initialization to libxfs_mount,
where we can check if the superblock indicates an internal RT device.
This works because all external callers of libxfs_buftarg_init never
need the RT device as they just examine the sb and/or log,

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 842a2e1e09a9..97c5286c00a9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -554,8 +554,7 @@ libxfs_buftarg_reinit(
 	}
 
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
-		if ((xi->rt.dev && xi->rt.dev == xi->data.dev) ||
-		    mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
+		if (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
 		    mp->m_rtdev_targp->bt_mount != mp) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, rtdev\n"),
@@ -587,10 +586,6 @@ libxfs_buftarg_init(
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
 		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log);
-	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
-		mp->m_rtdev_targp = mp->m_ddev_targp;
-	else
-		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -739,6 +734,10 @@ libxfs_mount(
 	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, xi);
+	if (sb->sb_rtstart)
+		mp->m_rtdev_targp = mp->m_ddev_targp;
+	else if (xi->rt.dev)
+		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
 	libxfs_setup_write_error_injection(mp);
 
 	if (xi->data.name)
-- 
2.53.0

