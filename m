Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A49B332EDE;
	Wed,  2 Sep 2026 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327925; cv=none; b=FbEbrITqy11RHiL1WLVtdqLvS+S60NAJXAgpwxqpHdyoA7FDxZdfk78IT8nzqEbGTnfMpyr5tu7xOoOObwTvq5FEPmZc9zQnTZUNvO5J7uhDqdHqHIvPFEPfygt+2A8vyMW3C/Z63sBpGxy6GW4mizafoRxcxe1xZSSg2xspmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327925; c=relaxed/simple;
	bh=Nfv7bnmhgi2tVHb1Nzyi4a2Q/NrKE9F/4vzDjNDpsBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVAxU9IEben131N/0zF3dsW5lSA7fLbIsotHa/fo7lUVTeFxVWM9QQ6Rh2H54vSEEBPjyuUkBLEvtzYtAG3sqTymSiClTHth9/gzZEufT+cJluAY1z1gsG4J1XDlk94QLu1fphPjMJu66GGAFaNJp2PkwlJPIlnirqhCSRnaLIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAhGk+BW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAhGk+BW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E710C1F000E9;
	Wed,  2 Sep 2026 05:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327924;
	bh=u2k2DVYfnGN/gm+XReqh0glrSTeFW3fm5Idk/JpomSI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hAhGk+BWBljIPlNv38wFRr44YWYa2nJtnhum6wjV1oo23C2A/FlZX4ysQn1mPZknZ
	 BciC4bihPgfUy+G8uKPF2n/85CXvlUDKXYqVo7d09MmNl/j16XAnf86+JkVAJBgjrh
	 b7iKzVDmLUmcg9cfqe52i5baorow5nTwu/D9YaFEZtt6VmIOyhunYAE4fitQZmfAlb
	 f2yUUsrdmpfSvdxRyG+9s0a0kWWarpQ2k0W8pDyAjKKfxyGiT6VqbKqffDIJsBy2MS
	 7wWLhJz7VQY1I6dLXC5RENLYKFvQ7Lp0esCw+PTX7D/AzWcCvsr7hnBnh1BlCxAt9J
	 P81Z9K6HBpeCQ==
Date: Tue, 01 Sep 2026 22:45:23 -0700
Subject: [PATCH 2/6] xfs: don't stash removename operations with unknown ftype
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749877.3507493.17018012854618133643.stgit@frogsfrogsfrogs>
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

