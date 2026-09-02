Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7AD387361;
	Wed,  2 Sep 2026 05:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328158; cv=none; b=uwWyODsxDo0NmLgWchJwFQf4U1apaEFdN9t7i4XWvLpMonivfQJAXHpg6EC1Jm2yjeEeRCi60G/IIYbypbXEBgr+iM7stUQxjDtW1A087ChmGyApmbgJwf/5GTw6Nk1xUgSuZuUGOsCz/GE5lqXzpLut0wLTUFzNxlwvZCHGLEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328158; c=relaxed/simple;
	bh=HwgHKjV1MdhGR4R4gsiOxOBL00BDZqbB/6HiFSwQS4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSubolRz6tnhtJd3GboYJ/EFrTocuqbu1w7gmwEKaFMoq7k6Y1bXtn+cRT+RBu/xGt5+G9O09wykJhLxPdV4JDhk26umxizn8RkEppzpNpfAoKOYxMuPzrAsLFwmreSuePhoyrPCm6yhFzIsb7xS545Lb3VNCJOElrys7F9Ii0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVSZikfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVSZikfQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 115A81F000E9;
	Wed,  2 Sep 2026 05:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328157;
	bh=V3CBnoAVT4YwBdPbD+NfXuHXk4+eBseD1E5Fny8dqco=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YVSZikfQc0zzfVeHKm9xutG6nZQllEmzwkNuAU28oIqeCYJnhk9tllw/FDrPZp7GQ
	 BEoc0bMOgz0ZNWp/SrlfDjvKjzS47uSYIUWyl6Vmh+NXXIFjOWa7FojJAaVZghErdy
	 dYNuWxR/YuFLzNmJQvxa4bEWEhrM93HGavynt7PoxhH7zPL/Dnh4DgiB8VtyFGlIL5
	 2rhc0SZWB2JqdtnKgHnDcKCT8IAF4TSyFPBk19QlQiNEmG4ft5NTjZCXy3tXZmj+ws
	 DZpt9tYjyqpW6Q13PCFAII7aPVURMbf5vW8oGqf3Wc3zJjUr3YZVMdzoXH81VQFYCq
	 ARqnZofOCnRXA==
Date: Tue, 01 Sep 2026 22:49:16 -0700
Subject: [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn in
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
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

LOLLM complains that xrep_quota_block updates dd_lsn after calculating
the crc of the ondisk dquot.  That's clearly broken, so fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index ca3ac6728339d1..9d0097c5656184 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -364,10 +364,10 @@ xrep_quota_block(
 				defq->rtb.time);
 
 		/* We only support v5 filesystems so always set these. */
+		dqblk->dd_lsn = 0;
 		uuid_copy(&dqblk->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
-		dqblk->dd_lsn = 0;
 	}
 	switch (dqtype) {
 	case XFS_DQTYPE_USER:

