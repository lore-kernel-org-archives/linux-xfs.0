Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5E339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928230; cv=none; b=L4H5fUV51y0zJYH7EIjkI1SSnOEjZj3/exkFOjzw3k+1r15mjz+BF159Ho0ZI8awHUAhCTiM6t20RjAHqykGQAte1l0HoME2TH7cIJRoAH+94adUzVqhgGLAHYH4mhgZaG8nIdiAlB/0w/UYFU+SbAzsECC77IDEFW8f0vh4SJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928230; c=relaxed/simple;
	bh=D77+ipp5kDfxhmQUHAv6umpm6b5r6ZykV04sO2IRzbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=so7S/ItdUkFzyPqxuMzJqSBgIW8YYVhiqfw1vOUuD7Lv69AOvTkPRwWfl4RKxUYCSY6S1TE5vxz7cLpJN7hs9JJcWwxwyTC3iRoV/IYHLlutCNq3NZuk01jFV5QHfOc7nNoBHBHMzitRx8GBefxYgzMqYcohW4C2qNZlbLpG5xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ps6jv1mS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ps6jv1mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28006C116B1;
	Wed, 24 Apr 2024 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928230;
	bh=D77+ipp5kDfxhmQUHAv6umpm6b5r6ZykV04sO2IRzbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ps6jv1mSECoX3dMEKuod0txqsaTTjch8VAaEpiI1pRLd9zqJmZ10r+5bSLo9WoXzz
	 /sBGWpcnicwm53eQZp9bHPylH3BnnjWw/KET5z1hTz+pF/Czh980VX2ew2gaVmVy56
	 Xf7ojpSgykBO0IxpAOufe6Pe3rPYQWccLI3cJd4lwxIMJXtn8mIVR/AwFKexwWh97+
	 4Utpet5BDsFG3OalzGIezUwKasyctjv/EpMEEhGlrZ0K92+t0Z4ZDlvZ+EjSdQIiJs
	 2oPfVR7mVAgABFwMWv65mLxPBeF/CPe4B9JRvI0Cpc2TltD8TAm4rYghPLSO3oteC1
	 a8teFafQb1Cfw==
Date: Tue, 23 Apr 2024 20:10:29 -0700
Subject: [PATCH 06/14] xfs: check shortform attr entry flags specifically
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782674.1904599.2878438845396319181.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5ca79af47e81..fd22d652a63a 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -579,6 +579,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {

