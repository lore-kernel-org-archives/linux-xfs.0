Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE1337B41F;
	Thu, 20 Aug 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242284; cv=none; b=hFHWDVNaa7dYQdLJwMJ+KFjmx85VuRWIUH8i/lXYTOCOMrdg/B812xOHIDbggTwOP0QEIrq0MruVPIPUyibqDW4XXgAinXro5Gnd+QPoeuRGg5c2YdXUveUJUmEVcebkqD2y+MHVPOIYJUwKoiyjAqfDPVZSY41o6N+FgnH6Z6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242284; c=relaxed/simple;
	bh=aclcvz+O+aIpOJSnFeQB+T8Wrsij8jiKj4hIZOiCzWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/pQ+Tk0KTuPoenwPWUYDWEaKcFowgeaYwYOZ2C2DhHxzIQMQWFo5ZsvRu8pvdA26cDa5NN4tNKsVV9/YcFsJonN/dVu5HBPocGFoH2WFoCQ0TrUoGCj8lCONLz7cas5tH5FfmMCDujkNbXIXFRRNnmWsGArt3cmtEuE9tsREVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAN75kfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAN75kfq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E8BF1F000E9;
	Thu, 20 Aug 2026 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787242283;
	bh=qJ11aVZ0ZTIsO+o2m2qGnQLz9ddNc0AhiXdFoKFMIp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eAN75kfqcV9Yj4BSvWcVpTea/SS1l2QfSInM1PW8GCMS6xyctATnDvYm0KM7o8GZ4
	 smGNzNwl9z/rGLn7o9NjvQytetym2s16XmFHbULeqX49JqVfqi1C+t1lGMoqUfb+ie
	 3x7uor4wb5F9KgylJydPIUktvOX2YdmJbqAp+HN0M8LJ+gOqkSlTd584Dj2F8KYe1m
	 KiKu8VRdTi/3kDKqr0hJqKqwbRxP6K3CnmvUzQyrqZLmgUf2QBUMCalRQ6JwrfNOKR
	 t/ppIj6UMAW48owubWlnOYf+PrYLu+KJKsUdFxJdo6wNSXZAGGz5WcuwWL1Me8tItm
	 p4OOgTF4iMU+A==
Date: Thu, 20 Aug 2026 09:11:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: revalidate cached COW fork mappings during writeback
Message-ID: <20260820161123.GH6072@frogsfrogsfrogs>
References: <20260820-b4-xfs-cow-wb-revalidate-v1-1-8a19080799ea@anthonyvardaro.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820-b4-xfs-cow-wb-revalidate-v1-1-8a19080799ea@anthonyvardaro.com>

