Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39382 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbeEVGlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 02:41:51 -0400
Date: Tue, 22 May 2018 14:41:45 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 2/5] generic: enable swapfile tests on Btrfs
Message-ID: <20180522064145.GQ29080@desktop.hz.ali.com>
References: <cover.1526503000.git.osandov@fb.com>
 <80a5002310ab7f06efd9fed76cf268673e631335.1526503000.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80a5002310ab7f06efd9fed76cf268673e631335.1526503000.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

On Wed, May 16, 2018 at 01:38:46PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Commit 8c96cfbfe530 ("generic/35[67]: disable swapfile tests on Btrfs")
> disabled the swapfile tests on Btrfs because it did not support
> swapfiles at the time. Now that we're adding support, we want these

So currently btrfs has no swapfile support yet, and tests still _notrun
with current v4.17-rc5 kernel? Just want to make sure that's expected.

> tests to run, but they don't. _require_scratch_swapfile always fails for
> Btrfs because swapfiles on Btrfs must be set to nocow. After fixing
> that, generic/356 and generic/357 fail for the same reason. After fixing
> _that_, both tests still fail because we don't allow reflinking a
> non-checksummed extent (which nocow implies) to a checksummed extent.
> Add a helper for formatting a swap file which does the chattr, and
> chattr the second file, which gets these tests running on kernels
> supporting Btrfs swapfiles.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  common/rc         | 15 ++++++++++++---
>  tests/generic/356 |  7 ++++---
>  tests/generic/357 |  6 +++---
>  3 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index ffe53236..814b8b5c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2222,6 +2222,17 @@ _require_odirect()
>  	rm -f $testfile 2>&1 > /dev/null
>  }
>  
> +_format_swapfile() {
> +	local fname="$1"
> +	local sz="$2"
> +
> +	touch "$fname"

Better to remove $fname first, just in case it's an existing file with
some blocks allocated, as chattr(1) says

"Note: For btrfs, the 'C' flag should be set on new or empty files.  If
it is set on a file which already has data blocks, it is undefined when
the blocks assigned to the file will be fully stable"

> +	chmod 0600 "$fname"
> +	$CHATTR_PROG +C "$fname" > /dev/null 2>&1

It'd be good to have some comments on this chattr +C.

> +	_pwrite_byte 0x61 0 "$sz" "$fname" >> $seqres.full
> +	mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c "$fname" >> $seqres.full

Is the label really needed?

Thanks,
Eryu

> +}
> +
>  # Check that the filesystem supports swapfiles
>  _require_scratch_swapfile()
>  {
> @@ -2231,10 +2242,8 @@ _require_scratch_swapfile()
>  	_scratch_mount
>  
>  	# Minimum size for mkswap is 10 pages
> -	local size=$(($(get_page_size) * 10))
> +	_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
>  
> -	_pwrite_byte 0x61 0 "$size" "$SCRATCH_MNT/swap" >/dev/null 2>&1
> -	mkswap "$SCRATCH_MNT/swap" >/dev/null 2>&1
>  	if ! swapon "$SCRATCH_MNT/swap" >/dev/null 2>&1; then
>  		_scratch_unmount
>  		_notrun "swapfiles are not supported"
> diff --git a/tests/generic/356 b/tests/generic/356
> index 51eeb652..b4a38f84 100755
> --- a/tests/generic/356
> +++ b/tests/generic/356
> @@ -59,11 +59,12 @@ blocks=160
>  blksz=65536
>  
>  echo "Initialize file"
> -echo >> $seqres.full
> -_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
> -mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
> +_format_swapfile "$testdir/file1" $((blocks * blksz))
>  swapon $testdir/file1
>  
> +touch "$testdir/file2"
> +$CHATTR_PROG +C "$testdir/file2" >/dev/null 2>&1
> +
>  echo "Try to reflink"
>  _cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
>  
> diff --git a/tests/generic/357 b/tests/generic/357
> index 0dd0c10f..9a83a283 100755
> --- a/tests/generic/357
> +++ b/tests/generic/357
> @@ -59,9 +59,9 @@ blocks=160
>  blksz=65536
>  
>  echo "Initialize file"
> -echo >> $seqres.full
> -_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
> -mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
> +_format_swapfile "$testdir/file1" $((blocks * blksz))
> +touch "$testdir/file2"
> +$CHATTR_PROG +C "$testdir/file2" >/dev/null 2>&1
>  _cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
>  
>  echo "Try to swapon"
> -- 
> 2.17.0
> 
