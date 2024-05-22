Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480822B9C2
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346361; cv=none; b=GH1Uu/epyMri/NOqy0u5b5G9C/SmXjl2MXhzu5U8mVbA/2HxxvL9yox5l3X6EiTXogUuvvhgDA7FBHvWIkw2suNIupuGfIRNM2fOOEhH3d/J9fn4WOG2022qPNSt5fjWzFyA/jHMJ0f71ayzb/cDpXwbevHU7y97Nc+X1beAEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346361; c=relaxed/simple;
	bh=LGMixZEJeeLoC3ISITeQsq9Mohc9qaqNUzouQ3q2yx8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlCco6zbQ2a2g42Uy25u66SOK/Ha/uxb3M+Eu+goa5cE3eLolDxeIMvjanahJi8G3eAGJwvxfXWEyJ9umCwPrtWVjwWa7fHGkluKcm+YSGRX4d9jGxI5p4m1YQUb2KcIsV3TO3WGazT2XzelXgOmg4s2nqKpK6RXgAXD0EyImsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoJgJhqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoJgJhqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC32C2BD11;
	Wed, 22 May 2024 02:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346361;
	bh=LGMixZEJeeLoC3ISITeQsq9Mohc9qaqNUzouQ3q2yx8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YoJgJhqPHYbJ2ctmzaFn3mMU/amVmZNfc7aH2oldKvnDp0ess6NgX3QrXquRjB1SK
	 Q39dhkMjRYj92I1gpzx1T/6Inh+vWLUgXRrrFqoNkT1dan3nRDkITh6tyNZvyW8/xV
	 5XX9Ct3XHmY/ohdllCXmUI0tmD0+YRLYfgxs+jm2d4Icm36sHBssAi7jjgS9sNygeN
	 h2WTveEG7279rYPnoDm1WnIrq9PYK1oUw15c9xcQ9pBF17b4VCfyACAISrJ7NWibxP
	 Lf+RG7q7g1QT/l5UmC+2WAmmYLijB97VlwfWTLSwWO+fbeUBdUUBGIFm12qb7znSHS
	 rukwL2vMH5PBg==
Date: Tue, 21 May 2024 19:52:40 -0700
Subject: [PATCH 015/111] xfs: teach scrub to check file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531936.2478931.5754798847297076403.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: f1184081ac97625d30c59851944f4c59ae7ddc2b

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f10d0aa0e..515cd27d3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -712,9 +712,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
+#define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

