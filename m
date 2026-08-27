Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9033E29C328;
	Thu, 27 Aug 2026 05:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808687; cv=none; b=SK9aS9CBSKmbtxmmkfUfT5A91ToTbVJyx+je+0ounkKcFGAl9/SWolOE4CE8QDpEVLR38k7iZ+L9CXx/f4GP06e4Rz+R6nN87GU5ydxEYTrByYQwqsLgrzyxcanxoTdVZpGgN46tIh4OGrxYhVgjpTffEDOaHBicUxQieAjBaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808687; c=relaxed/simple;
	bh=Nfv7bnmhgi2tVHb1Nzyi4a2Q/NrKE9F/4vzDjNDpsBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSGQL3RJ4FvmPbtwPNoV4eqi8jw5WNU2z56HtUJJ78h0A/EGwhx2b2SFe9e3/s/8w0uC0qFV4skzGUQwwJ03FZSgP/EdqepyrXAKA66z3qA9u046eOoCgRiBoAeIFpdyo9qmydwO3xFtCV3nq4BNmqy32yV+oI4zxsS7qZEA9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EL/RwFIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EL/RwFIR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2C3D71F000E9;
	Thu, 27 Aug 2026 05:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808686;
	bh=u2k2DVYfnGN/gm+XReqh0glrSTeFW3fm5Idk/JpomSI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EL/RwFIRfrDUVEOScc6t/uCwS/r1D1drTTYnDZCwc3r1FHtHkvMtTVxj9xjYSdM+J
	 WMLiHnhT5epEXMp8uXElW/5iK+EjGEaEf7sWgfVbYS0LRJWL9048pNidJ7DsDt7mCi
	 R42lbmKTUtFqPwot8PFQAuR5mtB19FvHY5PVALLOziBK91DRfLIidG5qDDOWNy+mLu
	 jhBLc9YziT1w5fStzpBp2ZDfN92J8k+5UjmXin9OHXn4//0Ow7LJ/FqxO1ltB6AuW3
	 xgaoGcSAZAk+o2PL99rHknuaI0MrSqw6L/ZjX7CE94ZL69LCymDQsBUpn6mz7QdPJw
	 E81XnscdKPNLQ==
Date: Wed, 26 Aug 2026 22:31:25 -0700
Subject: [PATCH 2/6] xfs: don't stash removename operations with unknown ftype
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640218.3528187.5597703740652569129.stgit@frogsfrogsfrogs>
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

LOLLM notices that the behavior of xrep_dir_replay_update changes based
on the ftype recorded in the stashed removename information.  It also
notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
because the regular directory tree update code paths don't need to know
the ftype of the child.

Unfortunately, this results in incorrect link counts, which eventually
trips link count errors in later phases of xfs_scrub, or in xfs_repair.
Fix this by creating a second xfs_name with the type set correctly.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 0c1224d05d579a..31a23c5f386ae6 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1381,9 +1381,24 @@ xrep_dir_live_update(
 		if (p->delta > 0)
 			error = xrep_dir_stash_createname(rd, p->name,
 					I_INO(p->ip));
-		else
-			error = xrep_dir_stash_removename(rd, p->name,
+		else {
+			/*
+			 * xfs_dentry_to_name in unlink or rename-exchange can
+			 * pass us names with ftype FT_UNKNOWN, but we really
+			 * must know the ftype of the child that is being
+			 * removed so that we can do nlink updates correctly
+			 * without holding inode references.
+			 */
+			struct xfs_name	name = {
+				.name	= p->name->name,
+				.len	= p->name->len,
+				.type	= xfs_mode_to_ftype(
+						VFS_IC(p->ip)->i_mode),
+			};
+
+			error = xrep_dir_stash_removename(rd, &name,
 					I_INO(p->ip));
+		}
 		mutex_unlock(&rd->pscan.lock);
 		if (error)
 			goto out_abort;

