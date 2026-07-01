Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036F0385D89;
	Wed,  1 Jul 2026 17:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782925635; cv=none; b=gKRxHzsxndjAV23hd1099vzsie4362Y/CMNU6WVMufR7JzsPl9IZlSPPdyCWxX/2Ouv8eXHA08vFcu9QJJq/IW9L7X2YHYZMNlc6vcn9+B4SxE8xQIzEpbPeUs4aMgQWktZsIOlwrLuAqfqvEkB6HbwViqlbAHIbuamOyKdIbp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782925635; c=relaxed/simple;
	bh=3iisFyUjd5BnT25bYG8Yi8RdLOCy3g9Jmhn0Ujipl1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4lsOdHv5Kng5FuWE35XjdW4rLZySUIKJb/lqjpvw7rsck4g6YOfVMh3wX2t+BzeaZHRaPZAw7iHHjhMvrgp9lBekqA6XK+Nv3om7fTHoF60+dQby5jQ/3aDZN7+D2gvoLtCnIZJSvb5YnxbNv9zkau4szFp0gUL7773h7hEZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGHmrzkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGHmrzkn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 820C61F000E9;
	Wed,  1 Jul 2026 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782925633;
	bh=09HWxDVeypl9bxp+WG1vrJ1WtSL6U/JuJK1E737LUCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGHmrzknDfNiq8VGRsyT1WFe2XL3uXXaXIZCL1ui2djLdJIfnfHuKxEU5syp72KCh
	 qyw1hcOzqCvu2hcXWvuASMVwcOvjBB5yIjrYbGUHX4hdpo6UTXoHGaraxCIpWMGD1Q
	 P9ruQ8vDAbzuTw0vM/87Ch1imZyFfR5kGZlDtNDA0XR1l3pFlt2+jT8/FTgt7T1amF
	 DK6cAPHT4dhE3+JKGwEgPW9uHZ/qDRQ9N0Jp8uYAlBC5sW7eydUQNJkWnd+ueuDNr9
	 c/0Jtb1npDKnM4thmBgtBFOpo4PtB444XJwEC5ky+GhOwrv2BwLANruV8uHOedK5Uw
	 1i9rzrCEqUExA==
Date: Wed, 1 Jul 2026 10:07:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v7 01/11] fstests: add _loop_image_create_clone() helper
Message-ID: <20260701170713.GE6517@frogsfrogsfrogs>
References: <cover.1781694879.git.asj@kernel.org>
 <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1781694879.git.asj@kernel.org>

On Wed, Jun 17, 2026 at 07:20:28PM +0800, Anand Jain wrote:
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
> +
> +	case $FSTYP in
> +	xfs)
> +		_mkfs_dev "-s size=4096" ${loop_devs[0]}

Not sure why you pass two separate cli arguments as a quoted string, but
my guess is it "doesn't matter" because _try_mkfs_dev uses $* unquoted,
which separates them again.

I HATE BASH.

> +		;;
> +	btrfs)
> +		_mkfs_dev ${loop_devs[0]}

And while I'm whining:    ^^^^^^^^^^^^^^^ actually should be quoted.
Not that fstests is at all good at getting this right.

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

What if cp doesn't create a reflink copy?  Can we fill up the $TEST_DIR
despite having checked it for sufficient free space?  Especially on
filesystems that don't support sparse holes?

> +
> +	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"
> +
> +	_ret=($loop_devs)

Hmm.  Should this function return nonzero if any part of the clone
creation fails?  Or are callers expected to notice that _ret only has
one element?

--D

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
