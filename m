Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230CC408008;
	Mon,  8 Jun 2026 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780930766; cv=none; b=DYpn7sRol/tvV9PXzV3DzvXJ7rGx1kmSUke2OeW3nNc9ZXS9A7NS1PiyBrN+1ZXPErUM/kOBrzP201QdaH3FCCqrrU9cJNuqrfWkrVtQo+mdRotySEOVQHIVdIbT+LpjqNqrpaAd53YKgih0+8IsyRRCCJ4Rk4JvUoo1SP1Uncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780930766; c=relaxed/simple;
	bh=HmDOSXQx7i2XjtJYq+q3DTWBCiyZoqUEp12WVkqP4ZM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=J+q9O2oAB4tZnBz1r839u+Br0IoQ7n0ffISX4Hz4/ANmaCGrNZRSc2lj47gzZ4Hp95wGmET+dq/37cektwqlkp+hWvH6morbZ98lkcgUWxGQsDXa0dbBRsm0gjvl1uIOZIa2a+u06Y35zqw53VKnTJSTh65Yzm4WwEtFCOtGD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh4KA5B+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh4KA5B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD62F1F0089A;
	Mon,  8 Jun 2026 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780930763;
	bh=JnAZ1H5PgHjSI2fcCNl7cro1QFov5yMV1RvlkQXKBX4=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=Lh4KA5B+YOKFtiIUsG3/u9KKoH0uT2tpJj+5j6PO6jQoeMqkxqVGLFkEzX4kQn7mv
	 bmJN/1L1+qlZwJc+MS4xN4OxLCGv280bLg4UkmtArdU0Dzdke+AoAO1uRpINuGxgk0
	 O2Zv+KyLlRHxwKrMeG4EV/n6JrK9/eUBaKfpoqsAPIsN4NOx1j7RuevL6r03OMjMew
	 8I1Ujur15CZsA7+RorFRg3fFbr442sA7S6CvliB+yDkz/OUeOu4erJwtIrj5JsnMqs
	 1opL7zjP97l2KitDssyhRS/F/M+tONTKhbg2Qc6z9RrPcYYE0bE8IEdXdA+J6d72c4
	 RGyB8Oy+Us9SA==
Message-ID: <cad74c16-ecb3-41ba-b349-66814abcf5e9@kernel.org>
Date: Mon, 8 Jun 2026 22:59:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v6 06/11] fstests: verify f_fsid for cloned filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1779939330.git.asj@kernel.org>
 <e029755044a32de6ec2a0d3391f3ff0089fc3c30.1779939330.git.asj@kernel.org>
 <20260529043955.GG6070@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260529043955.GG6070@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/5/26 12:39, Darrick J. Wong wrote:
> On Thu, May 28, 2026 at 12:05:37PM +0800, Anand Jain wrote:
>> Verify that the cloned filesystem provides an f_fsid that is persistent
>> across mount cycles, yet unique from the original filesystem's f_fsid.
> 
> Might want to add that last part to the test description itself, because
> otherwise I don't know what 'verify' means.
> 


Looks like there's going to be v7, I have updated the test description..

-------
+# Check that the cloned filesystem provides an f_fsid that is persistent
+# across mount cycles if the block device maj:min remains unchanged.
-------

>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/802     | 67 +++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/802.out |  7 +++++
>>  2 files changed, 74 insertions(+)
>>  create mode 100644 tests/generic/802
>>  create mode 100644 tests/generic/802.out
>>
>> diff --git a/tests/generic/802 b/tests/generic/802
>> new file mode 100644
>> index 000000000000..653e74e11b53
>> --- /dev/null
>> +++ b/tests/generic/802
>> @@ -0,0 +1,67 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 802
>> +# Verify f_fsid and s_uuid of cloned filesystems across mount cycle.
>> +
>> +. ./common/preamble
>> +
>> +_begin_fstest auto quick mount clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_loop
>> +
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> 
> _fixed_by_fs_commit?
> 

Oh right! I completely forgot about the new helper _fixed_by_fs_commit.
Now fixed. Thanks.

-[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
         "btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
-[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
         "btrfs: derive f_fsid from on-disk fsuuid and dev_t"

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
>> +echo "**** fsid initially ****"
>> +echo $fsid_scratch | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
>> +echo $fsid_clone | sed -e "s/$fsid_clone/FSID_CLONE/g"
> 
> Why echo only to sed?
> 

I tried to keep both the .out log and the script readable.
Since a bare echo FSID_SCRATCH and echo FSID_CLONE has no
clear reference to $fsid_scratch and $fsid_clone, I just
added a little extra code around them.

However, I'm completely fine with removing both viz,
expected output and its script (for the first mount part).
As I'm pretty sure there will be a v7 now, ;-)
I can make those changes.

Thanks, Anand

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
>> +
>> +status=0
>> +exit
>> diff --git a/tests/generic/802.out b/tests/generic/802.out
>> new file mode 100644
>> index 000000000000..d1e008f122bb
>> --- /dev/null
>> +++ b/tests/generic/802.out
>> @@ -0,0 +1,7 @@
>> +QA output created by 802
>> +**** fsid initially ****
>> +FSID_SCRATCH
>> +FSID_CLONE
>> +**** fsid after mount cycle ****
>> +FSID_SCRATCH
>> +FSID_CLONE
>> -- 
>> 2.43.0
>>
>>

