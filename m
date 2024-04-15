Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3D2E852
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225558; cv=none; b=J1cy6UsO8s1XmYfgK4sXmyGQUIqmqe9I1y6Q4KQOsTNK6SycfnRTU1wVS188vcWI/z/2fdTjM4db8Uz6FNd606t5aegQYQxWf8SgQl1Kwj/HlGQDT+ptO4NCMCjvzvxsvVbE+31qSmtH/zLZxwcjtUVxAW85irJSKiSJ6SFfB9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225558; c=relaxed/simple;
	bh=m+xulR3dysgmpUUHIkzQIx4UXc1TWfuPowYAh/T9Ogo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU8izLTip88li9XG9vIFm16AnpyHIPwQrdYXfL2TD/6pNzPs+dii8UEMlwuBazx2yP826YASlCeA1pc9FT6CSTL3qYCYXjFfhbvhJaiCh9df/PG0ojY8IqivEU7SRfeH05YS9vZsKWOjQwIPWkTPfyEWjkrohF3y7e4RYHvVGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwqSdqVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwqSdqVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989E0C113CC;
	Mon, 15 Apr 2024 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225558;
	bh=m+xulR3dysgmpUUHIkzQIx4UXc1TWfuPowYAh/T9Ogo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uwqSdqVUK76zkCHO7pL/M4VdSDXEZfjYOP6+Sr6JcEwC8v/g84mOz/pYTX2pEGXzX
	 xOfEwsCppzkB89FXh0sea6GkWAGg/KWJlBjSu5ffCTNkbGMn6UBuIGlfYfT9PRHfUn
	 JvX545MNXQFccNKNX2261MulQMemonq0Bt/e/JotBlnBANcLzBsUXXFRJGZZxtfVYj
	 BRCOS4lrKo7Zy1m39atUL3+DSNRkx72KJ64NYr/sTgPjoxatlZq9o05+CK6QwjHb8y
	 VowdN+JXe1Xbq9xr/lEPv/H9+6bjovJHkQeKnioxQxCjRDEVUZK6j+CFce76jHy/oK
	 Xd6dzRq396zBQ==
Date: Mon, 15 Apr 2024 16:59:17 -0700
Subject: [PATCH 7/7] xfs: unlock new repair tempfiles after creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171322386630.92087.7506240104067387040.stgit@frogsfrogsfrogs>
In-Reply-To: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
References: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
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

After creation, drop the ILOCK on temporary files that have been created
to stage a repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/tempfile.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index c72e447eb8ec..6f39504a216e 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -153,6 +153,7 @@ xrep_tempfile_create(
 	xfs_qm_dqrele(pdqp);
 
 	/* Finish setting up the incore / vfs context. */
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 	xfs_setup_iops(sc->tempip);
 	xfs_finish_inode_setup(sc->tempip);
 
@@ -168,6 +169,7 @@ xrep_tempfile_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (sc->tempip) {
+		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
 	}

