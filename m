Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E258725D1EC
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185503; cv=none; b=oT/tQcl2XFzEUqIi3nBXI8wtMZu3n6Zk7NtEj2Y5pndTVzbP7cMdNMgBs20ku1C7h+uO/2bSmKPW2Vg3iqANgYRuNsUwBigxzReidlP3TcmfS3Il6XY/Abw01CLRll2NbrHgLMaMpDC2/tfEWLF+xLvaFAw3d1LWbAOK+oE74Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185503; c=relaxed/simple;
	bh=25EUpVywAcDkKPmxDFddSPh2HeNzjfTfGOPTE0OqkOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rws9bPmIvydsWeByeonZe03SjYnRFSK9HN2nW3HiibKt3SN+v2lByHvRUOF32LPVSKS/wTb9xBFyu8sjzH697wwyQ9b8kcseq6Le2ICeGPy4YSbu2bMpstoewxX6d0o0cfNanAHii6nLfEUMKyRrjt5WMX9bNMQ5ZGs4uf3hTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R8pvFjjO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R8pvFjjO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AIjMUlhhiS4pbwAtGFZDh+S1sdmqoAyTmBttSWy8GGY=; b=R8pvFjjOMpEeDe60xTpJ4RgOab
	gC7EbIWN/ER043LmVdtvINC85A1kwM/MpAnQmDmCuDx8nLGInRckfS/NKS/Rf8dBwNFeXheYGjaRh
	REjM6oN7YjsS++xDiIepBBMmh4JNoJyIU8iTvf6i3yG1SS3BTy+UaWVqzAKuQ681lJsWUGT039LgC
	JAI1WdLraKWRIAsWWbNl+GHUqKTKdLwb8jSTpOn8112epJQZXc0IPvyflFu3d2ZVz7DrjDRrvPPsO
	+r9psiFwZn2Lf4xqBok/YA9eY805CDw7e5uueZj62r0O/Ncr/dapG2RsxpIq3ZfPTXDtmKqnJLs+0
	uQdMktOg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKD-00000006UgD-0dWO;
	Wed, 09 Apr 2025 07:58:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 35/45] libfrog: report the zoned geometry
Date: Wed,  9 Apr 2025 09:55:38 +0200
Message-ID: <20250409075557.3535745-36-hch@lst.de>
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

Also fix up to report all the zoned information in a separate line,
which also helps with alignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 5c4ba29ca9ac..b4107b133861 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -70,7 +70,8 @@ xfs_report_geom(
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
-"         =%-22s rgcount=%-4d rgsize=%u extents, zoned=%d\n"),
+"         =%-22s rgcount=%-4d rgsize=%u extents\n"
+"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -86,7 +87,8 @@ xfs_report_geom(
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents,
-		"", geo->rgcount, geo->rgextents, zoned);
+		"", geo->rgcount, geo->rgextents,
+		"", zoned, geo->rtstart, geo->rtreserved);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */
-- 
2.47.2

