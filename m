Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AEAEACE
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608079; cv=none; b=dZH8gQ0I608n6Y7oYUvHnVnwcJW61LSVSZky2WOUTMoVGJYs4XSwWyZMetlMN5gCWIeIOkUPRoDnemujZxRpLvLSwFjIR2Ub8eTHeB2w3Ln01dgrNA3jHV2fUg6JWkL26d5e/qWBcsGBcf9nFaUSSwGqBECi//T7nsPbgAWMgzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608079; c=relaxed/simple;
	bh=7oBn8ZFHkGZqgFJPNiX1+2w+kAS2jmPjpJOOY8PHIls=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtH2GvAwlNvlqU/hQKnAJi1l6qWNP4dP5BLbfYTEwOf5lTQ2ntdYdUsnpUyLJYQ/LvKHD5pgC6kWiKqvSv89v9J0vXjud6lInl05iwr7FgAPgxYCS17rzoibFoRROPqk/J1R3fV+R6FcKsFKwj7LjYK0yKLHrMq23SChnOrF1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4RaTaEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4RaTaEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4961CC4CEC5;
	Fri, 11 Oct 2024 00:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608079;
	bh=7oBn8ZFHkGZqgFJPNiX1+2w+kAS2jmPjpJOOY8PHIls=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a4RaTaEQKyUrvmVEMxPWN1zC25oIlKf3v+5vr72qSQpONM2lkzvrP+/nL5U+M5JoI
	 gBz7Ii/6fUnS8JLmzHyml5Zh3h/Rg9Lhm0h2PBWW9mh+xxRRlED4ZQUzXCrbhSulHI
	 PjfHIizMf5TZOumFwKrXPKefDCv84t0/6K6n5LX/m8njTUVQ9c0d/3pvvqk0EO3RQ9
	 FrvRmmY2XX1p3/BRCMGu++NyupMh9WaDiPxlz/FPErduKjuOD5vFkI/isn/nVONIag
	 PLzV83DBGcX8e2yFjV1o5KUgmkw5juoQ0nZBmFbEShcNuV4lG+sxgy3+qu4gnU+rKx
	 NhR4glPUKiJCg==
Date: Thu, 10 Oct 2024 17:54:38 -0700
Subject: [PATCH 24/28] xfs: check the metadata directory inumber in
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642430.4176876.1225567151184956369.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

When metadata directories are enabled, make sure that the secondary
superblocks point to the metadata directory.  This isn't strictly
required because the secondaries are only used to recover damaged
filesystems, and the metadir root inumber is fixed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 0d50bb0289654a..a9ab6da20e9c8b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -144,6 +144,11 @@ xchk_superblock(
 	if (sb->sb_rootino != cpu_to_be64(mp->m_sb.sb_rootino))
 		xchk_block_set_preen(sc, bp);
 
+	if (xfs_has_metadir(sc->mp)) {
+		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
+			xchk_block_set_preen(sc, bp);
+	}
+
 	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
 		xchk_block_set_preen(sc, bp);
 

