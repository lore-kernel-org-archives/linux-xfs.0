Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC110F4
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530051; cv=none; b=NJj0SFY46aky4whE3JR2zBwWFG0/C7VaJHQFEaB8zs2iGgstBGmqc9t4JJh1mNYWoZl/Xuz18IVun5VvA2dIg/IbgatJ87reDT1cd+sdaGIDYGMryDdcC9QB2yOBkeUaCE8alHc5mZZKhF3rkBxY2+x/RWfmK2LtDic6kMqfVOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530051; c=relaxed/simple;
	bh=//rDEdmrZscPpIKQa/vrBI9q4K9vJ16StolQFg8vxtE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEbhZDFQ0PE7d/oaiPX0HuBXNwj7beMqhumSoeZpp7XuCZ+eXeDnPqdkqD2c+tv1QKOB+ypWbC9vN42qOKLKDgHbY0KCj8Ohb7bvMhvB96mFGSWZuXUjkCjGC+UdG1UKpucJBNGXGDzYclagbCV4R/BVAVe73mHbzXSnri822KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAaSaQFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAaSaQFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2257C4CED1;
	Sat,  7 Dec 2024 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530051;
	bh=//rDEdmrZscPpIKQa/vrBI9q4K9vJ16StolQFg8vxtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JAaSaQFa/4RmB5x/ltYL+ZPPl6kE941PuJhCUA912jEwKqfhWyC8056p/L6odh9HS
	 MEBVvgzox85J4q1TVFMXsBbkg7KAiRlWJrGmVxRD2xUzwQrra2K2ejUyM2dZVG+BIf
	 1KlDppg+rJyi9eZ0gB+M7olyNzt7OtFy4QaJ2QzGWDL1rHLUol8z5//Z4Lstqi+1hK
	 D0TRg8Fvsv9n7BgZJsmSJjKZkzXRynwUQVcb1f7dyH8XBfvTkoRByPRv9NSHQxprW7
	 R/1E+badJlPuK7SwG9hnVUOIl2mszsffzyqSS0V8eXGXQYn3+pHg2HiRfOBb7dqHQM
	 onlGlbMlq7JXw==
Date: Fri, 06 Dec 2024 16:07:31 -0800
Subject: [PATCH 10/50] libfrog: report rt groups in output
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752098.126362.1262402405604422083.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report realtime group geometry.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 67b4e65713be5b..9c1e9a90eb1f1b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -67,7 +67,8 @@ xfs_report_geom(
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
+"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -82,7 +83,8 @@ xfs_report_geom(
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
-			(unsigned long long)geo->rtextents);
+			(unsigned long long)geo->rtextents,
+		"", geo->rgcount, geo->rgextents);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */

