Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195A1A76AE
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872832; cv=none; b=eQ0TVHKDHpFU28ULT1J6M9NVD73S+UEaOpILzwqaAQUD68yLJMM+4o9VeSMxYiwVn5vaijawX0Sm9OWDNTJ8X4tl1SCjSCXXeqTdL/Vw1sy2YNMKQIAg7Br83xAn3DJisHyVUgkbjhZwDOQWa6QnIryLmMk0QMQ36dtY4KAr7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872832; c=relaxed/simple;
	bh=rmfTfv9AtBAcA2kucdvtJZwQvc2MNreedMFZxSzz3sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WS8lWi9vFKtlKT7UNvA8FVjeVsThBZZdX4rtmihPRfIR8y5U7t4GLplyW5Vum/TUJFC7XhxNH8H8pBcTceeRFrS0nx8CZhE5XQzE1SvcRIa+fB7Gz8rvTu841OnmdQXNtXJplUdmge/14Ih5fw495b/MH2fEQvBVgvvX3TS3kkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOdJ9ulp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOdJ9ulp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE3C4CEDD;
	Thu,  6 Feb 2025 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738872832;
	bh=rmfTfv9AtBAcA2kucdvtJZwQvc2MNreedMFZxSzz3sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOdJ9ulpeHLJmMEnux5cR9eRDnaO9bVCEDli2UGA9/aDXO+hLAEOyzpwiJCyb8mIe
	 NlaJWISyOEdGwZSNdxzX8Gx/gdeQN0hjEewn/Q3GgW94ls1SEFKBVXPF9XTKeZd6mf
	 9RQz5uHoDyx2Je01EKee0bKIwBPkCPUFWDajNRatvxFyQAP4srjl+CxLYAknM7zv1U
	 5H6xZY3nLVyQyQ3ZsItd2ZsbD1XP2ce8amUMGeL8X/8MtIBKaOXx0jfFkhD0amlxUj
	 Fh0H10wY2iYW9cnRpyG7tSNwZMQ4l81Aa+/l9SwvGc1HqsaaAYmRDyyYwsN8nVCKUO
	 z1YqoOYAPGkQw==
Date: Thu, 6 Feb 2025 12:13:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: skip always_cow inodes in
 xfs_reflink_trim_around_shared
Message-ID: <20250206201351.GH21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-5-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:20AM +0100, Christoph Hellwig wrote:
> xfs_reflink_trim_around_shared tries to find shared blocks in the
> refcount btree.  Always_cow inodes don't have that tree, so don't
> bother.
> 
> For the existing always_cow code this is a minor optimization.  For
> the upcoming zoned code that can do COW without the rtreflink code it
> avoids triggering a NULL pointer dereference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm.  So this is to support doing COW on non-reflink zoned filesystems?
How then do we protect the refcount intent log items from being replayed
on an oler kernel?  Are they effectively protected by the zoned feature
bit XFS_SB_FEAT_INCOMPAT_ZONED?

If so then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 59f7fc16eb80..3e778e077d09 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -235,7 +235,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
> +	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> -- 
> 2.45.2
> 
> 
