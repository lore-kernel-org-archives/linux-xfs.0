Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE492CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609096; cv=none; b=DkAiGKQJdTmoissvH+6AzuIK8WDJAtxdluzO03VqKxQJLKmEUrMQLxoiDNbgxNlXy/oWVPiPFxGLUqezmqY5EnDlSjFOJUhBxD+cj/hbu0ZyVw3aV1IuVONZkLv694p1oBCkw4dQbUXa7VHyqQYJddjHSLgnKPfgKD998gwM9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609096; c=relaxed/simple;
	bh=2Xlh+FbsBmiTnrq+CI3tyr7tzQx9jyicl3qyyobsUw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFUpBWFUxcqBe67oT1NDJ3LH8qtzQbJk1ukWGPkHs4S648sNrwpEBX2l2sZtMWQ0fl6l+3W8qWhpkLrxgjLJNy+5pLXB0g2mLWVNwV1ru7DkYLvDPWvTb0sc1pZ+6/MGbJdIOxQmtg/YCfsjyNYWBW5HddkOnRldNNAEewTQ/jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bKXq4+MK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bKXq4+MK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pen18EcEAv0BRZqfYXwpjsP/yuVzZwZmGr7V3y5R0qM=; b=bKXq4+MKCFLKclA+Tg5a+PijXa
	0VgcutJ80vLhRAxUp6GD6nNO7NvE0HlyVeN7peI3jlBVvU6oxviQFv61Ylnid0vEuhkpEZhoRWmO0
	CO+aoWSxZA/9RaIRu7C+IOmICdMTIa2dtofYWXJMLkyONzhdoMIr5x772ba6eVsbjIcWahypxNzI9
	oqysGOzJsIjjf4ZbIvPPbUXy+8ns8kAxGVogvZdHySKJQdeHhsCR8xQhayPU/55EKRV2acZdfD9nM
	eGD2FGmNHMH3QJLkoTNalE7lKXc6CvXVrXdjTccITqnUrJ6BgB7pxNilAV69MyYcHw/A3LsGHv4t9
	To1TEuoQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWM-00000000iQw-1XOr;
	Mon, 14 Apr 2025 05:38:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/43] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Date: Mon, 14 Apr 2025 07:36:19 +0200
Message-ID: <20250414053629.360672-37-hch@lst.de>
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

Document the new zoned feature flag and the two new fields added
with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 502054f391e9..037f8e15e415 100644
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
+Start of the internal RT device in fsblocks.  0 if an external RT device
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

