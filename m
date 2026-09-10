Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF08D30EF63;
	Thu, 10 Sep 2026 06:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020033; cv=none; b=Dk/CJI0bioA7hqeI28eNr40n/ag1PKskO6RR040w1D34Ou9u1X/RRBdMdOKUrCog9V4zIME79qYN9205fJ6PyhmaMr6+TNv18Gp4hIQlyM4NLfBJiIS/t4dPeTATBr8QDaeFTGFGhoMpHssdRCOr0aRqHmUar3ejvzVcJSaXpqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020033; c=relaxed/simple;
	bh=v+sJ3ypw2UlLWJ3aDrJOhnexULXyMT7OgZ1YwD3efik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1Z80olxcdORxT0yC+MSHnJ+wteScA4Kqa99Uv75S9lyReOLaCRKwmrk/c9NuiVBow5Y3oChZA06k/4Gs+BOdzr947KraFpzBoiCLTHUPyncgzlxNlK1w7SQ0f/4CX+8wrtQCrmTLgJYeU61kt9x+3bTkK8b4fBw2EozqLYIevc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCDnWdkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCDnWdkF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4760E1F00898;
	Thu, 10 Sep 2026 06:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020032;
	bh=QczdJq0luOE4/Ur1cX1yl8WUldE12FuCNL2He82Bmg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mCDnWdkFX9t9ezD95MWz8eo2QcAesT15QFls5BmhNSzF0qiXdwAeqRr4mVQnJAL7p
	 et0nU3k3QIs3+MEkPapxqKSxAVPwShX5GSlV6bjsVBfhIgaOhGPZAVzIbI7fknak9r
	 Na7RyI1RCPTAlC65u12cvlXg2vAUNrS0lgkxr6OXpD5FBRJDY8XkAtX1jhy3fbhaAz
	 R05g2N2twq67DrGkiZrEUuPXWEmhdrkyZKPtmoFMFJqkasAyvtfwOvJDKmvDwHxVMe
	 2wN3q3Y0Rugoz44vVsAD5fKLXdcGo2b5QFw9FMMkCcz889skN9dH5Ry7ZHx/LkzcOc
	 7om+UOVDfxcog==
Date: Wed, 09 Sep 2026 23:00:31 -0700
Subject: [PATCH 3/6] xfs: fix attr fork block count checks in
 xrep_inode_blockcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178901989892.361651.4678916214576712344.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that a file has an attr fork, it will call
xchk_inode_count_blocks to set @ablocks to the number of fsblocks mapped
by the attr fork; but then it'll compare @blocks (aka the count of
fsblocks mapped by the data fork).  We already checked that and we never
do anything with @acount, so I think this is clearly a bug.  Fix the
comparison.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8bc508336aa5f4..b87c2214623383 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1702,7 +1702,7 @@ xrep_inode_blockcounts(
 				&acount);
 		if (error)
 			return error;
-		if (count >= sc->mp->m_sb.sb_dblocks)
+		if (acount >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
 				nextents);

