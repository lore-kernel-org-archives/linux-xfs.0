Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864301369B8;
	Tue,  9 Apr 2024 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676776; cv=none; b=LiE4x3KUQjWqd7XhAsPD8jZucx6c7ngZO6bTLsuLZlDMLw/AdhNItlMOhdxWTcJjEbg0XdYPS7DY85Ddt46XFauYM+tkf2PbsEyPU2C5EDtf0RcRU8njm8opGrL2avBfASsCBStByC8BF6uL0K66VUGp5L1X+fmnkyEHYnH41bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676776; c=relaxed/simple;
	bh=tIS88BbScAu9XLlrPxHSOTM/kYT7LrhpXHaasVFyJgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFpD/RLiffSV7+TLSHRSbnLrteTatqlWwe89X5MHOsXJe7RK9o6JYehPfN5L5ttx2wGHb+JvIqyL7Kaec7FQBUkQ40Wr+T4+8a0JYI4jUXZOqsvamDTgf57c93qC+BLqm/fkZUmq2yMTX5i4f0i3JCiTrjmS1Z2v2pPKcNwqrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxKGRfKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxKGRfKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D9C433F1;
	Tue,  9 Apr 2024 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712676776;
	bh=tIS88BbScAu9XLlrPxHSOTM/kYT7LrhpXHaasVFyJgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LxKGRfKDzzz7wmii9FtHQ08UKOqP+bbC5aFQjJBXKHfxJfw5CZTA9O9kaNbLPBgix
	 gu0mZJallZV8rFNeg5CpBlTpO9fKDXPN9sScBf4vkglO5FvysBLzka2SkrK/DSPBBh
	 STKkNadojgOqv41aY5mIRg0Szymetlhesa1qdjUGU0nq0Eo5ZzBBMQxUvG4wuyiIvA
	 bBFkfbAAAn4epTG1Zcp7+huRf9HK4r7R4No3yGzXKuMZ22XWYaDS6BjEOj8TM150M2
	 aHl+UkiHI7CPKi+OkDdTiM5sEd1p5Xfka5J6oxpYlIcexAfsqzThgKMYC+ZswWPQvw
	 n+iiAYmHa8pgA==
Date: Tue, 9 Apr 2024 08:32:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs/078: remove the 512 byte block size sub-case
Message-ID: <20240409153255.GD634366@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-4-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:40PM +0200, Christoph Hellwig wrote:
> 512 byte block sizes are only supported for v4 file systems, and
> xfs/078 crudely forces use of v4 file systems for it.  This doesn't
> work if the kernel is built without v4 support.  Given that v4
> support is slowly being phased out and 512 byte block sizes have never
> been common, drop this part of the test.

I've long wondered just how many people actually used that blocksize...

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/078     |  9 ++-------
>  tests/xfs/078.out | 18 ------------------
>  2 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 1f475c963..501551e5e 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -69,12 +69,8 @@ _grow_loop()
>  	echo
>  
>  	echo "*** mkfs loop file (size=$original)"
> -	mkfs_crc_opts=""
> -	if [ $bsize -lt 1024 -a -z "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
> -		mkfs_crc_opts="-m crc=0"
> -	fi

...because this was particularly nasty.  Why wouldn't this test have
skipped this iteration if the fs config doesn't support 512 blocksizes?

Who cares.  Anyway,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -	$MKFS_XFS_PROG $mkfs_crc_opts -b size=$bsize $dparam $LOOP_DEV \
> -		| _filter_mkfs 2>/dev/null
> +	$MKFS_XFS_PROG -b size=$bsize $dparam $LOOP_DEV | \
> +		_filter_mkfs 2>/dev/null
>  
>  	echo "*** extend loop file"
>  	_destroy_loop_device $LOOP_DEV
> @@ -104,7 +100,6 @@ _grow_loop $((168024*4096)) 1376452608 4096 1
>  
>  # Some other blocksize cases...
>  _grow_loop $((168024*2048)) 1376452608 2048 1
> -_grow_loop $((168024*512)) 1376452608 512 1 16m
>  _grow_loop $((168024*1024)) 688230400 1024 1
>  
>  # Other corner cases suggested by dgc
> diff --git a/tests/xfs/078.out b/tests/xfs/078.out
> index cc3c47d13..7bf5ed03e 100644
> --- a/tests/xfs/078.out
> +++ b/tests/xfs/078.out
> @@ -37,24 +37,6 @@ data blocks changed from 168024 to 672096
>  *** unmount
>  *** check
>  
> -=== GROWFS (from 86028288 to 1376452608, 512 blocksize)
> -
> -*** mkfs loop file (size=86028288)
> -meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> -data     = bsize=XXX blocks=XXX, imaxpct=PCT
> -         = sunit=XXX swidth=XXX, unwritten=X
> -naming   =VERN bsize=XXX
> -log      =LDEV bsize=XXX blocks=XXX
> -realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> -*** extend loop file
> -wrote 512/512 bytes at offset 1376452608
> -*** mount loop filesystem
> -*** grow loop filesystem
> -xfs_growfs --BlockSize=512 --Blocks=163840
> -data blocks changed from 163840 to 2688384
> -*** unmount
> -*** check
> -
>  === GROWFS (from 172056576 to 688230400, 1024 blocksize)
>  
>  *** mkfs loop file (size=172056576)
> -- 
> 2.39.2
> 
> 
