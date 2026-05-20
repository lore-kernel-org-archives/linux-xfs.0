Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA82A3E122D;
	Wed, 20 May 2026 12:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280682; cv=none; b=UHIzOngCox4Gtn6MVMIlWtbIK+agUUyGwO4m593G9nl6le4q6/NuA0ox20AvhBUmsiBP1nWIIq+uMoKWDxMlxsdsFsJdGT/N6oNAbehvitX/+jBmGWUab+M0BJqAaDf3wO1EsrRqHpIXTrO4JLRBBm+t9LjMfzKcVOt/UYvlMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280682; c=relaxed/simple;
	bh=J/crzavrYHIn1d+gW2ScGAtX27fA6aHmmfZp3AwtM2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1rV6Ie+X/cVTTpGvdecXTIDVttUxuZX9LfLX8rRQ0HlWhjX4QeVC5S4onLmLbx99iSHBrwcZurV1BmGbbL+kl5NS5l+9hgG5Nxt9ysmcWkok4BCOx9p8piXIYTwx3Evg3KShrA2IW7Hph4SGgSKW+yhMMaFCgr06nmuldXEqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUkVW4Tz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUkVW4Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9231F000E9;
	Wed, 20 May 2026 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280680;
	bh=VpHBl5t/VGkWUCdWGO0BSnsIrLjhVZANk3wAFYMTAUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUkVW4TzrSEHkRKhjpwkCgR9+l7/kyskC1KL6846qbfM5dI1NpUKyXYjjZjcqsQVD
	 8wyQdH5upJ/CZv4xWRgb2OcF67ZOEKLKY6IKYd9xGdEz/cu938mc3Qw0iK17zwVqzU
	 f+7uNr/AoOAhj/w6se+oX1k8znWlL68hh7RqDE3fMadk/dIjA/IDqxNa+fF/34ynnr
	 zau2L6KrFmv9PXq3pa2ylVDzBQiFetIWoXypeH98AZ0b1ck5THLICjCgQck5mv+Adf
	 LbSd8kikdQ38sKIAYaQpCEAzL7BYISOaN6BPNRZfwu3F3NEbrjYPhG7cViKtKDpVU8
	 tsfB2JnRy2JTg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v10 13/22] xfs: disable direct read path for fs-verity files
Date: Wed, 20 May 2026 14:37:11 +0200
Message-ID: <20260520123722.405752-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e3f4353b3b78..2ef946e3f46f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -282,7 +282,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -333,6 +334,14 @@ xfs_file_read_iter(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	/*
+	 * In case fs-verity is enabled, we also fallback to the buffered read
+	 * from the direct read path. Therefore, IOCB_DIRECT is set and need to
+	 * be cleared (see generic_file_read_iter())
+	 */
+	if (fsverity_active(inode))
+		iocb->ki_flags &= ~IOCB_DIRECT;
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
-- 
2.51.2

