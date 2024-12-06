Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C851F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528911; cv=none; b=jYvDUimodtHM5+/pRCes5lJ8h8xUeTGLI20OqR++tzMMnOnK+5AXATlPTZEyHny8xuRZuuIxz3fnF0PNX4pdTueB9RWp2CB+WuC7sH89wEP3QF8K8qYUEGMUXfhTBOstPFwfCS4WdHarmNg+3UhoseISWoc2EW3TumJjE/LB2qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528911; c=relaxed/simple;
	bh=U0xNar/9dHFHgN6epq09cPXaYm90nXz00NLyuKkwW20=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APrtieC+tn2P/yRqE7zWWWxq5GEo/+MfX+sgph60QEKkq+9aW5WFofGuStQWubwRLRCuaxKGwmlSxdW9VYfaVtJdysxHedETf2+pmG+C+7utazS+IC6lFdgTqbX06TO9OISKsUYTYd8j0Emd4jxq6uAkKkof0m0Jdll8xoo0ajo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXPe1izR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXPe1izR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE871C4CED1;
	Fri,  6 Dec 2024 23:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528911;
	bh=U0xNar/9dHFHgN6epq09cPXaYm90nXz00NLyuKkwW20=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mXPe1izRCL5n0D5wB0LWKr3bhW4Z9V3aTeroREtib+oTytX3DbXX2exImrgd88flb
	 X8vcI5FwCLcWbS1/cwHY3TIxXtPVgWmF71yLxKBXS4YBUv3MYwoYaOcnCZKt177i+B
	 Ozh9/rz0qs/w1Y1tdfnBFrd/IEbwauRSrg32qSLANi2EWwkPbpiJe2ern6ftFMsqMN
	 kMFyA8yKwfyGAbaGVsFEMHkJkRMXGbiyGIOioAhKyK0y9u8pUWhO/A+f99uv70Y000
	 PBej39tU6rML8FV94SO7rBxoA7fossEmJeNA87aHnW+i0XPSoap3hwah2hE6vB75iS
	 hM+k9GijFmGQQ==
Date: Fri, 06 Dec 2024 15:48:30 -0800
Subject: [PATCH 34/41] xfs_repair: adjust keep_fsinos to handle metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748756.122992.15190773572152273320.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In keep_fsinos, mark the root of the metadata directory tree as inuse.
The realtime bitmap and summary files still come after the root
directories, so this is a fairly simple change to the loop test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase5.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 86b1f681a72bb8..a5e19998b97061 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -419,13 +419,18 @@ static void
 keep_fsinos(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	int			i;
+	unsigned int		inuse = xfs_rootrec_inodes_inuse(mp), i;
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
-	for (i = 0; i < 3; i++)
+	for (i = 0; i < inuse; i++) {
 		set_inode_used(irec, i);
+
+		/* Everything after the root dir is metadata */
+		if (i)
+			set_inode_is_meta(irec, i);
+	}
 }
 
 static void

