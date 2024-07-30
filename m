Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD017D2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301030; cv=none; b=a08iQkgCT9fymCnns+O5ZxcpBa0Sj72y+uOCAiZZbEMXPFZsR5TeNgdTFsWEvmDI4VC00PMYhSN7PWZaSELU5Sf4u+pVKV8gPiIZcMnoRhGouwY9SDmEu2kraCbqgecBV9/k2nLzcFoeuRBh1HRu+b6AO+GesUlqyTYf4mqD0wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301030; c=relaxed/simple;
	bh=14O6FzBbVCjVPnXUHwkhkwEkF1UJNhx+cz8eEW617Qs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wo6Sc42VA7tpki1RTkPE3emdRFs20FMokoXNLPbIFG/Z+YSI5Jg4ZK7tbZrDuaLAcG2OfzdMla/x0MkuQZa+QwwWbHTH1kx+2F4FtFMvW2SrwTtQSCI8txp+J4D4SZKmbjRU5NtL7FtSfnDkW3MteLCPvCXnJfCMeyniHvT77pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yhx2/JgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yhx2/JgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F58AC32786;
	Tue, 30 Jul 2024 00:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301030;
	bh=14O6FzBbVCjVPnXUHwkhkwEkF1UJNhx+cz8eEW617Qs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yhx2/JgAEW9bXuGladAzKNskC8AHWatOIaiI6jC64jfmbndN9FQcKttI1HgluiKkk
	 RO4ySEo2t1RCdu6wakEg19Uc9xIA5v0Lr3KZqiVHlk1tuF/9HMJSopINEmmeMFWwlM
	 2L3Qa25yn8nigIWaAKZyyJ1h5R9jfOAi2Ck31/IhvNFsICZLSPi+E0a8UGdTHcYznd
	 QXMFOeSBzoff+3ogrbKtWxFB8iCQ+klsQ0agppW4BJNBksMpomy6Dtw4wW3H52b+Ah
	 oPEQ+ZYQzT+OP1n0hRB01k5dwvEhG4xhB4RtKFisZGZ3pOj6Tc7LVF548M/4Oueqye
	 Jasb4gcW91oEw==
Date: Mon, 29 Jul 2024 17:57:09 -0700
Subject: [PATCH 1/1] xfs_{db,repair}: add an explicit owner field to
 xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844892.1345343.14694480047115047580.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844879.1345343.7289627876555507553.stgit@frogsfrogsfrogs>
References: <172229844879.1345343.7289627876555507553.stgit@frogsfrogsfrogs>
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

Update these two utilities to set the owner field of the da args
structure prior to calling directory and extended attribute functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/namei.c      |    1 +
 repair/phase6.c |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 6de062161..41ccaa04b 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -447,6 +447,7 @@ listdir(
 	struct xfs_da_args	args = {
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
+		.owner		= dp->i_ino,
 	};
 	int			error;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 1e985e7db..92a58db0d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1401,6 +1401,7 @@ dir2_kill_block(
 	args.trans = tp;
 	args.whichfork = XFS_DATA_FORK;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
 		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
 	else
@@ -1505,6 +1506,7 @@ longform_dir2_entry_check_data(
 	struct xfs_da_args	da = {
 		.dp = ip,
 		.geo = mp->m_dir_geo,
+		.owner = ip->i_ino,
 	};
 
 
@@ -2294,6 +2296,7 @@ longform_dir2_entry_check(
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	fmt = libxfs_dir2_format(&args, &error);
 
 	/* check directory "data" blocks (ie. name/inode pairs) */

