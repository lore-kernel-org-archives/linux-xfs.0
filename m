Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275789;
	b=R7GQ6CHeYa9O2E3nH3Njuhw4f24u8bduoWtGnBjbPp2CB2JQBzUrizBTvZUD8kxex2z1
	 SdU0eOEmLYlo9hrJ7u3fe5oF6TxWab+INAHZZJeQJ6fFWTnMXyqBreXsWSOBgcpUJ/WJN
	 CD9E6AksYgnKj2ZCr/kQbNfieSBkrhXnwpvyurOfN1W078Qh583PGcesC3ZGGSNhH50J2
	 qvP3vUyuNQiOzEXRCtKn2Fz6uBX5zj/Y0D4z0OJeQxv417CJqN06SsSUUFBNL29tCki9B
	 4Ln146Va5997UyA2tKMstKD2QjWEKNkQVZmp+pukpBHDIPTjARsfJjndR6n7OVLBTQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S2sPNKl9gfCBQyDSxy0OdwqJfIl5r1lP7Qa2y/dFr/8=;
	b=EFpOSdli2f6wMbQA8c2XsCbLO/2cPRlKTpkmAwjVfn+tz5Hm4uuM6HIhu6dazxzsU/yF
	 az9a7Zy0anJMsYBRfnkczrU4Im4DZVY61gXzopgnnZJmBmlqEpCm21gX6bbnxxJGkXbQV
	 gZgU6fVSXZqrAUDpfabAs4kbBPe0XDABcUC4tKp4ohFSPn5n026ny6FOus/ZJCjDLBEYY
	 cr3FLPhHwzEMZSEfFdklHjSuCSzqz8kMxRRPglHu9k6ykJ/8celrXVd5+XrRBVWhiTYhG
	 Uw+6IBo1+nsWTlpQr+95ty4q72TEKR4bJiMcXqvtFQi7kvzSpyS7STLBnqTLg3qAzUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGD0maEp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CA4606A325
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGD0maEp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5028A1F01825;
	Thu, 29 Oct 2026 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275789;
	bh=S2sPNKl9gfCBQyDSxy0OdwqJfIl5r1lP7Qa2y/dFr/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGD0maEpp07GmnbA10dbTED0ljMvcbUL6xWpW4ORIbxEJUKFrLL4F6nvzHr7z1kMP
	 DQ+ULBgfAgMVDPGKI8coTI7CLPRl1V+kt08Qw8v2SNMLnswWHOTgi7Vx0LOaa6D4Pr
	 8R09Kdf73yQpgMiDkpw+OZb7kHo3W2w+oNPmO8dFQc2Oh/RMnK0ZRxrE+Tv5vcL0Zo
	 F4BzCluN6nufpNI+KmD2wyU3aqbeleTIp/N0kmwRQdgKXkMo++LGCnO8oUIsDcTvQw
	 kzQjL0DO+9jLel8e9UewWD1qc5WvZ7f53LMavEk9kEsDlQtUDe/jfKG1i2zJXP1rKj
	 Sr4ohc3f4rprw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 06/28] xfs: remove spurious XBF_DONE clearing on readahead validation failure
Date: Thu, 29 Oct 2026 13:06:03 +0100
Message-ID: <20261029120631.803074-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7a4eae80b5b3db8d68961af3707fd56f2220cc29

Both callers of ->verify_read already do this, so don't duplicate the
flag manipulation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dquot_buf.c |  8 +++-----
 libxfs/xfs_inode_buf.c | 15 ++++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 21e74d6d17d9..e4599a084be5 100644
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
2.54.0

