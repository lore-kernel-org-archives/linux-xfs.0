Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A2725A35E
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185522; cv=none; b=BRbzNhR0giH9X6jBOIMXs6xZl+U7R646qFGibJ4dU7NRILZP45fnNW/ZIwkubzvCmw4z8RY6+m20CbHhFcElMzZWxtAzIsDvWFiVsg/uEu+5V7t0cj9cZx1vfBpjwVjNxji+wTEKj0E37Nu0K2x2Bb+8YJFiSyvehVFhsTM9qGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185522; c=relaxed/simple;
	bh=vYPjX/agjtj9wQYY2b7JJQdUOJTA2r1NdieeeeluRNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBNzLbbm8aRodEKeRmo+ltV9gUQhdsBLhu3A0vtgtYSpZ82pNfp54S5rXTJ5rsExsCwhHRqGs04TP/wMKwqJAOu/8fA7hS5ZtUmvWcEA+bl08yyP5+oxrnGizV2+rBTlczj/kc7aASEfHIzCgwmp4Tia9/dviczOk1ulb+fs+J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k7k88J0j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k7k88J0j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ufxMRSmkvOCI/faremZfPOr48ef3lqUxllp3QeBUvfM=; b=k7k88J0jSE9b86s0mOcBySUFiZ
	yFRX7kv+ktKpv0hEXHvJUu814ONgEJMQm6jfnS2wWYHWlXZ8N0hVMQMUHBMDXknYPMLizCyUSGJuV
	80N9LuaQNLtFxqSuk+Laf7wZjbZt/5uzJGYilwu8JcSmt7NZdoISvnwHoa4Qug6yXLMkBcp9oprG/
	LmcBj5b2aQFcS43a0YGZBSLhXKO7gehfWYoczpvnfRsekCZG5eL90lnTnLqxiV8PvwuidZG9BkU6j
	sA55FJ7kipq81HF20cIlG11fD6JnWgh07teT9tlvcodwW7ol/PFYIO2YvZB0mQrBT60/Jl61Zk7/P
	CEQx/fNA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKV-00000006Ul5-439U;
	Wed, 09 Apr 2025 07:58:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 40/45] xfs_io: handle internal RT devices in fsmap output
Date: Wed,  9 Apr 2025 09:55:43 +0200
Message-ID: <20250409075557.3535745-41-hch@lst.de>
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

Deal with the synthetic fmr_device values and the rt device offset when
calculating RG numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/fsmap.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 3cc1b510316c..41f2da50f344 100644
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
@@ -478,9 +488,18 @@ fsmap_f(
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

