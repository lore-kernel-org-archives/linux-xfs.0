Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9C739656E
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127124; cv=none; b=HZloITvDSEsAb+Inirc87NvexN15ApRQJC0jS8D+t/09PANXihwebAph4G1MevtWyuprOnP2Yr6HSqEQDGWlKKW4RJVSGO9y2vixMLOn5IRVYwdKDpTb/SZVKOcwJ/eVnueelkQNcpuVqIBF3gSSQZqT22f4Uwt5viMAY3MHMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127124; c=relaxed/simple;
	bh=l4g1dop7NzlRp+35Zt2wEzZTKIn46fdzqxd8sL/Rm2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsxtWtCCJ3SscSiRWxqtEkyvYLzjGTq1XHa05W14gzj6+j4zIv+NOPkpFWoLXRMWc3RG9/3A0ls8/JoWYbd8zLHtys0Fz/vlWvRTz16N6IxVXlEfXqo1Oh8Vxcxuf2n+1+c5H42Iwn2xju6hjjV+dSDkfEIjV6KGgjBlq3YVU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qcdNmMC9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qcdNmMC9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3mVZgJmnFc1gFxzr2hwLngBJEiM7BUDQt7Zt4qzIrXg=; b=qcdNmMC9OPi5n7rOurRyJGUq0z
	Ms2Fif33/RJ2YTN/YyBSBJ5w9RzFR4rKKr4JVPC+23HML6pCB4J+5/dfv1Oo7B0m/KxOEg24qh4/Y
	nph+WWawgp6SjUa8DaFKTo1GLzu8vtpTYLkI/DQHTqxU3qbRmcG8VasUGy31BsKXHmLlBbX5taV28
	U0mLASLSVpOhi3RqtyYfdIzOCUAfDXZKCWayv+dCsAar7EOkMLisWoxhWiSH6eX8D5/mZKl5i0eHH
	s8PpvhBjEqjFD5xXIbu8ApjOi+LX1THUBa0YHvfe62sY0RcJYnPowmG0HbhOUOsw5Alw2K2fz6Y0i
	QdFuOa7w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0xu-0000000FDVy-3Vlu;
	Wed, 15 Jul 2026 14:52:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: remove spurious XBF_DONE clearing on readahead validation failure
Date: Wed, 15 Jul 2026 16:50:57 +0200
Message-ID: <20260715145147.95654-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_dquot_buf.c |  8 +++-----
 fs/xfs/libxfs/xfs_inode_buf.c | 15 ++++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bbada0d3cc08..4736f66e2a9a 100644
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

