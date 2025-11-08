Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCACD450FE
	for <linux-xfs@vger.kernel.org>; Sat,  8 Nov 2025 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762592310; cv=none; b=j45e1n3pXd6No3714Y5KVwPz2oJRvvIydzODOHjYQYP49HiDRlgNwxXrNlSnz8cfshQ6ZgOmr7++gEOkOsCBtjqjOlpLFjEG80rjOgp6nxAZu49Rs3oDE4tyxCXNbcqWHOSZieqlq652rfJlOUjYNG5NmE1/3Bv9vaKahrlMNoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762592310; c=relaxed/simple;
	bh=HC7kpJf5csxcMkwjTSVKDDdjkCvIGJkVKVGljxGY6J8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pHI4OmxcEUF7qS2IU4YFfCPK+HpIAmWGs0gdW2bB78ltNb4GD2lCAsyw7gms49uAH7PrKBJVtw+ZJ2YHo1mNxOG0UpoobC8gawTo1LPTqsWxiN4B1YjDH8MzYWqfUi1TnOyDiW/kqHOTTb+maZvNNp87fHkG8YueO8pRlB9zcc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ks6yHtII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ks6yHtII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B68C113D0;
	Sat,  8 Nov 2025 08:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762592309;
	bh=HC7kpJf5csxcMkwjTSVKDDdjkCvIGJkVKVGljxGY6J8=;
	h=Date:From:To:Cc:Subject:From;
	b=ks6yHtIIeVTfKp39nLWn2mhJ5v3Q5DSc75rXaIJUj6hua2YnndNqwmm3fXTQj8FZz
	 o6aI55IfkOMjFCU/+lFZ3qls+Ie/oV+/OR3gq11YBuvD7rsWc4aPkfj12REY4v20nl
	 9dX5f9pivwJnyNGT05W1WmlvbsieYJLxabIzzLP5MdJzUzDlW6JWWXzX2LDXapdxsd
	 /B6aAnVJa5iAEunJSEmvolinwY9xm7u+nw4mcWCXLfUkTOUaxHNdadd0SNE6bqnxgl
	 Uz0EXjWImK3NqwoKxNivzai8vOWRMWttWWqaBx9f+PzOBdMm5EuQcPfO4dSY+4TDJJ
	 2NchnALk2FeIg==
Date: Sat, 8 Nov 2025 09:58:23 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for for v6.18-rc5
Message-ID: <44wbf62am2tx46wyelnthkhzrh7kkknulqaf7ftpww64zahyr6@kiuc6di55b5g>
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

This contain fixes for the RT and zoned allocator, and a few fixes for
atomic writes.

Thanks,
Carlos

The following changes since commit 0db22d7ee462c42c1284e98d47840932792c1adb:

  xfs: document another racy GC case in xfs_zoned_map_extent (2025-10-31 12:06:03 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc5

for you to fetch changes up to d8a823c6f04ef03e3bd7249d2e796da903e7238d:

  xfs: free xfs_busy_extents structure when no RT extents are queued (2025-11-06 08:59:19 +0100)

----------------------------------------------------------------
xfs: fixes for v6.18-rc5

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (3):
      xfs: fix a rtgroup leak when xfs_init_zone fails
      xfs: fix zone selection in xfs_select_open_zone_mru
      xfs: free xfs_busy_extents structure when no RT extents are queued

Darrick J. Wong (2):
      xfs: fix delalloc write failures in software-provided atomic writes
      xfs: fix various problems in xfs_atomic_write_cow_iomap_begin

 fs/xfs/xfs_discard.c    |  4 ++-
 fs/xfs/xfs_iomap.c      | 82 +++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_zone_alloc.c |  6 ++--
 3 files changed, 76 insertions(+), 16 deletions(-)

