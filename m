Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C2F1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990953; cv=none; b=GFi0NWcsVSOhd8F9OIsFw+0by6B24eYNxbPKIsYpimk2IMTlN/4wymR3WFG1f0zxyubIkFOMEcw21vwVGWNyvazOzvdFk3JEp2DqfbNZCHJ2nIpnLawVQG7h2OpYdI1AX7hCPrL5RIbM0KW2HaGXijMJrdx5NaMMrI1ZSvU/iZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990953; c=relaxed/simple;
	bh=ccLIe5fRGu6J+3J+uLeO+yiC5qI/xj3fSQufACj8K0c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbIvolU2yRt5PANYo5UYJUeyATV41uTnbBVQz/VU+4v8P+BEgQJO/V2lv3wDpVdoiq38X8QJVK+oH89z2ioUTc2jxj4EFN+2w/GmPUdGkiB8sZpIdOtHIr0etbQAvBEGlhvPomGM9DwfCX8YHrHI5B925/MlTvAJoB1okKXyWEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k27kFii7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k27kFii7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD945C4CED3;
	Mon, 23 Dec 2024 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990952;
	bh=ccLIe5fRGu6J+3J+uLeO+yiC5qI/xj3fSQufACj8K0c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k27kFii7+56lLU55J5T3l4nvBhflAq9A3RfS7cK9b+FZjnhsQ1WvQQVMS2m+aNBcG
	 3n/PTp5J6uhQFBYL6pLZvAu1zuwLoosN7VuHFRARfXCrq6UJ2EI6TJCYoysHQmwAZt
	 UtTzYRtZyTZyoyoUWinIYFHqrzamjDJvU19PjfWWZCFdteA+ZXQhuaAbeZ+MkjhMfK
	 5gefCpMp081TnMNhytkukA9dnljFrjOdx87OirrFEj2qOyoY0CydJz0UPX7NQN5zYE
	 8uTkLwOY5AC1r/uX/qGwE9R0wwq+z70EHYXkR9ussLfHG8bEdTq+dIucMbvPsDe3+P
	 piHXLIPSZ8f1w==
Date: Mon, 23 Dec 2024 13:55:52 -0800
Subject: [PATCH 36/41] xfs_repair: metadata dirs are never plausible root dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941520.2294268.381012865092926549.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Metadata directories are never candidates to be the root of the
user-accessible directory tree.  Update has_plausible_rootdir to ignore
them all, as well as detecting the case where the superblock incorrectly
thinks both trees have the same root.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/xfs_repair.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 70cab1ad852a21..30b014898c3203 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -546,9 +546,15 @@ has_plausible_rootdir(
 	int			error;
 	bool			ret = false;
 
+	if (xfs_has_metadir(mp) &&
+	    mp->m_sb.sb_rootino == mp->m_sb.sb_metadirino)
+		goto out;
+
 	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
 	if (error)
 		goto out;
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
 	if (!S_ISDIR(VFS_I(ip)->i_mode))
 		goto out_rele;
 

