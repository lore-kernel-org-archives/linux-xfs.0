Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE33246788;
	Mon, 28 Sep 2026 00:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790554680; cv=none; b=GE0/DKeKPOmaA7v36+aYLKSlF/N36GSBSpjVLsVxkdNpQxq2CAw5hSrQ+W/nLbqnfX5B/8CbtMsPYp+v1NZ4MgP/NsYoL+WGTYb1yiYFShedfYsOQWO+iu3F+yPeRekFaF+raOVx5NuF40WgzNwBQ1COTywe5ywuKQNwuCHrLPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790554680; c=relaxed/simple;
	bh=SQrhgKaTPMx1AI8+vN/pA3pIoyGE2f9oz8iUxF25JU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FG8/QwOInL3r8uR/R9q3aUyAo6/CZsBr9JNyuywL04xr4JfIvgEIxTsnl4d+O5B+EiuH901GSJKhMIRvnT9qvOQFd0Ybm0MPM5dCAhSc8Ua2gIYh1avAo/R3eNf+vEVN5zHCe2DUR5rHYpQRRwvotfyJv0MgnBZiJT9X/Z7YhO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiOeEEbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiOeEEbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780701F00899;
	Mon, 28 Sep 2026 00:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790554679;
	bh=BrvjgngQVWWsLu8FybQ5949ekW2GT1BmcozWeYv5iBo=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=SiOeEEbe8GD/H8hvlMJPAymuwbvZGf4VKIRo+AnDu92s5DARo7VpUXKQINbb9P4qv
	 c/SBdEGZG2vHvhuU1fYYEY/JeSb1j3e5ULeX6zME3kIXY0O1JJ7nZ71C1Wwx/nzf/v
	 YYqRqAYwkkpmkDf+UCmAK69f7uFlJ0Dvtk0rjnHLNJzx3Kh5u97XH0iZiX/IguYe5Z
	 9X9Cp9Y9GSwLkq69sx1m3Dy21tPolE8owVQtH2u1a6yxbgkCTvf7zrUQdeM/NDVIoZ
	 QOVK0H9bUGug2hkS59JnxK67ItlNJec2PR0fzdj47dvbxBG31v9PSkG8peOOqcCiSX
	 vPVTw0QRCeKdA==
Message-ID: <944e99e2-c927-43cc-b4d5-f810a31cce96@kernel.org>
Date: Mon, 28 Sep 2026 08:17:55 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/13] fstests: verify IMA isolation on cloned
 filesystems
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <e2ba3b5cf7e17bf87e7e832222d72bcbf8b904f8.1784949155.git.asj@kernel.org>
 <apcmEu9jmi3wljdW@zlang-mailbox>
