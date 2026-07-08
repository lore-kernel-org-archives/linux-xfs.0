Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85DF1EB1AA;
	Wed,  8 Jul 2026 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487083; cv=none; b=VGaIpuv14qTCt/pnqjMrXcJlQ2VINFJLdFHRM+WGqzLTtSTaK8D8DNEqdbd1/F4lijHAnTYiiGdKYxhtoFMHZK+eEZhWz1YTCdsmBWlI/Au3k4oxjrxoY9POArIuO0Z1OsKNcO/+BQqmdJKj5E/TGlgDZJrUEA3G8pJWTPQTuJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487083; c=relaxed/simple;
	bh=BzbRcGzKldtgxpEm15QF8z1DUEq+zn/p4i+g4gasc3g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APuSwr3r/pcLb06t7Vj1hJdDWwf885kUmow8nAz11AP3who6TKtZ6fCJSnoI391/zxD6Q2hZT4GqDdLicGx7IhKDav/or1s9/ZC60msBgZPCJpTK1Xsn02zJYU1ijlqTPKiSQLmix1Xhard0F4/MeAnuUdjHV+PjTtyS5J5YuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ka0YZ+vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ka0YZ+vh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6C5391F000E9;
	Wed,  8 Jul 2026 05:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487082;
	bh=PHHQAbwralIomskC+xZJBTJwOfSkRgzi0FHJI95YXO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ka0YZ+vh91e7FBZvQbTifZ88zgLlL1/D1Z1WAOrn3PQLi8Xfx1CR/fjtu0Q67JlPI
	 Yjb/EswY26WLXUlvJC/sRzdmzfA7Vp4cKQ0AS+7nOorcOw6RJrPTq2A4J+YGerYYS+
	 h22lL/uFa3R62qmGIGKRu7kkW43z2r8P9tlpSC7RcMdPTbfFqcb0SUGhOZPBAWPpgy
	 b0aDGyxJ7T/QkYOkb9HY2WVhAz0l3yt1XcHJciDNb680VyBPuPbvEabhAeNVsQXx93
	 Bqx/Vbo11xXrfW9ySE3S8FR2TIKO4TUhHXE/NsHl4id1i8E8cxpH4FOGWsChRnaZT1
	 RGqHUpXScAQrA==
Date: Tue, 07 Jul 2026 22:04:42 -0700
Subject: [PATCH 6/6] xfs: grab rtrmap btree when checking rgsuper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178346726213.1271589.14188309471369607201.stgit@frogsfrogsfrogs>
In-Reply-To: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we aren't grabbing the rtrmap btree when we check the
realtime group superblock.  As a result, none of the cross-referencing
checks have ever run.  Fix this.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 428e4884656db9 ("xfs: allow queued realtime intents to drain before scrubbing")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rgsuper.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index a52d37c33ca15a..c92212d8eb11b0 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -23,6 +23,8 @@ int
 xchk_setup_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 	return xchk_trans_alloc(sc, 0);
 }
 
@@ -43,6 +45,7 @@ xchk_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
 	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
+	unsigned int		flags;
 	int			error;
 
 	/*
@@ -63,7 +66,12 @@ xchk_rgsuperblock(
 	if (!xchk_xref_process_error(sc, 0, 0, &error))
 		return error;
 
-	error = xchk_rtgroup_lock(sc, &sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	if (xfs_has_rtrmapbt(sc->mp))
+		flags = XFS_RTGLOCK_BITMAP | XFS_RTGLOCK_RMAP;
+	else
+		flags = XFS_RTGLOCK_BITMAP_SHARED;
+
+	error = xchk_rtgroup_lock(sc, &sc->sr, flags);
 	if (error)
 		return error;
 

