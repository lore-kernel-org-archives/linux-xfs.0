Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A445C96
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608845; cv=none; b=adxrOS43MDkxUJHNJY80IspsU4LcQBTv4qh8uLvyxKMCr/LWH16k495eDwiDNoLVcXddKmZ3NgCCfscN/4aaljdebupCwHetZCq79BCrbj78om3o7NYRCoEnpAaxaVsIw0zbNewpp9cKZ5AvQiQwMX/QH+GQ5Ek628KVS3W3JlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608845; c=relaxed/simple;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uykh/ygmq+u1jC53bBXsq2MXpm7fWOehzDM1AKIL+d9GMQ483PchQlzNRP83R49JUqd2EO+6XxJd/Jr8bLQIh8Ecbx7+EvnPufdjL4eU8kuLIU0b2YcfQli16YTiWOvTreqjrrB5dFWpc7BXLhkBrkmBifnxgvOuHkH4fcgOCOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q7jBVCXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q7jBVCXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3242AC4CEC5;
	Fri, 11 Oct 2024 01:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608845;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q7jBVCXZfxJ8l1Im7J8diq5KbAi0RjiIlIh5PYX/djtfqjKXvjcu5K7/fQGaUMhtH
	 jc+m5F/hKvhVWwxpAHSgAeok/tNxiUa5jVZ9K+E7Tfrpt0fDpfbt/xeve2U2SAkmtC
	 d7cDZ2nOLfVz2SzsjiNBKikORlX65vdu4UmxHD39/5bbVR/A1COTBIG1ks+BermYtq
	 /lGqEFI+zo5ZR2qjq0ks2ovJndp75KMA25BfARmr3kkQX9Pz/U5wmgfpz6zyZ9zos0
	 tqtIOn6B7VIuHZUrza721owpfyxp/ZzZwKOF4oIj1xljhGNwgeaBxRuPUKpywe6iGo
	 rPIzM2RC13PUA==
Date: Thu, 10 Oct 2024 18:07:24 -0700
Subject: [PATCH 22/36] xfs: don't coalesce file mappings that cross rtgroup
 boundaries in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644621.4178701.1353073607295469982.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

The bmbt scrubber will combine file mappings if they are mergeable to
reduce the number of cross-referencing checks.  However, we shouldn't
combine mappings that cross rt group boundaries because that will cause
verifiers to trip incorrectly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 008630b2b75263..7e00312225ed10 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -834,9 +834,12 @@ xchk_bmap_iext_mapping(
 /* Are these two mappings contiguous with each other? */
 static inline bool
 xchk_are_bmaps_contiguous(
+	const struct xchk_bmap_info	*info,
 	const struct xfs_bmbt_irec	*b1,
 	const struct xfs_bmbt_irec	*b2)
 {
+	struct xfs_mount		*mp = info->sc->mp;
+
 	/* Don't try to combine unallocated mappings. */
 	if (!xfs_bmap_is_real_extent(b1))
 		return false;
@@ -850,6 +853,17 @@ xchk_are_bmaps_contiguous(
 		return false;
 	if (b1->br_state != b2->br_state)
 		return false;
+
+	/*
+	 * Don't combine bmaps that would cross rtgroup boundaries.  This is a
+	 * valid state, but if combined they will fail rtb extent checks.
+	 */
+	if (info->is_rt && xfs_has_rtgroups(mp)) {
+		if (xfs_rtb_to_rgno(mp, b1->br_startblock) !=
+		    xfs_rtb_to_rgno(mp, b2->br_startblock))
+			return false;
+	}
+
 	return true;
 }
 
@@ -887,7 +901,7 @@ xchk_bmap_iext_iter(
 	 * that we just read, if possible.
 	 */
 	while (xfs_iext_peek_next_extent(ifp, &info->icur, &got)) {
-		if (!xchk_are_bmaps_contiguous(irec, &got))
+		if (!xchk_are_bmaps_contiguous(info, irec, &got))
 			break;
 
 		if (!xchk_bmap_iext_mapping(info, &got)) {

