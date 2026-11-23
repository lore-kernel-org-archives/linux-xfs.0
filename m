Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460810;
	b=0Fgmpil3ft1osg1LDXmu2xIcC5kogxJmoVRgW+q/iOiquWFOF6X6ial50KTl8cDF82eN
	 E79c3/vqd+NisVPqzMeqrYmgyA571BKOK3ONNGBFChKil0ZY/6ffyEzk1Hpv6Y7bi2QfP
	 iJnGUToSpOFjtsoNEv5Q7RRWWQktO/oTpUsSHCmGdauvBiJ9W7gd1caIkRLOw7kIpzdV0
	 tZd01TKe0+YezvUeCOo72henD3J9Ept3FfYlC4aYsb6Pp2dOaf9bT5MboyMHnQA8Va2LJ
	 WF9F9KCfh3sZHR+tpOS+NHeJPTJYNNjphLKCng+JU2zJp5qkwzarwziafs6f4i8DmYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460810;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=EzjGQCbWhisriS4842HHUs9cnA100PfIu86lZFwgK2Q=;
	b=EkyJOsQ2Cc4sYxiqq7anIMtJcd8OYDbkLkzQJzyFN4XoU3AWZHZqnE033dLUFyeaPXwW
	 d26B+XvQOm1FDtIMbcjuDhIuZnLVzpjCqPg47pT2La+5MDcvEItL78FfaBPRDRNpq4wxt
	 dojfBLPR1MBVYsjFD8hX7zp6KAYtncNvkq+zJTEnspse12fmn/FpmIFr+q13YT4WD1AKw
	 pLoCyvVBVJAYDHLpjBXqTM9jpPqrYwb9feQHQIB5ZmDeWE+pAY33yInoaV+VPpkHf1CVW
	 1dbAMnMuFvfl4JofGLhs9TMoMWWyV0Yqw+MLaeKlq8dmWmZLuYKldzF2Q8y67hSOdEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0C6ksNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D00606A31A;
	Mon, 23 Nov 2026 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0C6ksNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F291F000C0;
	Mon, 23 Nov 2026 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460810;
	bh=EzjGQCbWhisriS4842HHUs9cnA100PfIu86lZFwgK2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b0C6ksNJbze9dWZIz/YUXOx84s+NfPfHLKTYHO7w9rExchBRp6DQnh/UqJVZQjily
	 yEBn6xCmdZ4sN6KH/N0LeeRd/JIkKegBb7d0162LShhEPLdGkal8RIRnIc2jvjW4O7
	 9am6K9UlqjUWv2Z3ey9rh1jo28PJ1kTiJJZbW3PgDuGcEqW7I0r6JKt+5zRet/y/Gr
	 uk1oFOuNqk5znup2mr5nB0AjobnX0ZH7J00HVKUt8qCpg3Mp+v2pssffUFt5o/gyEd
	 Qvv81ccHoV4kTgdxk3/zHB4AU6+FszjAcEdiT0xG7M9H75VpzMtrEXzeuPUGcYjYAb
	 yNFoHKBogPqjg==
Date: Tue, 24 Nov 2026 03:06:42 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 19/21] fstests: generic/744: use new helper
 _require_clone_mount()
Message-ID: <awSOU4pH_5iTv9Ea@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <7c2209a7384968d252763bfd35289f776ebdd1af.1791272793.git.asj@kernel.org>
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
In-Reply-To: <7c2209a7384968d252763bfd35289f776ebdd1af.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:45PM +0800, Anand Jain wrote:
> Replace _require_duplicate_fsid() with the newly introduced
> _require_clone_mount() helper to verify kernel support for mounting
> cloned block devices with duplicate UUIDs.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc         | 14 --------------
>  tests/generic/744 |  8 ++++----
>  2 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 7feeec04a500..58e4c234b0f4 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6235,20 +6235,6 @@ _random_file() {
>  	echo "$basedir/$(ls -U $basedir | shuf -n 1)"
>  }
>  
> -_require_duplicate_fsid()
> -{
> -	case "$FSTYP" in
> -	"btrfs")
> -		_require_btrfs_fs_feature temp_fsid
> -		;;
> -	"ext4")
> -		;;
> -	*)
> -		_notrun "$FSTYP does not support duplicate fsid"
> -		;;
> -	esac
> -}
> -
>  # Can we find a program in the $PATH?
>  _have_program() {
>  	command -v "$1" &>/dev/null
> diff --git a/tests/generic/744 b/tests/generic/744
> index cda10e0f66ba..330d86ce826a 100755
> --- a/tests/generic/744
> +++ b/tests/generic/744
> @@ -25,8 +25,7 @@ _cleanup()
>  . ./common/filter
>  . ./common/reflink
>  
> -# Modify as appropriate.
> -_require_duplicate_fsid
> +_require_clone_mount
>  _require_test
>  _require_block_device $TEST_DEV
>  _require_test_reflink
> @@ -66,11 +65,12 @@ loop_dev2=$(_create_loop_device "$loop_file2")
>  clone_filesystem ${loop_dev1} ${loop_dev2}
>  
>  # Mounting original device
> -_mount $loop_dev1 $mnt1
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev1 $mnt1
>  $XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo | _filter_xfs_io
>  
>  # Mounting cloned device
> -_mount $loop_dev2 $mnt2 || _fail "mount of cloned device failed"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev2 $mnt2 \
> +					|| _fail "mount of cloned device failed"
>  
>  # cp reflink across two different filesystems must fail
>  _cp_reflink $mnt1/foo $mnt2/bar 2>&1 | _filter_test_dir
> -- 
> 2.43.0
> 
