Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92703233954;
	Wed,  2 Sep 2026 05:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327940; cv=none; b=nHlzZYxjoCjFqr9YWqLkmlJbkrvVpRHoj/s2svnntJ8dFx+dky32x5MEyCZ8PO5Q6jHS1wRBEdGr81fe5tYy31ANC7WTQf4ZuugtJe/AdSfooHsi0FW8h1Ctk5gWFc/HAU8PMcDuR2gyj82O9blyw6ETFK/HHL/dcL4PgC7+d/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327940; c=relaxed/simple;
	bh=YAZqMQEjp+RIQa74BrdAjUtijTeCMK6rqRFlCEJVHas=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGScTm8NWcPdIm5vx1mYKu91XvT+SyGLVEDCh0/WxGDtl+rpbxJA+zYqpX/DoRJIjPuaIM3h6K1JPgYwEcUfpaqEQDEV0elKT8yfMjte0VADGlMZbjo/WrjyS5z/fmDY+A4GbTvfH/fsAHsN8iz+1eQm8sALLQUhtBcQCP+eCTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7eX+tQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7eX+tQd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 701441F000E9;
	Wed,  2 Sep 2026 05:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327939;
	bh=jLyAWG45kl7ubmNjbUc+8nWqmKwTYV35mx52h//sHCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=P7eX+tQd6U8g5cozHtMEK0WSda+dwND3CgI/ehf3UxzCnVPWJwgSvYHFe0l7NkCeX
	 8MiQX5ojNxLr64r9iMp414RvHPaiDvNX//loJqpAME515fFctQMc4U96rzAbsbBjzR
	 Gg4ehyQ1sCTi/8G5RUVr7rudHPvpxZqg1btbcywvIfgSbSUUyO1iKGxILdtJ48nqrD
	 CO7QPtV6/RjBNKvhEFGuM2NkDNg05TVtHAYUFJenjLaewX4vx+NIXDLZ5EYQdBq7PD
	 PSQ1db5bfah6WGVeSSTWisBJbLExmnwCvUNXZsfoF+aEaCw56uvI4r1d4hqDs01/Fs
	 IdROVTdQjiUzg==
Date: Tue, 01 Sep 2026 22:45:39 -0700
Subject: [PATCH 3/6] xfs: log the tempip after we convert it to extents format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749898.3507493.79092786251830198.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
References: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xrep_symlink_swap_prep converts sc->tempip to an
extents format file prior to the atomic swap, but incorrectly logs
sc->ip immediately afterwards.  Fix that, and the other problem that
we're supposed to tell xfs_trans_log_inode what to log and don't.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 91c86ea0e0f155..18196136423336 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -291,7 +291,7 @@ xrep_symlink_swap_prep(
 		if (error)
 			return error;
 
-		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->tempip, logflags);
 
 		error = xfs_defer_finish(&sc->tp);
 		if (error)

