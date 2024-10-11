Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C653B747F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609734; cv=none; b=j5/AfArkO5oUs7at9Dh0ccMuV3RgycdSHxXuKtILXNLlVXmpN8/KQNBkGsYEghlm31ulZU21b08rhU0TLVzCMbAoRPyB19SXAnY38rSqOoRX1CxNEpCRCLnpbsSPaXLdfA+FJy+Ts+LfQBCnuUEqwRhU+31V81owVgmOo3A0cJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609734; c=relaxed/simple;
	bh=tK7zQ2KWQhIq5vGoidnX3/Dj3sGapFHssMUfRhFzfiU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ah3vrtIP/ifJRQqyUgHrwFTT5AcNqjS2i1zjqmMFYkMOT9eod0ofeQ0wIBcj5IhTETlM4+KN12TVeXAzFwhB3fzNS+tEVL+n1Jnz7cC8zO7DLvKqoOhReoiIXm4je/OaROT84cxysCP4ilUjRYnlrn91jB7NpZhtKfmxUsV4784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpB7lQWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpB7lQWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700FCC4CEC5;
	Fri, 11 Oct 2024 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609734;
	bh=tK7zQ2KWQhIq5vGoidnX3/Dj3sGapFHssMUfRhFzfiU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dpB7lQWUMep9xy/SgROcOO7ZDFPoPf5Ofa4PQEk00CG+KadKJSGAWN8rtSYYDsg5M
	 cxe+mGgBvzWOFUThiAjFRpjfMQy6TWZFq7QxfH4c1GDIKfLTLKLjMfgWvuAlL6+VuH
	 /14akv5vnK0NLvkunZaGbm7VFUtJdPaMlu8NQaZISoOKKPThPgHykDxMbr0jdrEtD8
	 70q/SZUzO2rcisNIQrhH0litbHfPb7cSkULTWVnv0YEWDYXwpLjlY5U5qdiiJRH+UC
	 WMO25DdyNqykxA0pOTM45tWIa9tOtG4UgY0tH4wao6HOVoz/MVDNbg2Fs9gS6gSn35
	 Ra0PsqRCMvF9A==
Date: Thu, 10 Oct 2024 18:22:14 -0700
Subject: [PATCH 31/38] xfs_repair: metadata dirs are never plausible root dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654453.4183231.708358800184901452.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Metadata directories are never candidates to be the root of the
user-accessible directory tree.  Update has_plausible_rootdir to ignore
them all, as well as detecting the case where the superblock incorrectly
thinks both trees have the same root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

