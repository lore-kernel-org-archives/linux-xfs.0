Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7D171AA
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504542; cv=none; b=YzggeK8bxTFZt8EukrRCo4/t7lK/a7wJNSLjUP176ooTynGYe4uYMn1du3MGByOsTuzXo/GwhtNZinZg5EOOFqwpP9FsNRr5+lGHWtkOa1Ts5Qvhoy1UmZT9XFO/kVWO5A8qLqRQPUCObvQZVkwEavBuQZQ83+d0e2F5EsGjsPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504542; c=relaxed/simple;
	bh=o9iIaWSYhQ3MC2Zqg/VKe33lM2bmHrfsINac+R7dP+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lf5BbalAnXL4gQYFOs1N31HrED1pOHtX48UA6ZmgDTmVmu6woGQqFhkdMgbhpvTnnw4picrdS18xO+e6wrofFMvDBLB50bYWOrAMNza+kqycj7dPfL8P5o+U7M3Vl6ECSgJnzBweXDk7cagMa8qUmY1E2jQtnzmb46FADij1rOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPgftRMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPgftRMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CDBC433C7;
	Wed, 27 Mar 2024 01:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504542;
	bh=o9iIaWSYhQ3MC2Zqg/VKe33lM2bmHrfsINac+R7dP+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UPgftRMatcNNStH2MkV3gkCmZUIZ8awM3FRTH90gS9Fy+324J+u6aeb/MDut4esRe
	 GJUo+Rbr1m0UcCe1rsRj0GUDjrVNdiYYKM2vh3DbkhbXipY472pMzjQrXOmAJ4Mswi
	 UV8uP9d5ZXTqqoRaGzjvIrZN42YIClGi9pKDLqTP58wwKEXyQnCKsNNe1REa6bREge
	 5pbFExg0vNIjn8Dx7eqnU15wL1hMETixkB6DLGADqF4sKeY9cMb/ciDDS4UDqUdJlH
	 7wlL0HQLwod6uE92rz6TiI8bndf2S0DsYOooWJt475m2lCQBIAeebUSxnqkL9gKz76
	 iG81BMY/6NynQ==
Date: Tue, 26 Mar 2024 18:55:42 -0700
Subject: [PATCH 11/15] xfs: make file range exchange support realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380850.3216674.4263166857518256437.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that bmap items support the realtime device, we can add the
necessary pieces to the file range exchange code to support exchanging
mappings.  All we really need to do here is adjust the blockcount
upwards to the end of the rt extent and remove the inode checks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_exchmaps.c |   70 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_exchrange.c       |    9 +++++
 2 files changed, 69 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 7b7b8b1d8a2b5..0ac52a73152f2 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -152,12 +152,7 @@ xfs_exchmaps_check_forks(
 	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
-	/* We don't support realtime data forks yet. */
-	if (!XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
-	if (whichfork == XFS_ATTR_FORK)
-		return 0;
-	return -EINVAL;
+	return 0;
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -198,6 +193,8 @@ xfs_exchmaps_can_skip_mapping(
 	struct xfs_exchmaps_intent	*xmi,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_mount		*mp = xmi->xmi_ip1->i_mount;
+
 	/* Do not skip this mapping if the caller did not tell us to. */
 	if (!(xmi->xmi_flags & XFS_EXCHMAPS_INO1_WRITTEN))
 		return false;
@@ -209,11 +206,64 @@ xfs_exchmaps_can_skip_mapping(
 	/*
 	 * The mapping is unwritten or a hole.  It cannot be a delalloc
 	 * reservation because we already excluded those.  It cannot be an
-	 * unwritten mapping with dirty page cache because we flushed the page
-	 * cache.  We don't support realtime files yet, so we needn't (yet)
-	 * deal with them.
+	 * unwritten extent with dirty page cache because we flushed the page
+	 * cache.  For files where the allocation unit is 1FSB (files on the
+	 * data dev, rt files if the extent size is 1FSB), we can safely
+	 * skip this mapping.
 	 */
-	return true;
+	if (!xfs_inode_has_bigallocunit(xmi->xmi_ip1))
+		return true;
+
+	/*
+	 * For a realtime file with a multi-fsb allocation unit, the decision
+	 * is trickier because we can only swap full allocation units.
+	 * Unwritten mappings can appear in the middle of an rtx if the rtx is
+	 * partially written, but they can also appear for preallocations.
+	 *
+	 * If the mapping is a hole, skip it entirely.  Holes should align with
+	 * rtx boundaries.
+	 */
+	if (!xfs_bmap_is_real_extent(irec))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten.
+	 *
+	 * - If the beginning is not aligned to an rtx, trim the end of the
+	 *   mapping so that it does not cross an rtx boundary, and swap it.
+	 *
+	 * - If both ends are aligned to an rtx, skip the entire mapping.
+	 */
+	if (!isaligned_64(irec->br_startoff, mp->m_sb.sb_rextsize)) {
+		xfs_fileoff_t	new_end;
+
+		new_end = roundup_64(irec->br_startoff, mp->m_sb.sb_rextsize);
+		irec->br_blockcount = min(irec->br_blockcount,
+					  new_end - irec->br_startoff);
+		return false;
+	}
+	if (isaligned_64(irec->br_blockcount, mp->m_sb.sb_rextsize))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten, start on an rtx
+	 * boundary, and do not end on an rtx boundary.
+	 *
+	 * - If the mapping is longer than one rtx, trim the end of the mapping
+	 *   down to an rtx boundary and skip it.
+	 *
+	 * - The mapping is shorter than one rtx.  Swap it.
+	 */
+	if (irec->br_blockcount > mp->m_sb.sb_rextsize) {
+		xfs_fileoff_t	new_end;
+
+		new_end = rounddown_64(irec->br_startoff + irec->br_blockcount,
+				mp->m_sb.sb_rextsize);
+		irec->br_blockcount = new_end - irec->br_startoff;
+		return true;
+	}
+
+	return false;
 }
 
 /*
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 1642ea1bd7b30..23e668a192e0d 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -21,6 +21,7 @@
 #include "xfs_sb.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_rtbitmap.h"
 #include <linux/fsnotify.h>
 
 /*
@@ -241,6 +242,14 @@ xfs_exchrange_mappings(
 	if (fxr->flags & XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 		req.flags |= XFS_EXCHMAPS_INO1_WRITTEN;
 
+	/*
+	 * Round the request length up to the nearest file allocation unit.
+	 * The prep function already checked that the request offsets and
+	 * length in @fxr are safe to round up.
+	 */
+	if (xfs_inode_has_bigallocunit(ip2))
+		req.blockcount = xfs_rtb_roundup_rtx(mp, req.blockcount);
+
 	error = xfs_exchrange_estimate(&req);
 	if (error)
 		return error;

