Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE71FDFA8;
	Thu, 24 Oct 2024 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793830; cv=none; b=TuUBTDUqG8Qqj7EAnet+wUTwSnlnr7KXzrBVmTnxQlChkbHhtjxHmDfqGRq4KBDNMS5seTUrKiNCuCQiLXANKvp8SeMeBqcapliLCqq5b/bj13dOOJ0kTxxJO2ptankHzXwyGG7B4Nql488HkniDEmhl2UyWOkmGERw+lJrKND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793830; c=relaxed/simple;
	bh=UqKK59RG/9ksv9++fzD89iQGiyW6uXPnlxc95Aow3Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBnuuaMCc8lGHDskM3PBsxb1KVdTKoqATJ195LN2ZIv9KdlTu5ndHb9I0PZugHeJSx/J168sOmHgZw7bfTkGLgnY/i3Yidq71qxYiwCWpEzhCktA6ekCj1F6+Fad2Fr21np1J07v74xw2c/V9DfzyB8W8Y7A4UWpe6NswFTexNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIVhZmx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIVhZmx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2092C4CEC7;
	Thu, 24 Oct 2024 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729793829;
	bh=UqKK59RG/9ksv9++fzD89iQGiyW6uXPnlxc95Aow3Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DIVhZmx2V68CalcuhXQj6ysXMak2atHrFBIJRR3I2DhxWWLR0TmsQEv90itxfdh5v
	 G+hmoI7lZbZtGO8V/TAe3boofEHdG7b1sOrHGDbqKR297Sz3Mq3nf21mbNyz6dMLom
	 od65of9/suK94LGCrIJvGujC5dDN6qypyHcz/vkjFKRumdoxa/aAGUQSfaql4W3HP1
	 om2wRe0pMC32oGvhhMUJewV7y2/kaPev6sBa3EqL06jPWuyNFLmV3QlaPQl9/Zx2oe
	 Ivgz9Ddn4gl0khdkyOCriUP5LQ97WTzT/uVVLjYpOjR4h/sfCbJ0HDxQHgb68tOMkk
	 huH2bZu1oSpdQ==
Date: Thu, 24 Oct 2024 11:17:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com, linux-xfs@vger.kernel.org,
	gost.dev@samsung.com, mcgrof@kernel.org, kernel@pankajraghav.com,
	david@fromorbit.com
Subject: Re: [PATCH 2/2] generic: increase file size to match CoW delayed
 allocation for XFS 64k bs
Message-ID: <20241024181709.GF2386201@frogsfrogsfrogs>
References: <20241024112311.615360-1-p.raghav@samsung.com>
 <20241024112311.615360-3-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024112311.615360-3-p.raghav@samsung.com>

On Thu, Oct 24, 2024 at 01:23:11PM +0200, Pankaj Raghav wrote:
> generic/305,326,328 have been failing for 32k and 64k blocksizes.
> 
> We do the following in the test 305 and 326 (highlighting only the part
> that is related to failure):
> 
> - create a 1M test-1/file1
> - reflink test-1/file2 and test-1/file3 based on test-1/file1
> - Overwrite first half of test-1/file2 to do a CoW operation
> - Expect the size of the test-1 dir to be 3M
> 
> The test is failing for 32k and 64k blocksizes as the number of blocks
> (direct + delayed) is higher than number of blocks allocated for
> blocksizes < 32k in XFS, resulting in size of test-1 to be more than 3M.
> Though generic/328 has a different IO pattern, the reason for failure is
> the same.
> 
> This is the failure output :
>     --- tests/generic/305.out   2024-06-05 11:52:27.430262812 +0000
>     +++ /root/results//64k_4ks/generic/305.out.bad      2024-10-23 10:56:57.643986870 +0000
>     @@ -11,7 +11,7 @@
>      CoW one of the files
>      root 0 0 0
>      nobody 0 0 0
>     -fsgqa 3072 0 0
>     +fsgqa 4608 0 0
>      Remount the FS to see if accounting changes
>      root 0 0 0
> 
> In these tests, XFS is doing a delayed allocation of
> XFS_DEFAULT_COWEXTSIZE_HINT(32). Increase the size of the file so that
> the CoW write(sz/2) matches the maximum size of the delayed allocation
> for the max blocksize of 64k. This will ensure that all parts of the
> delayed extents are converted to real extents for all blocksizes.
> 
> Even though this is not the most complete solution to fix these tests,
> the objective of these tests are to test quota and not the effect of delayed
> allocations.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  tests/generic/305     |  2 +-
>  tests/generic/305.out | 12 ++++++------
>  tests/generic/326     |  2 +-
>  tests/generic/326.out | 12 ++++++------
>  tests/generic/328     |  2 +-
>  tests/generic/328.out | 16 +++++++++-------
>  6 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/tests/generic/305 b/tests/generic/305
> index c89bd821..6ccbb3d0 100755
> --- a/tests/generic/305
> +++ b/tests/generic/305
> @@ -32,7 +32,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
>  testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
> -sz=1048576
> +sz=4194304

