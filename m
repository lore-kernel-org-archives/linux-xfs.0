Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4E4071E3;
	Mon,  8 Jun 2026 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929550; cv=none; b=AOL0BIa5yhrSqceFFZRSwGPyJSAcBEeyywyvQ4EkapmJrkJpr7vgK+UfoDZ3igN4MXGAa8x/jF2/do5IBGD6+dEMct70tJEYWAzlv2wrzz9Z+75uiVVnRePwFdZSL2OMbljIceTXw3h2mAM48Y8tOWrEqCsdmvBIIhh+XJY8Qfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929550; c=relaxed/simple;
	bh=IET4gOLg/GiuDH2G5sH6S/R5samsShL+Ri7O9a/SgzU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=aPZ6U8dxbhZEog8jGc4ETvd6dxSCKOFl59KMFH2/XKClbP+G/S0hbcnCT5XwkDViX3hC2Gj8K6BpYdfRhdmmx5vPkY7SscikBWa22KbbwGSF/suP8eF+csREC36RU2lrD8uYV2AvEqaU2N1pEJwO+M7ONqsXPMBQL91ZDB/xoR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzxHlb01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzxHlb01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6183B1F00898;
	Mon,  8 Jun 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929549;
	bh=b2IFtj8GrIFcfIZoR8REKv1zaTaDXNqjayO7wEM71no=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=BzxHlb01ARgm2lzi8SbGzOcsX4mGRQ8MAu9rvu3N3vgFzzZ2CKZK1x7BOruElyHt+
	 FuxTReh67hbF0e0jJgoi+YaBTXy+8WjhQ1bcr1snZd6xZcozL41RMCH+tcci5WBpi4
	 h/NaOarVTQ6hrihI3l3N54LD+SIG57NMPTfYkKoV9BorGrdQ+qv3RJLizbYwav60Rw
	 dI8ubnz6eOS4cHH+AyUG9Npemc0M2uLTHFdRUomBcLsU44ER2v4zXV1PiuMUO4CBfu
	 epEXt1IS6qUmNotNBXIWs7uA7UVBJH8jQwBJrpw58gxfg2bwyyLCV1yEsdlyQd8e6Q
	 auHB1SIm6tXZg==
Message-ID: <9c0989d8-202f-42ab-9347-df082c25aa72@kernel.org>
Date: Mon, 8 Jun 2026 22:39:04 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v6 01/11] fstests: add _loop_image_create_clone() helper
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1779939330.git.asj@kernel.org>
 <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1779939330.git.asj@kernel.org>
 <20260529042743.GB6070@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260529042743.GB6070@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/5/26 12:27, Darrick J. Wong wrote:
> On Thu, May 28, 2026 at 12:05:32PM +0800, Anand Jain wrote:
>> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
>> image file and clone it to another image file, and attach a loop device to
>> them. And its destroy part.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 63 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 79189e7e6e94..d7e3e0bdfb1e 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1520,6 +1520,69 @@ _scratch_resvblks()
>>  	esac
>>  }
>>  
>> +# Create a small loop image, run an optional tuning function ($2) on it,
>> +# clone it, and attach both to loop devices, returned in ($1).
>> +# Args:
>> +#   $1: Nameref to return the array of allocated loop devices [base, clone].
>> +#   $2: Optional callback function to tune the base filesystem before cloning.
>> +_loop_image_create_clone()
>> +{
>> +	local -n _ret=$1
> 
> That switch   ^^ is very clever.  I always wondered how one did indirect
> variables in bash.
> 
>> +	local pre_clone_tune_func="$2"
>> +	local img_file=$TEST_DIR/${seq}.img
>> +	local img_file_clone=$TEST_DIR/${seq}_clone.img
>> +	local size=$(_small_fs_size_mb 128) # Smallest possible
>> +	local loop_devs
>> +
>> +	# Since we copy the block device image, we keep its size small.
>> +	_require_fs_space $TEST_DIR $((size * 1024))
>> +
>> +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
>> +				_fail "Failed: Create $img_file $size"
>> +
>> +	loop_devs=$(_create_loop_device $img_file)
>> +	_ret=($loop_devs)
> 
> Should this check that a loopdev actually got created?
> 

Hmm, in the function _create_loop_device(), we are
calling _fail if create fails, so no need to duplicate, right?

>> +	case $FSTYP in
>> +	xfs)
>> +		_mkfs_dev "-s size=4096" ${loop_devs[0]}
>> +		;;
>> +	btrfs)
>> +		_mkfs_dev ${loop_devs[0]}
>> +		;;
>> +	*)
>> +		_mkfs_dev ${loop_devs[0]}
>> +		;;
>> +	esac
>> +
>> +	# Only execute if the function argument is not empty
>> +	if [ -n "$pre_clone_tune_func" ]; then
>> +		$pre_clone_tune_func ${loop_devs[0]}
>> +	fi
>> +
>> +	sync ${loop_devs[0]}
>> +	cp $img_file $img_file_clone
>> +


>> +	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"
> 
> 	local lodev="$(_create_loop_device ...)"
> 
> 	test -z "$lodev" && _fail "second loopdev not created"
> 	_ret+=("$lodev")
> 
> ?

If the second `_create_loop_device()` happens to fail, it will
already have called `_fail`, so "second loopdev..." won't be
used at all.


Thanks, Anand



>> +
>> +	_ret=($loop_devs)
>> +}
>> +
>> +# Teardown loop devices and delete their underlying backing image files.
>> +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
>> +_loop_image_destroy()
>> +{
>> +	for d in "$@"; do
>> +		# Retrieve the path of the backing file
>> +		local f=$(losetup --noheadings --output BACK-FILE $d)
>> +
>> +		# Detach the loop device from the backing file
>> +		_destroy_loop_device "$d"
>> +
>> +		# Clean up the backing disk image file
>> +		[ -n "$f" ] && rm -f "$f"
>> +	done
>> +}
>>  
>>  # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
>>  # errors found or errors were fixed) and nonzero otherwise; also spits out
>> -- 
>> 2.43.0
>>
>>

