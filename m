Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6452443D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300514; cv=none; b=fUWS/iRPbFZJE5h3nGhb4CMdVX6AwzHMLsJvMdgWxPajBv9gX+WQU6ASowHa8s0iYM22SzzZtWo7qeE/HboaNW4mrx4RIkgB1J7Esa7cT/QuemryMsqzgelW9wmX5ZQqC7hHf3MgOZG3w1Elw5v2h4utmRUEtFWL7lCdC+muVsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300514; c=relaxed/simple;
	bh=VkAJQt8TZvYkua759XFgLO0Z7h3lmP+DXLPmwTJeJg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7cY+wsjtiblvQHrCOdPKIeg86hxzzlcuP2fSibSI9sTkrDhmJ8JYgqW6sraX4e4GtDfElPT6HOuv4VnIc0dAjEVY04pvF1DSJ5Ty2sTxDkHexBM3+uPH3Z37He/3uJg2k1RXwEPgK7Oe08MosI9dtCs/GrVW8z9QswOMDPmarc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqC59XrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqC59XrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F48C32786;
	Tue, 30 Jul 2024 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300513;
	bh=VkAJQt8TZvYkua759XFgLO0Z7h3lmP+DXLPmwTJeJg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TqC59XrVH1rdD8nMqZz0S5HpHqz03HysN6rPUWlt9uJroabBf4S+hKNA16L21fqRY
	 k3lFSc56f2XebKPIKCwGr66bce35Us4rnHyyUBDZ5IMQfgFPtkqplz++Sb1P0D5Sk5
	 qkau7t1kWUfdaKxcF6ekl6CLaZdoGqsgoY/Bm1RRTNfTmE790nIKwXYdYGFfmMKDCc
	 dv4AX2QTuU+K56LU8rhj2mhRs3SxlXpCaPOe9yEdSHKYjgxJYJ51r4ztfjKCEL1Myi
	 Y2gHrPj+BZuejtFRWWgjPmMBWMNBn94exVjAg4MfaoxEQsxorkLsmvZlb/M/XsJQII
	 52mJuxlhbpPwA==
Date: Mon, 29 Jul 2024 17:48:33 -0700
Subject: [PATCH 095/115] xfs: remove the unusued tmp_logflags variable in
 xfs_bmapi_allocate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843802.1338752.18010593215932240102.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b11ed354c9f725ece2b9440dd6343b42cd5d031c

tmp_logflags is initialized to 0 and then ORed into bma->logflags, which
isn't actually doing anything.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 84760c889..f236e40d1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4176,7 +4176,6 @@ xfs_bmapi_allocate(
 	struct xfs_mount	*mp = bma->ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
-	int			tmp_logflags = 0;
 	int			error;
 
 	ASSERT(bma->length > 0);
@@ -4247,8 +4246,6 @@ xfs_bmapi_allocate(
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
 				&bma->logflags, bma->flags);
-
-	bma->logflags |= tmp_logflags;
 	if (error)
 		return error;
 

