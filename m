Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1B1225797
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824414; cv=none; b=L7t2LKaawkGXvIO9Hewir9/c9kTP/HLpVmSfARi4kEpHsFJxbYoQdGCMna1rrz73Bu7DYt0W+kSRmGtYSSp7NJYJNhYkQ8bQM/zmd/OD4n8PIHhIvuwXRmpM3hqdEtS4gFFlZD8ub2G71ZeYD9SoIKvodhkkvTIL7GQas2IZmgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824414; c=relaxed/simple;
	bh=s6HsAr0ZX6uI224Du3ISFGFcgT/oP1VB61i0bFpwoac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD/VA/9Bw33wNvAvJTptwi2D/wvIMrlI3SJHZVh3CChp5g4Bt3ebLRKIOrUEg/tH408uznv9NjrDiP5zXZBr0yHenaAf48cabHgysFh6ctqdYcYky/SnKCcVSMRuA1TyyIXAKQryXMZ3RUk4+vbQIMpyZrx1Ie21Nqp35v3nhYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XGbkn4M1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XGbkn4M1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EGlvub2akN5hAuktlvM1hOgHlSHrkDe+WZdcVhNOCdU=; b=XGbkn4M1+snww8xA9FmoK9RSb0
	KA3yR5OPPx9Pf69hBhGCeyQ2nNB2Q6gRQqGZfK/ZpSsEenirG5AeGR5IDv7hgjqq8kdbHrq5nrFYZ
	RvgHRB8vdrCLYO9ZukAGYTvqaHu/AcdsN4W8YZirP+GoH01rDUJXyKVdjmL3/dzq3h4rYote7nIjY
	O5FeKzQRB4zPsYQlA6x6Dnapl14xjCMPxcl9J6eHEpHcvg7Te89PUM5yICwLLzcwyCJU/ZUr70Mje
	RFEuei5jqnspwDsYwYGFa5mbx8Dqk6NimDJRYxiKGHnO+Tb6VQRe4AqesQK2QQWCg+dqPkYwwLW3O
	Rk0pxZMQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvf2-00000005QoE-2gUU;
	Thu, 06 Feb 2025 06:46:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 35/43] xfs: disable rt quotas for zoned file systems
Date: Thu,  6 Feb 2025 07:44:51 +0100
Message-ID: <20250206064511.2323878-36-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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

