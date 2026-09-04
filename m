Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A227841D21E;
	Fri,  4 Sep 2026 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502494; cv=none; b=ZnnqMnMCDPxWsK32lZddR1sCVWdE1wox+TvJVl7wKMhEsheI3HO6skSYxPdDLuch+EzRGgu2wtKup/QnArjgPetTf8dHDNfu4QuQGKcmPla7jT0N3Vpl9yWIwmdWNP1pqmn8hMzKRv9YgAwPb8c62UUW02IU+5tJ9wIAzU5Y6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502494; c=relaxed/simple;
	bh=+Vuva2x07kkQ3twdLMiAjuSVbM9K9HtOCZRS9vP9vak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Tby9VycMoLJP4/Tg/7XzqReTETGLVC534lsa1Kv7qzdhZCb6P3rDrm7dUJCQIOlsLKiA91ptm+Dh6pxphmZEINf3LhpcHjhzoN4lIg/FRLuy2azj8j65ph+gZk6jmGJ+MqPboqLcCTVK4v9piR7Q/n2GjtIwJ6Pfzh06dD0sxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHRJ79Ty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHRJ79Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A001F00A3E;
	Fri,  4 Sep 2026 06:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788502492;
	bh=bTsu2G89SJRy90MXm2vb5283BxfcwUlExbIyEQ3jmSY=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=iHRJ79TyoZxlkp7nwSUOLxwhbS90hnxS0b5CeEe1PqEX/vuIH/bXcZi5qBX5B6Uw1
	 yMoKiIMSuLBtRcvkY9F8W4vwGGqgsKa9Y53EmGTQ7io4tiB4ZiRCBdhjwtq63a55OE
	 h14hJbXsZ8SstPXhv5IkSy4aTpIBzdDptLREJJYg6spnarjqHd1u0KpLy+U9EocpQp
	 APbFMPo4vVbvZPj01MhRlN6Yp0KMzRWf7mKdWuaMI1ID+QPsRq77fEjmUXgejS8U+6
	 dBuRjMPUVe0kYilq1jQchst3KFjn5qz/IKeWtJtpXokHFDTfghmH4LEeMgWZd9TQKX
	 qx8coXyOyz1HQ==
Message-ID: <d6efde18-0e87-4db0-8560-cbb2acc7b5a5@kernel.org>
Date: Fri, 4 Sep 2026 14:14:48 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/13] fstests: verify fanotify isolation on cloned
 filesystems
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <96599abcd6e3264a088ea2f34947de6496f33359.1784949155.git.asj@kernel.org>
 <apb8S8g3Zqf1XpZ9@zlang-mailbox>
Content-Language: en-US
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, djwong@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apb8S8g3Zqf1XpZ9@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/9/26 02:23, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:04PM +0800, Anand Jain wrote:
>> Verify that fanotify events are correctly routed to the appropriate
>> watcher when cloned filesystems are mounted.
>> Helps verify kernel's event notification distinguishes between devices
>> sharing the same FSID/UUID.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/801     | 143 ++++++++++++++++++++++++++++++++++++++++++
> 
> `g/801` is already taken. To avoid merge conflicts, you can use a higher
> temporary number, and I'll assign the proper number when merging.
> 

Let me bump-it up to 90x.

>>  tests/generic/801.out |   7 +++
>>  2 files changed, 150 insertions(+)
>>  create mode 100644 tests/generic/801
>>  create mode 100644 tests/generic/801.out
>>
>> diff --git a/tests/generic/801 b/tests/generic/801
>> new file mode 100644
>> index 000000000000..904ba9440b3d
>> --- /dev/null
>> +++ b/tests/generic/801
>> @@ -0,0 +1,143 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 801
>> +# Verify fanotify FID functionality on cloned filesystems by setting up
>> +# watchers and making sure notifications are in the correct logs files.
>> +
>> +. ./common/preamble
>> +
>> +_begin_fstest auto quick mount clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
> 
> Which test condition requires `TEST_DEV` to be a block device?

You're right, I think this is a leftover from earlier prototyping
with scsi_device. The test only needs loop devices backed by
$TEST_DIR. I'll remove it in the following ver.

> 
>> +_require_loop
>> +_require_command "$SEMANAGE_PROG" semanage
>> +_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
>> +_require_fanotify_function
>> +_require_unique_f_fsid
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
>> +	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
>> +
>> +	if [ "$semanage_added" = "yes" ]; then
>> +		semanage permissive -d unconfined_t >/dev/null 2>&1 || true
>> +	fi
>> +
>> +	umount $mnt1 $mnt2 >/dev/null 2>&1
>> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
>> +	rm -r -f $tmp.*
>> +}
>> +
>> +# Run fsnotifywait in unbuffered mode to watch filesystem-wide create events
>> +monitor_fanotify()
>> +{
>> +	local mmnt=$1
>> +	exec stdbuf -oL $FSNOTIFYWAIT_PROG -m -F -S -e create "$mmnt" 2>&1
>> +}
>> +
>> +# Transform f_fsid into the hi.lo format used in fanotify FID logs
>> +fsid_to_fid_parts()
>> +{
>> +	local fsid=$1
>> +	# Pad to 16 hex chars (64-bit), then split into two 32-bit halves
>> +	local padded=$(printf '%016x' "0x${fsid}")
>> +	local hi=$(printf '%x' "0x${padded:0:8}")   # strips leading zeros
>> +	local lo=$(printf '%x' "0x${padded:8:8}")   # strips leading zeros
>> +	echo "${hi}.${lo}"
>> +}
>> +
>> +# Create base loop device and its clone
>> +devs=()
>> +_loop_image_create_clone devs
>> +mkdir -p $TEST_DIR/$seq
>> +mnt1=$TEST_DIR/$seq/mnt1
>> +mnt2=$TEST_DIR/$seq/mnt2
>> +mkdir -p $mnt1
>> +mkdir -p $mnt2
>> +
>> +# Mount both base and clone filesystems using required clone mount options
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +# Fetch filesystem IDs to verify the kernel can differentiate between them
>> +fsid1=$(stat -f -c "%i" $mnt1)
>> +fsid2=$(stat -f -c "%i" $mnt2)
>> +
>> +log1=$tmp.fanotify1
>> +log2=$tmp.fanotify2
>> +
>> +pid1=""
>> +pid2=""
>> +echo "Setup FID fanotify watchers on both mnt1 and mnt2"
>> +
>> +# Permit unconfined_t domains when SELinux is enforcing to prevent fanotify
>> +# blockages
>> +semanage_added="no"
>> +if [ "$(getenforce 2>/dev/null)" = "Enforcing" ]; then
>> +    if ! semanage permissive -l | grep -q "unconfined_t"; then
>> +        semanage permissive -a unconfined_t >/dev/null 2>&1 && semanage_added="yes"
>> +    fi
>> +fi
> 
> Looks like semanage/SELinux isn't a necessary requirement of this test case,
> if so that `_require_command "$SEMANAGE_PROG" semanage` also can be:
> 
>   if [ "$(getenforce 2>/dev/null)" = "Enforcing" ]; then
>       _require_command "$SEMANAGE_PROG" semanage
>   fi
> 
> right? And please replace semanage with $SEMANAGE_PROG.
> 

