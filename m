Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29529C328;
	Thu, 27 Aug 2026 05:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808703; cv=none; b=lNWH8aPLcs+Osl3K9vtc1tY2uArhDPoic/CW0jkSM6oBXZWK96IKNxMwX6LHGjLbSV7X0I0xa41ZX832TsrQ5UEXWKKBnkysK/HxeLT4ny4Fuvm6Nc53UoXPbBRruH3Z9X8FrXzndKwB0k1aGmQD1acXo3U50BrPxjWUlkyoC7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808703; c=relaxed/simple;
	bh=YAZqMQEjp+RIQa74BrdAjUtijTeCMK6rqRFlCEJVHas=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNQt+9lQjouARYRudtp4uEUh5jwRv/1TqxGa306s5OtZkMYvoQCinvq2o58Zn0dt1j1iuh1PKb+fXrK/qOYuTOdEN/mv0uyxsx/MSpN433OAsTO1jje/EJhdQxu6Dqlhy57fjVuN2arnxJEh9VPBnmoZlXR8anT8jXoYbygCf+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqVM4+t9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqVM4+t9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AF47B1F000E9;
	Thu, 27 Aug 2026 05:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808701;
	bh=jLyAWG45kl7ubmNjbUc+8nWqmKwTYV35mx52h//sHCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WqVM4+t9DvXagwvq7zMw2gTqB/DULvKvQe/9W8NSDlZ+Lw743m/kCfCij1/RN5tmG
	 9VaJz2nJ6UMJFhVRDFbMs+eqy6M2x/MSm/UDe0Sx45ee+sw4cRbLJsWGjlcLsvI59/
	 BwsCG8KJhm8yH9Z6qgEwWVTRjRoF/SzFGC7pLHeezz3IvIN2v43i2Df7Mi3ivfjPby
	 zeZ0cnC4houSkZELHyetUoqd3zUHGHanJAaXUOXdGNLMe1iBaQSOApx2iXCffgGs4Y
	 tb8DlP1RCti7n+nioP0tpdDadvfN9h2Elri7bIRk74YDKpuaMuzGMwuNomaGNAHSR1
	 m1QoLeqPDz7tQ==
Date: Wed, 26 Aug 2026 22:31:41 -0700
Subject: [PATCH 3/6] xfs: log the tempip after we convert it to extents format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640239.3528187.10915321092873575823.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
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

