Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CADD4457DB;
	Sun, 20 Sep 2026 14:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913462; cv=none; b=ft1KPUH7vZv4paKZsurbhCk72+gu1jkiudfKN72BbKHNA8clNo6F1758BN9ytRnkbFCn9CVXMg2fzmmWoHyNxoC7f+CdhTmJ6wRAVbiyvK560xcMonXsmGEi4CaJhVuY8SmI6dBrLym9Yjh8po3/N/XQzMXRXCBF0bT1b0U+YKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913462; c=relaxed/simple;
	bh=fuAjbvT2P5F2Qk4ccyn3d9sWskgEXsTxS4Ljb7TEsJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ce5i92tchC8iJqMrvLEuqQyYQbJdWBkC9Uii1lrSQdaJ+NjLQB10t3xyxHR/VU4zfMkjJsi+AF9983PIRxrTcQwjlTEb73Ewksyu59Iw6JbWG3cS6b1bc6gOAYN0iZvBpdLNpdFgj7Uyz4nfVk6HlW1ZzdezH9XLOhE2JkE/riE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zpzlivn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zpzlivn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E3B1F000FF;
	Sun, 20 Sep 2026 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913459;
	bh=4Y5xmyAmPfzgG3Q+Ybd8EMMKAncWD+ziq1NmXrhXuIE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Zpzlivn5YHXzw2m3lhoNF3WlqPj+Ww6xGHCjAVYPJn7Lrz1QeSs4sIZLUrUD9TCQA
	 uetAm9hKTnngSemAups5ZMm3zeoWML4zKpy67oXZMNx/Gx1KB8oe3Qg+dniEycHniA
	 3EJ0EX7hvPt0o9V7mIzrSRSPAS0umRLYVL6xx6AArfR7p/iHB1PLLW0O/1lpQsDZpb
	 SMVSlzgeX2XISabvlaCx/JmE701XmRqaL3BZlD0EelevDmKk91x1UZLxgRrjGKEqWY
	 jF+P+PM+nPsfmUP9Y/IDbLJF3zg2e/C0VGRzinXT8+PGDfiJv7qn2ktwSOem7eTToH
	 Nenjy96o8K5Ig==
Message-ID: <e3aef511-a5fd-47ce-acf2-365cc58ba999@kernel.org>
Date: Sun, 20 Sep 2026 22:10:54 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/13] fstests: verify libblkid resolution of duplicate
 UUIDs
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <0e530686fa2bfb9a4b8ec4596484a4fec6d849e4.1784949155.git.asj@kernel.org>
 <apchlvgfbKJDX1rO@zlang-mailbox>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apchlvgfbKJDX1rO@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 03:12, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:06PM +0800, Anand Jain wrote:
>> Verify how findmnt, df (libblkid) resolve device paths when multiple
> 
> I didn't find the `df` test part in this test case.
> 

Hm, I think `df` was too basic and didn't add any real value, so I've
removed it. I'll update the changelog accordingly.


>> block devices share the same FSUUID.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/803     | 72 +++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/803.out |  6 ++++
>>  2 files changed, 78 insertions(+)
>>  create mode 100644 tests/generic/803
>>  create mode 100644 tests/generic/803.out
>>
>> diff --git a/tests/generic/803 b/tests/generic/803
>> new file mode 100644
>> index 000000000000..77901592366c
>> --- /dev/null
>> +++ b/tests/generic/803
>> @@ -0,0 +1,72 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 803
>> +# Check if the mountinfo based findmnt would resolve to the common uuid
>> +# as per the blkid (libblkid based).
>> +
>> +. ./common/preamble
>> +. ./common/filter
>> +
>> +_begin_fstest auto quick mount clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_loop
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -r -f $tmp.*
>> +	umount $mnt1 $mnt2 2>/dev/null
>> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
>> +}
>> +
>> +# Normalize pool devices and mount points names
>> +filter_pool()
>> +{
>> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
>> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
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
>> +# Get the uuid from the source device
>> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
>> +
>> +# Mount both identical UUID filesystems simultaneously
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> 

> findmnt -n (or --noheadings) can be used here (and below) to avoid piping to
> `tail -n +2`.

applied.

> 
>> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> 
> Same here

applied

> 
>> +
>> +# Btrfs assigned a random uuid for the clone fs before the fix.
>> +# Cycle mounts and reverse the initialization (source and clone fs) order.
>> +echo "**** mount cycle ****"
>> +_unmount $mnt1
>> +_unmount $mnt2
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +
>> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> 
> Same here
applied

> 
>> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> 
> Same here
applied

> 
>> +	
>> +status=0
>> +exit
> 
> _exit 0
applied


Thanks.>
>> diff --git a/tests/generic/803.out b/tests/generic/803.out
>> new file mode 100644
>> index 000000000000..3a130c662430
>> --- /dev/null
>> +++ b/tests/generic/803.out
>> @@ -0,0 +1,6 @@
>> +QA output created by 803
>> +DEV1 MNT1 FSUUID
>> +DEV2 MNT2 FSUUID
>> +**** mount cycle ****
>> +DEV1 MNT1 FSUUID
>> +DEV2 MNT2 FSUUID
>> -- 
>> 2.43.0
>>

