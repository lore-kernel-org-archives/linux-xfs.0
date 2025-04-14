Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEFF2CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609103; cv=none; b=kan2Q+QhmzCXEN2irExx5ijg5oXD3W7B8pJ0Om/bL9cDflnS9eQQKrzT206Z8gqQwA3N6LeAayuj/IErlGK8yckwBFXLAyy6kGiX+J7ocCJOLmmzK9inKx8tpY8ujuwFc35aR5nllFlJIrpPp8lS4cEhe02MnWRu6FplD4X5IPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609103; c=relaxed/simple;
	bh=hduVqnFfF88VtrD26XOI5buHJzLZPN7Uk6XPmwE6MDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvzmNmLbTQwkD1rCFxUT3o8GHzj117HIVooJI3V+FE73qU0JkRTaKUkiONX41INks7xrS8LNRH9FpxEq6tPiZe6aNnJ29ekZNPBpk5He1TNVAHObvlW7RLtQhRxQkj2EhNW6ahPjtfiBdaHtHPXmHU06fTyUcPBVEbA+AxXJB1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZcUr60+z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZcUr60+z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YeVB0yryv50mnzMJDBHXwYDcKF7EkYZqepWgFzcMlcI=; b=ZcUr60+zkKgtEOoL5ARzDmpVA7
	JPAw0A6ZM0u6VosJDMlpTiuvCpxwbL3QoEnFSKjWjb2GmyePHDNQpCkNxplt/jz11ewI+sPZOAGec
	VyBRgO6U8ZC/ud7AvEa/FlYfUXFKEroZtB696suv6NGS+uu2Dk+OSnSKDK+PiB+roMSlmxFAKQhDa
	jiTfJlWC6AIJ5VFBMpGBjp+aKPF4+v5fw6CPrTMOeEKYq5sVW6F5qbUZ4YtmHXi1r+DmRq+vYnn/G
	VIFIy266oN7v7iTtHJlxt1KxXsIGh+3dckc1JX3KejxlVXAij/oUEzz3Mk2N7ux+NV2wBIzKVlvf0
	nfF4XgRw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWT-00000000iSf-2mjH;
	Mon, 14 Apr 2025 05:38:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 39/43] xfs_io: handle internal RT devices in fsmap output
Date: Mon, 14 Apr 2025 07:36:22 +0200
Message-ID: <20250414053629.360672-40-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Deal with the synthetic fmr_device values and the rt device offset when
calculating RG numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/fsmap.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 6a87e8972f26..005d32e500a0 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -247,8 +247,13 @@ dump_map_verbose(
 				(long long)BTOBBT(agoff),
 				(long long)BTOBBT(agoff + p->fmr_length - 1));
 		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
-			agno = p->fmr_physical / bperrtg;
-			agoff = p->fmr_physical % bperrtg;
+			uint64_t start = p->fmr_physical -
+				fsgeo->rtstart * fsgeo->blocksize;
+
+			agno = start / bperrtg;
+			if (agno < 0)
+				agno = -1;
+			agoff = start % bperrtg;
 			snprintf(abuf, sizeof(abuf),
 				"(%lld..%lld)",
 				(long long)BTOBBT(agoff),
@@ -326,8 +331,13 @@ dump_map_verbose(
 				"%lld",
 				(long long)agno);
 		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
-			agno = p->fmr_physical / bperrtg;
-			agoff = p->fmr_physical % bperrtg;
+			uint64_t start = p->fmr_physical -
+				fsgeo->rtstart * fsgeo->blocksize;
+
+			agno = start / bperrtg;
+			if (agno < 0)
+				agno = -1;
+			agoff = start % bperrtg;
 			snprintf(abuf, sizeof(abuf),
 				"(%lld..%lld)",
 				(long long)BTOBBT(agoff),
@@ -490,9 +500,18 @@ fsmap_f(
 		return 0;
 	}
 
-	xfs_data_dev = file->fs_path.fs_datadev;
-	xfs_log_dev = file->fs_path.fs_logdev;
-	xfs_rt_dev = file->fs_path.fs_rtdev;
+	/*
+	 * File systems with internal rt device use synthetic device values.
+	 */
+	if (file->geom.rtstart) {
+		xfs_data_dev = XFS_DEV_DATA;
+		xfs_log_dev = XFS_DEV_LOG;
+		xfs_rt_dev = XFS_DEV_RT;
+	} else {
+		xfs_data_dev = file->fs_path.fs_datadev;
+		xfs_log_dev = file->fs_path.fs_logdev;
+		xfs_rt_dev = file->fs_path.fs_rtdev;
+	}
 
 	memset(head, 0, sizeof(*head));
 	l = head->fmh_keys;
-- 
2.47.2

