Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECB41D1300;
	Wed, 21 Aug 2024 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724260490; cv=none; b=ib14F435nonZtz8b7fEyDxu3klrbLAzDue3/VTn9G9UxtidF6ujQh5hVTL1SRE5TRq3qwhz9cCp5+e4kZSJ0A3fc3ldjmZscKdQVgBYFAJLPTMjbKsTg7/5gzXpRl1YLKx0YUW6jP9R6Ms2uEyOA1Pi22A8nGcJv+3Vh0pzZQPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724260490; c=relaxed/simple;
	bh=F7gJUGJbRrNIAaoIUSkr3EzLCBWgke/byq041wjSEJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbqK9EzKM2vMbb3BNC6blfKvOQwHd4FLoi4oMNKNNeHPfbs6tAiBKOuMD4wRkL5Y65KgNFq2lMcLJDJY/J3gjS42gkJseevw3w4IuuftPSkZQawYW9E12w7ms1bBGnjmiYDcDF6CivpEG0O0MA9xZit83b1EmeybZiFNEsXjhe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8t7Mbyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8t7Mbyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F1C32781;
	Wed, 21 Aug 2024 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724260490;
	bh=F7gJUGJbRrNIAaoIUSkr3EzLCBWgke/byq041wjSEJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U8t7MbygiaUxZiqWtkPPTMU4z0e8XRyed/BJR+wnO4d/59syEse6ixIre85o3dnZn
	 TU1ksR18mwHB1UGTPVUMdAywAEHNou1rpSdtJzCtrZQt0yIJjUiZJ335j+PaUtdqC3
	 fUgaUO+VgoPtW4yyG/JTj5m376+HG8RPVfWLp2O7yI0s8HxrL9atwENb+Vgsiuag58
	 lciOTfnhfHWKaXEX/tpVisMcA+PGdo0UoRiUaYzA3XdkDgABIMA0rozvbStnauI1gJ
	 Sh41B+MAr0IqS0X7ZY3GgHMyEBIO+SzFLORy1BMJ7YKunlhiv5VB6+sYw/NR2ywm6o
	 pqoVDwRb+SP5Q==
Date: Wed, 21 Aug 2024 10:14:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: use FICLONE/FICLONERANGE/FIDEDUPERANGE for test
 cases
Message-ID: <20240821171449.GJ6047@frogsfrogsfrogs>
References: <20240809150455.GV6051@frogsfrogsfrogs>
 <20240817065027.14459-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240817065027.14459-1-liuhuan01@kylinos.cn>

