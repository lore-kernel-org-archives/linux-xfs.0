Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC57DEEB3
	for <linux-xfs@vger.kernel.org>; Fri, 16 May 2025 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747401404; cv=none; b=b1X5+0Ol5IAeOw7plEQ+wSK2f9BGBBDvNOKzFCU7yGgqptr6Nc5uYg0VjuegOMZsV1zWQxiHp8BA38DpfYPro2NH/Y3msLJidlBc0k2CI1UAPYYe/RyeHi2QIhpIEwjOe1fEFlHKx5x34ruyv0GSoWy+h5J5KdSMQ8vPcEZkr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747401404; c=relaxed/simple;
	bh=ifQ8vLpfl2oUHsjfhR9la3zU0yvJRbGRm3mLq6MkRLc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PmGeodYJWNiPKSRMwj1THJUpOYukP4BxhddeoNqWZVbUSrXFjg6OlijmV7OZoc2VPxAqnIueXoF8L1RQELs6SaI/Bozgr2Bg3ctNHB/JiLpQFY85HfAJHApFpPF0TMjehyoWD9pqX/CB5Efo2VNwKsxPcsnMj7b++4uiDdJzYbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOue3Ujt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOue3Ujt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FE3C4CEE4;
	Fri, 16 May 2025 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747401403;
	bh=ifQ8vLpfl2oUHsjfhR9la3zU0yvJRbGRm3mLq6MkRLc=;
	h=Date:From:To:Cc:Subject:From;
	b=oOue3Ujtre31xaMpSq9ZPSPlBrtFMZdFyresVZO/hZYQx1Qm7V2MU3zPvRrj9YcMJ
	 +21OUj5la8eFobU//tY+6JQeCWxsoI8CYSeQGMW+ZCGEaXPFujtBUzlg4xH9WNVKos
	 gPvFXMRH85QTtd6zVPE9PBdAu/OrIIbzhhIzEQticsK73wef9Q8uyWs14yM96rhVOW
	 jiae4+L1KZoVQJDpAK3st7LJC7sVr71aL1AcAKldZt0Aq3jtiCgUKXWFym0OdfBkf6
	 vTistj2vtUJFq7UJ3/IlBYNMNLulYocc0urTnChpEjo2iHgkFPRkhwvyktL8eY/bz9
	 3bJfe/57I61jw==
Date: Fri, 16 May 2025 15:16:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.15-rc7
Message-ID: <fo6f25yd3ywgunzhimk6s3c4vmh2bbwic7ihbq6agcafhyhcpx@5akhizn44tqy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

It's worth mentioning this includes a bug fix for a possible data corruption
vector on the zoned allocator garbage collector.

Thanks,
Carlos

The following changes since commit f0447f80aec83f1699d599c94618bb5c323963e6:

  xfs: remove duplicate Zoned Filesystems sections in admin-guide (2025-04-22 16:05:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc7

for you to fetch changes up to 08c73a4b2e3cd2ff9db0ecb3c5c0dd7e23edc770:

  xfs: Fix comment on xfs_trans_ail_update_bulk() (2025-05-14 15:37:50 +0200)

----------------------------------------------------------------
xfs fixes for 6.15-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (2):
      xfs: Fix a comment on xfs_ail_delete
      xfs: Fix comment on xfs_trans_ail_update_bulk()

Christoph Hellwig (1):
      xfs: fix zoned GC data corruption due to wrong bv_offset

Nirjhar Roy (IBM) (1):
      xfs: Fail remount with noattr2 on a v5 with v4 enabled

Wengang Wang (1):
      xfs: free up mp->m_free[0].count in error case

 fs/xfs/xfs_super.c     | 28 +++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
 fs/xfs/xfs_zone_gc.c   |  5 +++--
 3 files changed, 48 insertions(+), 19 deletions(-)

