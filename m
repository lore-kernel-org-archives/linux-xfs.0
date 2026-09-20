Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF61D3BB9F1;
	Sun, 20 Sep 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789918263; cv=none; b=VXKVSAN6ANWDGIulzTSr7d8GIKQvHoVpAthV5PVC/8Xgf3gXDJLcmS8V5xtPlRISsLNWlp2dpFnJGQ2FEHSky4ZPkLOzPEwmWLArBm9F0z+o/ro8LAOMPpFE1YgyK3RPZ4Mb0+4IgIuOtiHt2iwEdcH35gb3kXGWiZDn8fZ+HSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789918263; c=relaxed/simple;
	bh=gud0SJqfQvyOIkA/jEpePxvDduJLxNee0oLZCHPHNdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OwQKFuIdmjZeiCNg+YWSS5C2TvNOgAsZ2MB4DJMfgCHKJwpkrtfYGCNu8mXe7cd3pGZ2wu24FylxFjoNzWINnVYv+FJXaflSo3jGqdhGhiGpD2xC4EKFXU/Tm6ctfN5vSp/y1Nq+VCyEm6Iycvba4spKsnHIiRcnwxMlwupNpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJ4FvcVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJ4FvcVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59351F000FF;
	Sun, 20 Sep 2026 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789918262;
	bh=q4nLN7EfIVyldgJNtOOhMXXxfy+CJZvXFpy9/BJDnjs=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=oJ4FvcVw5KcvdlIC5PJ/sdTtUmsJ3JsUzKon0f0tW2e3+cNqp4P4sgnT+OU+lQdQw
	 zzvzkaXSIYe+7YR48kZPXkZuLtxwfYQ+PbrUBZT+7XNSnYJp2ilQND4sTmcvJ4/tvX
	 5SsdvNlVI3NrmTBX88WJbQoIwpdTeA86Y0a5Dn9agNKWPcDi/7JQkcj2sNvBTegMYR
	 GuuxOgf8pkOVb+1ZwWIHNytVZTqRvDJqkM1nryYZ04IBG9v/0Up3nl/Nz2jAkmtirU
	 Q97iUCbplZOeIK9/vK52XlBk1uYgU2/AhbFBhkl6F6kKpZlRCokmPoWAwb4/EBHt1E
	 vVrhvWQJ+UpiQ==
Message-ID: <c83b7f14-fb4e-4a33-b56b-08b353f111de@kernel.org>
Date: Sun, 20 Sep 2026 23:30:58 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/13] fstests: verify exportfs file handles on cloned
 filesystems
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <7afe9c82cce1540ea0f8cc1f3d1306c24b6cc84d.1784949155.git.asj@kernel.org>
 <apc1uPbA2hKofHA6@zlang-mailbox>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apc1uPbA2hKofHA6@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 04:30, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:08PM +0800, Anand Jain wrote:
>> Ensure that exportfs can correctly decode file handles on a cloned
>> filesystem across a mount cycle, by file handles generated on a
>> cloned device remain valid after mount cycle.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/805     | 80 +++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/805.out |  2 ++
>>  2 files changed, 82 insertions(+)
>>  create mode 100644 tests/generic/805
>>  create mode 100644 tests/generic/805.out
>>
>> diff --git a/tests/generic/805 b/tests/generic/805
>> new file mode 100644
>> index 000000000000..5827eee039df
>> --- /dev/null
>> +++ b/tests/generic/805
>> @@ -0,0 +1,80 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 805
>> +# Verify that file handles encoded on a cloned filesystem remain valid and
>> +# resolvable via open_by_handle across a mount cycle and mount order swap.
>> +
>> +. ./common/preamble
>> +
>> +_begin_fstest auto quick exportfs clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_exportfs
>> +_require_loop
>> +_require_test_program "open_by_handle"
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
>> +# Create test dir and test files, encode file handles and store to tmp file
>> +create_test_files()
>> +{
>> +	rm -rf $testdir
>> +	mkdir -p $testdir
>> +	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
>> +}
>> +
>> +# Attempt to read and decode the saved file handles on the targeted mount point.
>> +test_file_handles()
>> +{
>> +	local opt=$1
>> +	local when=$2
>> +
>> +	echo test_file_handles after $when
>> +	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
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
>> +# Mount both identical UUID filesystems simultaneously
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +

>> +NUMFILES=1
> 
> NUMFILES=${LOAD_FACTOR} ?

Added.


> 
>> +testdir=$mnt2/testdir
>> +
>> +# Decode file handles of files/dir after cycle mount
>> +create_test_files
>> +
>> +# Cycle mounts and reverse initialization sequence to check if
>> +# file handle lookups are okay
>> +_unmount $mnt1
>> +_unmount $mnt2
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +
>> +# Verify file handles can still be resolved post-mount-cycle
>> +test_file_handles -rp "cycle mount"
>> +


>> +status=0
>> +exit

Also this fixed to

_exit 0

Thanks.
Anand


>> diff --git a/tests/generic/805.out b/tests/generic/805.out
>> new file mode 100644
>> index 000000000000..29b11ec77ffb
>> --- /dev/null
>> +++ b/tests/generic/805.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 805
>> +test_file_handles after cycle mount
>> -- 
>> 2.43.0
>>

