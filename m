Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944E9310784;
	Tue,  1 Sep 2026 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251943; cv=none; b=ntE/UWR3A6QUymEXVvGNVxD9N/WZrCuENneVeU3/zazHqZTwjku7wDMItEJU+nCQSnSbxmdQKcS1+W7lgiB1Wy43zUrJd/l2LOM2DyQUGQ+6LUE4ZPCGkwBp5S3NSPav4spqSRsKyqFK6zcMtIeFYnavbQoDdlwI6BizPXtXqSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251943; c=relaxed/simple;
	bh=Q8rtIrAI/5YduudyVzsG7RUzA/U5EKFszaVpxqG/Uuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBb7bK7YBPp352b2S+gqpTOIU/sX1aZJrfmBMd3T+eHTMgB6CsIKl9s8iZbjeomVEpVDQrBfkRqQb2hiRU2sThSLcPct6uu+GepMw+hRizSw3Pe6QDUN6syhWaQnzejXAa6u21CIqJ0ld5jeLgzsa9Nu3H1uFVVTkfQFqM/zxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJuxSrOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJuxSrOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A971F000E9;
	Tue,  1 Sep 2026 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251942;
	bh=zhkPVoqdfinJ81L4Qda11eGJhGh7cb57yzPtQyej4UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WJuxSrOJHVIaYS/NlK4tlQD+/TDWYLeVY0YHxIv5/5+arLO9bCoXq1XQQn7W0WQTk
	 OewR+G1WLuEEQ+OVVVUDoXomVVDUtVLtYmSfvmJlgYBvxOEJxQDt+fPlqyfleE0N6x
	 6JaEjX/c975qqbBneSKvwQ2atHc60iK+VjMn9cDm4V+2e1FMsDIaGHM1F0BA6rubXZ
	 PRCmjJzQa08KshgjKq3q/5CxJz5kElWeVWNpyAE3dAJJsf7pOFfzmQ6Of1v3ekrRrp
	 LX0sK1h/kPFqx8mqDAWL/Pvl3zJIQpUTzcOClDHpsD+KDzNFPXWGitJiEhThdYJndt
	 w4+dB9trevm6g==
Date: Tue, 1 Sep 2026 20:33:35 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 01/13] fstests: add _loop_image_create_clone() helper
Message-ID: <apa_4wZ21FydhN8U@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <4fa4f6bc500e0496e3d8598d38cf69597493a25b.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fa4f6bc500e0496e3d8598d38cf69597493a25b.1784949154.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:38:58PM +0800, Anand Jain wrote:
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device to
> them. And its destroy part.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 106f044adc2d..e8ff5be0c547 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1520,6 +1520,71 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +# Create a small loop image, run an optional tuning function ($2) on it,
> +# clone it, and attach both to loop devices, returned in ($1).
> +# Args:
> +#   $1: Nameref to return the array of allocated loop devices [base, clone].
> +#   $2: Optional callback function to tune the base filesystem before cloning.
> +_loop_image_create_clone()

To capture both the relationship and distinction between this function and
existing _create_loop_device, I'd like to rename it to *_create_cloned_loop_devs*.

> +{
> +	local -n _ret=$1
> +	local pre_clone_tune_func="$2"
> +	local img_file=$TEST_DIR/${seq}.img
> +	local img_file_clone=$TEST_DIR/${seq}_clone.img
> +	local size=$(_small_fs_size_mb 128) # Smallest possible
> +	local loop_devs=()
> +
> +	# Since we copy the block device image, we keep its size small.
> +	_require_fs_space $TEST_DIR $((size * 1024 * 2))
> +
> +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
> +				_fail "Failed: Create $img_file $size"
> +
> +	loop_devs=("$(_create_loop_device $img_file)")
> +
> +	case $FSTYP in
> +	xfs)
> +		_mkfs_dev -s size=4096 "${loop_devs[0]}"

Why xfs needs a specific "-s size=4096" ? Hardcoding this parameter might cause
failures in certain incompatible environments.

> +		;;
> +	btrfs)
> +		_mkfs_dev "${loop_devs[0]}"

If btrfs is handled the same way as the default `*)` branch below, there is
no need to have a dedicated branch for it.

> +		;;
> +	*)
> +		_mkfs_dev "${loop_devs[0]}"
> +		;;
> +	esac
> +
> +	# Only execute if the function argument is not empty
> +	if [ -n "$pre_clone_tune_func" ]; then
> +		$pre_clone_tune_func "${loop_devs[0]}"
> +	fi
> +
> +	sync "${loop_devs[0]}"

Since the mkfs command above operates directly on a loop device, I wanted to
make sure, can the sync command be targeted at a block device, and does it
guarantee a cache flush or blockdev page cache sync ?

How about:
  sync -d "${loop_devs[0]}"
  blockdev --flushbufs "${loop_devs[0]}"
or any better idea?

> +	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"
> +
> +	loop_devs+=("$(_create_loop_device $img_file_clone)")
> +
> +	_ret=()
> +	for i in "${loop_devs[@]}"; do
> +		_ret+=("$i")
> +	done

How about:
  _ret=("${loop_devs[@]}")
directly?

> +}
> +
> +# Teardown loop devices and delete their underlying backing image files.
> +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
> +_loop_image_destroy()

To keep it consistent with the renamed function above, we could rename this
to *_destroy_cloned_loop_devs*. Alternatively, if we don't consider it
clone-specific, *destroy_loop_devs* would also be good to me.

Thanks,
Zorro

> +{
> +	for d in "$@"; do
> +		# Retrieve the path of the backing file
> +		local f=$(losetup --noheadings --output BACK-FILE $d)
> +
> +		# Detach the loop device from the backing file
> +		_destroy_loop_device "$d"
> +
> +		# Clean up the backing disk image file
> +		[ -n "$f" ] && rm -f "$f"
> +	done
> +}
>  
>  # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
>  # errors found or errors were fixed) and nonzero otherwise; also spits out
> -- 
> 2.43.0
> 
