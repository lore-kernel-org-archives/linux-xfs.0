Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38123C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881291; cv=none; b=uKOZsBj1f4ZBqcLE42GR/+97UUL879LK5z9LQSOvNpHcP/S/jNNd7ArHm7QFrP6xHiTjQZFdDO8SOg4iB8UhsId1GyAKXK5hxu8V8T5QhVm440Z4mpKyaYB5Z6UkiGYSlun5ynnuQ43NHZmkOtFJWSXrT6GkKwYTXYK7hGe4Tmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881291; c=relaxed/simple;
	bh=EntUuLe0v8aH7mEuub1bOR7lNmBDCnEbQvYQQlYHCSE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8GMiA+0/IkQHQsdkdkAsKPFHOPxbWeywOly/YHVKWk/yxvmVREbcKimWhPbtBWq8J3eY27yk97M/MCQpTRFyGPTljoLiG98Q5a6t9sA1jFpBES6EIX2SEqZTN0QgV0UJ+FDyVxqZRGB0hFWg5eunWTKcI3rhJr54mETgtHm3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxH6MSSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxH6MSSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B88C4CEDD;
	Thu,  6 Feb 2025 22:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881291;
	bh=EntUuLe0v8aH7mEuub1bOR7lNmBDCnEbQvYQQlYHCSE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sxH6MSSD/45/vuAKlC0C1mqlLMa2lxe7RnxIfJOuQfW3fu5d3od8EZhDCs6fhoA47
	 3Fzts6d/Nv0NgIX00o5ynBAecBhP8Lx279zHz/pz4ftvwkVBe8y+t3Q7ak/JOnHYYJ
	 G47fXuvmhr7ovSddPmmYukMd4l1STUXASqR71AsQA9REsvux3gg7olSo6HHBuRh1S3
	 BLGDELqe3oQAyCYGH4CwHbysqjTxtZ/Xw46tEEjhuUbEHsRbZferOm0OBstYE08Frf
	 dKeCixs5ecNrRLzJQGO+r6rZ5SGyTP8Idcdl8ODx/FFOXNJlfs3RpQ4C7KLBYj+7zT
	 VQNL5I4dOWMtg==
Date: Thu, 06 Feb 2025 14:34:51 -0800
Subject: [PATCH 16/17] xfs_scrub: ignore freed inodes when single-stepping
 during phase 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086302.2738568.11012690239317955502.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For inodes that inumbers told us were allocated but weren't loaded by
the bulkstat call, we fall back to loading bulkstat data one inode at a
time to try to find the inodes that are too corrupt to load.

However, there are a couple of outcomes of the single bulkstat call that
clearly indicate that the inode is free, not corrupt.  In this case, the
phase 3 inode scan will try to scrub the inode, only to be told ENOENT
because it doesn't exist.

As an optimization here, don't increment ocount, just move on to the
next inode in the mask.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 84696a5bcda7d1..24a1dcab94c22d 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -160,10 +160,34 @@ bulkstat_single_step(
 		 */
 		error = -xfrog_bulkstat_single(&ctx->mnt,
 				inumbers->xi_startino + i, breq->hdr.flags, bs);
-		if (error || bs->bs_ino != inumbers->xi_startino + i) {
+		switch (error) {
+		case ENOENT:
+			/*
+			 * This inode wasn't found, and no results were
+			 * returned.  We've likely hit the end of the
+			 * filesystem, but we'll move on to the next inode in
+			 * the mask for the sake of caution.
+			 */
+			continue;
+		case 0:
+			/*
+			 * If a result was returned but it wasn't the inode
+			 * we were looking for, then the missing inode was
+			 * freed.  Move on to the next inode in the mask.
+			 */
+			if (bs->bs_ino != inumbers->xi_startino + i)
+				continue;
+			break;
+		default:
+			/*
+			 * Some error happened.  Synthesize a bulkstat record
+			 * so that phase3 can try to see if there's a corrupt
+			 * inode that needs repairing.
+			 */
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inumbers->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
+			break;
 		}
 
 		breq->hdr.ocount++;

