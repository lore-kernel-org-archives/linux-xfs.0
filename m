Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22C279DB6;
	Mon, 20 Oct 2025 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978732; cv=none; b=HeDsjnzkOW+qL4p9pEhfwF8mEye2RrdKSdPKS1R6OUZmkwGo9uWvWNyS1S4VtgzosE/vNESms5EVxt7fwgXCyg6pVQVM5Z6Vqt1DhBSlPBDqUWoJqBkWc9JdXOECTviuqu9Tdu49o3ruVY/sM9bfawv8wdSs1HieyKh9b6YAeA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978732; c=relaxed/simple;
	bh=TyCbC7/RXi1HCsoA0tTA3Smw7tANZOdG9WkvoBliOkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVhk56W8uCZcyf7AwcnW4cILoo0Ae4+BKLnhcUd8et9bzWe3z9jkNBa8yzAz8FICCkpRJ/u89AKxFcaF912qcjDRDXiL/sAXrNQ5ZS5dIeOeCod2KDLG/7r+Xa69FDrgp7Ufi5f2uoSys/hWn5Z1GVpfIRTKW31StJTfINQw1io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+eVI1hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+eVI1hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCD7C4CEFE;
	Mon, 20 Oct 2025 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978731;
	bh=TyCbC7/RXi1HCsoA0tTA3Smw7tANZOdG9WkvoBliOkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+eVI1hlBgQ2EzGn+qHQf3P/MdrNEDEBmeh00RKY8+CYpYfdvxmUJMKnejt7iE7TJ
	 1yVY3F9u9w4CDV2bMm4+zsUdMITj8nu2rvlbGvS5UtIgbfqsaikmmJ0lAvI+KA3L2h
	 Sl1zxW60jfMD1wEGGnORtck3RIOYqTd2904xjIQ/sVkMOdl5A+JwN4BUzgONhILJng
	 bGgyTvhiIvYjzziUHN6u/vGFZ8M+BiLXS1w86AYXgeKo/gCsUpUNwKyZaF3jaw4qZu
	 bxi5dJJ4uavcv8k09nHtTuXLAW7otW3MrCDbdkgB6YUiePX48JAzthDX6XHmLhiIXy
	 dEy0wqAi11Ofw==
Date: Mon, 20 Oct 2025 09:45:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/3] generic/772: split this test into 772 and 773 for
 regular and special files
Message-ID: <20251020164531.GO6178@frogsfrogsfrogs>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
 <20251020135530.1391193-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020135530.1391193-4-aalbersh@kernel.org>

