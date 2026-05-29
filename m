Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4451F372ED2;
	Fri, 29 May 2026 04:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028865; cv=none; b=f8D5aIrW+N4uT2kVEEaA6BgQtHdlswyre0kvO6plvbFlQ6h8GfTEqaIYsPt7T2rLb3Wdb6z+5YeJLP0sTEPwrY7FYW0ctJxfFjQ6XtB1QOBYclhbWfYfa/BrReT6J+ibphtv4Jq7RIC4kmprrFTtKJDU0pPUtE8cIl8rLROa+JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028865; c=relaxed/simple;
	bh=EIqAni/pIgnNQbr7so1S559grb42Ae6dsus3VsHeF/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECcv5mXcnuUyh0B5roFjnRkbXT/RQm67gKnNG0xkh/TwXAOtbrtNPxUZniQOU6etE91TrQBlZXi7mcOq+d6pU6NOb+Dzinaeg5PO8Cg9k0k2Om3mBS0QhGzIZswn0jwxGaEPG1bwmcrqbh4FgdVuQaY9Ou46hLuYWfsi23aJRVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpjm47+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpjm47+e"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0E8961F00893;
	Fri, 29 May 2026 04:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780028864;
	bh=HqCYZs2wlS5Sw/AOAlKzlJPT1ANIz0S+Gw3elOFl6LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hpjm47+eVu5hbHMHY+XeCvXRczVYs4LsOB76U93I1dwcw/PaMlZY4Phpop+dXeXmU
	 En2ImAr6bjSYnMhzuO48d0H5k7xPhlsfwSqvpNVQdOFnmRtimLswlRxraUJoSQstvS
	 DjU74JNVpG0pzYMpvZFf4VecbqndYsFquvwSWer4U8Sw0DIVSiwlMn/yuoV4aqhPNm
	 2dgorvSUQ18YMAD2rPY/6q75bipMuD8l6HLazDQ3s4wH996JnG4Y9VUP0Md1U1ZspJ
	 0T9u/AkRcRjbRUm0GWbSnNZCW5NSRCylBsAgFetO2fCkb6EH+pn3efuAV3/N5UuSEh
	 T46s17M/Qk0hg==
Date: Thu, 28 May 2026 21:27:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 01/11] fstests: add _loop_image_create_clone() helper
Message-ID: <20260529042743.GB6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:32PM +0800, Anand Jain wrote:
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device to
> them. And its destroy part.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 79189e7e6e94..d7e3e0bdfb1e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1520,6 +1520,69 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +# Create a small loop image, run an optional tuning function ($2) on it,
> +# clone it, and attach both to loop devices, returned in ($1).
> +# Args:
> +#   $1: Nameref to return the array of allocated loop devices [base, clone].
> +#   $2: Optional callback function to tune the base filesystem before cloning.
> +_loop_image_create_clone()
> +{
> +	local -n _ret=$1

That switch   ^^ is very clever.  I always wondered how one did indirect
variables in bash.

> +	local pre_clone_tune_func="$2"
> +	local img_file=$TEST_DIR/${seq}.img
> +	local img_file_clone=$TEST_DIR/${seq}_clone.img
> +	local size=$(_small_fs_size_mb 128) # Smallest possible
> +	local loop_devs
> +
> +	# Since we copy the block device image, we keep its size small.
> +	_require_fs_space $TEST_DIR $((size * 1024))
> +
> +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
> +				_fail "Failed: Create $img_file $size"
> +
> +	loop_devs=$(_create_loop_device $img_file)
> +	_ret=($loop_devs)

Should this check that a loopdev actually got created?

> +	case $FSTYP in
> +	xfs)
> +		_mkfs_dev "-s size=4096" ${loop_devs[0]}
> +		;;
> +	btrfs)
> +		_mkfs_dev ${loop_devs[0]}
> +		;;
> +	*)
> +		_mkfs_dev ${loop_devs[0]}
> +		;;
> +	esac
> +
> +	# Only execute if the function argument is not empty
> +	if [ -n "$pre_clone_tune_func" ]; then
> +		$pre_clone_tune_func ${loop_devs[0]}
> +	fi
> +
> +	sync ${loop_devs[0]}
> +	cp $img_file $img_file_clone
> +
> +	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"

	local lodev="$(_create_loop_device ...)"

	test -z "$lodev" && _fail "second loopdev not created"
	_ret+=("$lodev")

?

> +
> +	_ret=($loop_devs)
> +}
> +
> +# Teardown loop devices and delete their underlying backing image files.
> +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
> +_loop_image_destroy()
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
> 
