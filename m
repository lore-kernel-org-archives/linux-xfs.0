Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE2D19DF61
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061848; cv=none; b=X3RvrQNIDhgNc8YUX10AgH4MHKp1I7ZGBwxTX1EyPV2R9AzgHiXuMbcCJ2VjIUdHHF7pNAY3grqyridD8uHksMDe3D7ga81UAjVlRJJfefO4+D9Xqcp0fAE+OsqeTClKuizwAofW5vI+JHxD3pJ8MgiAeiYQWiGSPqwL2tWMFjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061848; c=relaxed/simple;
	bh=NqLsg9DpDRBddmsMSaKziIRwyvp6jWmfMwdLVRv9mHM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CclSX8qLU7bSTvb58ME8H5nvcDSvsNqJTUqB27AvHqZVJDbRHUTQu9FqmmbgSuGthotup9isriDafMcTi7hEsd0ZPH8gwmWD4XHZImVt53YnGy81xC4ElKzhl71jueXKdMTe9gQbTl1+/Fi4jbHFvlb15XNOT8l97IxAlL4adGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFs/OAmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFs/OAmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83962C4CED3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061848;
	bh=NqLsg9DpDRBddmsMSaKziIRwyvp6jWmfMwdLVRv9mHM=;
	h=Date:From:To:Subject:From;
	b=eFs/OAmoL/gUODgr/6PSVipS6ynp8cEFSWO4rOHlIYgNYfbc2L4+PCrKL5/REYmjN
	 uDuQOV28f8sXvnzy3jMSNmRb4LWvSMw5SJ6k3GoSd8vYhPHCa4W/Want2ZqbJa2Wpa
	 WSopFTdswL2OMzB4tFqjx28oMWUNSMiUpHjL0xBv3sKRMbU6U4+P1W38sbttluSK8M
	 A7dcQLk/e6OeO5W5t7Q6XHUy7DdHyyWqRlNkjHJ7l2rsZJuK1KhezlS0i/F+FDH0Ol
	 yr5DWs/0S5CT+DijnpeSokjg+5ZOVOqoVqr1IVfKJqaaDCojNKQ805I8mHlq3acQIf
	 yypQKxRXQGMmg==
Date: Tue, 28 Jan 2025 11:57:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to a9ab28b3d21a
Message-ID: <4uu4ft6vby456cix3rt3sscioil5zdjxxexidhcisegybv4usl@nl2prvztzfis>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

a9ab28b3d21a xfs: remove xfs_buf_cache.bc_lock

6 new commits:

Christoph Hellwig (3):
      [89841b23809f] xfs: remove an out of data comment in _xfs_buf_alloc
      [f5f0ed89f13e] xfs: don't call remap_verify_area with sb write protection held
      [a9ab28b3d21a] xfs: remove xfs_buf_cache.bc_lock

Jinliang Zheng (1):
      [915175b49f65] xfs: fix the entry condition of exact EOF block allocation optimization

Wentao Liang (2):
      [fb95897b8c60] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
      [26b63bee2f6e] xfs: Add error handling for xfs_reflink_cancel_cow_range

Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c | 13 +++++----
 fs/xfs/xfs_buf.c         | 36 ++++++++++++------------
 fs/xfs/xfs_buf.h         |  1 -
 fs/xfs/xfs_exchrange.c   | 71 ++++++++++++++++++------------------------------
 fs/xfs/xfs_inode.c       |  7 +++--
 fs/xfs/xfs_iomap.c       |  6 ++--
 6 files changed, 58 insertions(+), 76 deletions(-)
