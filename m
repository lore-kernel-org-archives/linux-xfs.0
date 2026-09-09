Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932FB3A6EEE;
	Wed,  9 Sep 2026 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933799; cv=none; b=nKT0xNcha3ky3JZeQu+txEnVCo8hlys+nQpd2xlG6xEiy/vPE87wsPoUADndgC5XqcJmefxqkx7ALr+t1O0pJD2BETxWkyyQpSNbh4jCxmvYFCZiBx74arqTME1Z/aEwRiUUpoo+6l6cs5iIhVPjQSeo4aQLDCmK7FyLdRoJpkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933799; c=relaxed/simple;
	bh=QeyzStXubWpEiX9MN/4PLAYNn8qOWG7oOxok05oJyao=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=goOESKQyW/xRA4M9m4+CLmq4bRslu33g2sqRlnaQmfALNTY2pA8O3aTRFXjtoOoJMG2WX5nynzoNtzML+W6fNpjInpHFraczTluqWyulMHBjKmdw6au5cTOiKPRmj5xlavRrCM1dmc2fv/cQSUR7Lvv3UVV6Sh0eZ/mt9MXiyLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlK+kfYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlK+kfYg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E70871F00A3D;
	Wed,  9 Sep 2026 06:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933798;
	bh=sefoOM8OOCUXTQW1eri4pGiZ9cyZ000dFXGTiNEzXGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YlK+kfYgJWL9oq0Lx1gqj7S5GqOn+DRotRYC5AQYHj7GijKMUUakz0lLhsQog1cJk
	 I+//DZH+DA75icXBTGH430CBJE3CM2/RfXrG2amhfU/L2+A+LNSY50B8RqxRHiHlTA
	 QAj+/DFyRqJT4v9JyHGEnAbPW0qv7lsjgrpmsLc0sFG7La7yhQ/mLOPm/AW4DSmnXx
	 kWGC4lQOE6gLsPinFQPI+poysIFJd/5ZfKZQB3T4lko+ngbehoYzX3AIwjZQtwnna5
	 CUDVpfpkBWxYqmH3GKRYZj1Ph48vzNmXCj3mYhRW0zbQ8HA1topcWLIWjNg1YwMePi
	 pNZGttQu2dvoA==
Date: Tue, 08 Sep 2026 23:03:17 -0700
Subject: [PATCH 2/6] xfs: report healthy filesystem events in scrub stats
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936226.4057682.3076271094996020602.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also notices that I forgot to expose the "clean bill of health"
scrub stats.  Fix that.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/stats.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index f3f1fbfb6d9955..da0c05ffe5cd0b 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -84,6 +84,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 	[XFS_SCRUB_TYPE_RTREFCBT]	= "rtrefcountbt",
+	[XFS_SCRUB_TYPE_HEALTHY]	= "healthy",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */

