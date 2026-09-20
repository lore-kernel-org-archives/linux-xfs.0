Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32006349B15;
	Sun, 20 Sep 2026 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913446; cv=none; b=WFgxvYZJx4Vy9ZNoHFcaQEruwOkZ3YDj2LRefPShSr9VR+kbjV2W6qC5ricy5FSJycLgBPrf8m55DUgRHRv6qsnqvnIQLSQzJfJ1DNjEQ6JVZYBbKgIzXVb8vOxvryMhCSV2tT8mA24sT0lmrzuX6luU7KyBtFoQ0fm2MXWvpJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913446; c=relaxed/simple;
	bh=2IbgxxtBZJ9rQLYwiDjkkwArWTmIa3n8reudQLDHi+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V3p+koU7KPxNGsgpY3dnUfH+8pbOUQUP0IpN7ew40T8u4r2GVsuWgQF4nBG/TST/tmhs5yDBr+u+MgkufLOpGnMyR3yIZhH+klcysmWHT9c2HMkS0R6oOpBnCl03J7ZPE8whpzWofzyYh8fWubH+2boQBDJ0NNRH5EEfy807M+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OY14vxyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OY14vxyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158EC1F000FF;
	Sun, 20 Sep 2026 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913444;
	bh=L9U8x29FUMYYuun6BO6TXnYXUZdKJvqLoY6TjdR/gGg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=OY14vxyofU4iSX/+urwWgT4p8rLI95Hj5FWX4subo5GURa0SrjeP7fS6DWA7YBOQz
	 i1O2qFs410fkP5MFiDlObENnIjMrVl98e0lHlIPRev+rKcXQBfV5B+gnonpsb4DZGr
	 BYDt5ZPzD1LHOs3bf9QFN3T/mcIrCPFH74okdOKSQ+1FNUcu1s+GV6QI/0MrCvFfXS
	 O5/t6Hj6w6rdkHMAsKCBRTq1PmglCWdlqDn6QjDQM8vEcXXKadYRLwkWaPyB8PCINq
	 H3fn8qdPEDV4NMRpBcQHh2+PbbI6TBgazZI0VILZPRxEeiMIovMn+ITMsw4I1mCrX+
	 II09xWKQycbhg==
Message-ID: <e58634ab-9b04-4ae9-bc36-88f60724e8b1@kernel.org>
Date: Sun, 20 Sep 2026 22:10:40 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/13] fstests: verify f_fsid for cloned filesystems
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <f68b3bd9fcee878289f8ddd7c85a6913c89772cd.1784949155.git.asj@kernel.org>
 <apcdo8K-Lfi5imbg@zlang-mailbox>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apcdo8K-Lfi5imbg@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 02:51, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:05PM +0800, Anand Jain wrote:
>> Verify that the cloned filesystem provides an f_fsid that is persistent
>> across mount cycles, yet unique from the original filesystem's f_fsid.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/802     | 64 +++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/802.out |  4 +++
>>  2 files changed, 68 insertions(+)
>>  create mode 100644 tests/generic/802
>>  create mode 100644 tests/generic/802.out
>>
>> diff --git a/tests/generic/802 b/tests/generic/802
>> new file mode 100644
>> index 000000000000..910807c11584
>> --- /dev/null
>> +++ b/tests/generic/802
>> @@ -0,0 +1,64 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 802
>> +# Check that the cloned filesystem provides an f_fsid that is persistent
>> +# across mount cycles if the block device maj:min remains unchanged.
>> +
>> +. ./common/preamble
>> +
>> +_begin_fstest auto quick mount clone
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
>> +	umount $mnt1 $mnt2 2>/dev/null
>> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
>> +}
>> +
>> +# Setup base loop device and its clone
>> +devs=()
>> +_loop_image_create_clone devs
>> +mkdir -p $TEST_DIR/$seq
> 
> Better to `rm -rf $TEST_DIR/$seq` before creating a new one.
> 

Applied.

>> +mnt1=$TEST_DIR/$seq/mnt1
>> +mnt2=$TEST_DIR/$seq/mnt2
>> +mkdir -p $mnt1
>> +mkdir -p $mnt2
>> +
>> +# Mount both filesystems simultaneously using mandatory clone mount options
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +# Capture baseline filesystem IDs for comparison
>> +fsid_scratch=$(stat -f -c "%i" $mnt1)
>> +fsid_clone=$(stat -f -c "%i" $mnt2)
>> +
>> +# Verify that the fsids remain stable after a mount cycle, even when the
>> +# mount order is reversed.
>> +echo "**** fsid after mount cycle ****"
>> +_unmount $mnt1
>> +_unmount $mnt2
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +
>> +# Compare post mount-cycle values against the baseline
>> +stat -f -c "%i" $mnt1 | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
>> +stat -f -c "%i" $mnt2 | sed -e "s/$fsid_clone/FSID_CLONE/g"
> 

> Hmm... what if "$fsid_scratch" is same with "$fsid_clone"?
> 

That falls into the same category as ext4 (and likely Btrfs as well,
pending a regression report fix that is delaying this fstests patch as
well), where both the original and cloned filesystems share the same
`f_fsid`. However, since the objective of this test case is to verify
consistency within the filesystem across reboots, this behavior is fine.

>> +
>> +status=0
>> +exit
> 
> _exit 0

Applied.

> 
>> diff --git a/tests/generic/802.out b/tests/generic/802.out
>> new file mode 100644
>> index 000000000000..0202a9a2c108
>> --- /dev/null
>> +++ b/tests/generic/802.out
>> @@ -0,0 +1,4 @@
>> +QA output created by 802
>> +**** fsid after mount cycle ****
>> +FSID_SCRATCH
>> +FSID_CLONE
>> -- 
>> 2.43.0
>>

