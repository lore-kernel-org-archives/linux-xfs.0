Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEBD19F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416357; cv=none; b=eCdj42m17j0/CeFhyUh0nUOokwxKB+TIVRkL0wikZ1IdV4pm35yuGC8T1HzajevVpsuQOlfNiL9Gj0miAulPyAwOEvgJUx8uoSNvewm5h6C+KTrmvhLZoaZhChYV+/Iu18lGXTWl6JHVRtkg1z8S6JWCaYtHGTRhxCcrS3ETOng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416357; c=relaxed/simple;
	bh=AuqRh3OrtuH/JvbRD6WrnZHL53jxm6CypTiWutKsO5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3qAqYnoFvsLAZTkSY3i7R6SqDj4zvoRhqAUTgTqcSnw5xQOcthzndzwcRH0lTuhI01Peong/bJLLmDH/fOOO9ywlxISaZkI4e1spgLq4IsT5aBIWnWB0ztT/lgukxhMg1tMrwCoomQzgIJLtxVxdyU1NcNWWccUfhBAY79R4zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CL5ppxkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CL5ppxkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D815DC4CEC3;
	Thu, 31 Oct 2024 23:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416356;
	bh=AuqRh3OrtuH/JvbRD6WrnZHL53jxm6CypTiWutKsO5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CL5ppxknKRTurBp+7OvsFHzkIXkMx1ljqU0/BbsJkHorxFgcqaK6hxBWc4e409ETt
	 SGBhSvprYi56ObBJKneHTNEDvRyJNVWo8563VNwE0nWeOBVJo7A1HSFWt/FlE0aSPJ
	 uvmvbuy/dQEpyxVRWrpnkj+X7UonXFe4qBhz7uUc/opG8CBB/C3RKJylftOAMm7LiQ
	 fD6+IDm1nEd2j6HCPDNpnafbEDUdCYm9gGyaf/PONaBiMzDKbd3VK8tevrkZjl8yEy
	 MFMMQ3kfMQsA0lczrJ/hjZJies0TospRk5EMyvUS8oBhQ2ECx2YCw0kf0tOgI6mtij
	 TGxk/7Gll0Csg==
Date: Thu, 31 Oct 2024 16:12:36 -0700
Subject: [PATCH 15/41] xfs: remove xfs_rtb_to_rtxrem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566148.962545.7142397402329862218.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fa0fc38b255cc88aef31ff13b5593e27622204e1

Simplify the number of block number conversion helpers by removing
xfs_rtb_to_rtxrem.  Any recent compiler is smart enough to eliminate
the double divisions if using separate xfs_rtb_to_rtx and
xfs_rtb_to_rtxoff calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    9 ++++-----
 libxfs/xfs_rtbitmap.h |   18 ------------------
 2 files changed, 4 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c86de2aa13cea9..74029d4431e1ca 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1020,25 +1020,24 @@ xfs_rtfree_blocks(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 523d3d3c12c608..69ddacd4b01e6f 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

