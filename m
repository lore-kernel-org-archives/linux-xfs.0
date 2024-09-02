Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735C219CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301544; cv=none; b=SOcB7qAzGqGOjwFEn5e7oW8IdZl+EgjLA7Rg50FlDmcIXGIjtcg98vTdz/ejGdKadIfXaKiG/3p9KkdTfWxWZ1Ry+yvWzslf8HWUUHWrjrf+WVP0CWVLmCl5dg1aTzQ5wl046ZGP1cyiLgcq2u0BeLNYFQLILNuqtnoEpJwQF5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301544; c=relaxed/simple;
	bh=d1jThLlJPM79KgQhe4SW9k7gu8YIQCnuT0RU3IyUe44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C3yhjQ4kF/7qhbOsGV/0rUBXrMVeq6L0iAVQsiwOfH5WdfnmrxvQ+LWxH/BLRQuuDwwjfzxDpUIWhBEsIuhWE0StB14iJWPoCMAatkvfcXUHC/sHVC6Ukh1yoIqPHKV3iTQoZcYRlyUkxo6JZfxFfIJRzMSS07bakTV2PHH1Hy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExbkQ95A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExbkQ95A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53327C4CEC2;
	Mon,  2 Sep 2024 18:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301544;
	bh=d1jThLlJPM79KgQhe4SW9k7gu8YIQCnuT0RU3IyUe44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ExbkQ95Aoh6NKckuLY3GAHAMo46SA94WvyvyeuHxBoeWC7/krwyEpSxmljk43PZFR
	 Xn63YbZnIq9uHbF9ICdtT4nfRwnHmkR+lqPbG9p6IC2dNiJAfHvJxUOpt3WTa0K1o6
	 IolMzBlo8JrhN8ooPXU1nroox40TMGKIT+JZ6byjnwocSoHNG9PKWQa2J7B0SjoKO7
	 hTFvC0veHdHGAfFtSwGT4I+YfM22pm8EGrgRj7CnYjErvp1EKTWQV+iNZFtqQrobDL
	 uFeeHdF6ah5ed+EBTv2UUMD1IIx+xMCu2jFpamyu0z8tpHNz8luyc0V5//a3rckE9x
	 TzS2VNLussx/A==
Date: Mon, 02 Sep 2024 11:25:43 -0700
Subject: [PATCH 07/12] xfs: cleanup the calling convention for
 xfs_rtpick_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105831.3325146.1820766471312447244.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_rtpick_extent never returns an error.  Do away with the error return
and directly return the picked extent instead of doing that through a
call by reference argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3728445b0b1c..64ba4bcf6e29 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1300,12 +1300,11 @@ xfs_rtunmount_inodes(
  * of rtextents and the fraction.
  * The fraction sequence is 0, 1/2, 1/4, 3/4, 1/8, ..., 7/8, 1/16, ...
  */
-static int
+static xfs_rtxnum_t
 xfs_rtpick_extent(
 	xfs_mount_t		*mp,		/* file system mount point */
 	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_rtxlen_t		len,		/* allocation length (rtextents) */
-	xfs_rtxnum_t		*pick)		/* result rt extent */
+	xfs_rtxlen_t		len)		/* allocation length (rtextents) */
 {
 	xfs_rtxnum_t		b;		/* result rtext */
 	int			log2;		/* log of sequence number */
@@ -1336,8 +1335,7 @@ xfs_rtpick_extent(
 	ts.tv_sec = seq + 1;
 	inode_set_atime_to_ts(VFS_I(mp->m_rbmip), ts);
 	xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-	*pick = b;
-	return 0;
+	return b;
 }
 
 static void
@@ -1444,9 +1442,7 @@ xfs_bmap_rtalloc(
 		 * If it's an allocation to an empty file at offset 0, pick an
 		 * extent that will space things out in the rt area.
 		 */
-		error = xfs_rtpick_extent(mp, ap->tp, ralen, &start);
-		if (error)
-			return error;
+		start = xfs_rtpick_extent(mp, ap->tp, ralen);
 	} else {
 		start = 0;
 	}