Content-Language: en-US
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, djwong@kernel.org
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apcmEu9jmi3wljdW@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 03:58, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:07PM +0800, Anand Jain wrote:
>> Add testcase to verify IMA measurement isolation when multiple devices
>> share the same FSUUID.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/804     | 108 ++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/804.out |  10 ++++
>>  2 files changed, 118 insertions(+)
>>  create mode 100644 tests/generic/804
>>  create mode 100644 tests/generic/804.out
>>
>> diff --git a/tests/generic/804 b/tests/generic/804
>> new file mode 100644
>> index 000000000000..ced32e6d79dd
>> --- /dev/null
>> +++ b/tests/generic/804
>> @@ -0,0 +1,108 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 804
>> +# Verify IMA isolation on cloned filesystems:
>> +# . Mount two devices sharing the same FSUUID (cloned).
>> +# . Apply an IMA policy to measure files based on that FSUUID.
>> +# . Create unique files on each mount point to trigger measurements.
>> +# . Confirm the IMA log correctly attributes events to the respective mounts.
>> +
>> +. ./common/preamble
>> +. ./common/filter
>> +
>> +_begin_fstest auto quick clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_loop
>> +
>> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
>> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
>> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
>> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -r -f $tmp.*
>> +	_unmount $mnt1 2>/dev/null
>> +	_unmount $mnt2 2>/dev/null
>> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
>> +}
>> +
>> +# Normalize device names and mount points
>> +filter_pool()
>> +{
>> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|$mnt1|MNT1|g" \
>> +	    -e "s|${devs[1]}|DEV2|g" -e "s|$mnt2|MNT2|g" | _filter_spaces
>> +}
>> +
>> +# Core helper to set IMA policy and check measurement logs
>> +do_ima()
>> +{
>> +	local ima_policy="/sys/kernel/security/ima/policy"
>> +	local ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"
>> +	local fsuuid
>> +	local mnt=$1
>> +	local enable=$2
>> +
>> +	# Since the in-memory IMA audit log is only cleared upon reboot,
>> +	# use unique random filenames to avoid log collisions.
>> +	local foofile=$(mktemp --dry-run foobar_XXXXX)
>> +
>> +	echo $mnt $enable | filter_pool
>> +
>> +	[ -w "$ima_policy" ] || _notrun "IMA policy not writable"
> 
> How about a _require_security_ima to make sure there's securityfs
> and IMA supporting in current kernel.
> 

sure. added.

_require_security_ima()
{
        [ -d /sys/kernel/security ] || _notrun "kernel doesn't support
securityfs"

        # securityfs may not be mounted yet on the host; mount it
        # in a scratch location just to probe for IMA support.
        local se_mnt="${TEST_MNT}/${seq}/se_mnt"
        local has_ima=1

        mkdir -p "${se_mnt}"
        _mount -t securityfs securityfs "${se_mnt}" 2>/dev/null ||
_notrun "cannot mount securityfs"

        [ -d "${se_mnt}/ima" ] || has_ima=0
        [ -w "${se_mnt}/ima/policy" ] || _notrun "IMA policy not writable"

        _unmount "${se_mnt}"

        [ $has_ima -eq 1 ] || _notrun "kernel doesn't support IMA"
}


>> +
>> +	fsuuid=$(blkid -s UUID -o value ${devs[0]})
>> +
>> +	# Load IMA policy to measure file access specifically for this
>> +	# filesystem UUID.
>> +	if [[ $enable -eq 1 ]]; then
>> +		echo "measure func=FILE_CHECK fsuuid=$fsuuid" > "$ima_policy" || \
> 
> I'm not sure if we should have this test, especially add it into
> auto and quick group. Once an IMA policy is loaded, there is no way to
> clear or roll it back, and I am concerned it might potentially interfere
> with subsequent tests.
> 

Removed quick and auto. Looks like we need to gate it behind an opt-in
group or restrict it to disposable/reboot-per-run environments. New
group? I'm concerned it's getting too complicated and I see no other choice.


> Hmm... how about use `unshare` command to rewrite the do_ima as do_ima_in_ns?
> For example:
> do_ima_in_ns()
> {
> 	...
> 
>     unshare -U -m -p --fork --map-root-user bash <<EOF
> 		mount -t securityfs securityfs /sys/kernel/security
>         ima_policy="/sys/kernel/security/ima/policy"
>         ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"
>         echo "measure func=FILE_CHECK fsuuid=$uuid" > "\$ima_policy" || exit 1
>         ...
> EOF
>     ret=$?
> }


A new namespace doesn't help undo the loaded IMA policy; I don't see the
point of using unshare.

I have the following code using unshare, which works fine. I dropped -U
and --map-root-user (since fstests needs to run as root). I'm okay with
including unshare, but I still don't see why.


--------
        unshare -m -p --fork bash <<-EOF | filter_pool | sed
"s/$foofile/FOOBAR_FILE/"
                ima_policy="/sys/kernel/security/ima/policy"

ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"

                mount -t securityfs securityfs /sys/kernel/security ||
exit 1

                # Load IMA policy to measure file access specifically
for this
                # filesystem UUID.
                if [ $enable -eq 1 ]; then
                        echo "measure func=FILE_CHECK fsuuid=$fsuuid" >
"\$ima_policy" || exit 1
                fi

                # Create a file to trigger measurement and verify its
entry in
                # the IMA log.
                echo "test_data" > $mnt/$foofile

                # IMA log extract
                grep $foofile "\$ima_log" | awk '{ print \$5 }'

                echo "dbg: $mnt $fsuuid $foofile" >> $seqres.full
                tail -1 "\$ima_log" >> $seqres.full
                echo >> $seqres.full
        EOF
--------



Thanks.


> 
> Thanks,
> Zorro
> 
>> +			_notrun "Policy rejected"
>> +	fi
>> +
>> +	# Create a file to trigger measurement and verify its entry in
>> +	# the IMA log.
>> +	echo "test_data" > $mnt/$foofile
>> +
>> +	# IMA log extract
>> +	grep $foofile "$ima_log" | awk '{ print $5 }' | filter_pool | \
>> +						sed "s/$foofile/FOOBAR_FILE/"
>> +
>> +	echo "dbg: $mnt $fsuuid $foofile" >> $seqres.full
>> +	cat $ima_log | tail -1 >> $seqres.full
>> +	echo >> $seqres.full
>> +}
>> +
>> +# Initialize loop base and cloned instances
>> +devs=()
>> +_loop_image_create_clone devs
>> +mnt1=$TEST_DIR/$seq/mnt1
>> +mnt2=$TEST_DIR/$seq/mnt2
>> +mkdir -p $mnt1
>> +mkdir -p $mnt2
>> +
>> +# Concurrently mount both clones
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +#  IMA response on baseline and clone configuration
>> +do_ima $mnt1 1
>> +do_ima $mnt2 0
>> +
>> +# Cycle mount on the second device.
>> +echo mount cycle
>> +_unmount $mnt2
>> +_mount $mount_opts ${devs[1]} $mnt2 || _fail "Failed to mount dev2"
>> +
>> +do_ima $mnt1 0
>> +do_ima $mnt2 0
>> +
>> +status=0
>> +exit
>> diff --git a/tests/generic/804.out b/tests/generic/804.out
>> new file mode 100644
>> index 000000000000..9804181d6c17
>> --- /dev/null
>> +++ b/tests/generic/804.out
>> @@ -0,0 +1,10 @@
>> +QA output created by 804
>> +MNT1 1
>> +MNT1/FOOBAR_FILE
>> +MNT2 0
>> +MNT2/FOOBAR_FILE
>> +mount cycle
>> +MNT1 0
>> +MNT1/FOOBAR_FILE
>> +MNT2 0
>> +MNT2/FOOBAR_FILE
>> -- 
>> 2.43.0
>>

