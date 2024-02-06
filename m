Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD173196
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 05:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707197063; cv=none; b=WA0KYETVuLarWI1PcKymYaCXW3VHNeEo4bwRIoZd9QdIXhrbWGZrMDZa5MFZNevw11e0mGP0P31+yao2zX3cF1oZHUAIPckM8V0PShafWs9xJHM1yHwdUoCueGGjQ/ZBoszfE3mhLfQBl4c2Gc8tXYU1etIhyeK+GlKLz29yP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707197063; c=relaxed/simple;
	bh=89Mh0CMhsjSzkeY9ielS7vk2zt3NkjXa/EV+YenbvvQ=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=d3NFuqNZMFVolTQ3s9NKgjmH0CrWJ/vWVxaE6VisaBRhk7+aTbzmOoDZQkjmAeVfe7ScperSkTh90D0LPeVaLuB+4cZk39sQZ2ZyqIN0lbwakpDmzb5omgryncR18HdT/bBIS9VMoUaX+COltftJGrxF0bQdkSC8MOJL8BQXB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFwpM/vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFwpM/vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E437C433F1;
	Tue,  6 Feb 2024 05:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707197062;
	bh=89Mh0CMhsjSzkeY9ielS7vk2zt3NkjXa/EV+YenbvvQ=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=lFwpM/vD3gAEVGPQ9Wc8ETyNKRt23sC721jmdj4/aqDwD1GsiTzJvogfAEgs4MpCK
	 Vw1V98Hm9PQ2AKkvRpfyG2yE0Ixl+N7yj9mTEkq4PoUQyylDwOW7Cz3lmQcgT+lgx5
	 aAmc+kBHS18eACiwDBfG0QU/4TnKMfOZVvV/YduiYRk02QF7iOP5qIHrAYmMDDGCDR
	 98f4zybi6+6Mts9Fwu1eKu1GrsYEAWIr3xSWFsuAeAGv0gn12cQJDZRAcicPT6mBf3
	 eMGIjj0KxC7QuGcKpEcFKe9FGPXxn4NtezR0TDlzDB5nxSu7vpkptk83kBUBtScOtD
	 4Uwu7HO/bOihg==
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE v2 00/21] xfs backports for 6.6.y (from v6.7)
Date: Tue, 06 Feb 2024 10:53:13 +0530
In-reply-to: <20240205222011.95476-1-catherine.hoang@oracle.com>
Message-ID: <87h6im9ncs.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Feb 05, 2024 at 02:19:50 PM -0800, Catherine Hoang wrote:
> Hi all,
>
> This series contains backports for 6.6 from the 6.7 release. Tested on 30
> runs of kdevops with the following configurations:
>
> 1. CRC
> 2. No CRC (512 and 4k block size)
> 3. Reflink (1k and 4k block size)
> 4. Reflink without rmapbt
> 5. External log device
>

Looks good to me.

Acked-by: Chandan Babu R <chandanbabu@kernel.org>

> Changes from v1:
> - add "MAINTAINERS: add Catherine as xfs maintainer for 6.6.y"
>
> Anthony Iliopoulos (1):
>   xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
>
> Catherine Hoang (2):
>   MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
>   xfs: allow read IO and FICLONE to run concurrently
>
> Cheng Lin (1):
>   xfs: introduce protection for drop nlink
>
> Christoph Hellwig (4):
>   xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
>   xfs: only remap the written blocks in xfs_reflink_end_cow_extent
>   xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
>   xfs: respect the stable writes flag on the RT device
>
> Darrick J. Wong (8):
>   xfs: bump max fsgeom struct version
>   xfs: hoist freeing of rt data fork extent mappings
>   xfs: prevent rt growfs when quota is enabled
>   xfs: rt stubs should return negative errnos when rt disabled
>   xfs: fix units conversion error in xfs_bmap_del_extent_delay
>   xfs: make sure maxlen is still congruent with prod when rounding down
>   xfs: clean up dqblk extraction
>   xfs: dquot recovery does not validate the recovered dquot
>
> Dave Chinner (1):
>   xfs: inode recovery does not validate the recovered inode
>
> Leah Rumancik (1):
>   xfs: up(ic_sema) if flushing data device fails
>
> Long Li (2):
>   xfs: factor out xfs_defer_pending_abort
>   xfs: abort intent items when recovery intents fail
>
> Omar Sandoval (1):
>   xfs: fix internal error from AGFL exhaustion
>
>  MAINTAINERS                     |  1 +
>  fs/xfs/Kconfig                  |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.c        | 21 +++--------
>  fs/xfs/libxfs/xfs_defer.c       | 28 +++++++++------
>  fs/xfs/libxfs/xfs_defer.h       |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c   |  3 ++
>  fs/xfs/libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h          |  2 +-
>  fs/xfs/xfs_bmap_util.c          | 24 +++++++------
>  fs/xfs/xfs_dquot.c              |  5 +--
>  fs/xfs/xfs_dquot_item_recover.c | 21 +++++++++--
>  fs/xfs/xfs_file.c               | 63 ++++++++++++++++++++++++++-------
>  fs/xfs/xfs_inode.c              | 24 +++++++++++++
>  fs/xfs/xfs_inode.h              | 17 +++++++++
>  fs/xfs/xfs_inode_item_recover.c | 14 +++++++-
>  fs/xfs/xfs_ioctl.c              | 30 ++++++++++------
>  fs/xfs/xfs_iops.c               |  7 ++++
>  fs/xfs/xfs_log.c                | 23 ++++++------
>  fs/xfs/xfs_log_recover.c        |  2 +-
>  fs/xfs/xfs_reflink.c            |  5 +++
>  fs/xfs/xfs_rtalloc.c            | 33 +++++++++++++----
>  fs/xfs/xfs_rtalloc.h            | 27 ++++++++------
>  23 files changed, 312 insertions(+), 102 deletions(-)


-- 
Chandan
