Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC5B2F549F
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589633; cv=none; b=I7i8rS5ZEU35E/bTMCSJvlGj2DTwSKNq66g+uxioHP+UWHzm8X5rYhJQQ9gdkR3DHslDXYb4eTF6TkIlMtM//rJKCkBOXFFfN1aLPX6PNMs/+KQWQkqap7E93DfRLWylOeq7dDr6JwN+eL4V1irwerSGAPIUM2GHoJmts+jOU/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589633; c=relaxed/simple;
	bh=kTnsOVvXRHVN+b2mvxuS12uPX66ONPVrs6MGzPNIt2U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JvpmWIOflGlISxB9/JuT8CH+sm3jPSA4U7XhtuJg8qNiOsqiocMIbCMkeZC5jvWaZZoVEEOKCli8ZAULNJ0pdpKKbDgfiYmyvWuxDUqeMKUQoQfp+B5rY0sKSPPZS/u7p+I2ZF+2IGsyKIVae8guzys+iTVr+Zl802B3YdKVgX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAuXxmuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAuXxmuD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1FADA1F000FF;
	Fri,  9 Oct 2026 23:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589632;
	bh=uFMAJaIP6QMg6t86xJpas0NZ0RT5P9PKJ/Y6Y/GIMkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=lAuXxmuD435VKDEzOcZN2wl9WtTh5ZadHj39b4qPAxNw0nTQiNXV1kIouxg2rmhg4
	 hij/AWQyWY4TF18bDl/wNsBy61GBdL2s2PyoaXMO2XcwD3EzzWiBSaV/4/N6cCzWXF
	 tFmx/jcrM1n6D7sKfMl771VocTHgwhWU3ABj6vQJwH8lZrSyGbMQT90y2mwu8Zr4JT
	 CrfPWCztmR2e0S6yH0AQ/iE/LH5Rn2x1fP33zobD1Y7AumVwG0LzfK1VTeSS2nBQRt
	 8p4UzoFs8vyjYoYgZLDB3zfrk2P+cRsYGzjx4MEOx46iDqmpCnFj5vh2klW6vGqDz5
	 ZcOUHqL1BOfWA==
Date: Fri, 09 Oct 2026 16:47:11 -0700
Subject: [PATCH 06/26] xfs: remove spurious XBF_DONE clearing on readahead
 validation failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947478.3719791.2939220584005102229.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7a4eae80b5b3db8d68961af3707fd56f2220cc29

Both callers of ->verify_read already do this, so don't duplicate the
flag manipulation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dquot_buf.c |    8 +++-----
 libxfs/xfs_inode_buf.c |   15 ++++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 21e74d6d17d961..e4599a084be571 100644
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
index 8ea12f82ad818b..6fff9bbd39abb0 100644
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

