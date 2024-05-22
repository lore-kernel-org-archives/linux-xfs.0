Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AA11E4A2
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346549; cv=none; b=e94RDpmMSlKkSI4Wica2jTXHhZUUaNy5CC+Aoad1C4hPijSvvj9FNNeunjCvcxGe7mzBglcZ7GWiutYU8ruxHA7Ln2Nqoj45iJrrxYtTdTEIgVbDRkDOqmgJhq3u6P+89b9BMqROS8+HZbSXohA20e6ID8tF0TXurcLONRPY4Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346549; c=relaxed/simple;
	bh=WcxyOnWaRyWEvwikXgmFoA53PNz/2IcDJFeOUUBheV8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jy9kCdZdQy0ps6DQelZE4wXj2ewxa2+6sLFSz6Sg9GC3JZe0/Ztw9gnLItfRfPUxE/UlaEZXW9jNwlgMOToYro9Ee3FxLHVAFSU+bYJS1lp4Rky6y9eKQiKlX7xdb3HeYEbZDWXA9jhe1YoFnwt7bfGSgrnAKmjLIOYSX4Qwu9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDE4tM+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDE4tM+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35045C2BD11;
	Wed, 22 May 2024 02:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346549;
	bh=WcxyOnWaRyWEvwikXgmFoA53PNz/2IcDJFeOUUBheV8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BDE4tM+hVGdlwtBS7bkCirvAN5S89EpvDLEFWIhhTVWlTjQSphR9bPqqfX1cKWdAW
	 FMdyhGL+EPJrFplTRF9GMIj80OZm3Lezx+kD8mVq3VHznvjwwxdp66cA/VGrrEbn5T
	 qzBIseKoo+H8qkHDo1cLOCOj9CM6+MmbJFzaL0vjUavnK7TOKJV9BfsACs7L2a+qpD
	 SIj3Cn1RL0vRYWldMUuiikHL2gAgzJHXtLKuhzosEb20rxlPuau2drwgouRMCg1FS5
	 CLPSB9X8iaO8JEYeNB5ymo32aglXmaM7/1EAOol9C7rnZb7itlF7pumR7V+a4sW/Wt
	 XXzHyxR2ltvfg==
Date: Tue, 21 May 2024 19:55:48 -0700
Subject: [PATCH 027/111] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532117.2478931.2457368454685012972.stgit@frogsfrogsfrogs>
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

Source kernel commit: a1f3e0cca41036c3c66abb6a2ed8fedc214e9a4c

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b5c8da7e6..ca1b17d01 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -714,9 +714,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
+#define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	27
+#define XFS_SCRUB_TYPE_NR	28
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

