Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0610E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895595; cv=none; b=Ur+mq6NdCCBraRuT4FmiDxYmS27T2ZkL3U3xbDCJdJB7YmksdITEPLn/kNPUAgjTlVbFxs+on1uQpmuzPwmwZahY5QJoCX4jcU2uzBlYK6JyzVJLdAuTS5AAXuzPj1jhbsss7jQm+vAlxORs/vV0G9Igf1OB1xLy2RLTZzXh5iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895595; c=relaxed/simple;
	bh=j1nfIwzV9Ain/F6QMPz5IVeePJaiHErM4BnVJ6JeP54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQG2qNDyMrIfu+GXXLPoVgWSqv27rDE9B/WcyRUVGCEwcE0xi77ar5JaK5W/SqGmKWxMeDUBANSMcjheaoQb66O35I3/ckkbKhCdCH+ySwwsYT8IjaFEfUgyUxZ5sypvFnslsbNom01Dr80GefKeFV8m9k1slDJfRuPD6f5fZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XoFwgn3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XoFwgn3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BABEC19425;
	Thu, 19 Mar 2026 04:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895595;
	bh=j1nfIwzV9Ain/F6QMPz5IVeePJaiHErM4BnVJ6JeP54=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XoFwgn3C3HACttvsMOZdaXjBxpGO8sgmFyMiKuHRyblI/sRtziRKM7lY7/Xizxi5R
	 D0jb1wf5FvWtiyfMnfVVkREbGl1NmAjkoQ5BYRLaExUWfD73ACDbcUXkrzcWMIyqFv
	 wyL4Emxe6UybyiR5VJPZ902BCL2tPFuLyBIzv1nCq+rtUzk0F2SKAJJH6kSfHtyBOG
	 bGrg4DrvGOxG4zPnQJjOegzbmYEdBiEf7f69rGxUhNm76jl+aU+nFYXgNCQ2Sen1PY
	 K4ZKgke+I4f9k92q/LhHfslhPez6sT33ZhuBlLsggQjmxiYwlnJH9g/tD214nOiVav
	 eUQioKd0eGDfg==
Date: Wed, 18 Mar 2026 21:46:34 -0700
Subject: [PATCH 04/22] xfs_scrub: report truncated devices as media errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177389507014.3681140.10664326482423206046.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a zero-length read of an xfs device but don't hit any
actual media errors, we won't report the truncated device.  Fix that.
Also fix the mistake that flushing the verify-pools of the log/rt
devices doesn't actually cause scrub to abort.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: a6e089903f2f58 ("xfs_scrub: tread zero-length read verify as an IO error")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index abf6f9713f1a4d..590e5d23e6b267 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -782,9 +782,13 @@ phase6_func(
 	 * If the verify flush didn't work or we found no bad blocks, we're
 	 * done!  No errors detected.
 	 */
-	if (ret || ret2 || ret3)
+	if (ret || ret2 || ret3) {
+		ret |= ret2 | ret3; /* caller only cares about non-zero/zero */
 		goto out_rbad;
-	if (bitmap_empty(vs.d_bad) && bitmap_empty(vs.r_bad))
+	}
+	if (bitmap_empty(vs.d_bad) && !vs.d_trunc &&
+	    bitmap_empty(vs.r_bad) && !vs.r_trunc &&
+	    !vs.l_trunc)
 		goto out_rbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */

