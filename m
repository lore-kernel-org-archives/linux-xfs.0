Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B019CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301294; cv=none; b=uJiI3MDHDKAM8zZYbIZOAjBcW6L+KaTLs5SHYUuJ7faghvxP/nJ8JNkk+hVKfohQ1IwQhfiSjKaQRHfN8R/oOghfdW4+HNcrHkB55Ql/oKq/cCyqv0wBYkLm7ZUVO0ZBmJntthzyr0mzPaz80woxbYj0K1riD/cskHybdF6mDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301294; c=relaxed/simple;
	bh=C3pztucs4jrLNwFsukVkFQAlgnN2g7UyPOW6f6bMdT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSfnMpT6W81dcEFW1gXCCfuqIywTuFkrgssHYWekLPpF2j0+vViFEppahi6lkdN/pX+RJifKHzq3YPQ9X9FVMgtt8VMMWglbBhXd1AiTcog7hVtigDeNTm1I77ga+aLISVY5MSI6ih7jAZUPMjNeEcH9h9yt7esX7WiF9XlUf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8JO99yH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8JO99yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BA0C4CEC7;
	Mon,  2 Sep 2024 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301293;
	bh=C3pztucs4jrLNwFsukVkFQAlgnN2g7UyPOW6f6bMdT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A8JO99yHMryywF1gafGvad9Q1LhQq267tjHA16EGUhP+34SWsQXVdyRGc5cLoB9gg
	 2XXBHRELzCgn0Of/C4/Rmoq2+3NoJBY/68NNFJhr4HPcVzJvqd7Rnjs9Wii6FbJO0V
	 ZLCSp0PVM8yS6Q93JbtGFWuVmTgkaP/JvwxMnvRUKRYYeqQTvD0OepPzB8QUwwDCeZ
	 R9LEdroeYZ/VdS/OTMGSpQdE/6h/J0G17r0r5Szp91fG5r1dK8CoQE6anXZOHgeoaJ
	 nFnGwBOy4yOyhC0KTyTBLGgZL9EzDggMkRPiKgG96bGNRhrfEZrHLZDyLEwcxlYxOO
	 VYNf6FnYiAWaA==
Date: Mon, 02 Sep 2024 11:21:33 -0700
Subject: [PATCHSET v4.2 3/8] xfs: clean up the rtbitmap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
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

Here are some cleanups and reorganization of the realtime bitmap code to share
more of that code between userspace and the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtbitmap-cleanups-6.12
---
Commits in this patchset:
 * xfs: remove xfs_validate_rtextents
 * xfs: factor out a xfs_validate_rt_geometry helper
 * xfs: make the RT rsum_cache mandatory
 * xfs: remove the limit argument to xfs_rtfind_back
 * xfs: assert a valid limit in xfs_rtfind_forw
 * xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
 * xfs: cleanup the calling convention for xfs_rtpick_extent
 * xfs: push the calls to xfs_rtallocate_range out to xfs_bmap_rtalloc
 * xfs: factor out a xfs_growfs_rt_bmblock helper
 * xfs: factor out a xfs_last_rt_bmblock helper
 * xfs: factor out rtbitmap/summary initialization helpers
 * xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock
---
 fs/xfs/libxfs/xfs_bmap.c     |    3 
 fs/xfs/libxfs/xfs_rtbitmap.c |  192 ++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h |   33 +--
 fs/xfs/libxfs/xfs_sb.c       |   64 +++--
 fs/xfs/libxfs/xfs_sb.h       |    1 
 fs/xfs/libxfs/xfs_types.h    |   12 -
 fs/xfs/xfs_rtalloc.c         |  535 +++++++++++++++++-------------------------
 7 files changed, 438 insertions(+), 402 deletions(-)

