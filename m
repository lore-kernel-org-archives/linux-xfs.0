Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB27378D84;
	Fri, 10 Jul 2026 05:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661027; cv=none; b=miFG6u9qvg8fg1AEa1o852Rc22U6694cLndRKTpUNh1rqd03Xqyq5+dYbXGBr/SXtrTd5r8/peUcWEKF749sWNxDCfuaO+ZOUTajJtSMmXEAvCTfQqsxoE21NC0dCn8fyliBO7JiLboqv+95nwUoVw0VL2FUkqQd/Lm1BoZvkuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661027; c=relaxed/simple;
	bh=XZXBrAeICcTrqGjWR2W+8miethNUnuOfQPyZWVCQ5Fg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9jq9R6kpWO1wMY/R5O+y/pxnijT2TaeTDmEK9tjws9a1Ltess20DYwmObWtr7oQMTe2ZYDcoBKkmGc1dLp2RerzXmX75pelJ2Jegz0U6oD3FOgyW8r/Zx90W1H7z55+gKTzFxdhFZsqPcHRMw5TUNyjZZeR+EwjmLX2vzfcz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNgnjLpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNgnjLpU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DEEEE1F000E9;
	Fri, 10 Jul 2026 05:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783661025;
	bh=5PV5w+3RRKozs7/plCeNFPREm1AXWoTk3eR6cu9jv7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FNgnjLpUvUZc195fRuJLMuA1DmlI63tOO0xpYta/3i9iVl6FwoZuKtVT4guMKcL7i
	 Fe9mubxcuyKU1rJq4516Nz6bhrhi/Wu+FKWynNLFSMonV8pESt8yYui4fgArw7Agfa
	 SkIG5lSKTcHQJCwEWBCOQhZ9oY6BkbCLNQecCR7I01I4ci2Rsi2e0E6ulGSpHVhcKr
	 Ufty3DXwOfCV8QmlP/zEMD4xG5FCRNfAUbS7J3BDCpKLUvdBLacgS9YQWH4vaWXCDj
	 ++O9aNHTn8cQ6eaecvzEVe45R7RapZdhHBtJqbie96A0fq7A1jOST9cPGd8K1aeuAK
	 ZuSBMErnucwTw==
Date: Thu, 09 Jul 2026 22:23:45 -0700
Subject: [PATCH 8/8] xfs: grab rtrmap btree when checking rgsuper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178366081161.1173468.10755055144321092019.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

