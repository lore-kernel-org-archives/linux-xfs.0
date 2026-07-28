Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0023BB9F1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226331; cv=none; b=qYXMjI5auD0ps5ICtAgKqJleUl78TlNQwB5SesPHMmggn8Fc+QYz92rwLxyq66Rhs+l66MdWvNFoA/Nrgoi7OKTlWsiZva6W/BIqBLyQh2CjwaBYe7LR8IvIriSB/Ib0SH3b5HOec6pnoglhe9YNVzGsyUKcFVWDKXto43uWX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226331; c=relaxed/simple;
	bh=sOwBYSpGFZ7p2FDjR7wBd0fHnq02vfy58nW7IPzZN+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2hgpwwObTgmcPZuPPgWLqRWZ7CuR97SOyPtzKv/+KPkiZrQUzrE1dCL1L+hSsMefIGLZpiY95NmwsVENnnQkCHtsP2V/buLTncbAg0L/cFuURDX5/06XEA1MMpemcvblgno29YTwQC87GhZrxmqYQOGB3RuB0oZAb+8yzpYVc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RTNxu6Wq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RTNxu6Wq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1XHCBRqaMHeHM2a0ZPfluChSn6rJaxBrlcrOUaXf3vw=; b=RTNxu6Wq2V6w6KnbBG+ZNi8Q0M
	o41JhRMu8flOnkknz7m0MHhZTKhUHCEd8BN+0APHawDiuVDIMZHCbmB/cDA2qJcll+UKu1Ju8MAYK
	fQ4W3PTtRc+z3Usqb+E9hxSerMFFtLe18lig1Ls2EV1p6WMuHQJEit6Y0/Knyb3mStp5hSuf/zMoT
	KK5E4nG4za41AAGSrKaKMfbc+4KcnuNiYBgix3SEBcO8uFNUPt2qeW9xa1J3T5v8oML/T4tWUcW7i
	5lr8T3mbWx54FaQSclU2SQVJmzx55Y1WYS/gWLOrBl3/xrkYRGgSvQ8crI4BlUz0c5V0biPqLWUc3
	4Xv0SjaQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocv3-00000004h0H-1FQC;
	Tue, 28 Jul 2026 08:12:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: remove spurious XBF_DONE clearing on readahead validation failure
Date: Tue, 28 Jul 2026 10:11:12 +0200
Message-ID: <20260728081152.1778841-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Both callers of ->verify_read already do this, so don't duplicate the
flag manipulation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |  8 +++-----
 fs/xfs/libxfs/xfs_inode_buf.c | 15 ++++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index f960474bed3d..77954d1d924c 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -252,8 +252,8 @@ xfs_dquot_buf_read_verify(
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
@@ -262,10 +262,8 @@ xfs_dquot_buf_readahead_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
-	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
+	    xfs_dquot_buf_verify(mp, bp, true) != NULL)
 		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &= ~XBF_DONE;
-	}
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 336ef843f2fe..e4c3f7b24e95 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -29,12 +29,14 @@
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
@@ -64,7 +66,6 @@ xfs_inode_buf_verify(
 		if (unlikely(!di_ok ||
 				XFS_TEST_ERROR(mp, XFS_ERRTAG_ITOBP_INOTOBP))) {
 			if (readahead) {
-				bp->b_flags &= ~XBF_DONE;
 				xfs_buf_ioerror(bp, -EIO);
 				return;
 			}
-- 
2.53.0

