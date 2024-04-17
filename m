Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BE41E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389925; cv=none; b=U1f8RS+W5STj7SEAu3j1fgHFqy6oj9YEN+CzjwB3GFtSSPsOLyf0UCHZtUjdUPCChqkBEn+/eLk2FtlU5WfDt4ZlWRSt5gW+81xLwEMJg/zVHUKlDegI/zsehpSLSxaQcaUmmpf/EE81FRsWPWHBWqAAoGUehd7KzKuZTlLZk64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389925; c=relaxed/simple;
	bh=H7fSyNN7tytdqPRm1PNx9BIuUS5Yb9HJQB5J4BFsPzc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceXLJZSv5m8LVex3FdIylw33BxzTof19UuT7m58lYB+z7CfXZs39LP44g2heu9zuMOO3qG5MP6UVzaF9RP8lEI791E9RVnBPXnozo2p/r8vwy9I8umrMEy8a+1intYlkkUiEsvV+1x/N62sII/W7kuVPmZjHALT6tdwx2zOo2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCKy4/bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCKy4/bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5756C072AA;
	Wed, 17 Apr 2024 21:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389924;
	bh=H7fSyNN7tytdqPRm1PNx9BIuUS5Yb9HJQB5J4BFsPzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TCKy4/bvjvtRgxah0zZbHA5uggL0BSmKxWc+QvtKq8MUxdhivelW9eylO7fXe3Bij
	 HChBPdbT4c24aajTmUG+UpVryFkvrHJsd4gU+iiBkhdAxKaNPmHgKoYyyveFfSM5I2
	 gTcAUxS5eBikPYv63rwfhkkcg4dtrTZZmj1GdvrrDJowWd66uFp+fgoQFSasmSLhZB
	 wl4VVlT7TOgVdOvZgde+nqW9cLzlvx23ZBq7KdA4HOrHVjrtPa9VSWL4tVkpc+E/Qh
	 IiEIckBvEtRjNj3pW4ObjQdPJWsy0kdAE78dS9MM0srIoOC6AoZk3L3NrADFNW9FIa
	 YSyhQiOz9xCgg==
Date: Wed, 17 Apr 2024 14:38:44 -0700
Subject: [PATCH 65/67] xfs: fix backwards logic in xfs_bmap_alloc_account
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843315.1853449.14622932159434895277.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: d61b40bf15ce453f3aa71f6b423938e239e7f8f8

We're only allocating from the realtime device if the inode is marked
for realtime and we're /not/ allocating into the attr fork.

Fixes: 58643460546d ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e6a5e1f3..494994d36 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3271,7 +3271,7 @@ xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
 	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
-					(ap->flags & XFS_BMAPI_ATTRFORK);
+					!(ap->flags & XFS_BMAPI_ATTRFORK);
 	uint			fld;
 
 	if (ap->flags & XFS_BMAPI_COWFORK) {

