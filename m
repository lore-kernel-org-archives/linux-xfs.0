Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C0616415;
	Tue, 26 Nov 2024 01:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584393; cv=none; b=oKo5IHZhEN3z0r3pKuEgyuMndneibAE48MvQz/IfDddA6QazcNJgYLVznHNHF2YvoUROqFd0JhpcbV9o6w/QKN4A0jVeYTF5R2e34en5p9ie+z+vj0kcEfafxRD+iWj5E82O4fQt6mmsk4aTsrpm8K43rXuVj2NTyL6X+vr1wso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584393; c=relaxed/simple;
	bh=0n2zX6/mxPc+XZPbT+FTVtajLFs2Gy5QQQ2igxVDaVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXJps+kAZgrC89J23qWo1HQMjJKnR+c6NexbQK8qT4Wm0v0RIbc0l1kYC+nZIjuXCu852wFi/JF1MsP26z2yknuD9iV1tUXZTOtC2GK2kO5PoUqKsonL8JDLZCfO3Zr5cTrKkK72VhhgX/nXor+URvTfZUdVmtL8gYZiMTR+7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIJPbBvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIJPbBvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35A8C4CECF;
	Tue, 26 Nov 2024 01:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584393;
	bh=0n2zX6/mxPc+XZPbT+FTVtajLFs2Gy5QQQ2igxVDaVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dIJPbBvSvrqh9+ROlDvgOP/zEWk+NaccKCWxZ04vvHwnOz8u0qO6OX5bUNafboI7U
	 iwFJpPXxL7coZvlxkQ8GgWSWsggVsdR6Prwmoh9lywhlujknMH3mqykj1JTr0AMP01
	 F2TayOmHOcctu67qYw6ydbFr1QXRDWMHdnDAbO9pdPAbuG0LDqP/nnhwN6SlxYhcBv
	 l0KRlf57MnNFbzTrxsazJfvPSAxk6ex0NwTQCdZxMjZ5K+3k+vUllzzOAa57MJSo2n
	 vVmUiL1LnPl5tVl4Lmgxqn5nbU9eVaEXPBU8Clfaaa26h2YA5TC0PNEGp3+K6SEb8/
	 cYXydNZpFmzfw==
Date: Mon, 25 Nov 2024 17:26:32 -0800
Subject: [PATCH 07/21] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when
 zapping a symlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397923.4032920.8428901441460084038.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

