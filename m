Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93D1DBB2E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529582; cv=none; b=E3+LwawxZQk00xxJ1Gnq05KJpY9DE/r4Ed0wJhICSocWCJqHEgbIkoOT4FSMJxlUY691hCXOv4qwbcIF1/Mbjbfh2ly1z9V8XROB6MiwcvaiWSxSJM6cI+ymljhiEpAa6ODHxzj0ulhw70Xmq2ALWwHxE876i4icJWnDpLyzYxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529582; c=relaxed/simple;
	bh=r+JOey2kdyWb8sZmQ8+lm/Sl9KT9WvbT+ivXj9RbVjU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZaEotORu+7PAfvAgfzP9iyGkNTYarSayRaYhqVabRR9Sz984THTgGffzAusoxkx8CJOR2KriuVfBhum8vTF4ab25YaItMaCpKXlXMVEVN94Rqbwzk40cRQgii0dr7HGrya5cTdTuSIWBKlgm4HKzbRFQu99nxRcASrkc2lR1oG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+uzZmpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+uzZmpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264BBC4CED1;
	Fri,  6 Dec 2024 23:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529582;
	bh=r+JOey2kdyWb8sZmQ8+lm/Sl9KT9WvbT+ivXj9RbVjU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G+uzZmpPvcRQaIvRhMhxbUJPs1rfUwlioEhOCTMUE/iCMSiKnTbjEcTWT9uy0oqpl
	 R3evas1sBZTXel/EI+fc336KGny80IOs+QrJM9VmitNT0A6MWv9DkDKCJaSKxRMjwW
	 tsOdKV+NQjLuLQTiVl6xWhbkgjf4jJdF/Nzc7AnPDY5+iHdwtUk6DGmAwLdXbPdtrv
	 L22MlK+skkktScc7euNCqBYY9PjGU6F/bPvgfi+cJib13lUAW+b9l3zTBfuD9QUhd/
	 vBXH0Kk/kozox7jjQxa2e1KSoVBcTCViR4AzDm+o/09c8nemlP8oL+IOwSyn86VwOR
	 a1QRQAZ0PvbYw==
Date: Fri, 06 Dec 2024 15:59:41 -0800
Subject: [PATCH 32/46] xfs: create helpers to deal with rounding xfs_fileoff_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750484.124560.12006693185286070177.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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
 

