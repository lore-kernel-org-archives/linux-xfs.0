Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF438F94F;
	Tue, 25 Aug 2026 05:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636205; cv=none; b=DTwt8mQJ534RBd6HWNyVlRmyxR5lA7QbTQXzxrF/NsFqkWwS0nC1X6bdSVzyuagCQEbeSR3UgA98f0wRpAsjRCeAEaHjwnf5aOWUQql5jDOmtzm5BEBqdfiK2OuzhN5FCMO84qMTlpH7mvakvzlVNzl9/su/4ecyLOBTzRJPwik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636205; c=relaxed/simple;
	bh=UDYLkVzBOqiSrIVb3UuTLDiP+sW3+2NEuqVRRMe6cLM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNspSM91Do+ZEv/lzLgLyoMGhhhQnIhQvWZCurBB1wN5X5h7XeRuYuoHAjh8iPL+sTxDr+a2/tbsKkLuzJBp+hHb/ZfDNmTvmZ97CNgNaypoe9fazQHIcDRJ4GnG+sWpKsaUWlTSiEs4oHUmXI/uZHeVAq407bwkALOm/JZ2+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAnbl8jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAnbl8jY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 19C381F000E9;
	Tue, 25 Aug 2026 05:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636204;
	bh=DpjE1MO6dj8OvUi+UP8tIjhZt9kaAAJI4d0onkh0Tmw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=RAnbl8jYcSWlwbPunbjxDmC/432czZXxi9al8D6ay0K622ZsI2IpxGacaycvrFOnB
	 gak2FhIh1qNgd5FjP626GgA6lTqF26ITnCUDoA47vdT5DP1XwP/9/puvHJF+h5fwZl
	 AeJB9uA/rMp0Jbq+/bP85DZ3yxwmr4sAUXiKEMrVOUiGZQ0dEbJ5X+d4GalAIC2VFO
	 gUK2L8OmDLuMz8jKIRJHdLNSaAUO0/uBne36q88pTKAR5mxBM7y41nJ6LbF//2tp1j
	 /KWt1zLWPtVBZfVmU+bn8pDLX/P/jWlLD3h7d2O/PjTzTO4GnEElx/5FtJ9XAlsf0K
	 8iU4GLB78Ja3w==
Date: Mon, 24 Aug 2026 22:36:43 -0700
Subject: [PATCH 3/5] xfs: bump lost_prev_errors if we lose even the healthmon
 lost event
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941144.944364.17236586366229926747.stgit@frogsfrogsfrogs>
In-Reply-To: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we don't bump xfs_healthmon::lost_prev_event even if
we can't allocate or queue a LOST event, which means that events can
disappear silently when things are going very wrong.  Bump the counter
to avoid this problem.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_healthmon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index a2ae15a262a510..234ec20e1faed5 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -329,8 +329,10 @@ xfs_healthmon_clear_lost_prev(
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
 		event = kmemdup(&lost_event, sizeof(struct xfs_healthmon_event),
 				GFP_NOFS);
-	if (!event)
+	if (!event) {
+		xfs_healthmon_bump_lost(hm);
 		return -ENOMEM;
+	}
 
 	__xfs_healthmon_push(hm, event);
 cleared:

