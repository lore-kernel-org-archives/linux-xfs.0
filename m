Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540AEAF6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992172; cv=none; b=THPq56ICNivfVLXw51B7LuorQhLzaLfhDqvhBo75Cd2qzIpZJNPFrZJ6dkYDf4IHSxu2w1Jc+q6/mQiQ/kN0lfVkYzKdEle6fN+pH+0qZIgwXnb9c6OaLIaQP/VCVJDIWSgCO1FqQJx2H8VbZErq6cSczcqLBJaQAdCBxvaO4DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992172; c=relaxed/simple;
	bh=IQEflgmwTkdS0n/TPlu0QU8zII4gFFZXGm64bqJhjR0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8XjyD2LjLqxGqETHvpaWHXbjgxlMqqS3fQ29HVx1/RIw0F9C4rpk/vyWGGGMFoUBMoZB4wIc8zWzW0wiJsIYv1Mir4a3Z2uN75unelhBM//mdwdgSntwbifJuKRiM3l7DRwY/Z7ZWyJzzRWSsyL5fyInuK/wWCz050xuUS7YQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIIjX/DA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIIjX/DA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE87C4CED3;
	Mon, 23 Dec 2024 22:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992172;
	bh=IQEflgmwTkdS0n/TPlu0QU8zII4gFFZXGm64bqJhjR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BIIjX/DAfcgliWpsD5ffNOFb1hjdD9LJspFXCLHHL88U8ff8qYQ59zxgd/+W+pEW3
	 flsM6VvtxzlR6jtqFIMDB6VU3FGaoxPPaLMeg5bPnuZSxiIL3WO26zrKuuonENCisT
	 K9+mmnHg6HSTdLLvp6RWXGuX8nmgdSNcgL/N+2+158RXLbYZZ5VdEuV5+edDSK90NZ
	 RKFKA448JBM30AiQyrnJ2g1QEdBAHyXjqvGIc1Gj2MTH2FvTOwZ1p0cGn6EryyPGex
	 bHuixb1S8cnLYo/ebxxNcRoiSrGnJl9Xz0EpFQsLM5lxtNApzYB/vcD9ntY0HyAuM+
	 zZDyN2LdIneqQ==
Date: Mon, 23 Dec 2024 14:16:11 -0800
Subject: [PATCH 17/51] xfs_repair: improve rtbitmap discrepancy reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944065.2297565.1047635748326194606.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Improve the reporting of discrepancies in the realtime bitmap and
summary files by creating a separate helper function that will pinpoint
the exact (word) locations of mismatches.  This will help developers to
diagnose problems with the rtgroups feature and users to figure out
exactly what's bad in a filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rt.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)


diff --git a/repair/rt.c b/repair/rt.c
index 65d6a713f379d2..a3378ef1dd0af2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -131,6 +131,44 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 	}
 }
 
+static void
+check_rtwords(
+	struct xfs_mount	*mp,
+	const char		*filename,
+	unsigned long long	bno,
+	void			*ondisk,
+	void			*incore)
+{
+	unsigned int		wordcnt = mp->m_blockwsize;
+	union xfs_rtword_raw	*o = ondisk, *i = incore;
+	int			badstart = -1;
+	unsigned int		j;
+
+	if (memcmp(ondisk, incore, wordcnt << XFS_WORDLOG) == 0)
+		return;
+
+	for (j = 0; j < wordcnt; j++, o++, i++) {
+		if (o->old == i->old) {
+			/* Report a range of inconsistency that just ended. */
+			if (badstart >= 0)
+				do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, j - 1, wordcnt);
+			badstart = -1;
+			continue;
+		}
+
+		if (badstart == -1)
+			badstart = j;
+	}
+
+	if (badstart >= 0)
+		do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, wordcnt,
+					wordcnt);
+}
+
 static void
 check_rtfile_contents(
 	struct xfs_mount	*mp,
@@ -203,9 +241,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
-			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
-					filename, (unsigned long long)bno);
+		check_rtwords(mp, filename, bno, bp->b_addr, buf);
 
 		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;

