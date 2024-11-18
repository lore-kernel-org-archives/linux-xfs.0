Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5EA1E767D;
	Mon, 18 Nov 2024 23:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971181; cv=none; b=HtWrIx/4cshNbdTlr3O129j3GUdr/ALQtDON13OnQMUuvSz59JJm87sjys+uf4kdoPbu12cNCp3mCljnNLdkYxlx4x1PldlOeMtS8cw69gvJdcbjcUE5ENpA87mY1NJCzVJun3VYdsQT5iuPys5FrH/070xgSidsxvug1rHSTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971181; c=relaxed/simple;
	bh=PvtW6tfIcNcUbhG3Xo1d2VxsQ+XoCeJz0XHMA34S+LI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItjZjULqlP2Jpabhr2wnhOVvFGZQMEBSFnEKw+TOLuVTG39cYrR/tyj2QcFVMJ3+fz9Vmnw1uWN1Ge9GT1nF/JCu5OPpfTt8D3v350m9MbcQYgv8V4QNPScLC9ATGOfx/O0CdUBdlKrIX+NEynhuDBFrYKYOMP3Nk1QH1f8jIfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sxaym0uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sxaym0uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37B4C4CECF;
	Mon, 18 Nov 2024 23:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971180;
	bh=PvtW6tfIcNcUbhG3Xo1d2VxsQ+XoCeJz0XHMA34S+LI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sxaym0uETQAjbS1gBtnktWhIMExe7rQ8SEIdb90TkHF40dRITTgi9arFlWXYDUR7U
	 85X06PpKX+JEo+chs/j7/Y1kr2JXW22lYlzZHhujJmBRSD0KvePqlgwBzjZ3HUs5ue
	 qzp8xO49q9p6KEhTDV1pzlup+EPAmxxrIAVRHEtnPYcBP9FA313hGHP2m7hvyg6wK+
	 pMz3laVO8yyjHALX1ydc0fWBAL3KOraeolNs4doXlTmvZZwyPjTxkCY0JsotOsFsOM
	 KrdDNuUcgrM+5irc/GUsjEHGyiT5rOF2AYq34uWQB19WmCWuu7m/JCsbz3xWWD5fg/
	 w8wTemj8/utAg==
Date: Mon, 18 Nov 2024 15:06:20 -0800
Subject: [PATCH 07/10] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when
 zapping a symlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197084532.911325.5157952313128832887.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we need to reset a symlink target to the "durr it's busted" string,
then we clear the zapped flag as well.  However, this should be using
the provided helper so that we don't set the zapped state on an
otherwise ok symlink.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/symlink_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index d015a86ef460fb..953ce7be78dc2f 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -36,6 +36,7 @@
 #include "scrub/tempfile.h"
 #include "scrub/tempexch.h"
 #include "scrub/reap.h"
+#include "scrub/health.h"
 
 /*
  * Symbolic Link Repair
@@ -233,7 +234,7 @@ xrep_symlink_salvage(
 	 * target zapped flag.
 	 */
 	if (buflen == 0) {
-		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
 		sprintf(target_buf, DUMMY_TARGET);
 	}
 