On Thu, Aug 20, 2026 at 12:21:38AM +0000, Anthony Vardaro (Anthropic) wrote:
> Writeback can write a folio through a cached COW fork mapping after the
> blocks behind it have been freed. Since commit d9252d526ba6 ("xfs:
> validate writeback mapping using data fork seq counter") a cached data
> fork mapping is dropped when the fork changes, but a COW fork mapping is
> accepted on range alone, and since commit 3b3508980730 ("xfs: remove
> superfluous writeback mapping eof trimming") nothing trims it to EOF. So
> when close() or truncate frees the post-EOF COW blocks and the file is
> then appended, the same writeback pass writes the new folio into blocks
> the inode no longer owns. fsync() returns 0 and the range reads back as
> zeroes, or the data lands in another file.
> 
> Check cow_seq against the COW fork if_seq for COW mappings as well, and
> only sample cow_seq where the mapping is built so a failed conversion
> cannot pair a stale mapping with a fresh sequence number.
> 
> This costs one extent lookup and one cancelled transaction per
> invalidation: about 5% more fsync time on random 4k overwrites of a
> reflinked file, nothing measurable on sequential writeback.
> 
> Fixes: d9252d526ba6 ("xfs: validate writeback mapping using data fork seq counter")
> Cc: stable@vger.kernel.org # v5.1
> Assisted-by: Claude:unspecified
> Signed-off-by: Anthony Vardaro (Anthropic) <me@anthonyvardaro.com>
> ---
> An fstests case for this, using the wb_delay_ms error injection knob,
> follows separately.
> 
> Backport note: kernels before v6.2 do not have
> trace_xfs_wb_cow_iomap_invalid() (added by commit c2beff99eb03), so
> drop that call there. Kernels before v5.5 test wpc->fork ==
> XFS_COW_FORK instead of IOMAP_F_SHARED and have no XFS_WPC().
> ---
>  fs/xfs/xfs_aops.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2a0c54256..c043e5bad 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -304,12 +304,22 @@ xfs_imap_valid(
>  	    offset >= wpc->iomap.offset + wpc->iomap.length)
>  		return false;
>  	/*
> -	 * If this is a COW mapping, it is sufficient to check that the mapping
> -	 * covers the offset. Be careful to check this first because the caller
> -	 * can revalidate a COW mapping without updating the data seqno.
> +	 * A COW mapping is only valid while the COW fork is unchanged. After a
> +	 * change, the blocks behind the mapping can already be freed, for
> +	 * example by the post-EOF trim on close. Do this check before the
> +	 * data fork check, because the caller can revalidate a COW mapping
> +	 * without updating the data seqno.
>  	 */
> -	if (wpc->iomap.flags & IOMAP_F_SHARED)
> +	if (wpc->iomap.flags & IOMAP_F_SHARED) {
> +		if (!ip->i_cowfp)
> +			return false;
> +		if (XFS_WPC(wpc)->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)) {

The buffered write path has similar data/cow fork sequence counter
revalidation code, so would it be a better idea to adapt the writeback
path to sample the sequence counter via xfs_iomap_inode_sequence in
xfs_map_blocks, and re-check that in xfs_imap_valid()?

I weakly hinted at this a few years ago when we were adapting the
buffered write path, see [1].

--D

[1] https://lore.kernel.org/linux-xfs/Y2mcOCpKiDb4nf1X@magnolia/

> +			trace_xfs_wb_cow_iomap_invalid(ip, &wpc->iomap,
> +					XFS_WPC(wpc)->cow_seq, XFS_COW_FORK);
> +			return false;
> +		}
>  		return true;
> +	}
>  
>  	/*
>  	 * This is not a COW mapping. Check the sequence number of the data fork
> @@ -359,9 +369,8 @@ xfs_map_blocks(
>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
> -	 * check for overlap on reflink inodes unless the mapping is already a
> -	 * COW one, or the COW fork hasn't changed from the last time we looked
> -	 * at it.
> +	 * check for overlap on reflink inodes unless the COW fork hasn't
> +	 * changed from the last time we looked at it.
>  	 *
>  	 * It's safe to check the COW fork if_seq here without the ILOCK because
>  	 * we've indirectly protected against concurrent updates: writeback has
> @@ -394,16 +403,14 @@ xfs_map_blocks(
>  	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
>  		cow_fsb = imap.br_startoff;
>  	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
> -		XFS_WPC(wpc)->cow_seq = READ_ONCE(ip->i_cowfp->if_seq);
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
>  		whichfork = XFS_COW_FORK;
>  		goto allocate_blocks;
>  	}
>  
>  	/*
> -	 * No COW extent overlap. Revalidate now that we may have updated
> -	 * ->cow_seq. If the data mapping is still valid, we're done.
> +	 * No COW extent overlap. If the data mapping is still valid, we're
> +	 * done.
>  	 */
>  	if (xfs_imap_valid(wpc, ip, offset)) {
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 
> ---
> base-commit: 0877338ade31b825884a744e03f27c8de300f101
> change-id: 20260813-b4-xfs-cow-wb-revalidate-0427d1fb36d7
> 
> Best regards,
> --  
> Anthony Vardaro (Anthropic) <me@anthonyvardaro.com>
> 
> 
