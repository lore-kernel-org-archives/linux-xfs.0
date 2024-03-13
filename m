Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77834B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295080; cv=none; b=pLwUoK4TPknTMgsspKXXMfsvQfHYYPn7VmAJpzpUUZGwlxkMZfITtz0JYf8VGOyTRJK02LsbX8HVTWMvAc85mQyY5pBU8YElwbvFoYQoFnU5GFCiPGF3NWWMeYa2SqnCUcKGO9d7gtzP4R8+PHYG7cEnJ44veDk0WtUi/wqdYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295080; c=relaxed/simple;
	bh=aBdg5Y2A6KNGas+M+i63ch27M76w/i1Bkgt+IYLn+LQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDg5CH8Wj2sekUU5u4Yh6ZD+woi90P6vxppQt1150c6SlgchkHeHXESDzEQXlrVIAwr0sy2NqgCZNtsIdM4cUGpRBTZa6AD+TKA1e9h6HMd2ViajD+rVvnUbnThwAiDayRNWR1ytIItn0VDhLmNRrIfKDX59l78oY67bnTpWPKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHhN82aD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHhN82aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A7BC433F1;
	Wed, 13 Mar 2024 01:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295080;
	bh=aBdg5Y2A6KNGas+M+i63ch27M76w/i1Bkgt+IYLn+LQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QHhN82aDx4vSITyi2mBKHHXR9NTbzmpZelYzuoqBFdmbVvq+AVLg498W9n2yFBzGN
	 OfZsakRUqtTr+sZrttp+49oUp52C5iElisHXitJWjIyl9HBvC1Lpr2vmdcF2iBlh7M
	 RDt+6WhKwdpCQug08Gggvq5YKEojTXoiGphgH6K6KcKpTSCaO54+Hv3B0LPVq0ZK38
	 Q7hmlwosTqCS5T2Sw3SRVDAFY440PL9U1YZWUyenyLom0kSRjoD+kICvof7pU/6GxS
	 uRCBsehe1PkD0B/MVhmW6Ok98q1vMSOPhIutiz7Ll+BxuKbXVpmf5pXysppJ7r9vPu
	 yNvHz9Qw1NPHA==
Date: Tue, 12 Mar 2024 18:57:59 -0700
Subject: [PATCH 19/67] xfs: remove unused fields from struct xbtree_ifakeroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171029431468.2061787.8852752644725960285.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

