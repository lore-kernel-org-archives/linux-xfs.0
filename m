Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B680C128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422467; cv=none; b=qoWwUGkCwUJfiweAMVreLgL8LnlffaU5wbrfEopp6CdJ93Epas0A9aBl+sDn0JbE2/4Zze5ra7FqIUbUg3b0Nbjl99fzekpyltNCdfy3g0iGceR5m8JPZS110N34vBw4Kum5je4lV5mETPNa6NFspSMKA7hWS1tp7UEVYyK8bJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422467; c=relaxed/simple;
	bh=rjXl44e7GfDEisxe4SPL4dDGfWeHnDNN6PU+nINk6yE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGNoqFH+27n2jl44XNOtZMHY2sD2X4i1xX/pKKH709LuRXYk+8oLuSaDMrqj70REb4GOeiTgzhqnwLIFQulqA4uZzVQUCgjaLX2Jkh5gdHfh849NhFVIFe7HOR8R1bg3BOFO+MA2FcBq8SjuQck8YLkpYde2g0YVQQou29CR1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/AlsGbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/AlsGbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91746C433F1;
	Tue, 26 Mar 2024 03:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422467;
	bh=rjXl44e7GfDEisxe4SPL4dDGfWeHnDNN6PU+nINk6yE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b/AlsGbL4tpM9yITiTWplV+Cu6ZEf4yLY8k3aTPQtRD3OizDEobuEFbz7AGdhXS1Y
	 i1qVohbYlW6HoE5Q26PYRLmafsMdNNW+drU8jzff19xLSmeKGmYhnysptQrXx5Ypur
	 bnpgUqgn3evhb9HdJsW2Y1Pok/bmhjTugVkTjCKjOi3BwDnHRMvm8ZlBrbkzkIBsON
	 ZzJOtkmATMmVUuLyLrmHRT0/0R4s4yjwUTJ+n8vhUD6Gd2K3Y6/+h8EnGvKVTbt5UQ
	 hBJeM79lwMC+qCTIA8NQqx2ws2JTgIyUewhIJ0XRHDtmrk+VTMjtTjauqcMAPHGWNX
	 JR7VzCSQpgw0Q==
Date: Mon, 25 Mar 2024 20:07:47 -0700
Subject: [PATCH 19/67] xfs: remove unused fields from struct xbtree_ifakeroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127236.2212320.15996549141273268581.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4c8ecd1cfdd01fb727121035014d9f654a30bdf2

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_btree_staging.h |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index f0d2976050ae..5f638f711246 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */

