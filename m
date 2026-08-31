Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DEA39FCB4
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 07:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160318; cv=none; b=ByLnENyfWFmk9TQzDnlvl0UeGa/qSir6UxAnKBFfGnwnVhVFNJqDF29OS69LSI4jTgArVT9wOT58j7G2FnR1NzoDEqml4PXpJHSWquRU1G8llxtP7eRJTR2OxXKPQzjxFJW225tvbg51OzmIKHnilpnmx4sJpl9C4995PkBswk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160318; c=relaxed/simple;
	bh=OINsmb9OMe1t8Wh1Ce8I3nADzwDDfeZCV3aDElDYA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jdYeO53LAOmhOYt+t0JpagQWQkUu2hXIqibzaGHgWMIDYnXxNAILn5fydiUnDhwXgCGecTqYnrhzDlrfSTvBeFjJBcuSWqyuIXzp1hVFoCFAVbv6+Cp0H+PtA1wLBvGUaMjuWFz/pegTi6OxXSQhoFTU9n0sxbWWyfBfkxcceI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T6pceSjY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T6pceSjY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bANS14JZNvsf/ZhQCcSB0VdFS2YvE9JCui45lNw5uyc=; b=T6pceSjYSpPwB49r38DHRbJpnj
	/8TvnvEWDC1WsrWKAd998kh4wjhucP9Rb1JvxC7Ajj4VVc28nO6mISUIqPVym2EhnLVfpQpDUirCc
	LBcAYUqflQhsXowPImX/4knY7HNbjMqIP07fPxaPiMC4mFZJgj1sopxvJW67pi5p0wpsuUhyFZVot
	c91t5N0lR5LNcDSloZft9q29gHTsnu8PfYdzI01Qdth+o4r8TsnRfpZGFfrLhLd5LMh6BS1oKFO4V
	I9Nv1GxHhcabUonxs6AVFewP3Y2YRulNg1bCQ4d8y0zecWm6nT3xhrstMfSdywhLVBtcu4E5TPnwC
	XiTTuHTA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0wBP-00000008gwB-3kzh;
	Mon, 31 Aug 2026 07:11:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: improve the fsmap man page entry
Date: Mon, 31 Aug 2026 10:11:52 +0300
Message-ID: <20260831071152.2580927-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Improve documentation of the flags and optional arguments, and fix up
messed up formatting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_db.8 | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index ba2a68211ef2..89db535d38c9 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -849,14 +849,24 @@ command to convert to and from this form. Block numbers given for file blocks
 .B bmap
 command) are in this form.
 .TP
-.BI "fsmap [ " start " ] [ " end " ]
+.BI "fsmap [\-r] [" start " [" end ]]
 Prints the mapping of disk blocks used by an XFS filesystem.  The map
 lists each extent used by files, allocation group metadata,
 journalling logs, and static filesystem metadata, as well as any
 regions that are unused.  All blocks, offsets, and lengths are specified
 in units of 512-byte blocks, no matter what the filesystem's block size is.
-.BI "The optional " start " and " end " arguments can be used to constrain
-the output to a particular range of disk blocks.
+.IP
+The optional
+.I start
+and
+.I end
+arguments can be used to constrain the output to a particular range of disk
+blocks.
+.IP
+When the
+.B \-r
+option is specified, prints the reverse mapping for the real-time device
+instead of the data device.
 .TP
 .BI "fuzz [\-c] [\-d] " "field action"
 Write garbage into a specific structure field on disk.
-- 
2.53.0

