Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A16A25A2A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311570; cv=none; b=DnMAXr16ZCAE65JPlj3W03kXQfD6wWWRyVKDpiKtC1uPpqFeE3sRGuPK/R+qO7HU1/cnI00HjuEIcs8UbsknSlxOkzxRc5a0gp3WkJxAn2rsX/u9RKvoOTMBV3YDDMjyuvSHOwzMyiT1jBharhMvhvGg6RgC5fDjbT4ox8J6suQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311570; c=relaxed/simple;
	bh=foGuigQp6sCK3NnhGVYgqLHHtBhAk9kNX/gDuY/x+9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXrEY/4hvqYtTbCf74Cx1w1FYBcUg0CsFcfxTVikUp9ei3TfDA17T3sZz7wM/DG546JMwk1ENfw5yGzpjktTqH3+fDxkRkIDOqHUR8B7ZC3gCVjyYcqo7V8n992236aYcS7wFjvePX/8guoxuP1iRqzPMj6Or216De9ef0HesLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X4KJhIIX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X4KJhIIX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qi0jPrYiiLOmpCnSenHNU2vWSjjWTPU7zfJ3pmQEock=; b=X4KJhIIX7JFOEX6dMNVZoba5qz
	T+Qk7soqVOI1GX9KcPYo5iHNJ7N0dyWQANnPccfjSPrt0QcksoD/N8AMrlUmp8+MJFLVaHSa54WbA
	zmaAGg74KBNGY5Vsw2Qhkpf5hqcORn71e2Q/KHDLSd02vUYTMIWBUfQrKaMENZ6f0uUz7TfaP3RBn
	zmQ/miUr2z2KyMqTZPuPxiXBjY2vgS/H/oPOeq1UtptpgsMKhEuCZkxC53RjUfsQd3ai57HWb2/nW
	hX8t+McIE6mOWD3YkkhGSckLnkPoTiAODkJ1hDh3q9foCfVIeM+GPO/M7beUvlHpsbJygfMdRWBQx
	GSvNZBeQ==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs2C-000000002jt-41ec;
	Fri, 28 Nov 2025 06:32:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 22/25] logprint: cleanup xlog_reallocate_xhdrs
Date: Fri, 28 Nov 2025 07:29:59 +0100
Message-ID: <20251128063007.1495036-23-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Re-indent and drop typedefs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index ba48c7a3190c..b67a2e9d91a4 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1321,11 +1321,15 @@ print_xlog_bad_reqd_hdrs(
 }
 
 static void
-xlog_reallocate_xhdrs(int num_hdrs, xlog_rec_ext_header_t **ret_xhdrs)
+xlog_reallocate_xhdrs(
+	int				num_hdrs,
+	struct xlog_rec_ext_header	**ret_xhdrs)
 {
-	int len = (num_hdrs-1) * sizeof(xlog_rec_ext_header_t);
+	int				len;
 
-	*ret_xhdrs = (xlog_rec_ext_header_t *)realloc(*ret_xhdrs, len);
+	len = (num_hdrs - 1) * sizeof(struct xlog_rec_ext_header);
+
+	*ret_xhdrs = realloc(*ret_xhdrs, len);
 	if (*ret_xhdrs == NULL) {
 		fprintf(stderr, _("%s: xlog_print: malloc failed for ext hdrs\n"), progname);
 		exit(1);
-- 
2.47.3