Hm, so you're increasing the filesize so that it exceeds 32*64k?
Hence 4M for some nice round numbers?

If so then I think I'm fine with that.  Let's see what testing thinks.
:)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  echo "Create the original files"
>  $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
>  _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
> diff --git a/tests/generic/305.out b/tests/generic/305.out
> index fbd4e241..1c348d1e 100644
> --- a/tests/generic/305.out
> +++ b/tests/generic/305.out
> @@ -1,22 +1,22 @@
>  QA output created by 305
>  Format and mount
>  Create the original files
> -root 3072 0 0
> +root 12288 0 0
>  nobody 0 0 0
>  fsgqa 0 0 0
>  Change file ownership
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  CoW one of the files
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  Remount the FS to see if accounting changes
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  Chown one of the files
>  root 0 0 0
> -nobody 1024 0 0
> -fsgqa 2048 0 0
> +nobody 4096 0 0
> +fsgqa 8192 0 0
> diff --git a/tests/generic/326 b/tests/generic/326
> index 1783fbf2..321e7dc6 100755
> --- a/tests/generic/326
> +++ b/tests/generic/326
> @@ -33,7 +33,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
>  testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
> -sz=1048576
> +sz=4194304
>  echo "Create the original files"
>  $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
>  _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
> diff --git a/tests/generic/326.out b/tests/generic/326.out
> index de7f20b5..4ccb3250 100644
> --- a/tests/generic/326.out
> +++ b/tests/generic/326.out
> @@ -1,22 +1,22 @@
>  QA output created by 326
>  Format and mount
>  Create the original files
> -root 3072 0 0
> +root 12288 0 0
>  nobody 0 0 0
>  fsgqa 0 0 0
>  Change file ownership
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  CoW one of the files
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  Remount the FS to see if accounting changes
>  root 0 0 0
>  nobody 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  Chown one of the files
>  root 0 0 0
> -nobody 1024 0 0
> -fsgqa 2048 0 0
> +nobody 4096 0 0
> +fsgqa 8192 0 0
> diff --git a/tests/generic/328 b/tests/generic/328
> index 0c8e1986..25e1f2a0 100755
> --- a/tests/generic/328
> +++ b/tests/generic/328
> @@ -32,7 +32,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
>  testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
> -sz=1048576
> +sz=4194304
>  echo "Create the original files"
>  $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
>  chown $qa_user $testdir/file1
> diff --git a/tests/generic/328.out b/tests/generic/328.out
> index b7fe9f8c..0167637e 100644
> --- a/tests/generic/328.out
> +++ b/tests/generic/328.out
> @@ -2,24 +2,26 @@ QA output created by 328
>  Format and mount
>  Create the original files
>  root 0 0 0
> -fsgqa 3072 0 0
> +fsgqa 12288 0 0
>  Set hard quota to prevent rewrite
>  root 0 0 0
> -fsgqa 3072 0 1024
> +fsgqa 12288 0 1024
>  Try to dio write the whole file
>  pwrite: Disk quota exceeded
>  root 0 0 0
> -fsgqa 3072 0 1024
> +fsgqa 12288 0 1024
>  Try to write the whole file
>  pwrite: Disk quota exceeded
>  root 0 0 0
> -fsgqa 3072 0 1024
> +fsgqa 12288 0 1024
>  Set hard quota to allow rewrite
>  root 0 0 0
> -fsgqa 3072 0 8192
> +fsgqa 12288 0 8192
>  Try to dio write the whole file
> +pwrite: Disk quota exceeded
>  root 0 0 0
> -fsgqa 3072 0 8192
> +fsgqa 12288 0 8192
>  Try to write the whole file
> +pwrite: Disk quota exceeded
>  root 0 0 0
> -fsgqa 3072 0 8192
> +fsgqa 12288 0 8192
> -- 
> 2.44.1
> 
> 
