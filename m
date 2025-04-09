Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D2725B680
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185542; cv=none; b=NsPuPRvNtRIeITtlTi0yKyf1EiFa6gRsRwjZ5z+Ps41WHEqQyA47qDVXReLTimajJvCAwFRyHGlOVD6Fo7eZriPdSDgN1xeVBm9RDFixrZsTHnqld5aZNNGFJS+wm63Tefjy/JNGjpBBcWLIkyoM0fdRRhVTQaLn3vAqS+g6JUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185542; c=relaxed/simple;
	bh=Zzc2VXEe+JnyKDtMJ8xylT0FUvdUoh/s7RjgOsW4Nw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUTtuRNj6qa7TYzYbSsMS8Rh8FVzplXvl1IOXFcAR1iRjDiFXeshj9RsV3vZ4J9f1tuV91UfyAtu8NVhLLNV2joJeWOATi2UHzo35bH6NO+0uP/PqgHQ6eioVs8yR0pw3KdPFCNMJ+sLqguggHkPkypPVJNnWey8apSOnCI1U9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BOjKGeL4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BOjKGeL4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZzIx3CeyBbwOH77YIEu6KLjfHaw5Tk6XU8SDVqkK6x4=; b=BOjKGeL4WRScUPBGEyAyYTiPUr
	1T+LKYZbJD+SDe5LybhXAargykrl6Y1uDvxfqmSFGCvdwz3ogVMuPvez7zBtTJZXaDOgyHsBclv6n
	9yz77Xem6Q1wTUmwmHkomuez5fLC+afpPqYVln/+KixmpF/hU1/YRjkGANvrx/zB051l6IEZO/m+u
	ObonRw2iLvC9YFhslUo/XSI+V/yK+uQm+oHmPf4ck3GdcF21u3UpS1R2HZonokq8PbFh6xZjcuXUd
	bNCSInyRIF8FsT/u32/VSalVQROHx0ijldr1C6FZ5xlD5+HN9u2DOJvuQh2NnAZeIkoWLmXRL+8nc
	WbGvjJkg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKq-00000006Ur4-1RBu;
	Wed, 09 Apr 2025 07:59:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 45/45] xfs_growfs: support internal RT devices
Date: Wed,  9 Apr 2025 09:55:48 +0200
Message-ID: <20250409075557.3535745-46-hch@lst.de>
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

Allow RT growfs when rtstart is set in the geomety, and adjust the
queried size for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 growfs/xfs_growfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 4b941403e2fd..0d0b2ae3e739 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -202,7 +202,7 @@ main(int argc, char **argv)
 			progname, fname);
 		exit(1);
 	}
-	if (rflag && !xi.rt.dev) {
+	if (rflag && (!xi.rt.dev && !geo.rtstart)) {
 		fprintf(stderr,
 			_("%s: failed to access realtime device for %s\n"),
 			progname, fname);
@@ -211,6 +211,13 @@ main(int argc, char **argv)
 
 	xfs_report_geom(&geo, datadev, logdev, rtdev);
 
+	if (geo.rtstart) {
+		xfs_daddr_t rtstart = geo.rtstart * (geo.blocksize / BBSIZE);
+
+		xi.rt.size = xi.data.size - rtstart;
+		xi.data.size = rtstart;
+	}
+
 	ddsize = xi.data.size;
 	dlsize = (xi.log.size ? xi.log.size :
 			geo.logblocks * (geo.blocksize / BBSIZE) );
-- 
2.47.2

