Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0265E3D7A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301310; cv=none; b=izNBZd9X+SIPNNXI+HgfUfx/czSTFb/r7NWERqpRWV2fAIucuiVZHqUYnT9KXT8VH/ylEq/DIJvs/bcy+3R30ttskQIBlKkIMQoHGxxCkyWPXCnAVJLOyYw1oOkIuLOqY4pdF+TKKJYvWnUICgciDFUdtM3EfDp8EPY7+QDiE4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301310; c=relaxed/simple;
	bh=2NF2T7fiXzdJuCQmGQAk7SuDechH+ACkv8cjhFhz7Yo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SddADx41wpYWgM0GADpdziljuAvBBSsTnzJtEVIPgKnakdQ06fQtY1/UcYIDlayuPRY2KMPcYRZ/xwDf/kc+QdEdFGsS6WCKs1qaVVQnxnTbSlCRtMZKZNirN/8iDmQ4P/RoFEDR/AWUpPTUrg6KuPfYiAGaq5hAHZoN1R+5qxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHo1xwIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHo1xwIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D2C4CEC2;
	Mon,  2 Sep 2024 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301309;
	bh=2NF2T7fiXzdJuCQmGQAk7SuDechH+ACkv8cjhFhz7Yo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RHo1xwISm1B17PvU29v4fe35ZhmQiX/621UOLuAY/8fz9l7BJgOLJn9gtTJFua92k
	 ofqmXTgNzbRIPLkBDGLgr6cFQDJ/eeYmD6kCLGhZB7iscsHEmemV2vFUnxhgPMbsUv
	 1zZ5pgY8Iatq0EPhkk1GMCjxflFvaetUEd5/Orp0lfjXHpzpFWFct7hSm8Bnk26elt
	 vvs7FfN+78BQHf1/nVbNauF0fDhg/9tm8nwK1IJGvAX9rY7m6el3yJFQ1A/wtpQx7Y
	 1qURaI80cBengiC1gJOWZEuKFIydfHYHSlngt9UvtWsAXzlgXSJ3KMZM+X6OZg3KZ4
	 FIxfJcAnUaGTA==
Date: Mon, 02 Sep 2024 11:21:49 -0700
Subject: [PATCHSET v4.2 4/8] xfs: fixes for the realtime allocator
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

While I was reviewing how to integrate realtime allocation groups with
the rt allocator, I noticed several bugs in the existing allocation code
with regards to calculating the maximum range of rtx to scan for free
space.  This series fixes those range bugs and cleans up a few things
too.

I also added a few cleanups from Christoph.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtalloc-fixes-6.12
---
Commits in this patchset:
 * xfs: use the recalculated transaction reservation in xfs_growfs_rt_bmblock
 * xfs: ensure rtx mask/shift are correct after growfs
 * xfs: don't return too-short extents from xfs_rtallocate_extent_block
 * xfs: don't scan off the end of the rt volume in xfs_rtallocate_extent_block
 * xfs: refactor aligning bestlen to prod
 * xfs: clean up xfs_rtallocate_extent_exact a bit
 * xfs: reduce excessive clamping of maxlen in xfs_rtallocate_extent_near
 * xfs: fix broken variable-sized allocation detection in xfs_rtallocate_extent_block
 * xfs: remove xfs_rtb_to_rtxrem
 * xfs: simplify xfs_rtalloc_query_range
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   51 ++++++---------
 fs/xfs/libxfs/xfs_rtbitmap.h |   21 ------
 fs/xfs/libxfs/xfs_sb.c       |   12 +++
 fs/xfs/libxfs/xfs_sb.h       |    2 +
 fs/xfs/xfs_discard.c         |   15 ++--
 fs/xfs/xfs_fsmap.c           |   11 +--
 fs/xfs/xfs_rtalloc.c         |  145 +++++++++++++++++++++++-------------------
 7 files changed, 124 insertions(+), 133 deletions(-)

