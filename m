Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F523B794
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714173248; cv=none; b=hQCOdhJq/Uq+NOgjArhVx6KbVcm/MZwgDspj0qejoa7uLWVyg47/eNM0lBQ1JQ1mEN/GFqn1fs8VE6f5QM2wvUqNEJBpfWYIgI4Y6XFVt2mSVn7mkxB1wch2X6g1DV6+mMKF/Xb6ZtlaiHU8Sugwv8nQ6Q0+5DjUvr0XJvXdfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714173248; c=relaxed/simple;
	bh=u2hMRS4kCpEcv5SWdeC2AqIlS+6jveCS0zoi5xeEBik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4EVzdKTA0FNpYVxNERW8IT0l5cMuYyDi8CwChAhkS2fKayev9Dhe4GURpDbO/94gBb4uHj4EPWNnpOgYXjJmxEQzh6/9PqBSJ5V2zyuJ5/DtqIt8GJcIJzFq8/3KlcVcR82rM1edl57T3HQcL/rd1Bvc4p7OuasMV1HDN9fQYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLeZ9smZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLeZ9smZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346CDC113CD;
	Fri, 26 Apr 2024 23:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714173248;
	bh=u2hMRS4kCpEcv5SWdeC2AqIlS+6jveCS0zoi5xeEBik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLeZ9smZr6IeSKTG3XEf+3Z08Z0+qbD4Flz+jqL2p72o0k5hs1JwWQr9OvBbOXqOx
	 7I/Wd7Pp6FqFhmWn3JmaIQggzzIPScSluqOKgzn9gUPq9hyTRnB1AwWm6Luo2GSZ6a
	 +GhVOVhfaE9nPV9aKypOi+gPEQMVuGlg61m6i+kCOXnvxIF4MzC+ipqtLl6ivdr0y4
	 EeExJsTUL25b36kz8GYO0WaOdwM4QlBaEToTk1cmHc8Khtl4zgK09YWlAXxe+q626C
	 DT7nojg0+igtusEUiSC6QFY8Aq45Lw8aj99xvgAfmKiwre+1HfuSTT4TUz/rx/BxhN
	 /OLzZNbyuDdcw==
Date: Fri, 26 Apr 2024 16:14:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: linux-xfs@vger.kernel.org, amir73il@gmail.com, chandan.babu@oracle.com,
	fred@cloudflare.com, mngyadam@amazon.com
Subject: Re: [PATCH 6.1 CANDIDATE 00/24] more backport proposals for
 linux-6.1.y
Message-ID: <20240426231407.GQ360919@frogsfrogsfrogs>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>

On Fri, Apr 26, 2024 at 02:54:47PM -0700, Leah Rumancik wrote:
> Hi again,
> 
> These have been tested on 10 configs x 30 runs of the auto group. No
> regressions were seen.
> 
> - Leah
> 
> Darrick J. Wong (8):
>   xfs: fix incorrect error-out in xfs_remove
>   xfs: invalidate block device page cache during unmount
>   xfs: attach dquots to inode before reading data/cow fork mappings
>   xfs: hoist refcount record merge predicates
>   xfs: estimate post-merge refcounts correctly
>   xfs: invalidate xfs_bufs when allocating cow extents
>   xfs: allow inode inactivation during a ro mount log recovery
>   xfs: fix log recovery when unknown rocompat bits are set
> 
> Dave Chinner (10):
>   xfs: write page faults in iomap are not buffered writes
>   xfs: punching delalloc extents on write failure is racy
>   xfs: use byte ranges for write cleanup ranges
>   xfs,iomap: move delalloc punching to iomap
>   iomap: buffered write failure should not truncate the page cache
>   xfs: xfs_bmap_punch_delalloc_range() should take a byte range
>   iomap: write iomap validity checks
>   xfs: use iomap_valid method to detect stale cached iomaps
>   xfs: drop write error injection is unfixable, remove it
>   xfs: fix off-by-one-block in xfs_discard_folio()
> 
> Eric Sandeen (1):
>   xfs: short circuit xfs_growfs_data_private() if delta is zero
> 
> Guo Xuenan (2):
>   xfs: wait iclog complete before tearing down AIL
>   xfs: fix super block buf log item UAF during force shutdown
> 
> Hironori Shiina (1):
>   xfs: get root inode correctly at bulkstat
> 
> Long Li (2):
>   xfs: fix sb write verify for lazysbcount
>   xfs: fix incorrect i_nlink caused by inode racing

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/iomap/buffered-io.c       | 254 ++++++++++++++++++++++++++++++++++-
>  fs/iomap/iter.c              |  19 ++-
>  fs/xfs/libxfs/xfs_bmap.c     |   8 +-
>  fs/xfs/libxfs/xfs_errortag.h |  12 +-
>  fs/xfs/libxfs/xfs_refcount.c | 146 +++++++++++++++++---
>  fs/xfs/libxfs/xfs_sb.c       |   7 +-
>  fs/xfs/xfs_aops.c            |  37 ++---
>  fs/xfs/xfs_bmap_util.c       |  10 +-
>  fs/xfs/xfs_bmap_util.h       |   2 +-
>  fs/xfs/xfs_buf.c             |   1 +
>  fs/xfs/xfs_buf_item.c        |   2 +
>  fs/xfs/xfs_error.c           |  27 +++-
>  fs/xfs/xfs_file.c            |   2 +-
>  fs/xfs/xfs_fsops.c           |   4 +
>  fs/xfs/xfs_icache.c          |   6 +
>  fs/xfs/xfs_inode.c           |  16 ++-
>  fs/xfs/xfs_ioctl.c           |   4 +-
>  fs/xfs/xfs_iomap.c           | 177 ++++++++++++++----------
>  fs/xfs/xfs_iomap.h           |   6 +-
>  fs/xfs/xfs_log.c             |  53 ++++----
>  fs/xfs/xfs_mount.c           |  15 +++
>  fs/xfs/xfs_pnfs.c            |   6 +-
>  include/linux/iomap.h        |  47 +++++--
>  23 files changed, 683 insertions(+), 178 deletions(-)
> 
> -- 
> 2.44.0.769.g3c40516874-goog
> 
> 
