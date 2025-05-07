Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675BF25D523
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746620092; cv=none; b=OUTV1m5HQc4Q4SPdvCZtHnyHd+JjtPmO9P3ced9OEjAHOn+5a2XvenuF8jSXT2GIclBuMX4mn25eq3TFivCT8lSrCwEIzqIRU/Z5ty/6NOhOyOpbMGIpAhQzxoONeTkaKDv4YTyVle0zkge15o64J7TzE7e3wPalrpDmKgowviQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746620092; c=relaxed/simple;
	bh=/WEEsWbx1/mri6nSHegn2hIYS9GKDahnJwkt8WGggow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNC+/FIoX0GY7Q3SgUB1lDWtbXdfF4Q1k4zV7K2TvuzKDpeiTvXGj8l/NFNZBs4X1nty3YBBlYg+me68xYCSJQr+z2XoRD3jCtaZnzmkGKIttIJQr7SHGUbAHqHHYNPKcNSDwrX12wcwJreq+/PA+ALDpHb8tlyw59mXzL5XGpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AP4rm69D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AP4rm69D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2076C4CEE7;
	Wed,  7 May 2025 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746620091;
	bh=/WEEsWbx1/mri6nSHegn2hIYS9GKDahnJwkt8WGggow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AP4rm69DD7p60FJFo/EEJvKKW80hrV3dAZLPVrcdZKoHap0KJb9Po8mzTr/DFiKr2
	 WXKYIuN9pgrbpyA6eTPwcDnW/xXsxQ0ZcnRJ4elPGTUOd2Db+XbH6/Q2FaEZ+VGo/X
	 S8N1Ml7//q0k5raw41JlWKwGmMJq+w0ROllDO/7gub9sjutqV+ii36Ez0P7+FzNG9n
	 Iyx2WV0Y6aK9Hriz45qpvqPkJW6Yc+eJ0Lw7WynMiXV+XNo4A+dQ08ZM4T1EfMdEc8
	 ctPSOFtCJsUJEaXdSzY7Cc593Ol9OWWwapLOR6bICdS0hPXUR2fVogsaCreyZwQraj
	 f59e9Z1XgsqKw==
Date: Wed, 7 May 2025 14:14:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] large atomic writes for xfs
Message-ID: <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
References: <Na27AkD0pwxtDXufbKHmtlQIDLpo1dVCpyqoca91pszUTNuR1GqASOvLkmMZysL1IsA7vt-xoCFsf50SlGYzGg==@protonmail.internalid>
 <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>

On Wed, May 07, 2025 at 01:00:00PM +0100, John Garry wrote:
> Hi Carlos,
> 
> Please pull the large atomic writes series for xfs.
> 
> The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:
> 
>     xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30
> 20:53:52 +0200)
> 
> are available in the Git repository at:
> 
>     https://github.com/johnpgarry/linux.git tags/large-atomic-writes-xfs
> 
> for you to fetch changes up to 2c465e8bf4fd45e913a51506d58bd8906e5de0ca:

The last commit has no Reviews into it.


> 
>     xfs: allow sysadmins to specify a maximum atomic write limit at mount
> time (2025-05-07 08:40:35 +0100)
> 
> ----------------------------------------------------------------
> large atomic writes for xfs
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (6):
>         xfs: only call xfs_setsize_buftarg once per buffer target
>         xfs: separate out setting buftarg atomic writes limits
>         xfs: add helpers to compute log item overhead
>         xfs: add helpers to compute transaction reservation for finishing
> intent items
>         xfs: ignore HW which cannot atomic write a single block
>         xfs: allow sysadmins to specify a maximum atomic write limit at
> mount time
> 
> John Garry (11):
>         fs: add atomic write unit max opt to statx
>         xfs: rename xfs_inode_can_atomicwrite() ->
> xfs_inode_can_hw_atomic_write()
>         xfs: allow block allocator to take an alignment hint
>         xfs: refactor xfs_reflink_end_cow_extent()
>         xfs: refine atomic write size check in xfs_file_write_iter()
>         xfs: add xfs_atomic_write_cow_iomap_begin()
>         xfs: add large atomic writes checks in
> xfs_direct_write_iomap_begin()
>         xfs: commit CoW-based atomic writes atomically
>         xfs: add xfs_file_dio_write_atomic()
>         xfs: add xfs_calc_atomic_write_unit_max()
>         xfs: update atomic write limits
> 
>    Documentation/admin-guide/xfs.rst |  11 ++
>    block/bdev.c                      |   3 +-
>    fs/ext4/inode.c                   |   2 +-
>    fs/stat.c                         |   6 +-
>    fs/xfs/libxfs/xfs_bmap.c          |   5 +
>    fs/xfs/libxfs/xfs_bmap.h          |   6 +-
>    fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
>    fs/xfs/libxfs/xfs_trans_resv.c    | 343
> ++++++++++++++++++++++++++++++++++----
>    fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
>    fs/xfs/xfs_bmap_item.c            |  10 ++
>    fs/xfs/xfs_bmap_item.h            |   3 +
>    fs/xfs/xfs_buf.c                  |  70 ++++++--
>    fs/xfs/xfs_buf.h                  |   4 +-
>    fs/xfs/xfs_buf_item.c             |  19 +++
>    fs/xfs/xfs_buf_item.h             |   3 +
>    fs/xfs/xfs_extfree_item.c         |  10 ++
>    fs/xfs/xfs_extfree_item.h         |   3 +
>    fs/xfs/xfs_file.c                 |  87 +++++++++-
>    fs/xfs/xfs_inode.h                |  14 +-
>    fs/xfs/xfs_iomap.c                | 190 ++++++++++++++++++++-
>    fs/xfs/xfs_iomap.h                |   1 +
>    fs/xfs/xfs_iops.c                 |  76 ++++++++-
>    fs/xfs/xfs_iops.h                 |   3 +
>    fs/xfs/xfs_log_cil.c              |   4 +-
>    fs/xfs/xfs_log_priv.h             |  13 ++
>    fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
>    fs/xfs/xfs_mount.h                |  17 ++
>    fs/xfs/xfs_refcount_item.c        |  10 ++
>    fs/xfs/xfs_refcount_item.h        |   3 +
>    fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
>    fs/xfs/xfs_reflink.h              |   6 +
>    fs/xfs/xfs_rmap_item.c            |  10 ++
>    fs/xfs/xfs_rmap_item.h            |   3 +
>    fs/xfs/xfs_super.c                |  80 ++++++++-
>    fs/xfs/xfs_trace.h                | 115 +++++++++++++
>    include/linux/fs.h                |   3 +-
>    include/linux/stat.h              |   1 +
>    include/uapi/linux/stat.h         |   8 +-
>    38 files changed, 1351 insertions(+), 127 deletions(-)
> 
