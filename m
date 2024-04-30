Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE20D1118C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714450088; cv=none; b=gOwo32UwaXjLu5JbW9zIT54dm2ovQydlSKkNxxyiLx+YXKIeIsVcxfXUN0Qw1avygbZNRJL4sfCscp8mq42f4Yum81HwcafXbQOJEgZGZBHS12PTS6iEr9oAqqQzjgYVUHhamryxPgUdLzaqTk18GujqwCt4uCtpdQasXVauYQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714450088; c=relaxed/simple;
	bh=eNxmu/TuUt7KaA/3J7Rar47zliWly2Lb5wDoXBHXaAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nluTR9NLy2q1id1vxseOx1+Z1bibod2ivvkHGEpxBCvStW2UMztDP9V11ZvHZeNDUFpauGjEhp3M4wfdnm2c55A6EmVGzR7Yronr+aSdem40AkV1WkC2rIBuJ+u2ZqsKv8eub2F/LuDCS9hB5FxBlCEeXKGM2HwFiMotg6X4Psw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TYDZKqR0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TYDZKqR0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=63ttVSyLpQdogNyrNe20vEEk7TOv1JTdQv3msvayczA=; b=TYDZKqR0XaLz8w0aqqLNWqEn0r
	jGjB9DJfCH99DTX6MB9AsbwVuIdxTODAsEct2ZUTkRZsDJfnE2COOrmnbo0MjQeGcDXf/cybXXGGv
	0FGCeEaEpJIKxnyPNDr31WCG+mKKLva7ID6+1hbMjrFCpN3cgs9xQ9CW4+6qv0xRTVukMaa7Vo3Yr
	PjlMLryIqhM3v+BODpBGFg2HyLjLznLaTYAnbscJjbXKZS8hd5eJvKF0xEnzuueYg/lDPkzWDRJmV
	Ew5YkGQkeeJr81Ja9B8Uz2cecdUcKVePAKcfS+Sa/Ep2om1r2nG8eRBa7F+4Tr1tpxyPb0qFO42ge
	M+r1pFGg==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1emi-0000000501Z-2fqK;
	Tue, 30 Apr 2024 04:08:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: clean up buffer allocation in xlog_do_recovery_pass
Date: Tue, 30 Apr 2024 06:07:56 +0200
Message-Id: <20240430040757.1653768-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430040757.1653768-1-hch@lst.de>
References: <20240430040757.1653768-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Merge the initial xlog_alloc_buffer calls, and pass the variable
designating the length that is initialized to 1 above instead of passing
the open coded 1 directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bb8957927c3c2e..4fe627991e8653 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3010,6 +3010,10 @@ xlog_do_recovery_pass(
 	for (i = 0; i < XLOG_RHASH_SIZE; i++)
 		INIT_HLIST_HEAD(&rhash[i]);
 
+	hbp = xlog_alloc_buffer(log, hblks);
+	if (!hbp)
+		return -ENOMEM;
+
 	/*
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
@@ -3020,10 +3024,6 @@ xlog_do_recovery_pass(
 		 * iclog header and extract the header size from it.  Get a
 		 * new hbp that is the correct size.
 		 */
-		hbp = xlog_alloc_buffer(log, 1);
-		if (!hbp)
-			return -ENOMEM;
-
 		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
 		if (error)
 			goto bread_err1;
@@ -3067,16 +3067,15 @@ xlog_do_recovery_pass(
 			if (hblks > 1) {
 				kvfree(hbp);
 				hbp = xlog_alloc_buffer(log, hblks);
+				if (!hbp)
+					return -ENOMEM;
 			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
 
-	if (!hbp)
-		return -ENOMEM;
 	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
 	if (!dbp) {
 		kvfree(hbp);
-- 
2.39.2

