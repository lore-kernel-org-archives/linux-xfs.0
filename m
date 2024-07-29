Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FEB14AD19;
	Mon, 29 Jul 2024 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722262830; cv=none; b=WCnbVLlxc3hvObusgGdVPga0Hzp9K51I/DgA0RnYKrLrFa9BZMAKzJCuxX0Fblpj/IPLrejvUPKCGZbRKWndH3avym4ieh7Jx8fUp0yDbUecm0LuR5n9XnGF9oFwr2VSXU9WZ/baz+3vphoqgHcpG+06ht/U2/DHRWJhhIAhR+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722262830; c=relaxed/simple;
	bh=AaRyLQlWyuf5I9g1QGodjljghtPBc0T/zwO9Ka0JHns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNR0Sz/9DhwdW4UFJ/Gi0lhv33ecAzmfG11DY3d9GRMyqDC42dz78L/qTsiNVDTSHzaaicpe6+GJtCUOKwyam00wME+/DjYUliUOizzUVOwmFBp8rlKBgrjCDae29i82KXD4pinS+WFfWiF6e0C2hiTVNWKPoKnryN/5oaQG4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gK2Cdl4o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gK2Cdl4o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wvUKTCHYU0C7CySjyO5yDnsoWj+h/ZvWrHcJ8Bzg7SA=; b=gK2Cdl4o5CSh1KbVHhT6TqHBQ2
	pY5ZEuCRvcBH42qiDEaEqOylcrd3iK/Zt+Dui13hoKXPNinwoe3JjhQFpXTpYcqrCDz3gYRUSVEB/
	5Sy5aU2LXxgdO2BXZl/vjDbKql3JSyvL8OMguZKwVaig+GzZweUlPT7QPG8C/uJSsb2JxeJNbCxgk
	wQ0skFLtNoX8S2SIAIpcf2H6II0nyyl/xElkShg6YdLVvU9NHaeSIdPjTOhNGSgMJAyOelAXlUtEs
	oQmeWwDOoxQqiaIj0N/xA/A/qjCMsnaE9z8SxTAu8nkgqnOxq7Bp/GolH88J6AAIM4B18vqnxjz+H
	IiWhqzbA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYREi-0000000BXXt-0ZYL;
	Mon, 29 Jul 2024 14:20:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs/233: don't require rmap
Date: Mon, 29 Jul 2024 07:20:27 -0700
Message-ID: <20240729142027.430744-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240729142027.430744-1-hch@lst.de>
References: <20240729142027.430744-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Nothing in xfs/233 requires an rmap, it can run on any file system.
And it is a very useful test because it starts out with a very small
file system (or RT subvolume), which exercise some code paths no other
test does.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/233 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/xfs/233 b/tests/xfs/233
index 5d2c10e7d..211e5f842 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 233
 #
-# Tests xfs_growfs on a rmapbt filesystem
+# Tests xfs_growfs starting with a really small file system.
 #
 . ./common/preamble
 _begin_fstest auto quick rmap growfs
@@ -12,7 +12,6 @@ _begin_fstest auto quick rmap growfs
 # Import common functions.
 . ./common/filter
 
-_require_xfs_scratch_rmapbt
 _require_no_large_scratch_dev
 
 echo "Format and mount"
-- 
2.43.0

