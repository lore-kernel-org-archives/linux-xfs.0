Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EED43A7E9
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244349; cv=none; b=KCgqhBAD7Cpn/0yyyhJEJnbzZxIqYtctOhm078DXhc82SaGr6HZpd7oUoElExd75QLvw13JELUAlWSLeSCxwPULcaIOxgKCyCAsIOjCNg6Rtgq1QBCOslAq0bRojbmkwEpF8M/H2CzpOjc1JEXyEHGrYL7biKWeLlhn48QGtwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244349; c=relaxed/simple;
	bh=KkdrTfhWP2oBoI/Au+ZN2ykJqt1lgeJMRHyhmZrVqBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCFo4AeaDCEVZBzjvJsZxlTDvPeBTAFot/jv8d7N9smD/6IK3pfUk9wzZYZ+r1cksbcyjHqEPnGfj6sDvNUiMC5tNPwPSRrqSBkQXmhXXqstVUVoh+b+5uUwjzbyvxqr+bCvXGHb1IQ1AzyOCi8gMrgmV5vq8pZGcEFpTKP1O+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2LRaH5kV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2LRaH5kV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iQHDvoHr//4dnpsMaPZf2TAa9/vlaU4xg96hw1k8ZcM=; b=2LRaH5kVdFlEX89UZBOo4S9F59
	CNi8FxT32f+agW7UBBeaU4cTLQXaQLGH2vGYpx4r/Zq0Zh03lnBQCq8aikJqQX5kUIgnc9gRmnOfq
	Kg6iUJTct+14nMRs1aMsad4W5YmqzdxuR7BB3JwkvlvEetesyd87VMuPEKzMQRz/algrcJHiXbroV
	l+Ax5g4naSs6yzpdKzhVcGjMdyX0xCovFr1AlAcFLzwj8jV/gtnk70DsquyDJlLFb1FzZf4w8MbUZ
	v6LNeS9bkf20XOzkQBsbiS0s9JM8UN2VR+Z3f8VLRQcy3vis/yRcgP9RVvQEfn9h2syM+45jghnJL
	UU65fVdA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKf-0000000AfDk-1fJW;
	Thu, 24 Sep 2026 10:05:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 07/32] xfs: remove spurious XBF_DONE clearing on readahead validation failure
Date: Thu, 24 Sep 2026 12:03:57 +0200
Message-ID: <20260924100512.2733748-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 7a4eae80b5b3db8d68961af3707fd56f2220cc29

Both callers of ->verify_read already do this, so don't duplicate the
flag manipulation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dquot_buf.c |  8 +++-----
 libxfs/xfs_inode_buf.c | 15 ++++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 0e59106303c4..b9a38346bdb9 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -251,8 +251,8 @@ xfs_dquot_buf_read_verify(
 /*
  * readahead errors are silent and simply leave the buffer as !done so a real
  * read will then be run with the xfs_dquot_buf_ops verifier. See
- * xfs_inode_buf_verify() for why we use EIO and ~XBF_DONE here rather than
- * reporting the failure.
+ * xfs_inode_buf_verify() for why we use EIO here rather than reporting the
+ * failure.
  */
 static void
 xfs_dquot_buf_readahead_verify(
@@ -261,10 +261,8 @@ xfs_dquot_buf_readahead_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
-	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
+	    xfs_dquot_buf_verify(mp, bp, true) != NULL)
 		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &= ~XBF_DONE;
-	}
 }
 
 /*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 8ea12f82ad81..6fff9bbd39ab 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -27,12 +27,14 @@
  * has not had the inode cores stamped into it. Hence for readahead, the buffer
  * may be potentially invalid.
  *
- * If the readahead buffer is invalid, we need to mark it with an error and
- * clear the DONE status of the buffer so that a followup read will re-read it
- * from disk. We don't report the error otherwise to avoid warnings during log
- * recovery and we don't get unnecessary panics on debug kernels. We use EIO here
- * because all we want to do is say readahead failed; there is no-one to report
- * the error to, so this will distinguish it from a non-ra verifier failure.
+ * If the readahead buffer is invalid, we need to mark it with an error so that a
+ * followup read will re-read it from disk.
+ *
+ * We don't report the error otherwise to avoid warnings during log recovery and
+ * we don't get unnecessary panics on debug kernels.  Use EIO here because all
+ * we want to do is say readahead failed; there is no-one to report the error
+ * to, so this will distinguish it from a non-ra verifier failure.
+ *
  * Changes to this readahead error behaviour also need to be reflected in
  * xfs_dquot_buf_readahead_verify().
  */
@@ -62,7 +64,6 @@ xfs_inode_buf_verify(
 		if (unlikely(!di_ok ||
 				XFS_TEST_ERROR(mp, XFS_ERRTAG_ITOBP_INOTOBP))) {
 			if (readahead) {
-				bp->b_flags &= ~XBF_DONE;
 				xfs_buf_ioerror(bp, -EIO);
 				return;
 			}
-- 
2.53.0

