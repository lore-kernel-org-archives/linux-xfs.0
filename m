Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460917;
	b=lLzdgfT3AMk/i01D1+bRRKtxCXx2HCq24E3ZYB3eT1bAtxadopFZJb97r+E6N7EeaR3J
	 n0SWjhMOCmpda7onQ/kVrbI9mYBQzUX/ZwD+CbvPIegzxN62WuIYOSuAJ8b1udYZkf0yj
	 tQuQuOUyU97VTpXHx5jYNDE6EySELSDEUkTHx9KKvlPALxEuGAW/Kt+hNc9AZMi/rXr8u
	 izwAKxkFIbeKgbCiHdszTa6Dk0h5LjHpZ/8X8lgjUAEjijdQ17bIefxLgZqlozx7RC5Oq
	 FpRG94FzDaxabuh2BTm2TjkHiZZvVu65WIY1yEOpMw/hZYx81EN0MUgGaOIg5+av26w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460917;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=fTN8vdK235+uC79sauRv+UP8AALuyUxzYO9E3eZKSZc=;
	b=iTXkxqcLc09/C0UmYB1bqR/ho8qiNH+ygMKbPe4PboEKn9KiU6D2RN2uEeJXFUtLNuux
	 fLC7IZv53NQYEpDU/jxIWZ3Z8pVLGbVpJHqNZAPnnjaA9x9m8Eci3DnyzNMf/iWgug5EM
	 9iCSAnNR7ql+ViubnOcZIulQqLuEZ/SWWrB/O1g5x0OvPQtSz0c/9d/+ncWw55Vnvv6Kl
	 H0ELowKxNLncbyb/rjxixGni0SGagWlw48Jm8U3kvZ5eXxS6X4y7nsQq+V9xWq5Nl40El
	 jY/pY5sCior8/HgrHifOxVM0IOI7Rh7N2VnAUeUAAPkeAFNH1uH9vmFqv1wed/8nxog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kfy3RuDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46400606A31A;
	Mon, 23 Nov 2026 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kfy3RuDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E1D1F000ED;
	Mon, 23 Nov 2026 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460917;
	bh=fTN8vdK235+uC79sauRv+UP8AALuyUxzYO9E3eZKSZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kfy3RuDSQ9EIQvEeNT3epUDAPezGpBL+AyFR3Xgqc57X2lce7oOHHb/xFaT27FTWZ
	 s5zKBXkhCFQM9QwiEf5/wQo8BJ35drSvcGtePSMiEZ/XrZ538pR2CNqJ4BOzQnA5nq
	 1e/pZu+s4oH2KNYMk4y4kB0xbTtCDjCQqgTwQ8SD9YmD2n0lJiObxDqIHvwJD/bN2K
	 HhcgRtPSmTMUff9Az8j5KbpWljbxclib6bL5ZAKNowkNtBr3Stu2glxrjuay8bdEJK
	 LCT9SNOVFlhT7hlD4li2+AG8Vlup4ncCBQNwdik6dPOVzL4+ZeloWCF7qf7/wYV/bO
	 cBrXJ8q6HnyJQ==
Date: Tue, 24 Nov 2026 03:08:29 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 20/21] fstests: generic/744: migrate to
 _create_cloned_loop_devs()
Message-ID: <awSPHC1UWULsJCx8@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <2d0903ee55156a1a384f95b6e54ce2bacf0c9a77.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d0903ee55156a1a384f95b6e54ce2bacf0c9a77.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:46PM +0800, Anand Jain wrote:
> Switch generic/744 to use the common _create_cloned_loop_devs() helper
> to format, modify, and clone the underlying loop devices, avoiding
> open-coded clone setup and teardown logic.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/744 | 70 ++++++++++++++++++-----------------------------
>  1 file changed, 27 insertions(+), 43 deletions(-)
> 
> diff --git a/tests/generic/744 b/tests/generic/744
> index 330d86ce826a..c522d6f46713 100755
> --- a/tests/generic/744
> +++ b/tests/generic/744
> @@ -10,71 +10,55 @@
>  . ./common/preamble
>  _begin_fstest auto clone volume tempfsid
>  
> -_cleanup()
> -{
> -	cd /
> -	rm -r -f $tmp.*
> -
> -	_unmount $mnt2 &> /dev/null
> -	_unmount $mnt1 &> /dev/null
> -	[ -b "$loop_dev2" ] && _destroy_loop_device $loop_dev2
> -	[ -b "$loop_dev1" ] && _destroy_loop_device $loop_dev1
> -	[ -n "$seq" ] && rm -rf $TEST_DIR/$seq
> -}
> -
>  . ./common/filter
>  . ./common/reflink
>  
> -_require_clone_mount
>  _require_test
>  _require_block_device $TEST_DEV
>  _require_test_reflink
>  _require_cp_reflink
>  _require_loop
>  
> -clone_filesystem()
> +_cleanup()
>  {
> -	local dev1=$1
> -	local dev2=$2
> -
> -	_mkfs_dev $dev1
> -
> -	_mount $dev1 $mnt1
> -	$XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo >> $seqres.full
> -	_unmount $mnt1
> +	cd /
> +	rm -r -f $tmp.*
>  
> -	# device dump of $dev1 to $dev2
> -	dd if=$dev1 of=$dev2 conv=fsync status=none || _fail "dd failed: $?"
> +	_unmount $mnt2 &> /dev/null
> +	_unmount $mnt1 &> /dev/null
> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
>  }
>  
> -[ -n "$seq" ] && rm -rf $TEST_DIR/$seq
> -mkdir $TEST_DIR/$seq
> +add_foo()
> +{
> +	local orig_dev="$1"
> +	local temp_mnt="$TEST_DIR/$seq/temp_mnt"
> +
> +	mkdir -p $temp_mnt
> +	_mount $(_common_dev_mount_options) $(_clone_mount_options) $orig_dev $temp_mnt
> +	$XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $temp_mnt/foo >> $seqres.full
> +	$XFS_IO_PROG -c 'fsync' $temp_mnt/foo
> +	_unmount $temp_mnt
> +}
>  
> +rm -rf $TEST_DIR/$seq 2>/dev/null
> +mkdir -p $TEST_DIR/$seq
> +# Setup base loop device and its clone
> +devs=()
> +_create_cloned_loop_devs devs add_foo
>  mnt1=$TEST_DIR/$seq/mnt1
>  mnt2=$TEST_DIR/$seq/mnt2
> -mkdir -p $mnt1 $mnt2
> -
> -loop_file1="$TEST_DIR/$seq/image1"
> -truncate -s 300m "$loop_file1"
> -loop_dev1=$(_create_loop_device "$loop_file1")
> -
> -loop_file2="$TEST_DIR/$seq/image2"
> -truncate -s 300m "$loop_file2"
> -loop_dev2=$(_create_loop_device "$loop_file2")
> -
> -clone_filesystem ${loop_dev1} ${loop_dev2}
> +mkdir -p $mnt1
> +mkdir -p $mnt2
>  
>  # Mounting original device
> -_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev1 $mnt1
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1
>  $XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo | _filter_xfs_io
> -
>  # Mounting cloned device
> -_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev2 $mnt2 \
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 \
>  					|| _fail "mount of cloned device failed"
>  
>  # cp reflink across two different filesystems must fail
>  _cp_reflink $mnt1/foo $mnt2/bar 2>&1 | _filter_test_dir
>  
> -# success, all done
> -status=0
> -exit
> +_exit 0
> -- 
> 2.43.0
> 
