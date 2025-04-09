Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104925D206
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185509; cv=none; b=C2XlBfdHKKoDm+MDOxCFpbxbXpR1dZscFrZOAtZgQ29lqpFX4MFsxZhrllEPKD9yDi9HFgZRnNkCXQxK2kmljgSizGaE6OP5VguDfMAaO1Fvw068U9AVAK4agm2UCPNQl5FcDgT1txxphwg0ZIHEDf/U+MOKgqvgMMmlGvz3zUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185509; c=relaxed/simple;
	bh=jWy6Kb0HaXBOu3O6q7h9GImOaj/UGckCOGefB/ZYyoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXXzajcKuhJw60AMQgdSiZhvjHqI9uq7u5QhzbOUVqyhE7F6XNr7tMymOKQAA2/aiHMFGo7j9J0zsNeW6D/rKfvM2ByShxqASho0VmDDDTiVbfdyZaEpOF0RC+c9XD5DUjf/CDs3qf12pecj+bi+6HTketutuqijVqKlKKyI+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vY3HKufX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vY3HKufX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UOn5C/UXrLFnkUHs6vZi7ZP5Q/TSrqTGGfapk5KYhpE=; b=vY3HKufX7HjNpTpFf7XSaxiPrh
	GWX2Pfu5nPu9IJSp7VHcZ8LGv4AbvjefH+rtEmNXYmNo0Q4WOOkWbD6XU9kUkwQtY7ZFLLHUBaeu6
	DppqtCUH+g6CHPyWO5gUzBlwBAho59Fxbhpgt19Aqp5eWrsWdgD/5RTDBgZzmlBh78AFRqB8tnulE
	fZKsTk7C3uTnjdl1HSE+ytmVIynFISZeCKOuuIZiRj+6wo2zrd2F9Ljsjn2ee82qfQSYZh4Z+TJbG
	wll36f9JbShFmTCubk13acmLSbpueIZUkO5+/3rizLrakG3/XPqqrCoJHjgCqp9Ct1b8rda7cymk4
	cKG2DodA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKG-00000006Ugu-3YBV;
	Wed, 09 Apr 2025 07:58:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/45] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Date: Wed,  9 Apr 2025 09:55:39 +0200
Message-ID: <20250409075557.3535745-37-hch@lst.de>
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

Document the new zoned feature flag and the two new fields added
with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 502054f391e9..df7234e603d2 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -50,7 +50,9 @@ struct xfs_fsop_geom {
 	__u32         sick;
 	__u32         checked;
 	__u64         rgextents;
-	__u64         reserved[16];
+	__u64	      rtstart;
+	__u64         rtreserved;
+	__u64         reserved[14];
 };
 .fi
 .in
@@ -143,6 +145,20 @@ for more details.
 .I rgextents
 Is the number of RT extents in each rtgroup.
 .PP
+.I rtstart
+Start of the internal RT device in fsblocks.  0 if an external log device
+is used.
+This field is meaningful only if the flag
+.B  XFS_FSOP_GEOM_FLAGS_ZONED
+is set.
+.PP
+.I rtreserved
+The amount of space in the realtime section that is reserved for internal use
+by garbage collection and reorganization algorithms in fsblocks.
+This field is meaningful only if the flag
+.B  XFS_FSOP_GEOM_FLAGS_ZONED
+is set.
+.PP
 .I reserved
 is set to zero.
 .SH FILESYSTEM FEATURE FLAGS
@@ -221,6 +237,9 @@ Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_METADIR
 Filesystem contains a metadata directory tree.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_ZONED
+Filesystem uses the zoned allocator for the RT device.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP
-- 
2.47.2

