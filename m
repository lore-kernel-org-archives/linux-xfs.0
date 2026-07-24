Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F02E388879;
	Fri, 24 Jul 2026 06:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874079; cv=none; b=SXHiGOm4pKHxRtJ1uBCyEMF9HGtJTRBWCccXMpT6EOjOZlk+sSZ/RvgBgEMqCGDduJ/A4jwhNWiAAxcBQBQMOa3jNoZCOtw/jVfZ8L4hEunbLiJUc/9o4Mn7J/jca/WYYkrL7dtyDriPN1vLt2QFB+HH5SOXb5NU38XrfLsBWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874079; c=relaxed/simple;
	bh=0oSpeqxjq7adk9CxJv+3BetaK6c2OITgJtdqvLIBsbQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4h8UqYH+LWvAeBps9d3xkllW/qw0nT1OfF5c2/Kfvq80wbfxHKYGzhB1THK+Ea/tNoio8YTDFbsaA5A8rLpRrilsRt4D4e/sP1OL0vfXs3a1OJt4NeZeivyyYy3sNzfBqxBLkgucwT2Xj8EJuZjNfAN71vkqPJeOikD2X+RfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njac0Grm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njac0Grm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A98151F000E9;
	Fri, 24 Jul 2026 06:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874076;
	bh=bUjvrWHDkuJT5zQa/sUKDucGjGE/xtmGtLX1gd1CvuM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=njac0GrmNja/mcrwg7+WGRgswe68/7xwr/3nyBDpZttbZQZD6gOkIg558jSwE1GkR
	 IaJHsPcaHQLAqx+NC9qysU6BdpVGC+RpnoKKuv6hrVa+PF6XiZBegILxLg1UcvjaOj
	 9BUepeYiXBl+D2BQGTmZh7gi/Ii6nW1KN6Zf6VinYXeMDiHcNdgPxABPmuqjJbXutV
	 ztPQlsgavYtVl5vJ6Sr5vxLROOGbhrpCcyPRDCX6IlwWJZzBSgV2j4lv/HwTDnnl7d
	 P7qMw7nBGHA5C6r/8/8yTnkiCggu6kKama0zkBwKhZmd4GLok5fF8SdKEyKxJ6ffsm
	 InKNx6looEPag==
Date: Thu, 23 Jul 2026 23:21:16 -0700
Subject: [PATCH 1/6] xfs: only check mergeability of bnobt records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405399.3442778.7901047937592189648.stgit@frogsfrogsfrogs>
In-Reply-To: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the cntbt (free space by block count) btree, records are not supposed
to be in startblock order.  Hence the mergeability check is pointless.
Remove it, since it does nothing, as LOLLM points out.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: d5784ae82778d9 ("xfs: flag free space btree records that could be merged")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 48edaa2cb1e079..c666be69f16481 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -136,7 +136,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
-	struct xchk_alloc	*ca = bs->private;
+	struct xchk_alloc		*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
@@ -144,7 +144,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;

