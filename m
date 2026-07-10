Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926B235DA63;
	Fri, 10 Jul 2026 05:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661011; cv=none; b=M1msKPrVoWOL7q4VHOJb7EM7NQNo2/kphHiGhg1cwuxdxlFBqHQpvZQ7SUUIIY6H/IuHFYb4GL/aF6qGI2w0MeZNtyjglz/GtOkncho2SjO3RwIia1e6TGr8IIfL9JGcWeuOSendoKEJVYiLGxi/uxrZ21aWQE41j9dcOnZpUoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661011; c=relaxed/simple;
	bh=OoDeBw1d3MtqV8UiZirvMaP4yCQa+/SgK1mAqDvxKLA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWbGj7473Xp/OTjMef37cC6/xew6bH7WimOBLa/05ZAfIcIEuZmFLKLWQZtBMTuqKsRqii4xmqPHovt3fbgAPKid1Pw8CO6+Ca/pDENamCliFAPFy7Y7uKIz4x0w+/kGTtvdgDwCBwXRqdmzdacHDff7gmzJ9ob3Ra4sfmFd2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Knf7C1Lj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Knf7C1Lj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 293901F000E9;
	Fri, 10 Jul 2026 05:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783661010;
	bh=z0eP1PC+9/ib/5UkCbwQ8BdVWAE/6FSGiiBAAI3MK1s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Knf7C1Lj898c7zCOfIEQyVPtH9vMGYLb9ZeSsdQ8im7jqDkV2fe6WNlYabDQSUQHU
	 1MppwgBks73Rp2WFQERt1kebuJPl4aziAu/IfP8wIxfXpdeNciXsv36QRR5YmM7MB3
	 PTt59tnTcZ3L0AjmUqI5ggPkd/wTqE4YjqC/pa80arLGg+fF7SddpK+fWxvEMzSThO
	 AvG1B66+e1KCY8PwLaNjXZN0hyxExdy1pGBX+DDhz1xO5hSwXFdPjT7J4poBD3khBR
	 jHTCuIHqAK9Epnhk0V1faSl50lIplzXZPqgpz5nLelNppMSSkDdqdS4fTnp4DhaAVr
	 TqZl/lk9MN3xw==
Date: Thu, 09 Jul 2026 22:23:29 -0700
Subject: [PATCH 7/8] xfs: write the rg superblock when fixing it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178366081141.1173468.17546458034191861675.stgit@frogsfrogsfrogs>
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

The rtgroup superblock fixer should write the rtgroup superblock.
LOLLM noticed this, oops. :/

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 1433f8f9cead37 ("xfs: repair realtime group superblock")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rgsuper.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 482f899a518a85..a52d37c33ca15a 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -80,9 +80,13 @@ int
 xrep_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_buf		*sb_bp;
+
 	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
 
 	xfs_log_sb(sc->tp);
+	sb_bp = xfs_trans_getsb(sc->tp);
+	xfs_log_rtsb(sc->tp, sb_bp);
 	return 0;
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

