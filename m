Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C529405
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570846; cv=none; b=sPS1+DHzyQSuRekZRiN9OYx3OS3hLZ7u6ZWUYMtHt/mj5MV4ngtqjRAMjTB+R5lPKb7cS5OkRmPtZVVJUX01cnd7siv/Vti59IjK81eH3+F9GDRJG9HwNakBNpCK3THZ9LtD06DxI8eHaXzW7HBykkLU7+EV2YNTkzlIuJ5e5j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570846; c=relaxed/simple;
	bh=U3CS+SUm0fIBHwcBGzB0kVPv+nlDbV4nWe7CD5di3Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcMZLiITUK7TYjY/yWz91e1TMFtf33RqwMH09H4WAwQMHh3UPbB6mdRh3KuJm2PtMWPtYjHaWdI1RTqOmUixnpomOvp4fT5rIL6bKmsygftlsV2ilviun43tQyDAfKg4Cu0GD49Za+EW9SnznZnpEaSLo6gV5/1VfdEnxCeuQYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4DdaiHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4DdaiHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4DEC4CEE3;
	Fri, 21 Mar 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742570846;
	bh=U3CS+SUm0fIBHwcBGzB0kVPv+nlDbV4nWe7CD5di3Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N4DdaiHu8E24zQpzqea1jIM0slGjHQJa4XEaobaUHWU/V12yAbo+jJvR1D1SRj7Va
	 t+fuiWCvupknwTv6U6hdSUoarcBpcWG58+zeUP6B8C5zEyvye3qUbG2aKNCLbmlMSC
	 hhRTKPWPlIrAKMVMBoXzeu+i4k/WgXgSkiK9RznbqQjGvWJZDAwGdrblFXG+zSt3Qq
	 t/XRvj12bzv/7HSh0NOOxXVLos8W35IKc0PW/SkIz48NI2Y/dhT8wr5KOV+QHTY+px
	 P3s8UMrF1zmLrobRWKAcEchHnchwyMeAT8kVNEWFo6UaGMUBX30fMARpcITal4QiQ/
	 Xtp00fsn0dVcQ==
Date: Fri, 21 Mar 2025 08:27:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bodonnel@redhat.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@infradead.org
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <20250321152725.GL2803749@frogsfrogsfrogs>
References: <20250321142848.676719-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321142848.676719-2-bodonnel@redhat.com>

On Fri, Mar 21, 2025 at 09:28:49AM -0500, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> In certain cases, if a block is so messed up that crc, uuid and magic
> number are all bad, we need to not only detect in phase3 but fix it
> properly in phase6. In the current code, the mechanism doesn't work
> in that it only pays attention to one of the parameters.
> 
> Note: in this case, the nlink inode link count drops to 1, but
> re-running xfs_repair fixes it back to 2. This is a side effect that
> should probably be handled in update_inode_nlinks() with separate patch.
> Regardless, running xfs_repair twice fixes the issue. Also, this patch
> fixes the issue with v5, but not v4 xfs.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

That makes sense.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Bonus question: does longform_dir2_check_leaf need a similar correction
for:

	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
		error = check_da3_header(mp, bp, ip->i_ino);
		if (error) {
			libxfs_buf_relse(bp);
			return error;
		}
	}

--D

> 
> v2: remove superfluous wantmagic logic
> 
> ---
>  repair/phase6.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4064a84b2450..9cffbb1f4510 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2364,7 +2364,6 @@ longform_dir2_entry_check(
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		const struct xfs_buf_ops *ops;
>  		int			 error;
> -		struct xfs_dir2_data_hdr *d;
>  
>  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
>  		if (bmap_next_offset(ip, &next_da_bno)) {
> @@ -2404,9 +2403,7 @@ longform_dir2_entry_check(
>  		}
>  
>  		/* check v5 metadata */
> -		d = bp->b_addr;
> -		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
> -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> +		if (xfs_has_crc(mp)) {
>  			error = check_dir3_header(mp, bp, ino);
>  			if (error) {
>  				fixit++;
> -- 
> 2.48.1
> 
> 
