Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAAE17DFFD
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727716155; cv=none; b=IYvFdn9hXRoSmUFk97FybWjSNB8MxwVSQbMZ8OBs5tEGTVkGMHFECsVh6qNyDi8KdMQpQttBXoyqKn3TeSgIlDChnaPNTmkIqlP4/9NJL4PUq8xGDvo7Nkwa41FKTlBhGiaXBC4V51SbDILVf5OoIaI4lVjraEL6hfMfQN09E1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727716155; c=relaxed/simple;
	bh=a1wEkG0r6+BtCtAvn5qSr6DfWkR5qUSmMyuuCh+myyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4SqcVcHuByKY05MlJcm4g5pFXB3UfkC44yYdQlWlHOdrVDR9jwhQZUPPzainALyo3GiHtTe3ugAGwsuOhfwBYXctggHM+uhCqu0LE6isNF6zjRaxkkYIyBepPkWYqepcdEv3L2X29h1+aMPsioJh+5Np45wwJRR0TA1YoGm5+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ls/VCIur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ls/VCIur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2A9C4CEC7;
	Mon, 30 Sep 2024 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727716154;
	bh=a1wEkG0r6+BtCtAvn5qSr6DfWkR5qUSmMyuuCh+myyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ls/VCIurZWWF/JLf1WwwmbuQCtA3jY65NSYCmhjqF3aI9VvkqgQ04kPxoUHHREIu5
	 tv1LXJaiF8tqskKVmVbn/jYGE3a9dM+y2Rfp/uVk1NlYwxzhlngCSMWIlB78WNEN6f
	 4VfUk4gy0El0zNeYwzt9EdGz8sKhaxHvZiZ/Hnbo2vU5NxM3jkHjJdCQWdcEZQOPnn
	 3NbKItTv8n+PyB3ZvRLTS4OaNST/uCvbS347kAZWkYQwDUj6YlALqVeLceiH6PhLht
	 vSAp8KbN3Lm8EQ9BIPlTsioPYJehzdhcPVyxqBlYgYetQDFU8e3JpIvrE/wlzwsLcH
	 t1/EJcclZGYlA==
Date: Mon, 30 Sep 2024 10:09:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: skip background cowblock trims on inodes open
 for write
Message-ID: <20240930170914.GU21853@frogsfrogsfrogs>
References: <20240903124713.23289-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903124713.23289-1-bfoster@redhat.com>

On Tue, Sep 03, 2024 at 08:47:13AM -0400, Brian Foster wrote:
> The background blockgc scanner runs on a 5m interval by default and
> trims preallocation (post-eof and cow fork) from inodes that are
> otherwise idle. Idle effectively means that iolock can be acquired
> without blocking and that the inode has no dirty pagecache or I/O in
> flight.

Hey, can we get this data corruption fix staged for 6.12-rc2, please?
Yesterday's fstests push contained the exerciser for this bug.

--D

> This simple mechanism and heuristic has worked fairly well for
> post-eof speculative preallocations. Support for reflink and COW
> fork preallocations came sometime later and plugged into the same
> mechanism, with similar heuristics. Some recent testing has shown
> that COW fork preallocation may be notably more sensitive to blockgc
> processing than post-eof preallocation, however.
> 
> For example, consider an 8GB reflinked file with a COW extent size
> hint of 1MB. A worst case fully randomized overwrite of this file
> results in ~8k extents of an average size of ~1MB. If the same
> workload is interrupted a couple times for blockgc processing
> (assuming the file goes idle), the resulting extent count explodes
> to over 100k extents with an average size <100kB. This is
> significantly worse than ideal and essentially defeats the COW
> extent size hint mechanism.
> 
> While this particular test is instrumented, it reflects a fairly
> reasonable pattern in practice where random I/Os might spread out
> over a large period of time with varying periods of (in)activity.
> For example, consider a cloned disk image file for a VM or container
> with long uptime and variable and bursty usage. A background blockgc
> scan that races and processes the image file when it happens to be
> clean and idle can have a significant effect on the future
> fragmentation level of the file, even when still in use.
> 
> To help combat this, update the heuristic to skip cowblocks inodes
> that are currently opened for write access during non-sync blockgc
> scans. This allows COW fork preallocations to persist for as long as
> possible unless otherwise needed for functional purposes (i.e. a
> sync scan), the file is idle and closed, or the inode is being
> evicted from cache. While here, update the comments to help
> distinguish performance oriented heuristics from the logic that
> exists to maintain functional correctness.
> 
> Suggested-by: Darrick Wong <djwong@kernel.org>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Reorder logic and update comments in xfs_prep_free_cowblocks().
> v1: https://lore.kernel.org/linux-xfs/20240214165231.84925-1-bfoster@redhat.com/
> 
>  fs/xfs/xfs_icache.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index cf629302d48e..900a6277d931 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1241,14 +1241,17 @@ xfs_inode_clear_eofblocks_tag(
>  }
>  
>  /*
> - * Set ourselves up to free CoW blocks from this file.  If it's already clean
> - * then we can bail out quickly, but otherwise we must back off if the file
> - * is undergoing some kind of write.
> + * Prepare to free COW fork blocks from an inode.
>   */
>  static bool
>  xfs_prep_free_cowblocks(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_icwalk	*icw)
>  {
> +	bool			sync;
> +
> +	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
> +
>  	/*
>  	 * Just clear the tag if we have an empty cow fork or none at all. It's
>  	 * possible the inode was fully unshared since it was originally tagged.
> @@ -1260,9 +1263,21 @@ xfs_prep_free_cowblocks(
>  	}
>  
>  	/*
> -	 * If the mapping is dirty or under writeback we cannot touch the
> -	 * CoW fork.  Leave it alone if we're in the midst of a directio.
> +	 * A cowblocks trim of an inode can have a significant effect on
> +	 * fragmentation even when a reasonable COW extent size hint is set.
> +	 * Therefore, we prefer to not process cowblocks unless they are clean
> +	 * and idle. We can never process a cowblocks inode that is dirty or has
> +	 * in-flight I/O under any circumstances, because outstanding writeback
> +	 * or dio expects targeted COW fork blocks exist through write
> +	 * completion where they can be remapped into the data fork.
> +	 *
> +	 * Therefore, the heuristic used here is to never process inodes
> +	 * currently opened for write from background (i.e. non-sync) scans. For
> +	 * sync scans, use the pagecache/dio state of the inode to ensure we
> +	 * never free COW fork blocks out from under pending I/O.
>  	 */
> +	if (!sync && inode_is_open_for_write(VFS_I(ip)))
> +		return false;
>  	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
>  	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
>  	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> @@ -1298,7 +1313,7 @@ xfs_inode_free_cowblocks(
>  	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
>  		return 0;
>  
> -	if (!xfs_prep_free_cowblocks(ip))
> +	if (!xfs_prep_free_cowblocks(ip, icw))
>  		return 0;
>  
>  	if (!xfs_icwalk_match(ip, icw))
> @@ -1327,7 +1342,7 @@ xfs_inode_free_cowblocks(
>  	 * Check again, nobody else should be able to dirty blocks or change
>  	 * the reflink iflag now that we have the first two locks held.
>  	 */
> -	if (xfs_prep_free_cowblocks(ip))
> +	if (xfs_prep_free_cowblocks(ip, icw))
>  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
>  	return ret;
>  }
> -- 
> 2.45.0
> 
> 