On Mon, Oct 20, 2025 at 03:55:30PM +0200, Andrey Albershteyn wrote:
> Not all filesystem support setting file attributes on special files. The
> syscalls would still work for regular files. Let's split this test into
> two to make it obvious if only special files support is missing.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/772     | 38 +-------------------
>  tests/generic/772.out | 14 --------
>  tests/generic/773     | 84 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/773.out | 20 +++++++++++
>  4 files changed, 105 insertions(+), 51 deletions(-)
>  create mode 100755 tests/generic/773
>  create mode 100644 tests/generic/773.out
> 
> diff --git a/tests/generic/772 b/tests/generic/772
> index bdd55b10f310..0d5c4749b010 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -4,7 +4,7 @@
>  #
>  # FS QA Test No. 772
>  #
> -# Test file_getattr/file_setattr syscalls
> +# Test file_getattr() and file_setattr() syscalls on regular files
>  #
>  . ./common/preamble
>  _begin_fstest auto
> @@ -13,7 +13,6 @@ _begin_fstest auto
>  
>  # Modify as appropriate.
>  _require_scratch
> -_require_test_program "af_unix"
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> @@ -21,29 +20,16 @@ _require_mknod
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
>  _require_file_attr
> -_require_file_attr_special
>  
>  file_attr () {
>  	$here/src/file_attr $*
>  }
>  
> -create_af_unix () {
> -	$here/src/af_unix $* || echo af_unix failed
> -}
> -
>  projectdir=$SCRATCH_MNT/prj
>  
>  # Create normal files and special files
>  mkdir $projectdir
> -mkfifo $projectdir/fifo
> -mknod $projectdir/chardev c 1 1
> -mknod $projectdir/blockdev b 1 1
> -create_af_unix $projectdir/socket
>  touch $projectdir/foo
> -ln -s $projectdir/foo $projectdir/symlink
> -touch $projectdir/bar
> -ln -s $projectdir/bar $projectdir/broken-symlink
> -rm -f $projectdir/bar
>  
>  echo "Error codes"
>  # wrong AT_ flags
> @@ -59,37 +45,15 @@ file_attr --set --new-fsx-flag $projectdir ./foo
>  
>  echo "Initial attributes state"
>  file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
> -file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> -file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> -file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> -file_attr --get $projectdir ./socket | _filter_file_attributes ~d
>  file_attr --get $projectdir ./foo | _filter_file_attributes ~d
> -file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
>  
>  echo "Set FS_XFLAG_NODUMP (d)"
>  file_attr --set --set-nodump $projectdir
> -file_attr --set --set-nodump $projectdir ./fifo
> -file_attr --set --set-nodump $projectdir ./chardev
> -file_attr --set --set-nodump $projectdir ./blockdev
> -file_attr --set --set-nodump $projectdir ./socket
>  file_attr --set --set-nodump $projectdir ./foo
> -file_attr --set --set-nodump $projectdir ./symlink
>  
>  echo "Read attributes"
>  file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
> -file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> -file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> -file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> -file_attr --get $projectdir ./socket | _filter_file_attributes ~d
>  file_attr --get $projectdir ./foo | _filter_file_attributes ~d
> -file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
> -
> -echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
> -file_attr --set --set-nodump $projectdir ./broken-symlink
> -file_attr --get $projectdir ./broken-symlink
> -
> -file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
> -file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
>  
>  cd $SCRATCH_MNT
>  touch ./foo2
> diff --git a/tests/generic/772.out b/tests/generic/772.out
> index f7c23d94da4a..c89dbcf5d630 100644
> --- a/tests/generic/772.out
> +++ b/tests/generic/772.out
> @@ -9,25 +9,11 @@ Can not get fsxattr on ./foo: Invalid argument
>  Can not set fsxattr on ./foo: Invalid argument
>  Initial attributes state
>  ----------------- SCRATCH_MNT/prj
> ------------------ ./fifo
> ------------------ ./chardev
> ------------------ ./blockdev
> ------------------ ./socket
>  ----------------- ./foo
> ------------------ ./symlink
>  Set FS_XFLAG_NODUMP (d)
>  Read attributes
>  ------d---------- SCRATCH_MNT/prj
> -------d---------- ./fifo
> -------d---------- ./chardev
> -------d---------- ./blockdev
> -------d---------- ./socket
>  ------d---------- ./foo
> -------d---------- ./symlink
> -Set attribute on broken link with AT_SYMLINK_NOFOLLOW
> -Can not get fsxattr on ./broken-symlink: No such file or directory
> -Can not get fsxattr on ./broken-symlink: No such file or directory
> -------d---------- ./broken-symlink
>  Initial state of foo2
>  ----------------- ./foo2
>  Set attribute relative to AT_FDCWD
> diff --git a/tests/generic/773 b/tests/generic/773
> new file mode 100755
> index 000000000000..f633706a1455
> --- /dev/null
> +++ b/tests/generic/773
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test 773
> +#
> +# Test file_getattr() and file_setattr() syscalls on special files (fifo,
> +# socket, chardev...)
> +#
> +. ./common/preamble
> +_begin_fstest quick
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# Modify as appropriate.
> +_require_scratch
> +_require_test_program "af_unix"
> +_require_test_program "file_attr"
> +_require_symlinks
> +_require_mknod
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +_require_file_attr_special
> +
> +file_attr () {
> +	$here/src/file_attr $*
> +}
> +
> +create_af_unix () {
> +	$here/src/af_unix $* || echo af_unix failed
> +}
> +
> +projectdir=$SCRATCH_MNT/prj
> +
> +# Create normal files and special files
> +mkdir $projectdir
> +mkfifo $projectdir/fifo
> +mknod $projectdir/chardev c 1 1
> +mknod $projectdir/blockdev b 1 1
> +create_af_unix $projectdir/socket
> +touch $projectdir/foo
> +ln -s $projectdir/foo $projectdir/symlink
> +touch $projectdir/bar
> +ln -s $projectdir/bar $projectdir/broken-symlink
> +rm -f $projectdir/bar
> +
> +echo "Initial attributes state"
> +file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
> +file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./socket | _filter_file_attributes ~d
> +file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
> +
> +echo "Set FS_XFLAG_NODUMP (d)"
> +file_attr --set --set-nodump $projectdir
> +file_attr --set --set-nodump $projectdir ./fifo
> +file_attr --set --set-nodump $projectdir ./chardev
> +file_attr --set --set-nodump $projectdir ./blockdev
> +file_attr --set --set-nodump $projectdir ./socket
> +file_attr --set --set-nodump $projectdir ./symlink
> +
> +echo "Read attributes"
> +file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
> +file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./socket | _filter_file_attributes ~d
> +file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
> +
> +echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
> +file_attr --set --set-nodump $projectdir ./broken-symlink
> +file_attr --get $projectdir ./broken-symlink
> +
> +file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
> +file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
> +
> +# optional stuff if your test has verbose output to help resolve problems
> +#echo
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/773.out b/tests/generic/773.out
> new file mode 100644
> index 000000000000..46ea3baa66fd
> --- /dev/null
> +++ b/tests/generic/773.out
> @@ -0,0 +1,20 @@
> +QA output created by 773
> +Initial attributes state
> +----------------- SCRATCH_MNT/prj
> +----------------- ./fifo
> +----------------- ./chardev
> +----------------- ./blockdev
> +----------------- ./socket
> +----------------- ./symlink
> +Set FS_XFLAG_NODUMP (d)
> +Read attributes
> +------d---------- SCRATCH_MNT/prj
> +------d---------- ./fifo
> +------d---------- ./chardev
> +------d---------- ./blockdev
> +------d---------- ./socket
> +------d---------- ./symlink
> +Set attribute on broken link with AT_SYMLINK_NOFOLLOW
> +Can not get fsxattr on ./broken-symlink: No such file or directory
> +Can not get fsxattr on ./broken-symlink: No such file or directory
> +------d---------- ./broken-symlink
> -- 
> 2.50.1
> 
> 
