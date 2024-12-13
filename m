Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2432F4A
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052685; cv=none; b=hzm7jNzpOrjDc432WeuJSIinobBnfoy9CYzdENp9UlJ9TCTT2kHFBIz8AWGsY5v/wIZLmr2HzUusK19ftsy3PHD7jQO0dMAzi3/zfDaZmTqkqh71WtvVBnqOqmY5HWJ7psK1zBjJW3yHthyTqw83hYZdjKnOGRUPdNnK+jcRc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052685; c=relaxed/simple;
	bh=zF/mZvt2lnU/h7FhE6tVO1XszjeOK7lHYKbfG5Xj60I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ty82k6UzyIa0o+hju6zMZ1+2i/Ye/IG2E7tJS+Uo7pcExRCCbhuwsB+W8V+kA9SPPLbJ4dp7Zwc5rw2F8Vtw5kQrL/cBKYDNftKpH4IbvhhhTemR/HOH669m5WM5Ff1P1ktNyXRv4uvKoR8fYlCrqHYjNDK3A3f6anU0nLf+/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crZq/eky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crZq/eky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF9BC4CECE;
	Fri, 13 Dec 2024 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052684;
	bh=zF/mZvt2lnU/h7FhE6tVO1XszjeOK7lHYKbfG5Xj60I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=crZq/ekyXe6ypllHj5EFRXvu+0ls+AJQxk9Nr60h5SQKawUWAbQlEOxPN4OKSYaeb
	 1Gy1trTIkOtI9G0o3J3rSGByFRGe+QfFt290r4opurz7rShQPVuAofCfKRm0cL0A6K
	 BOC0eY3BEAU9/pA3sTbFk2qbhSxwXU052YRmrZQh3orRWt7XY/n0S7KBxvcj5AsAlC
	 7PIv6z3W4dF4mayZrzeUeEwFhnxuYBcAqr3XNfkDs7YSANsO3h5/BwoKPHHnnfN1B8
	 35QCXTovWQh8i5ugRHuMnJl+bvJCN93gJJTw7gBkplXU/iayQrC+0CJsRrDZnQhy1x
	 sZhT6Jetu3LDw==
Date: Thu, 12 Dec 2024 17:18:03 -0800
Subject: [PATCH 30/43] xfs: allow overlapping rtrmapbt records for shared data
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125082.1182620.1056977780292340402.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow overlapping realtime reverse mapping records if they both describe
shared data extents and the fs supports reflink on the realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 3d5419682d6528..12989fe80e8bda 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -78,6 +78,18 @@ struct xchk_rtrmap {
 	struct xfs_rmap_irec	prev_rec;
 };
 
+static inline bool
+xchk_rtrmapbt_is_shareable(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (!xfs_has_rtreflink(sc->mp))
+		return false;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		return false;
+	return true;
+}
+
 /* Flag failures for records that overlap but cannot. */
 STATIC void
 xchk_rtrmapbt_check_overlapping(
@@ -99,7 +111,10 @@ xchk_rtrmapbt_check_overlapping(
 	if (pnext <= irec->rm_startblock)
 		goto set_prev;
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	/* Overlap is only allowed if both records are data fork mappings. */
+	if (!xchk_rtrmapbt_is_shareable(bs->sc, &cr->overlap_rec) ||
+	    !xchk_rtrmapbt_is_shareable(bs->sc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	/* Save whichever rmap record extends furthest. */
 	inext = irec->rm_startblock + irec->rm_blockcount;

