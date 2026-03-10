Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BF3305962
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154975; cv=none; b=FcQIsTihbtxvTvAenN8ycOb7jW8NgyElDJPwQA3KFQR2y2HYcYSEiQCe9OeKhLQQ0XOom9lzAd0S3FbM8CRO6udDiGXVxuzh9IxgxH6yD/H4HGmpTbD083tRrQ8b/tzF5em3yp1tBTKVOrAgtxQeqeqF13umYlwND8I/3ZJrElc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154975; c=relaxed/simple;
	bh=4IBJS8O9pMClJmgPRxC4s9c8Dv66uhbDHtsW10Lf/mE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z47R7bMGVZLg1dSDfnf6rwqW4/jqUaHAMinhGeyXw1cIRSRWLcv6a7Mpfj6QtcztjWVwu+vgbD/n1WC0zgTnpd9SbEC1OJ7KAMn7aV0oOC0siANIIbRPrA54ZuLUIlICIW0cx88qjoJg+OoCeHkU7H4CaKexWX3YBGqiIqLmxFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgDKcPeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgDKcPeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC0FC19423;
	Tue, 10 Mar 2026 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154975;
	bh=4IBJS8O9pMClJmgPRxC4s9c8Dv66uhbDHtsW10Lf/mE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MgDKcPeopZ+VO0o2jeHUZaa1i7oDRDvFs5QP2hDS5GReRWiv2r6wbAARUifkZO9Dz
	 +WlHsoeYCOzwwW+h8iv1eKRxVXMoft+7j3kh/3psHV3T6cQpl+AZ11fWpKdT/XxbqN
	 tA4WveWz3DkcWzSSPmbS0zMjyLgWT32a7hnJmsT235fZVad04PCsW0UtCdz0Dy12Lk
	 UKcmYQLkmweNiwRKfJtIMWw7NX80nakJs/0u90k+n5CdvKqtPBe2faLGj345tW+YnB
	 6abD+azimWPuYayXexmXRsiMp8coscKvZPzkSRb/AnOrbG9GIy2GwsrcJpQm7C/Dqt
	 sjrNTf/q4YLUQ==
Date: Tue, 10 Mar 2026 08:02:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>,
	linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260310150254.GP1105363@frogsfrogsfrogs>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <20260310004400.GU6033@frogsfrogsfrogs>
 <j2nfikz4ugqs6u25jpf7mlxhvzpiochp7eu4yslm6tjpwprcmu@e33c7htr3cd3>
 <db573faa5330e7cc8ad31ca86333227f@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db573faa5330e7cc8ad31ca86333227f@herbolt.com>

On Tue, Mar 10, 2026 at 12:22:54PM +0100, Lukas Herbolt wrote:
> On 2026-03-10 11:10, Pankaj Raghav (Samsung) wrote:
> > > 	if (xfs_is_always_cow_inode(ip) ||
> > 
> > Why should we check for this here but we don't do this check in
> > xfs_falloc_zero_range()?
> > 
> > There is a comment in xfs_falloc_allocate_range():
> > 
> > 	/*
> > 	 * If always_cow mode we can't use preallocations and thus should not
> > 	 * create them.
> > 	 */
> > 	if (xfs_is_always_cow_inode(XFS_I(inode)))
> > 		return -EOPNOTSUPP;
> > 
> > Don't we also use preallocations in xfs_falloc_zero_range()?
> > 
> 
> For the xfs_falloc_zero_range we return 0 on COW from xfs_alloc_file_space
> and that
> results in creating a hole in the file instead of having preallocated
> extents as shown
> bellow.
> 
> But for the xfs_falloc_write_zero_range(), we want fail as soon as possible
> as possible.
> 
> Feel free to correct me if I am wrong.

You're correct, write-zero-range wants to actually write zeroes to
storage to avoid remapping overhead during a write.  However, zoned /
alwayscow files always remap so this mode is not supported for them.

--D

> int
> xfs_alloc_file_space(
>         struct xfs_inode        *ip,
>         xfs_off_t               offset,
>         xfs_off_t               len)
> {
>         xfs_mount_t             *mp = ip->i_mount;
>         xfs_off_t               count;
>         xfs_filblks_t           allocatesize_fsb;
>         xfs_extlen_t            extsz, temp;
>         xfs_fileoff_t           startoffset_fsb;
>         xfs_fileoff_t           endoffset_fsb;
>         int                     rt;
>         xfs_trans_t             *tp;
>         xfs_bmbt_irec_t         imaps[1], *imapp;
>         int                     error;
> 
>         if (xfs_is_always_cow_inode(ip))
>                 return 0;
> 
> 
> root@build-00:/mnt# dd if=/dev/urandom of=/mnt/test.bin bs=10M oflag=direct
> count=1
> 1+0 records in
> 1+0 records out
> 10485760 bytes (10 MB, 10 MiB) copied, 0.167452 s, 62.6 MB/s
> root@build-00:/mnt# xfs_bmap -vp  test.bin
> test.bin:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..20479]:      192..20671        0 (192..20671)     20480 000000
> root@build-00:/mnt# strace -e fallocate fallocate -zl 2M  test.bin
> fallocate(3, FALLOC_FL_ZERO_RANGE, 0, 2097152) = 0
> +++ exited with 0 +++
> root@build-00:/mnt# xfs_bmap -vp  test.bin
> test.bin:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..4095]:       hole                                  4096
>    1: [4096..20479]:   4288..20671       0 (4288..20671)    16384 000000
> root@build-00:/mnt# dd if=/dev/urandom of=/mnt/test.bin bs=1M oflag=direct
> count=1 conv=notrunc
> 1+0 records in
> 1+0 records out
> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0172151 s, 60.9 MB/s
> root@build-00:/mnt# xfs_bmap -vp  test.bin
> test.bin:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..2047]:       192..2239         0 (192..2239)       2048 000000
>    1: [2048..4095]:    hole                                  2048
>    2: [4096..20479]:   4288..20671       0 (4288..20671)    16384 000000
> root@build-00:/mnt# cat /sys/fs/xfs/debug/
> always_cow          bload_node_slack    larp                mount_delay
> bload_leaf_slack    bug_on_assert       log_recovery_delay  pwork_threads
> root@build-00:/mnt# cat /sys/fs/xfs/debug/always_cow
> 1
> 
> 
> -- 
> -lhe
> 
