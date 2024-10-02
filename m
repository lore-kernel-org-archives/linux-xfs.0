Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89592391
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727830823; cv=none; b=MhxgBvCe0/mSuvhmr94ddH/iH9qbvSBQrioVtjdu1x3LLnUlNzlZ3L0usPuzsAOrxlJyC27m4ZKUsG4TOLnOaZcc3fjNrtLRhFfZ1M8l0M+9gquoqhmw5ZMXPcC24SJ7FOxtJ1iKHalmujjAqOLcLjFvbXgmj5QGNDd6UvCpFAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727830823; c=relaxed/simple;
	bh=iuO/47p3bV+JUJZBnkpN4GWPW4rJ5NZrYsMrYdkhRkw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IqWMxMYUrMf0GrcBQwE73rNaT3VW/ZjZfpxxSReASsHqzGfzDdIaoPMGdz4dZbkNGEfSVain0wqplDY8wtvK0FMT9IQQ+a7RLMzMFFivwTOXI+GS5PF+K5o2CTGVFYMNFBJ/OrQ8eRlTtSniYLtS7T4x+L8Gt1XzOGjv1/iFQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Queqs9MT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Queqs9MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E5AC4CEC6;
	Wed,  2 Oct 2024 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727830823;
	bh=iuO/47p3bV+JUJZBnkpN4GWPW4rJ5NZrYsMrYdkhRkw=;
	h=Date:From:To:Cc:Subject:From;
	b=Queqs9MT9rCI8pm0iht92t530WTxmnzc+8Zb6I8Agcff+KkVNH6ppa+Qzfi7V+Q0k
	 MiolJvS103eL3as96m/O9sO7+h1dF3FdQm+HQBdcSiPAF3QkfwJ6P4W5wI4+To7PtM
	 yD+Q8kAABo7N6wBVaPTYlpqa4v7FkKR2YSPzef8xVxIRKcTkwq0n9uk7nXpaKwrgDX
	 BkCDnvzKQ99IwvYojCYuFKatbs++u1b3wh2vkSHxeEg0uU8Zvq2dJwBI5hH7ObLpPF
	 uink0JYs07IfBjSw+umEygkmm5HVdzu9cZPYGqHd7yAFF3/nj9oLKXY/nVU8ciz6QV
	 yr3EULkb5YHsA==
Date: Tue, 1 Oct 2024 18:00:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.11
Message-ID: <20241002010022.GA21836@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey & Christoph,

Here's all the patches that I was going to submit for xfsprogs 6.11.
The following patches have not been reviewed:

The 6.11 libxfs sync is a bit intense this time, because we're merging
all the inode creation code with the kernel's versions of those
functions.  I tried to reconcile the versions gradually, but then you
get this:

[PATCHSET v4.2 3/6] libxfs: resync with 6.11
[PATCH 07/64] libxfs: put all the inode functions in a single file
[PATCH 08/64] libxfs: pass IGET flags through to xfs_iread
[PATCH 10/64] libxfs: pack icreate initialization parameters into a
[PATCH 12/64] libxfs: rearrange libxfs_trans_ichgtime call when
[PATCH 13/64] libxfs: set access time when creating files
[PATCH 14/64] libxfs: when creating a file in a directory,
[PATCH 15/64] libxfs: pass flags2 from parent to child when creating
[PATCH 17/64] libxfs: split new inode creation into two pieces
[PATCH 18/64] libxfs: backport inode init code from the kernel
[PATCH 19/64] libxfs: remove libxfs_dir_ialloc

The only new functionality is that new child files get real (i.e.
nonzero) i_generation values:

[PATCH 20/64] libxfs: implement get_random_u32

The rest of these patches are ports, fixes, and cleanups:

[PATCHSET v4.2 4/6] xfsprogs: port tools to new 6.11 APIs
[PATCH 1/4] xfs_db: port the unlink command to use libxfs_droplink
[PATCH 2/4] xfs_db/mkfs/xfs_repair: port to use
[PATCH 3/4] xfs_db/mdrestore/repair: don't use the incore struct
[PATCH 4/4] xfs_db: port the iunlink command to use the libxfs

[PATCHSET 5/6] xfs_repair: cleanups for 6.11
[PATCH 1/4] xfs_repair: fix exchrange upgrade
[PATCH 2/4] xfs_repair: don't crash in get_inode_parent
[PATCH 3/4] xfs_repair: use library functions to reset root/rbm/rsum
[PATCH 4/4] xfs_repair: use library functions for orphanage creation

[PATCHSET v4.2 6/6] mkfs: clean up inode initialization code
[PATCH 1/2] mkfs: clean up the rtinit() function
[PATCH 2/2] mkfs: break up the rest of the rtinit() function

--D
