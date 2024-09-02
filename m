Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86319CC0F
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302540; cv=none; b=LYPFA0h+i9JnaPp76PHiDRcfIxbFhAI1t9gt26AYVsYeBx9ECpE9ZagmcWnOyAf732BparyTzkoqR756F1VUrcaBYxnSBpDGFweFMdJqmDAOfpxSLk2UNwOBE9QipZdStrYqrZrvoDBftgQDkF7CB2ESNHtkJ1iLXjfF12UFDt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302540; c=relaxed/simple;
	bh=t9fji/yZarWRC6pGHSQE57a/dDJSuCweZSy6+71rMhk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=GEm9DbEd6X50WB+OdMd83uJkBtKnQLRt+EDoeECm7LHYDz5llU7PcxAVnKLvH/ikMwB/0/O4A9RCxJwPSv4SrG9pnCP/wTpXKEUy8/xZbclMcVBbOWMp3GfQJT7n5eG70M4JFaiCUhftuvoo9GgM6QbGP+CsVnqYhRoY3B3Nx2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n84oV0Q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n84oV0Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9C0C4CEC2;
	Mon,  2 Sep 2024 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302540;
	bh=t9fji/yZarWRC6pGHSQE57a/dDJSuCweZSy6+71rMhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n84oV0Q/S7FlBa3eQFydweR90S3juEsBjXwqZCn6kPeQrPI/JkGbGyec5tDu8uFTX
	 ut0yKn5fo9KJ9CMqv60ONmpWnylTRoPIFGLOqpvNl5QDscjsXiolQvA0jwtk28DYDQ
	 I4v+ubvd4B6ChpuYZUtDOCr/IZkOWE2pqZxbZ0gzn4o8y0a2swUtRylTdLqYjGVCX/
	 6YTnUhx9RACXcJdGxgGLK0Qiq4NHeBm1itDM7pB7JX5qttPf0vOx+vJHvqmXKHA6yO
	 KFMxjp7t7AbS6i2/eeXku0vSyzGKUnxq0Q/XzkK8AwHfvkESa4X3EcE8UrV45+zGuD
	 6qDYHRHPzQfCw==
Date: Mon, 02 Sep 2024 11:42:19 -0700
Subject: [GIT PULL 3/8] xfs: clean up the rtbitmap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248144.3348968.14040388584318376231.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 390b4775d6787706b1846f15623a68e576ec900c:

xfs: pass the icreate args object to xfs_dialloc (2024-09-01 08:58:19 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rtbitmap-cleanups-6.12_2024-09-02

for you to fetch changes up to 0a59e4f3e1670bc49d60e1bd1a9b19ca156ae9cb:

xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock (2024-09-01 08:58:19 -0700)

----------------------------------------------------------------
xfs: clean up the rtbitmap code [v4.2 3/8]

Here are some cleanups and reorganization of the realtime bitmap code to share
more of that code between userspace and the kernel.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (12):
xfs: remove xfs_validate_rtextents
xfs: factor out a xfs_validate_rt_geometry helper
xfs: make the RT rsum_cache mandatory
xfs: remove the limit argument to xfs_rtfind_back
xfs: assert a valid limit in xfs_rtfind_forw
xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
xfs: cleanup the calling convention for xfs_rtpick_extent
xfs: push the calls to xfs_rtallocate_range out to xfs_bmap_rtalloc
xfs: factor out a xfs_growfs_rt_bmblock helper
xfs: factor out a xfs_last_rt_bmblock helper
xfs: factor out rtbitmap/summary initialization helpers
xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock

fs/xfs/libxfs/xfs_bmap.c     |   3 +-
fs/xfs/libxfs/xfs_rtbitmap.c | 192 ++++++++++++++--
fs/xfs/libxfs/xfs_rtbitmap.h |  33 +--
fs/xfs/libxfs/xfs_sb.c       |  64 +++---
fs/xfs/libxfs/xfs_sb.h       |   1 +
fs/xfs/libxfs/xfs_types.h    |  12 -
fs/xfs/xfs_rtalloc.c         | 535 +++++++++++++++++--------------------------
7 files changed, 438 insertions(+), 402 deletions(-)

