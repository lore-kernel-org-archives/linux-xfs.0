Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A919CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301763; cv=none; b=n983HaN0JT/etsir3CIr0Qy4fgK392LAub4kDmGJKhW5rea44TopxB8FPuig2+7natSQek2bJCmAlkYlu6WB2CjolK8eOT+gZN+yJlGQd85wS+BkNtbACPlJ8nZCvG2q6jQ8juCILp6JoeBM0NL2n2CGsj24iroGSVAo/GCx/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301763; c=relaxed/simple;
	bh=sTy5TSJGSEi37euAB2/sI+kJrqMP4MUXQHA18+G+hMs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MEi0ukF0zY946OWKPsPQfYPziOf3/x5/8b7n3VXTvUHfUcO0lnnhEebCfY3l/Ce83gO5jZKoFUWKJxQ6+ujmtSLSuAQUgr8Xc2MzlaUFIkeGEx8D857J06NSWrWbO3HYwfnKmqzxTzmdhc3MRMmMJ1ds0hxSJHIFtV2Hzahg3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCRcYUGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCRcYUGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D8C4CEC2;
	Mon,  2 Sep 2024 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301763;
	bh=sTy5TSJGSEi37euAB2/sI+kJrqMP4MUXQHA18+G+hMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CCRcYUGR8/y+NM6fyuQ5vxFr508MpTu/223175ZAh3lczTBOTAjS7+oNw8jHQhUOu
	 e032zHFCxF41wGSl+m9WUmKIdtcSm5JrWhGJAHCFp5hK9eq3BEciLcE7BwXJBUjTMW
	 YcFatftVC2ICTeBS4FIy99MXFVPHUTlRftXJ6FMedcelFsen7YuGBjuz7NSCG3/m+f
	 hfbsYUZSRtsVzkSklW+ayhbBA2LGep9YH+hnDymBP+rxcqDNq/9V8ueVUgcEJjR16j
	 xgAurWM2/LN3pn+XTfcMdqTlM7gXXxNVsQLhzArZioBprb1I3t309eAWAE25bUam2I
	 AMUBA8RFqL7Ow==
Date: Mon, 02 Sep 2024 11:29:23 -0700
Subject: [PATCH 09/10] xfs: remove xfs_rtb_to_rtxrem
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106406.3325667.17621512722551301352.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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

Simplify the number of block number conversion helpers by removing
xfs_rtb_to_rtxrem.  Any recent compiler is smart enough to eliminate
the double divisions if using separate xfs_rtb_to_rtx and
xfs_rtb_to_rtxoff calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |   18 ------------------
 2 files changed, 4 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d7c731aeee12..431ef62939ca 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1022,25 +1022,24 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		rtlen)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_rtxnum_t		start;
-	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = xfs_rtb_to_rtxrem(mp, rtlen, &mod);
+	mod = xfs_rtb_to_rtxoff(mp, rtlen);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
+	mod = xfs_rtb_to_rtxoff(mp, rtbno);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, start, len);
+	return xfs_rtfree_extent(tp, xfs_rtb_to_rtx(mp, rtbno),
+			xfs_rtb_to_rtx(mp, rtlen));
 }
 
 /* Find all the free records within a given range. */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 523d3d3c12c6..69ddacd4b01e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -86,24 +86,6 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/*
- * Crack an rt block number into an rt extent number and an offset within that
- * rt extent.  Returns the rt extent number directly and the offset in @off.
- */
-static inline xfs_rtxnum_t
-xfs_rtb_to_rtxrem(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno,
-	xfs_extlen_t		*off)
-{
-	if (likely(mp->m_rtxblklog >= 0)) {
-		*off = rtbno & mp->m_rtxblkmask;
-		return rtbno >> mp->m_rtxblklog;
-	}
-
-	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
-}
-
 /*
  * Convert an rt block number into an rt extent number, rounding up to the next
  * rt extent if the rt block is not aligned to an rt extent boundary.