Absolutely, that is the right way. I'll update it. Thanks!. More below.

>> +
>> +# Start asynchronous fanotify monitors
>> +( monitor_fanotify "$mnt1" > "$log1" ) &
>> +pid1=$!
>> +( monitor_fanotify "$mnt2" > "$log2" ) &
>> +pid2=$!
>> +sleep 2
> 
> Are you using `sleep 2` to ensure `fsnotifywait` is fully set up?
> I'm not sure if `sleep 2` is 100% reliable here. Since the subsequent tests
> strictly depend on `fsnotifywait` starting up properly, is there a more
> robust approach than `sleep 2`? For example, could we check the output
> in `$log1` and `$log2` to make sure that? Or any other better idea?
> 
>> +
>> +if ! kill -0 "$pid1" 2>/dev/null || ! kill -0 "$pid2" 2>/dev/null; then
> 
> `kill 0` only can make sure the process is running, can't make sure it's
> fully set up, right?
> 

I rely on checking whether the userspace process is still
running after a 2 second delay.

Matching specific stdout strings a common pattern in fstests
tends to be fragile across different versions of userspace
utilities. For instance, the "Watches established" string
in fsnotifywait isn't guaranteed across versions:

$ fsnotifywait -m -F -S -e create /btrfs
Setting up filesystem watches.
Watches established.
^C


>> +	cat "$log1"
>> +	cat "$log2"
>> +	_fail "$FSNOTIFYWAIT_PROG setup failed"
>> +fi
>> +
>> +echo "Trigger file creation on mnt1"
>> +touch $mnt1/file_on_mnt1
>> +sync
>> +sleep 1
>> +
>> +echo "Trigger file creation on mnt2"
>> +touch $mnt2/file_on_mnt2
>> +sync
>> +sleep 1
>> +
>> +echo "Verify fsid in the fanotify"
>> +kill $pid1 $pid2
>> +wait $pid1 $pid2 2>/dev/null
>> +pid1=""
> 
> unset pid1
> 
>> +pid2=""
> 
> unset pid2
> 

Added.

>> +
>> +e_fsid1=$(fsid_to_fid_parts "$fsid1")
>> +e_fsid2=$(fsid_to_fid_parts "$fsid2")
>> +
>> +# Dump debug details to the full log
>> +echo $fsid1 $e_fsid1 $fsid2 $e_fsid2 >> $seqres.full
>> +cat $log1 >> $seqres.full
>> +cat $log2 >> $seqres.full
>> +
>> +# Ensure monitor 1 only captured events belonging to mnt 1 and fsid 1
>> +if grep -qF "$e_fsid1" "$log1" && ! grep -qF "$e_fsid2" "$log1"; then
>> +	echo "SUCCESS: mnt1 events found"
>> +else
>> +	[ ! -s "$log1" ] && echo "  - mnt1 received no events."
>> +	grep -qF "$e_fsid2" "$log1" && echo "  - mnt1 received event from mnt2."
>> +fi
>> +
>> +# Ensure monitor 2 only captured events belonging to mnt 2 and fsid 2
>> +if grep -qF "$e_fsid2" "$log2" && ! grep -qF "$e_fsid1" "$log2"; then
>> +	echo "SUCCESS: mnt2 events found"
>> +else
>> +	[ ! -s "$log2" ] && echo "  - mnt2 received no events."
>> +	grep -qF "$e_fsid1" "$log2" && echo "  - mnt2 received event from mnt1."
>> +fi
>> +
>> +status=0
>> +exit
> 
> _exit 0
> 

Added.

Thanks.
Anand

> Thanks,
> Zorro
> 
>> diff --git a/tests/generic/801.out b/tests/generic/801.out
>> new file mode 100644
>> index 000000000000..d7b318d9f27c
>> --- /dev/null
>> +++ b/tests/generic/801.out
>> @@ -0,0 +1,7 @@
>> +QA output created by 801
>> +Setup FID fanotify watchers on both mnt1 and mnt2
>> +Trigger file creation on mnt1
>> +Trigger file creation on mnt2
>> +Verify fsid in the fanotify
>> +SUCCESS: mnt1 events found
>> +SUCCESS: mnt2 events found
>> -- 
>> 2.43.0
>>

