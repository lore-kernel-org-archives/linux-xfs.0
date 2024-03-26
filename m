Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D093C128801
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424127; cv=none; b=CO0oEARQDMLDLVpXf5pKfyfuRIACfQZ8ejBxGko476wpkT0esRFrO2GkmGBHa2uxxnS1J6Ee0q5C3D+nceLIegJfBoJOYwJa9Bi0aYr1biOhDVXZ0DZzuZFgh/tt3LJiF0hy7+EfxHGDIe3IR1qw+voNCHo78OewMeaeGF47e3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424127; c=relaxed/simple;
	bh=uZg70TBQ+1ZHTAfb3qjCsywQUJLERyEplvhailPi0ek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKiNJ/iXP8qeSedBYa2zi7GK4E3OT0ESv3524eCAs6Zvu4hQi0zlwPe9FNOCUC9JrTxojZ7cCqN2vl9aRKOMNyWTRD01CR7hCEuW7TsmFvT911aEqfG+ipmWDOKfI9bevaPSFxRr2sfxpxyQKaVYiwH/6djcC8Wlg3xRmmpKKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+akPMpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+akPMpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F31C433F1;
	Tue, 26 Mar 2024 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424127;
	bh=uZg70TBQ+1ZHTAfb3qjCsywQUJLERyEplvhailPi0ek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k+akPMpKbm0zW+T7w0lOEGJYU1J6qc3WH/e3EuFZzirJ3E2xeNtZHiZcy+9EvyVBk
	 p/fhw1VfWtvCr6oyRqUNw204NclNzVjHcDo3oltJmGkCYfHuAgf5dz//35WjZvL0ey
	 U6njSbG5tHN8nBZtAVH5AVdM/0l2j+TfSBFR4p6gmk0Ku1F1DKF4F/3/7sq+EQswnQ
	 f7WDh9SzcdsABdCbQNmbvjP7ub4GbU2sKTtKcq5SOrK8F2W7pA140wwZKRpJEJdGZZ
	 i/fH+AfO0q37RxFiHpiMsFpl2b4d5CQ3R7F8N+QpOn7Icn8Hqbg5X1mtrhANR43kuO
	 PXdQpBmxUH99A==
Date: Mon, 25 Mar 2024 20:35:27 -0700
Subject: [PATCH 027/110] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131774.2215168.13763262812483093657.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index b5c8da7e6aa9..ca1b17d01437 100644
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

