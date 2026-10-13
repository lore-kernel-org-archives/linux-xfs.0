Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2E48F018;
	Tue, 13 Oct 2026 06:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871545; cv=none; b=nK/KiGVF0wnfzFCXTZe24uLkZXq7XIfCMniJotPY0kQjvSuSnKMm91yKaeFbJnATAah5CpA1mk1G1238U63CAGFP3CmkyCokQMKRl91dndXVMVh7VUUiErvauKdBnE24o54vD5Le2mDdGcUAJTSM6ocRiUrD7hwUujcqRb+mUS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871545; c=relaxed/simple;
	bh=iFaDuKlrGJaPHH7T1t62Q9i6XQYD6yQCSFUGkARGz2g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPbM8ipN4erqv38JNq8JJ9ZSu8vdSuS+bREx0YhN9DJJCbIvmpmCKh2/WYA/YsvBURfUVc+zh7sUvg8kOPat6b+TxOnF0sfM8fbJtTAnoFSgscAwjRQ4xnZQ3oSMtZ3tlA8DorCuDnVKtFYps+FaA7SAssbkxGJxnpaD2UpOB9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8lgiAal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8lgiAal"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1BFAF1F000FF;
	Tue, 13 Oct 2026 06:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871544;
	bh=0SYibqoalzic2Rhvl8/Geq4/Z2hFqCZJfjUhGzbVhI4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=E8lgiAalBPyRdTYRcI4OKz7hKrdxRYhoybdI4kP3y2vLL3mBSY/7trAVggRQNhrhs
	 hnGMq9L9w5xdOChKBSkKG+8qJL6E4J9jq102AUMTvx5ivvWaBON32joTfH8pYutaXH
	 5lbEy52kG6Wl5yI64a0TKpx4WjgoPEILoOZIk8N+PHi78e4POLKKuizfZZuL/ueaEj
	 TDnC9Pf/WyS4YdhJVsT0iFi/zuXSQRd4lubugKpdigMbjZCsonwKtiZgtKpN5F7LPw
	 LaHZEelUt5yv5ifVFva0LWg1ZwQJztGZaTLApOUGC0RvBDguLgXx6m+qeadYTDzQPu
	 m4+iBbsFRYqnA==
Date: Mon, 12 Oct 2026 23:05:43 -0700
Subject: [PATCH 02/12] xfs: fix data fork block count check in
 xrep_inode_blockcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107182.1898400.11277561086741397264.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that for non-reflink realtime files, the @count output of
xchk_inode_count_blocks includes both the file blocks on the realtime
volume and the bmap btree blocks on the data volume.  Therefore, we must
compare this value to rblocks + dblocks to avoid unnecessary failure.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index de3c915984290b..89cbf599795b2f 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1719,7 +1719,7 @@ xrep_inode_blockcounts(
 		 */
 		;
 	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
-		if (count >= sc->mp->m_sb.sb_rblocks)
+		if (count >= sc->mp->m_sb.sb_rblocks + sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 	} else {
 		if (count >= sc->mp->m_sb.sb_dblocks)

