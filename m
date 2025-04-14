Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6A1A01CC
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609101; cv=none; b=TqKngIrl/PDDA4vQQkyzasrLn3l17l7JxkVOJRnOXuirVSkJggGn2gEF4RMHYSS2jWCzWovifVhu9Uwg2/qLfZOkjZAb93s58BUtr6qcmZqssgu41kLzB3MyuV04O1VFDOonPDhW6u28zokFNvC7z58G//XkmYpngmK53hYA4Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609101; c=relaxed/simple;
	bh=mytRrBZa8OljVA0XMTFr1BITy7pFBu9imLPSlRMDua4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPFPONAgZxQJoWyKEO+Nd94VdZW/VQ7W+BiNUvKSY+hCOIY+0CkNPYLing6c4HLRw7FrVB87IBpQDNHL0kUZKY31G7No7Uq+h0XWTqjbsOQfJoNc1bMUHFz9W3xITtVFLfpcqAKYaQQpzPWM+sLhR29sEZNg9mInv0nfqhg5CQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sXpCF/jv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXpCF/jv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zpfNM22mm4wxkkUfonjdTHePIU8f0mal6XrHz+ty20k=; b=sXpCF/jvyaHwH85EM5F+ZADqgf
	U6oJxNyww+FWlYz6KF9Dcpn6e18/5BXCG3EIn2IcgYqQ2RcRYhFzEAD9PJwRXOcN6UOuZtJmFZo2e
	ZiJSKAB3KXgsDdyTMdzQ3p8MDnwbwfOjBJUsXrYFdbTKzVwEqfRLrb0iU6zeQiDX3jmI1+5aBPmX4
	niei8mdLfQTG5kmhNvyyUQuypUx4i7T2qnPDsx2RDsrnkEUZZCg+uatKqeKUIzu6hmhC+XWs9Y1eW
	cVly/Fhzvw4G5SbCKY2BkFhDA5Nk5b/HM6Qzy+plHP6DruXuPPYJm1i7BmlMfXCJwVaoqdcZzABBB
	/BTeVnWQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWR-00000000iS3-1RKT;
	Mon, 14 Apr 2025 05:38:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 38/43] xfs_io: don't re-query fs_path information in fsmap_f
Date: Mon, 14 Apr 2025 07:36:21 +0200
Message-ID: <20250414053629.360672-39-hch@lst.de>
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

Reuse the information stashed in "file" instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/fsmap.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 6de720f238bb..6a87e8972f26 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -14,6 +14,7 @@
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
+static dev_t		xfs_log_dev;
 static dev_t		xfs_rt_dev;
 
 static void
@@ -405,8 +406,6 @@ fsmap_f(
 	int			c;
 	unsigned long long	nr = 0;
 	size_t			fsblocksize, fssectsize;
-	struct fs_path		*fs;
-	static bool		tab_init;
 	bool			dumped_flags = false;
 	int			dflag, lflag, rflag;
 
@@ -491,15 +490,19 @@ fsmap_f(
 		return 0;
 	}
 
+	xfs_data_dev = file->fs_path.fs_datadev;
+	xfs_log_dev = file->fs_path.fs_logdev;
+	xfs_rt_dev = file->fs_path.fs_rtdev;
+
 	memset(head, 0, sizeof(*head));
 	l = head->fmh_keys;
 	h = head->fmh_keys + 1;
 	if (dflag) {
-		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
+		l->fmr_device = h->fmr_device = xfs_data_dev;
 	} else if (lflag) {
-		l->fmr_device = h->fmr_device = file->fs_path.fs_logdev;
+		l->fmr_device = h->fmr_device = xfs_log_dev;
 	} else if (rflag) {
-		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
+		l->fmr_device = h->fmr_device = xfs_rt_dev;
 	} else {
 		l->fmr_device = 0;
 		h->fmr_device = UINT_MAX;
@@ -510,18 +513,6 @@ fsmap_f(
 	h->fmr_flags = UINT_MAX;
 	h->fmr_offset = ULLONG_MAX;
 
-	/*
-	 * If this is an XFS filesystem, remember the data device.
-	 * (We report AG number/block for data device extents on XFS).
-	 */
-	if (!tab_init) {
-		fs_table_initialise(0, NULL, 0, NULL);
-		tab_init = true;
-	}
-	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
-	xfs_data_dev = fs ? fs->fs_datadev : 0;
-	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
-
 	head->fmh_count = map_size;
 	do {
 		/* Get some extents */
-- 
2.47.2

