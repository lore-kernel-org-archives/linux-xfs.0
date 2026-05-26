Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B6237B00F
	for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825246; cv=none; b=VhhR7NMh5PBGDeKFcNxxTMSsLiR4W7DSPwXv8boIQpSnuSShccm4SQ5ZY56EUHXwKQcfxRjQmjWNUkClcO2NdnKBwPhTmkNgwAUZN5E2aw+zDfLGRrTV9IC6HJRCZPtybmJlcQrDYcZb1TqQUEtrAo4ZpsYIGNPp5Mcus9mVtp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825246; c=relaxed/simple;
	bh=/lAywNftA6Q2L79ZJiKrhm2DIFRAPfE/aKf3WI2b8/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JyX0l2dqBcuGx2Qz3rWeqZXL1xNLJ4FUpDBs8Jb6v0mN0qtMgePA13LmK93CpCDlxLbJvmE5CacixIbdQZW6geddSReTDD3RZn0w/pngjYOex5y5qyoJYlcz4E/163mnPE7bUBF5tNx+NNGrsgWazbRCrEWU2+O0+WIr0HiGycw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YbmiCTlM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YbmiCTlM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1rMun5N9ELE5VBIDfCk4Qpbo5dkmW1peh5bVDQhfm50=; b=YbmiCTlMhKC+8T1gOSdqxdLGrC
	4drC5+RE5glbQcZ3w/onytWFAqH1P1R0VG5I6ors44ezXL246k/AEvIGeMoxOkRhkU9d9NYbQ6dDJ
	sNPDh44m6Wt1BpClxbrm/W2IaoP+e5BhKg2gHqCU4vu2qmux2b1VFqivfBN5nb7gHmcbJSLNlkA4H
	wG/N2eidiZfdIxWDemumzaW/8tf6paMYTYXCpsCDQtwaePc/WRq+/9u72eILiPqh9ANNWQ3sATcUF
	JH/v0uXVPH9sTLtW6DHmLc6EM8LuELBfizVXnqHXw3a/aMRFoZSs8kO4uG8m8mYzfarflvXd/KsSp
	q0gdkUSA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRxqk-00000001TiZ-1roY;
	Tue, 26 May 2026 19:54:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Remove mention of PageWriteback
Date: Tue, 26 May 2026 20:53:59 +0100
Message-ID: <20260526195400.352557-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update a comment to refer to folios instead of pages.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/xfs/xfs_reflink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db23a0f231d6..251dec48f0e3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -949,16 +949,16 @@ xfs_reflink_end_cow(
 	 * repeatedly cycles the ILOCK to allocate one transaction per remapped
 	 * extent.
 	 *
-	 * If we're being called by writeback then the pages will still
-	 * have PageWriteback set, which prevents races with reflink remapping
-	 * and truncate.  Reflink remapping prevents races with writeback by
-	 * taking the iolock and mmaplock before flushing the pages and
-	 * remapping, which means there won't be any further writeback or page
-	 * cache dirtying until the reflink completes.
+	 * If we're being called by writeback then the folios will still
+	 * have the writeback flag set, which prevents races with reflink
+	 * remapping and truncate.  Reflink remapping prevents races with
+	 * writeback by taking the iolock and mmaplock before flushing
+	 * the folios and remapping, which means there won't be any further
+	 * writeback or page cache dirtying until the reflink completes.
 	 *
 	 * We should never have two threads issuing writeback for the same file
 	 * region.  There are also have post-eof checks in the writeback
-	 * preparation code so that we don't bother writing out pages that are
+	 * preparation code so that we don't bother writing out folios that are
 	 * about to be truncated.
 	 *
 	 * If we're being called as part of directio write completion, the dio
-- 
2.47.3

