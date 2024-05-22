Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610D14295
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348005; cv=none; b=QkN2oR5/vgrPkL6Y4+lphlfNBPhAhQlmph3chqcjj4YisJfDkgTS+x647ER7BPAIejnf72N8vn+6px3d4sfb5uR3q4VBycBHzcWq/8Wpp8H7DAu/CCZ6Z3+bJEgj69X+HFZxp9xvTjkf7MaSuVT89RrlVCZA9RtoaVrJzlEYMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348005; c=relaxed/simple;
	bh=7Wm/xrBnHEkX0WwBgWywLm727BoZhI45CyPSn9OSAgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFzPfvZfFGdy4gzHB3uophzX6QKxMlYG/Xf9/P1fKraQkXNA7f9z0n0dli/vRkg0JWVx8JN4dH/jc1Cwo+wUKNg2NrFoRv49W9ZwfuDwnH4NlLwsyW0Kyz88aMgW/XtLo3lAS/YyqdN7Gx7Edz3IIoe08dzpxX6FQQD783lGQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adGFxbzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adGFxbzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC91FC2BD11;
	Wed, 22 May 2024 03:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348005;
	bh=7Wm/xrBnHEkX0WwBgWywLm727BoZhI45CyPSn9OSAgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=adGFxbznDC0NCS3rWwPBZsz4/w2R6E6fY2yODPk+CwSyC3nPoqUcjMzKNy1rdnfkh
	 DY152juOfOA9WzG31KsdNhOzYzmZrFs8fTTNiEgppI2jFYkXKwHHNt+hZpK46ZLaht
	 S/eblzIpK78Pkc1+r8493hyZHc1SX0L4s7n0ovFQ1jFnXN9siMP3cghDgXUv1KhQ8y
	 5WNPTfnFCgItICjxD+Iz5rIHVzfJoT8KtPMOBPRGdShHf6355UfFbcB2xj0zi7uzUV
	 FBcUY6YQQy3VlKTMqq4te6HqxH4ha4YuOFwvp2hdfHmYDZkbFizZj9opHlQ4jE0BlO
	 F3MzhrWb7zviA==
Date: Tue, 21 May 2024 20:20:04 -0700
Subject: [PATCH 2/5] xfs_scrub: check file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534744.2482960.10112447380248089111.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
References: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
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

Check file link counts as part of checking a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 ++++
 2 files changed, 9 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 53c47bc2b..b6b8ae042 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -139,6 +139,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "quota counters",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_NLINKS] = {
+		.name	= "nlinks",
+		.descr	= "inode link counts",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 046e3e365..8e8bb72fb 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -164,6 +164,10 @@ Examine all user, group, or project quota records for corruption.
 .B XFS_SCRUB_TYPE_FSCOUNTERS
 Examine all filesystem summary counters (free blocks, inode count, free inode
 count) for errors.
+
+.TP
+.B XFS_SCRUB_TYPE_NLINKS
+Scan all inodes in the filesystem to verify each file's link count.
 .RE
 
 .PD 1

