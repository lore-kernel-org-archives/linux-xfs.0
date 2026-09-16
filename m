Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F3E44236C
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789564585; cv=none; b=iEzia9lKWnqwfacTNyWiUrLKEpIdyzFQeYXvVnl42S/IB+3sqWhRewA5ocrxPlfMzR6U+hHQgmIrj6sCqDz1Z6p/GNK7tnNHNJQmn9Wg01Yjr2OQglyvcVFRl5NVO81qfA6wz2StjhdwltcE+vpXBVTvnDnBM04mjQLDZUGuMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789564585; c=relaxed/simple;
	bh=pfPWWhl/Oi4nyrANLTUYHGOxHsOKDNSCtHTQUXjuBIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngIWTe7k3LkdCmh4KTgKqyAotAMUQHakfWIyV9sKWZCGQl2SbRp4gDoTjBnk/Hy2WbAdJlZ/9VLQDkpzUUEFov3nPBASWT3zuFXh2LPt3J9VLybiHZuHwRfPqJJk489m0UK5hUmtvXgYDvwEDq42bkxfGmI/mn7NpnhLy5+wswM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXe+FOvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXe+FOvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF071F000FF;
	Wed, 16 Sep 2026 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789564584;
	bh=GxundNYEnH4WJN1X6X9Kb0sVeaXZZ5PLCZYQWbqql/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jXe+FOvYrt7CBwk1aXVFZKLkJgV8whhK8fjm49wacCZ8wdHMaruVvd+3u+xTPl9+N
	 LdZjRLSs+ifvhADMeogfvjmRF8UIXGxB/95JAZQIwy+MhPCoXleEVZy2cokFQOhR/X
	 2Opf/LADeB2xiJK9teLnjZBYmh74onwKVk8DhVPSSUcZyLKRsoI+UF2H8I4T8p50Pj
	 n4BZEbtXrTBYz4pw2czgnS7M95fpGWiofImfD8FopTvIH8utkJP58VF16tSFHHvIVx
	 kCGrexOqWJIbtqGsQSxc1N8yF65HigGTKW2hMAp1NM7X91qfOpyP8xHhC0jhFNHD10
	 zgcrkI4SY9dxA==
Date: Wed, 16 Sep 2026 15:16:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 0/14] xfs: remove unused arguments from many functions
Message-ID: <aqqVSjbSGn-a1moW@nidhogg.toxiclabs.cc>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>

On Mon, Sep 14, 2026 at 05:28:46PM -0500, Eric Sandeen wrote:
> V2: Sorry, that was stale already. This is against for-next in
>     https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git :(
> 
> Seems it's cleanup season lately on the list, so figured I'd play
> too.
> 
> This removes unused arguments (mostly mp) from a bunch of functions.
> 
> I did a quick check of the xfsprogs port, and it should be fine.
> (Left out xfs_rmapbt_maxrecs changes for that reason; all the
> .maxrecs functions in xfs_db need to match.)
> 
> Assisted-by: gcc version 15.3.1 20260722 (Red Hat 15.3.1-1) (GCC)

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Total diffstat:
> 
> $ git diff 654ae5d73c05.. | diffstat
>  libxfs/xfs_attr.c             |   14 ++++++--------
>  libxfs/xfs_bmap.c             |    5 ++---
>  libxfs/xfs_bmap.h             |    2 +-
>  libxfs/xfs_btree_mem.c        |    6 ++----
>  libxfs/xfs_exchmaps.c         |    1 -
>  libxfs/xfs_exchmaps.h         |    3 +--
>  libxfs/xfs_ialloc.c           |    2 +-
>  libxfs/xfs_ialloc_btree.c     |    1 -
>  libxfs/xfs_ialloc_btree.h     |    5 ++---
>  libxfs/xfs_metadir.c          |    2 +-
>  libxfs/xfs_parent.h           |    1 -
>  libxfs/xfs_rmap.c             |   13 ++++++-------
>  libxfs/xfs_rtrefcount_btree.c |    8 ++++----
>  libxfs/xfs_rtrefcount_btree.h |    5 ++---
>  libxfs/xfs_rtrmap_btree.c     |    6 +++---
>  libxfs/xfs_rtrmap_btree.h     |    3 +--
>  libxfs/xfs_trans_resv.c       |    7 +++----
>  libxfs/xfs_types.c            |    7 ++-----
>  libxfs/xfs_types.h            |    7 +++----
>  scrub/bmap.c                  |    9 ++++-----
>  scrub/bmap_repair.c           |    4 ++--
>  scrub/inode_repair.c          |    6 +++---
>  scrub/orphanage.c             |    2 +-
>  scrub/quota.c                 |    2 +-
>  scrub/quota_repair.c          |    4 ++--
>  scrub/rtrefcount_repair.c     |    3 +--
>  scrub/rtrmap_repair.c         |    2 +-
>  xfs_bmap_item.c               |    2 +-
>  xfs_exchmaps_item.c           |    4 ++--
>  xfs_exchrange.c               |    2 +-
>  xfs_inode.c                   |   20 ++++++++++----------
>  xfs_rmap_item.c               |    2 +-
>  xfs_super.c                   |    2 +-
>  xfs_symlink.c                 |    4 ++--
>  34 files changed, 73 insertions(+), 93 deletions(-)
> 
> 
> 