On Sat, Aug 17, 2024 at 02:50:27PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> With the patch "xfs_io: use FICLONE/FICLONERANGE/FIDEDUPERANGE for reflink/dedupe IO commands", and modify relevant test cases.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  common/reflink        |  2 +-
>  tests/generic/122.out |  2 +-
>  tests/generic/136.out |  2 +-
>  tests/generic/157.out | 18 +++++++++---------
>  tests/generic/158.out | 20 ++++++++++----------
>  tests/generic/303.out |  8 ++++----
>  tests/generic/304.out | 14 +++++++-------
>  tests/generic/493.out |  4 ++--
>  tests/generic/516.out |  2 +-
>  tests/generic/518.out |  2 +-
>  tests/xfs/319.out     |  2 +-
>  tests/xfs/321.out     |  2 +-
>  tests/xfs/322.out     |  2 +-
>  tests/xfs/323.out     |  2 +-
>  14 files changed, 41 insertions(+), 41 deletions(-)
> 
> diff --git a/common/reflink b/common/reflink
> index 22adc444..21df20e2 100644
> --- a/common/reflink
> +++ b/common/reflink
> @@ -261,7 +261,7 @@ _dedupe_range() {
>  # Unify xfs_io dedupe ioctl error message prefix
>  _filter_dedupe_error()
>  {
> -	sed -e 's/^dedupe:/XFS_IOC_FILE_EXTENT_SAME:/g'
> +	sed -e 's/^dedupe:/FIDEDUPERANGE:/g'

Hmm, don't you have to squash both "dedupe:" and
"XFS_IOC_FILE_EXTENT_SAME:" to "FIDEDUPERANGE:" here?  Or else you break
the intermediate xfs_io versions that emit "XFS_IOC_FILE_EXTENT_SAME:"?

And apply the same filtering for the clone and clonerange ioctls?

(Or just leave the error message prefixes in xfs_io the way they are!)

--D

>  }
>  
>  # Create a file of interleaved unwritten and reflinked blocks
> diff --git a/tests/generic/122.out b/tests/generic/122.out
> index 4459985c..f243d153 100644
> --- a/tests/generic/122.out
> +++ b/tests/generic/122.out
> @@ -4,7 +4,7 @@ Create the original files
>  5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
>  Files 1-2 do not match (intentional)
>  (Fail to) dedupe the middle blocks together
> -XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
> +FIDEDUPERANGE: Extents did not match.
>  Compare sections
>  35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
>  5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
> diff --git a/tests/generic/136.out b/tests/generic/136.out
> index 508953f6..eee44f07 100644
> --- a/tests/generic/136.out
> +++ b/tests/generic/136.out
> @@ -7,7 +7,7 @@ c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
>  Dedupe the last blocks together
>  1->2
>  1->3
> -XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
> +FIDEDUPERANGE: Extents did not match.
>  c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
>  c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
>  07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
> diff --git a/tests/generic/157.out b/tests/generic/157.out
> index d4f64b44..0ef12f80 100644
> --- a/tests/generic/157.out
> +++ b/tests/generic/157.out
> @@ -2,23 +2,23 @@ QA output created by 157
>  Format and mount
>  Create the original files
>  Try cross-device reflink
> -XFS_IOC_CLONE_RANGE: Invalid cross-device link
> +FICLONERANGE: Invalid cross-device link
>  Try unaligned reflink
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try overlapping reflink
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try reflink past EOF
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try to reflink a dir
> -XFS_IOC_CLONE_RANGE: Is a directory
> +FICLONERANGE: Is a directory
>  Try to reflink a device
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try to reflink to a dir
>  TEST_DIR/test-157/dir1: Is a directory
>  Try to reflink to a device
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try to reflink to a fifo
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Try to reflink an append-only file
> -XFS_IOC_CLONE_RANGE: Bad file descriptor
> +FICLONERANGE: Bad file descriptor
>  Reflink two files
> diff --git a/tests/generic/158.out b/tests/generic/158.out
> index 8df9d9a5..2b304820 100644
> --- a/tests/generic/158.out
> +++ b/tests/generic/158.out
> @@ -2,26 +2,26 @@ QA output created by 158
>  Format and mount
>  Create the original files
>  Try cross-device dedupe
> -XFS_IOC_FILE_EXTENT_SAME: Invalid cross-device link
> +FIDEDUPERANGE: Invalid cross-device link
>  Try unaligned dedupe
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try overlapping dedupe
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try dedupe from past EOF
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try dedupe to past EOF, destination offset beyond EOF
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try dedupe to past EOF, destination offset behind EOF
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try to dedupe a dir
> -XFS_IOC_FILE_EXTENT_SAME: Is a directory
> +FIDEDUPERANGE: Is a directory
>  Try to dedupe a device
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try to dedupe to a dir
>  TEST_DIR/test-158/dir1: Is a directory
>  Try to dedupe to a device
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try to dedupe to a fifo
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Try to dedupe an append-only file
>  Dedupe two files
> diff --git a/tests/generic/303.out b/tests/generic/303.out
> index 39a88038..256ef66f 100644
> --- a/tests/generic/303.out
> +++ b/tests/generic/303.out
> @@ -4,14 +4,14 @@ Create the original files
>  Reflink large single byte file
>  Reflink large empty file
>  Reflink past maximum file size in dest file (should fail)
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Reflink high offset to low offset
>  Reflink past source file EOF (should fail)
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Reflink max size at nonzero offset (should fail)
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Reflink with huge off/len (should fail)
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  Check file creation
>  file3
>  7ffffffffffffffe:  61  a
> diff --git a/tests/generic/304.out b/tests/generic/304.out
> index a979099b..d43dd70c 100644
> --- a/tests/generic/304.out
> +++ b/tests/generic/304.out
> @@ -2,19 +2,19 @@ QA output created by 304
>  Format and mount
>  Create the original files
>  Dedupe large single byte file
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe large empty file
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe past maximum file size in dest file (should fail)
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe high offset to low offset
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe past source file EOF (should fail)
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe max size at nonzero offset (should fail)
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Dedupe with huge off/len (should fail)
> -XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +FIDEDUPERANGE: Invalid argument
>  Check file creation
>  file3
>  7ffffffffffffffe:  61  a
> diff --git a/tests/generic/493.out b/tests/generic/493.out
> index d3426ee6..8bb71d3b 100644
> --- a/tests/generic/493.out
> +++ b/tests/generic/493.out
> @@ -2,6 +2,6 @@ QA output created by 493
>  Format and mount
>  Initialize file
>  Try to dedupe
> -XFS_IOC_FILE_EXTENT_SAME: Text file busy
> -XFS_IOC_FILE_EXTENT_SAME: Text file busy
> +FIDEDUPERANGE: Text file busy
> +FIDEDUPERANGE: Text file busy
>  Tear it down
> diff --git a/tests/generic/516.out b/tests/generic/516.out
> index 90308c49..53611b3b 100644
> --- a/tests/generic/516.out
> +++ b/tests/generic/516.out
> @@ -4,7 +4,7 @@ Create the original files
>  39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-516/file2
>  Files 1-2 do not match (intentional)
>  (partial) dedupe the middle blocks together
> -XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
> +FIDEDUPERANGE: Extents did not match.
>  Compare sections
>  35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-516/file1
>  39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-516/file2
> diff --git a/tests/generic/518.out b/tests/generic/518.out
> index 726c2073..57ae9155 100644
> --- a/tests/generic/518.out
> +++ b/tests/generic/518.out
> @@ -3,7 +3,7 @@ wrote 262244/262244 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  wrote 1048576/1048576 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +FICLONERANGE: Invalid argument
>  File content after failed reflink:
>  0000000 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
>  *
> diff --git a/tests/xfs/319.out b/tests/xfs/319.out
> index 160f5fd2..25f1ed2e 100644
> --- a/tests/xfs/319.out
> +++ b/tests/xfs/319.out
> @@ -7,7 +7,7 @@ Check files
>  4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
>  Inject error
>  Try to reflink
> -XFS_IOC_CLONE_RANGE: Input/output error
> +FICLONERANGE: Input/output error
>  FS should be shut down, touch will fail
>  touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
>  Remount to replay log
> diff --git a/tests/xfs/321.out b/tests/xfs/321.out
> index c0abd52b..59fd7b7b 100644
> --- a/tests/xfs/321.out
> +++ b/tests/xfs/321.out
> @@ -6,7 +6,7 @@ Check files
>  b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
>  Inject error
>  Try to reflink
> -XFS_IOC_CLONE_RANGE: Input/output error
> +FICLONERANGE: Input/output error
>  FS should be shut down, touch will fail
>  touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
>  Remount to replay log
> diff --git a/tests/xfs/322.out b/tests/xfs/322.out
> index b3fba5d0..695dd48b 100644
> --- a/tests/xfs/322.out
> +++ b/tests/xfs/322.out
> @@ -6,7 +6,7 @@ Check files
>  b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
>  Inject error
>  Try to reflink
> -XFS_IOC_CLONE_RANGE: Input/output error
> +FICLONERANGE: Input/output error
>  FS should be shut down, touch will fail
>  touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
>  Remount to replay log
> diff --git a/tests/xfs/323.out b/tests/xfs/323.out
> index 99b9688c..f7f36c05 100644
> --- a/tests/xfs/323.out
> +++ b/tests/xfs/323.out
> @@ -6,7 +6,7 @@ Check files
>  4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
>  Inject error
>  Try to reflink
> -XFS_IOC_CLONE_RANGE: Input/output error
> +FICLONERANGE: Input/output error
>  FS should be shut down, touch will fail
>  touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
>  Remount to replay log
> -- 
> 2.43.0
> 
> 
