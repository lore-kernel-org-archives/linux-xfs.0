Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B63735B632;
	Wed,  2 Sep 2026 05:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328174; cv=none; b=V5haOJmQAlKStVG16ahoXc9H2dMWTpsLaGnjp3O3v3ErRbJv7qJsA8lpRIorFTCT/w8SFlMs2RqIXfsy1plp0KOK7se2vahrPheXFVbl7GwOOquBLPMHmncHPgVBKH53SmEmRi2ddlgZXLfHpAAm1hILVmfjDJuExS/dtTbs7PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328174; c=relaxed/simple;
	bh=5KAyypkrn8YqrEqYNh89m3YdVJCM/L2Wl2PR68jv+jA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nupTXc4UNykhgUDSMZ8L2he1BQQRJW4LJ11hUp0MdC84z9C0QApuaXJA0M0AtFKoeEsyGTPn+5VzH3fP2tcL7aPzdS7ggw9fZVLTumsEEmkQcNKArirkGxDgTiioYU/+vlFNLEBTtygoMM03KBKafs7iqJKR+Edt/mUDkCPU2Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ay8D2FR0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ay8D2FR0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91D271F000E9;
	Wed,  2 Sep 2026 05:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328172;
	bh=Q9kJWU/IUgMcX3WVWOe2kzHulvZOFIJ2lSbA3wx0fd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ay8D2FR0VXww74EYsYR4DHieSi3QRmNcdoDMVxwPdZ4Fzrj2hqgSGG3tvQN8WJKoI
	 cgC2Zk/Ci7oVKJJkSvGo6da2gkXYZWTWCOrzrQTW/EmYxxRrRJlvU0MelMXiNtrgun
	 WCddfh8hFIJMuTUnkYhjkEUjyliVOIGtzfP30gwMb+jwVgZWfI5zag/XdjZ7TATLSF
	 A87vPABadkYyr3MoqQvg+NCiyJP52LTJVf6cHQVPsJ9IL2WlHuT4EIRmyIQqEpkhX1
	 tis/sxGPlHpJjBA03O80NesS5OxE1Hnk73JcHYCvhxHAL8x/aQrTG2FA1iv+JVyX7L
	 d2hbFYvtaUI3A==
Date: Tue, 01 Sep 2026 22:49:32 -0700
Subject: [PATCH 4/5] xfs: fix backwards skipping logic in xrep_quota_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750794.3508131.17764052841526629326.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains about the logic in xrep_quota_block that skips
reinitializing the ondisk dquot if there aren't any problems that would
impede a dqiterate walk later.  I got the type checking logic backwards,
which is the source of the problem.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 9d0097c5656184..be825448288ed8 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -325,7 +325,7 @@ xrep_quota_block(
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
 		    id == be32_to_cpu(ddq->d_id)) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;

