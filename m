Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795455413;
	b=iVUMtIrc9HlMro+EQGPo/e4vOpi7/FIcOmob3BtHrLLgYjGmkvdGHjEaXIxCr65msME9
	 B3TBxqBlR/JeCYr7SYFKsLxO4zIW2AjpCGswY27gkkAqnJFVZuzFnfG3Jb0cgN6p43mnU
	 p4rA4ejwmKn9uanswxjwsCY3p3h26PUlqBxZHvKj5v6wfdJ4ZW1PHyKEea4COMidpvPMv
	 d2E/SxkMG1e9Vh/5HVFJ/fBLmTejMCiv1FGTkqQERK3lZWUyadXG5z0ymSLqSvplOoScE
	 94Ugrpv65O4CQvBJHkdl6bxHodDqqsWfFfo59i6AtgmUQ6Gs5fIW3EsW9BYaLv6K3GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795455413;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9Y6aOWkpjpSTVf2HoD6BSvDp+T6/1/XKZfs2BsPaJSI=;
	b=XGan7w9NRg7tuHTWpIiI9rVfdytTLhGG4zyVZHMcUDzsAmEPG0VY28Rv9JngPkurcMg7
	 T9J5Glxs9pYOmEJBTpAhQaMr4ue+EykFxywPU9oNy18XJW7X2Z9+TzRpQVZFw+03QUelN
	 SaCGTgc1o9vQ8q5VIUEHb7AMCy2N2HGhCkTrtZK2ki9veKXmB6UrEt7SMSvl1eOQLZ8vU
	 PUvkmdP0bNR/QK0jnAB3eHkVEWeBivtX/y8+b9qmSlnimP9G2AWxfHPmzNiroDN2/30Mv
	 KgIMAvfE3LxsHvacv5qyYctuly3pXyU34lrPMDk2tS07ByQrp7jDEFmxlshvqYei+FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mzoA6nYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899A606A6AF;
	Mon, 23 Nov 2026 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mzoA6nYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9A61F000D2;
	Mon, 23 Nov 2026 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795455412;
	bh=9Y6aOWkpjpSTVf2HoD6BSvDp+T6/1/XKZfs2BsPaJSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mzoA6nYvtMEt6dkhL+n8rOfWS/EDMN0nEK7E8HbmA/DhDEt2FDTlY5SA4FN+0MawJ
	 iHxkiA3GKPvQqNtGvmNvDC8QdWQTXz9pOpS+nvkP9wDUk0+Hp4GabXGCraWxgWxXru
	 pLBVzQDy/bCtMkxAiJSgnZCq0b7P/8AB+Ux/tfj+rjXErb5nPYCuRVNHaJSZPM3YmR
	 6x16niKPTzyCqCbzQkzCQIhOQNW2nxOdkCGcQSyq+S27IKkZXG0MXDo1MX687Cll/S
	 1KOC4nljE5QKik527KcGu0sw2o9JaziyYBZvqRx+g0q+OlfjoUMb/dSvoL2nAloQBk
	 RW7lwUvJWmguw==
Date: Tue, 24 Nov 2026 01:36:42 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/21] fstests: introduce _create_cloned_loop_devs()
 helper
Message-ID: <awR26muFLJ2qF5qN@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <d97b87a346488157df940edbf89c62b71bbd0340.1791272793.git.asj@kernel.org>
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
In-Reply-To: <d97b87a346488157df940edbf89c62b71bbd0340.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:28PM +0800, Anand Jain wrote:
> Introduce _create_cloned_loop_devs() and _destroy_cloned_loop_devs to mkfs an
> image file and clone it to another image file, and attach a loop device to
> them. And its destroy part.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 7868e6d311a2..f2ab4bc491af 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1534,6 +1534,72 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +# Create a small loop image, run an optional tuning function ($2) on it,
> +# clone it, and attach both to loop devices, returned in ($1).
> +# Args:
> +#   $1: Nameref to return the array of allocated loop devices [base, clone].
> +#   $2: Optional callback function to tune the base filesystem before cloning.
> +_create_cloned_loop_devs()
> +{
> +	local -n _ret=$1
> +	local pre_clone_tune_func="$2"
> +	local img_file="$TEST_DIR/${seq}/orig.img"
> +	local img_file_clone="$TEST_DIR/${seq}/clone.img"
> +	local size=$(_small_fs_size_mb 128) # Smallest possible
> +	local temp_dev
> +	local loop_devs=()
> +
> +	# All current callers mount the original and the clone simultaneously.
> +	_require_clone_mount
> +
> +	# Since we copy the block device image, we keep its size small.
> +	_require_fs_space $TEST_DIR $((size * 1024 * 2))
> +
> +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
> +				_fail "Failed: Create $img_file $size"
> +
> +	temp_dev=("$(_create_loop_device_like_bdev $img_file ${TEST_DEV})")
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You defined this as an array here, but later you treat it as a regular variable.
If an array isn't needed here, just declare it as a normal variable.

> +	_mkfs_dev "${temp_dev}"
               ^^^^^^^^^^^

> +
> +	# Only execute if the function argument is not empty
> +	if [ -n "$pre_clone_tune_func" ]; then
> +		$pre_clone_tune_func "${temp_dev}"
                              ^^^^^^^^^^^

> +	fi
> +
> +	# We are about to copy the loop device's backing file
> +	# Flush loop device's buffer cache
> +	blockdev --flushbufs "${temp_dev}"
                          ^^^^^^^^^^^
> +	# Sync system's dirty pages including backing file's
> +	sync
> +	_destroy_loop_device "${temp_dev}"
                          ^^^^^^^^^^^
> +
> +	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"
> +
> +	loop_devs=("$(_create_loop_device_like_bdev $img_file ${TEST_DEV})")
> +	loop_devs+=("$(_create_loop_device_like_bdev $img_file_clone ${TEST_DEV})")
> +
> +	# Help debug
> +	losetup --list "${loop_devs[0]}" >> $seqres.full
> +	losetup --list "${loop_devs[1]}" >> $seqres.full
> +
> +	_ret=("${loop_devs[@]}")
> +}
> +
> +# Teardown loop devices and delete their underlying backing image files.
> +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
> +_destroy_cloned_loop_devs()
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
