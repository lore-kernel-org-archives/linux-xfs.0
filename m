Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A731862;
	Fri, 21 Nov 2025 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743438; cv=none; b=WMOx6N1G2F5unezmn0IbKaZyWpJerKknkiE5F05mr2k21CB/nFmvL8XsBjtnLUI6flKp224nHOpXb4i0vqFaZ/661affbw00OzDwN33XkJyzxTj0eKB4dPlFcWrZEnuvMsG1DxSFSeVbbjkjDOZ+r6x/9Un6mGbRkT8AdSjOUYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743438; c=relaxed/simple;
	bh=O0NeCM1aqHsDdVcalf19UL/Q3n5vMpE7SNHyhehrMQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cbuvjd+F8dZz8fFGwNqgVi+kIsJKA5EPquD0QSWtFz+UMNbE2XCOXIhij2jHhn0RxnwPVfeDsTCCPwjiPXcDT4jc0ag9PM3xUIl2l++05sOsuy/ilmbPLi5xgDFPHA/jst98EI9VYj2F6rAxwUHqrX32j2JvF3m2PNeFP2nICLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0x0oeDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0x0oeDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831D5C116C6;
	Fri, 21 Nov 2025 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763743437;
	bh=O0NeCM1aqHsDdVcalf19UL/Q3n5vMpE7SNHyhehrMQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0x0oeDI+HHsEBve0VHEhZfA0aNPbQWAev17BzBOfBGSNx3ww+dILKa5enpMIn11o
	 5hCZuIe0y079ztEAGxFXWkBeQtwm527v0F1STew1+pogQVUJDZNODxYmVmcSToSGzK
	 RPZKsY08tdIT4WM7W+ZVfl4xeYrOpXOPxchP6pUpZ75ikcOXSf7wkR31Va2PN6mUgi
	 KG9vfzUiOlZ8SH9ByRL5vJLuV20THTWqQToE2PLqXfn0Xca4+tBfXnVDwNjVvZm6/5
	 MqGJ4Le3o3MJx10g9iwpqG/NApawDj895WY3e7EQJCa2jBMD7qkqfqy9y2qTE0RLY2
	 naoEs/Mslwysg==
Date: Fri, 21 Nov 2025 08:43:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/049: create the nested XFS file systems on the
 loop device
Message-ID: <20251121164357.GN196366@frogsfrogsfrogs>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121071013.93927-3-hch@lst.de>

On Fri, Nov 21, 2025 at 08:10:06AM +0100, Christoph Hellwig wrote:
> Without this I see failures on 4k sector size RT devices, as mkfs.xfs
> can't pick up the logical block size on files.  Note that the test
> already does this for the nested ext2 image as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/049 | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index 07feb58c9ad6..a3f478fa9351 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -58,7 +58,9 @@ mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mount"
>  
>  _log "Create xfs fs in file on scratch"
> -${MKFS_XFS_PROG} -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
> +truncate -s 40m $SCRATCH_MNT/test.xfs
> +loop_dev1=$(_create_loop_device $SCRATCH_MNT/test.xfs)
> +${MKFS_XFS_PROG} -f $loop_dev1 \
>      >> $seqres.full 2>&1 \
>      || _fail "!!! failed to mkfs xfs"
>  
> @@ -67,7 +69,6 @@ mkdir $SCRATCH_MNT/test $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
>      || _fail "!!! failed to make mount points"
>  
>  _log "Mount xfs via loop"
> -loop_dev1=$(_create_loop_device $SCRATCH_MNT/test.xfs)
>  _mount $loop_dev1 $SCRATCH_MNT/test >> $seqres.full 2>&1 \
>      || _fail "!!! failed to loop mount xfs"
>  
> -- 
> 2.47.3
> 
> 
