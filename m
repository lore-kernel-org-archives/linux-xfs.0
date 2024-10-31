Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32031CC8AF
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416278; cv=none; b=Bj1lh2DSGTCmUWcaDMtK8KnwlMmVRxsuoPifDBFWXvg86k+IshQn7hlqRefkQF5LXGXbrKyG7oD4ZjOm8SJFnhCpP/4IDZs+rT1cTeWEKKu3E0MluiERgagDefRyt2QWP2IoUaAV9RIzhZ9NUxRp617QD1yXMOhjaKNFA2K34Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416278; c=relaxed/simple;
	bh=RIiq8wv6cT21v+OF5Npukq//GNb2e8AddT2Ptw9IdAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oc06WZlXQcl0g5znPfeEfy2CFFamqo/nGMDzkizc+WKHaYf1i7jKkOqTKMS29lwJIWLSyI1fr2IGHYQxUzVI2V3pwumi5av0yrDUQND6Kxe66WygpdaKKRfAEMRFEXhDfMUjwc6vQf7MmT7CCI5qtrQgE1MasYuCCjb2rV+dXQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J27z5B7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J27z5B7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A808BC4CEC3;
	Thu, 31 Oct 2024 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416278;
	bh=RIiq8wv6cT21v+OF5Npukq//GNb2e8AddT2Ptw9IdAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J27z5B7zVe0Bz9hcbMCuKcMO3u1PUBQLB3EH/abQ0OhdgnXwb3hso12kLRENHgowF
	 s+Woaj5uSLHBm8l8LQpGzctURz7WEmHeu4GmZL9UnlisCzeN1iO4N8LpHMdhCW5FKu
	 eoPNP+WZ1bpT4fK8Bt5x+WqJnU2AEvCFmyDJKvAhG+b+ZAVvASng8KMSoEO5qAkLzL
	 LZcG6NLKdXiHeAW4oIN41998JFC5F6PL2GUvZu8QhDq6h+tfWEPNKU4kpkJquaM5ku
	 c7jm8schc5Us3+uFbo8aXSv3FPG99xNK34cXztMNJ2GOyBZukDHIS19WENWBEufbBd
	 xLfoEmiDa0Lsg==
Date: Thu, 31 Oct 2024 16:11:18 -0700
Subject: [PATCH 10/41] xfs: assert a valid limit in xfs_rtfind_forw
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566073.962545.18309774070518861945.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6d2db12d56a389b3e8efa236976f8dc3a8ae00f0

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c7613f2de7b0a0..f578b0d34b36d3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -313,6 +313,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t		incore;
 	unsigned int		word;	/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */

