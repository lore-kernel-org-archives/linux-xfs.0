Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5BD1A6809;
	Tue,  1 Sep 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270762; cv=none; b=Ic+KIih6L4MoVCkF5p/f4sAoOrxWfoMLQbSw4fZHIjXBOHvfue91Nt1iYglkkj06e+3FqQtESZV2QjzBQfkf+evdfzLs82hNwS9yb7GlQPF2cUf2xXrQU84WtSjj5E9fyMPG4umnhgj3Wi7ZBGvCWabVjoGligJU5ftxJ6yXXJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270762; c=relaxed/simple;
	bh=3ZLnb7VbGB4e/0RgyN/Bz5Akor7xy34ULeCjaWrJ2gU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=hVaozDKoU532/V9DPgjXrKI9O3vOsMtCBOwTMQ6ISDoRlAeuHvznOPFQ9QigSmP8f70fx2Hp0Lq3Jz9YR5+LXViW3NTSEhOTv7YjJxvZxkWwM54MdCm70yMJA0LJ6uZAJvHBw2khbibuGK8Gwi9K84mmcdxIs01NRl+oYzkcwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEOPtGto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEOPtGto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82341F000E9;
	Tue,  1 Sep 2026 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788270761;
	bh=HXnPG0/LcG0lxd3ZdKJGWDWrH5H/kviA78EYIxQw82Y=;
	h=Date:From:Subject:To:References:In-Reply-To;
	b=dEOPtGtoy/fSficVO7Rzbw4A8lsrKRivNCm4qWDHc04g2zGDNVi1qXnljsdIQ7yHQ
	 H4jItzM+fJ7a8cts9UPBACiy5A2fMIlU2t3ejf2MvwJmZxAc0dLRlvnCoLXdNMlABK
	 UsZHzTfYwtbT23OMkk8vmMYXbIzAWcaGe/JqB4+fw8Hqp6IqGqAYg1qFjHXc7HqwBR
	 sIhEKi5rH8GwUmIY6kyCUXg9XRMOCSiQpBX/fvdiY2+B3rtHiar4WehHv4iK1aJvD1
	 Bud+C+uzemfL82nphnep4BYxh7sWv9YIjidfmOO2kiveEqK4Fp0eFeKzCL1A1AdRwt
	 srz4db27eXonQ==
Message-ID: <345c5451-2d23-4df9-8c2b-ae2a3d29b383@kernel.org>
Date: Tue, 1 Sep 2026 21:52:37 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v8 01/13] fstests: add _loop_image_create_clone() helper
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <4fa4f6bc500e0496e3d8598d38cf69597493a25b.1784949154.git.asj@kernel.org>
 <apa_4wZ21FydhN8U@zlang-mailbox>
Content-Language: en-US
In-Reply-To: <apa_4wZ21FydhN8U@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 20:33, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:38:58PM +0800, Anand Jain wrote:
>> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
>> image file and clone it to another image file, and attach a loop device to
>> them. And its destroy part.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 65 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 106f044adc2d..e8ff5be0c547 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1520,6 +1520,71 @@ _scratch_resvblks()
>>  	esac
>>  }
>>  
>> +# Create a small loop image, run an optional tuning function ($2) on it,
>> +# clone it, and attach both to loop devices, returned in ($1).
>> +# Args:
>> +#   $1: Nameref to return the array of allocated loop devices [base, clone].
>> +#   $2: Optional callback function to tune the base filesystem before cloning.
>> +_loop_image_create_clone()
> 
> To capture both the relationship and distinction between this function and
> existing _create_loop_device, I'd like to rename it to *_create_cloned_loop_devs*.

 I'm fine with _create_cloned_loop_devs() and other patches must be
updated accordingly.

>> +{
>> +	local -n _ret=$1
>> +	local pre_clone_tune_func="$2"
>> +	local img_file=$TEST_DIR/${seq}.img
>> +	local img_file_clone=$TEST_DIR/${seq}_clone.img
>> +	local size=$(_small_fs_size_mb 128) # Smallest possible
>> +	local loop_devs=()
>> +
>> +	# Since we copy the block device image, we keep its size small.
>> +	_require_fs_space $TEST_DIR $((size * 1024 * 2))
>> +
>> +	_create_file_sized $((size * 1024 * 1024)) $img_file ||
>> +				_fail "Failed: Create $img_file $size"
>> +


>> +	loop_devs=("$(_create_loop_device $img_file)")
>> +
>> +	case $FSTYP in
>> +	xfs)
>> +		_mkfs_dev -s size=4096 "${loop_devs[0]}"
> 
> Why xfs needs a specific "-s size=4096" ? Hardcoding this parameter might cause
> failures in certain incompatible environments.
>> +		;;
>> +	btrfs)
>> +		_mkfs_dev "${loop_devs[0]}"
> 
> If btrfs is handled the same way as the default `*)` branch below, there is
> no need to have a dedicated branch for it.
> 
>> +		;;
>> +	*)
>> +		_mkfs_dev "${loop_devs[0]}"
>> +		;;
>> +	esac
>> +
>> +	# Only execute if the function argument is not empty
>> +	if [ -n "$pre_clone_tune_func" ]; then
>> +		$pre_clone_tune_func "${loop_devs[0]}"
>> +	fi
>> +
>> +	sync "${loop_devs[0]}"
> 
> Since the mkfs command above operates directly on a loop device, I wanted to
> make sure, can the sync command be targeted at a block device, and does it
> guarantee a cache flush or blockdev page cache sync ?
> 
> How about:
>   sync -d "${loop_devs[0]}"
>   blockdev --flushbufs "${loop_devs[0]}"
> or any better idea?
> 

Spotted stale code here while refactoring pre_clone_tune_func.
The updated code with the suggested renames is below.

Agreed that <dev> in sync is redundant. Adding sync serves
as a safeguard if a future mkfs fails to do so. Flushing
via blockdev --flushbufs followed by a global sync properly
follows the data flow path it may not be strictly required
but it is safer.


>> +	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"
>> +
>> +	loop_devs+=("$(_create_loop_device $img_file_clone)")
>> +
>> +	_ret=()
>> +	for i in "${loop_devs[@]}"; do
>> +		_ret+=("$i")
>> +	done
> 
> How about:
>   _ret=("${loop_devs[@]}")
> directly?
> 

yeah. added.

>> +}
>> +
>> +# Teardown loop devices and delete their underlying backing image files.
>> +# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
>> +_loop_image_destroy()
> 
> To keep it consistent with the renamed function above, we could rename this
> to *_destroy_cloned_loop_devs*. Alternatively, if we don't consider it
> clone-specific, *destroy_loop_devs* would also be good to me.
> 

 _destroy_cloned_loop_devs() is fine.



Updated code:

---------------------------------
diff --git a/common/rc b/common/rc
index 45cf9360ba73..285463b4e3db 100644
--- a/common/rc
+++ b/common/rc
@@ -1561,7 +1561,7 @@ _change_metadata_uuid()
 # Args:
 #   $1: Nameref to return the array of allocated loop devices [base,
clone].
 #   $2: Optional callback function to tune the base filesystem before
cloning.
-_loop_image_create_clone()
+_create_cloned_loop_devs()
 {
 	local -n _ret=$1
 	local pre_clone_tune_func="$2"
@@ -1578,37 +1578,28 @@ _loop_image_create_clone()

 	loop_devs=("$(_create_loop_device $img_file)")

-	case $FSTYP in
-	xfs)
-		_mkfs_dev -s size=4096 "${loop_devs[0]}"
-		;;
-	btrfs)
-		_mkfs_dev "${loop_devs[0]}"
-		;;
-	*)
-		_mkfs_dev "${loop_devs[0]}"
-		;;
-	esac
+	_mkfs_dev "${loop_devs[0]}"

 	# Only execute if the function argument is not empty
 	if [ -n "$pre_clone_tune_func" ]; then
 		$pre_clone_tune_func "${loop_devs[0]}"
 	fi

-	sync "${loop_devs[0]}"
+	# We are about to copy the loop device's backing file
+	# Flush loop device's buffer cache
+	blockdev --flushbufs "${loop_devs[0]}"
+	# Sync system's dirty pages including backing file's
+	sync
 	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"

 	loop_devs+=("$(_create_loop_device $img_file_clone)")

-	_ret=()
-	for i in "${loop_devs[@]}"; do
-		_ret+=("$i")
-	done
+	_ret=("${loop_devs[@]}")
 }

 # Teardown loop devices and delete their underlying backing image files.
 # Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
-_loop_image_destroy()
+_destroy_cloned_loop_devs()
 {
 	for d in "$@"; do
 		# Retrieve the path of the backing file
-------------------------------


Thanks.
Anand


> Thanks,
> Zorro
> 
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

