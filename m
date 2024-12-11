Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AC11EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907505; cv=none; b=ODVRyEk5nfAj0zOWMKqdWZlKS6QwreTW0m2Vc7EszCmynvpvfgZThlh+q5oX1VY0KDkDldNxFK1rcv3oXqPALhVwzeFwcLNiMdZXt/2wbE1sHWMWagCsvJqAlVUeStt2jqSpZXZDtiXNqSxk++K95f7lSd5gkyzr8w5Ep6Z30t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907505; c=relaxed/simple;
	bh=s6HsAr0ZX6uI224Du3ISFGFcgT/oP1VB61i0bFpwoac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gz1yeQTEGPEQQV+hevPSHy7iKj/V+xNJbec6a6E2IHfAC1QIs/XXz0uJrSddYUjhxkDAzPAXIbwPyJhc/OGAv1i+ULNUJqhp8jM4mHJEEnoKPQ6kAVuaIlbnOgDgamimutthVGLZvEzE0Ne8ZqhKv4BXgQPHBzDlqAP5NRLU9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TipeL72h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TipeL72h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EGlvub2akN5hAuktlvM1hOgHlSHrkDe+WZdcVhNOCdU=; b=TipeL72hY0ctni7s1LZEyDu6Jx
	XSWVCwdx2AxHiui/lOZ3tPw65k4GDmBCIRyxnSKTsfzf4KCDZqX3Pc3bJyVO5GANTgAyoHXExLUrW
	LBRdSR7Cvw3mjYKncpEd+AuegHi8UHEUefhyq30DZGEFPkDr8X5ec6dm/k6AAbl+b2k5MEfuDRRqO
	ygHs8o456x3tat8grv1tIIBEA5Xw/30K6eo/TT+FM8IGLClBbzoOlkuegR9Qxe2oHcBvG2eMaPEjZ
	JRdNHQapYLNioChgaJT1olbU3Z1z/AjFoNkEgUPuhSQygllEyKq2I4LKuLZ5DOzaNPluFvF+Bc3GJ
	Vt5yNpLQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIY3-0000000EJUH-2jCj;
	Wed, 11 Dec 2024 08:58:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 37/43] xfs: disable rt quotas for zoned file systems
Date: Wed, 11 Dec 2024 09:55:02 +0100
Message-ID: <20241211085636.1380516-38-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

They'll need a little more work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e1ba5af6250f..417439b58785 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1711,7 +1711,8 @@ xfs_qm_mount_quotas(
 	 * immediately.  We only support rtquota if rtgroups are enabled to
 	 * avoid problems with older kernels.
 	 */
-	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
+	if (mp->m_sb.sb_rextents &&
+	    (!xfs_has_rtgroups(mp) || xfs_has_zoned(mp))) {
 		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
 		mp->m_qflags = 0;
 		goto write_changes;
-- 
2.45.2

