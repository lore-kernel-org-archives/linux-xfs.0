Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14818FC89
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991594; cv=none; b=paHVKRJ1AJdMothCHJV9x7eDO6m+EXtalNFy5M7DYvLjAippoj07Zms3Q6PAVscvRTsCiGLttK8DH4JS+LuE1qkt2OHQKLoXcHuS/0pl1LaEsSvvPkmceSXGEKrhvLUJajjHK8yxRjdA8Eqaa/l8Jd2tUqT/ByyZHAA1NYflk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991594; c=relaxed/simple;
	bh=r+JOey2kdyWb8sZmQ8+lm/Sl9KT9WvbT+ivXj9RbVjU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PaHTrbrP/y/Z1FRM2Yf0WdnMMy2vmwUERn6SQOGITHtIGnsk23pMHDqZ/28fV5ULuOVWP+8GSZPqj56/o29VVBbebEkn+2Py8ACwcnLiBo+snOhFxI/Pd9WRLfRKc8QZLsCT6onDmLKkF3en5loDinYsRzDnU81jAiDi6hzhrgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9twhaSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9twhaSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23689C4CED3;
	Mon, 23 Dec 2024 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991594;
	bh=r+JOey2kdyWb8sZmQ8+lm/Sl9KT9WvbT+ivXj9RbVjU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j9twhaSdIp1toaay+qlSYswOAv3hgDrLU6zYfjvPLijCc/4o1sRPM62z4ErY+wAsA
	 dvkgtmVGbqe0mRwGd9+7Bx25DJdo/mFhWxrW5FpZb/SfqKMxtdeQzi9EhSTOru5wVD
	 31M9mN6A+gIMQR1M7Br6slO4PDs8XBFATdA3UZwMh1zu74jChGqJ8WTT5GQSeuCFCn
	 X8/yyMfB6Oxc+myDRvouexd41YeVMzFXAWVK6RhiKZ90+7EkzAUlDgd/NcMa+1JHBQ
	 U/87kPN4hJQ8Ss/aoYpF9sULbqwzqEGeAxm0ZInkLfKTHHbKan0qwuGtyj0VSHFtfo
	 wUyZ6JJhBIdfA==
Date: Mon, 23 Dec 2024 14:06:33 -0800
Subject: [PATCH 32/52] xfs: create helpers to deal with rounding xfs_fileoff_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942986.2295836.2457023360630121973.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: fd7588fa6475771fe95f44011aea268c5d841da2

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file block offsets
because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.h |   17 +++++++++++++----
 repair/dinode.c       |    4 ++--
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 7be76490a31879..dc2b8beadfc331 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -135,13 +135,22 @@ xfs_rtb_roundup_rtx(
 	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/* Round this rtblock down to the nearest rt extent size. */
+/* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
-xfs_rtb_rounddown_rtx(
+xfs_fileoff_roundup_rtx(
 	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
+	xfs_fileoff_t		off)
 {
-	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+	return roundup_64(off, mp->m_sb.sb_rextsize);
+}
+
+/* Round this file block offset down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_fileoff_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	return rounddown_64(off, mp->m_sb.sb_rextsize);
 }
 
 /* Convert an rt extent number to a file block offset in the rt bitmap file. */
diff --git a/repair/dinode.c b/repair/dinode.c
index 2185214ac41bdf..56c7257d3766f1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -197,7 +197,7 @@ process_rt_rec_dups(
 	xfs_rtblock_t		b;
 	xfs_rtxnum_t		ext;
 
-	for (b = xfs_rtb_rounddown_rtx(mp, irec->br_startblock);
+	for (b = irec->br_startblock;
 	     b < irec->br_startblock + irec->br_blockcount;
 	     b += mp->m_sb.sb_rextsize) {
 		ext = xfs_rtb_to_rtx(mp, b);
@@ -245,7 +245,7 @@ process_rt_rec_state(
 				do_error(
 _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
 					ino, ext, state, b);
-			b = xfs_rtb_roundup_rtx(mp, b);
+			b += mp->m_sb.sb_rextsize - mod;
 			continue;
 		}
 

