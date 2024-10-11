Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464641119A;
	Fri, 11 Oct 2024 00:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608001; cv=none; b=TyPURoDESuTqQcKsB/uXhjq4OJo33c9erqMzZ32XGTWrYrS9/s6aTiyaNM6Q7F+jdwTp93mTml3nZy9U4uN1lgCCzkn4PMa1oFM7RWw3ptWzB7zfxlsYkS6ongqoJCa/trjzpk0D+wAZ9QQobhCKRMCfjbMHY559dlXLSZ5DmgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608001; c=relaxed/simple;
	bh=3xCmm/ozmDl6ayamaN5IqbYaI43YKYhBeLikoP0M3yk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzmLZbXKhONdwmb/wGKLgm6wwL4EfjtVWbt/xe+/mMG/qy+TvFgpw0RxwRYzUmBlCROC0k8CwUMZe4dejBvTRo7epaHLkrqJYqMjfgUsYzMIukHRd6fH9UnxQKJDYwXMQCVy/agk/uU6hMUpNTgHOQUENtBba9Bt1Q/L/cdriSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dk0bQitI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dk0bQitI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2276AC4CEC6;
	Fri, 11 Oct 2024 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608001;
	bh=3xCmm/ozmDl6ayamaN5IqbYaI43YKYhBeLikoP0M3yk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dk0bQitIa6RWEpKfqx1Ke+3pcwYZO3CQv//QlV3KX5rAbr37HEt0ZW+qdoPJI75p+
	 yZhUnkNXhowT5sNT83YAKzxvdBC2PEd7n+bhNR7EKWrCKHp9rneorT1qVwZEwNxUDQ
	 AzjWiL3Utn/3VFTuQHAYQCF/6Zj8pQ3ILfWYUayOcn5hUPte1M13abYcvqKEXlNyRA
	 GhQA1pyYono8w4FO4UJKMR9FczzvamSU5hBpITLfezgkGUBNub41V2LZkzMRtc46Rl
	 Xi9jzbSNIw0vf53Vbxf8XlC32+6oaCqVee4A+rI7fPbD0RbmIuoabKAeG0A2wBajMG
	 S2OVBc+STu6cA==
Date: Thu, 10 Oct 2024 17:53:20 -0700
Subject: [PATCH 19/28] xfs: don't fail repairs on metadata files with no attr
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642345.4176876.11684206292592860343.stgit@frogsfrogsfrogs>
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

Fix a minor bug where we fail repairs on metadata files that do not have
attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3b4f6c207576a6..646ac8ade88d0b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1083,9 +1083,11 @@ xrep_metadata_inode_forks(
 		return error;
 
 	/* Make sure the attr fork looks ok before we delete it. */
-	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
-	if (error)
-		return error;
+	if (xfs_inode_hasattr(sc->ip)) {
+		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error)
+			return error;
+	}
 
 	/* Clear the reflink flag since metadata never shares. */
 	if (xfs_is_reflink_inode(sc->ip)) {

