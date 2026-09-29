Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5552842D
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693281; cv=none; b=s0xe1ePDOWYQV2wVIeP7QJ2kERrbDRKHlWH8ds6sQdzJnWnyO325ZLNZPaTkepiZLtlEU5dl/SH6A4KfiUvR5TKg7KkqVniwzUEDUEuCfOzJiwzW2cO7S42EpzyriJ1G9Zsk9LSie2QgiyXDtuxjtBuFAuwom2bffvoVPTG9B7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693281; c=relaxed/simple;
	bh=DRO+ZqQh4zskqfjZRu3I28zydi7TUz8g5jVXchTtXiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUfaQuL7G++2yMktIiG/Abr5e/wb8NvlmytSCk/FocZtDSo6KBNkcCJhM4mE4jsDtxpGMIr0GNZ1ed0RjqaRhiUJ+SKctl/Umso7QWVHrrcIJI3CbBSSTbfSE/TNlH+7zTqVnIpFSTS3WQuM0XCDHmIF6a4ard7LYlgheOTLTI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YIBb1rS/; arc=none smtp.client-ip=91.218.175.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YIBb1rS/"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DRO+ZqQh4zskqfjZRu3I28zydi7TUz8g5jVXchTtXiI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790693276; v=1; x=1791298076;
 b=YIBb1rS/2tyqO+fiHJcB5UZsqmdm7loB5l7nIhiA1lCmXZxqfeRrSB6eCCuY74sBkJZ0OLKK
 Mirg94cuaTw9wvQdbAW44EcgejdQLsNrb+WhJwQbe0SrZW/R8D96iSfIfCvNDHEGseonSYLz5/n
 h9fOaH/rT1aet+05w022bTnQ=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 84e850235836b2e7;
	Tue, 29 Sep 2026 14:47:56 +0000
X-Mizu-Trace-ID: 84e850235836b2e7
X-Migadu-Flow: FLOW_OUT
Message-ID: <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>
Date: Tue, 29 Sep 2026 15:47:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
 Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>, "Darrick J . Wong"
 <djwong@kernel.org>, gost.dev@samsung.com
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/29/26 08:17, Pankaj Raghav wrote:
> 
> 
> On 9/25/2026 1:44 PM, John Garry wrote:
>> On 9/25/26 11:36, Pankaj Raghav wrote:
>>  > xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
>>  > greatest power-of-two factor of the group size when the device 
>> advertises
>>  > atomic writes, so that allocations can be made naturally aligned for
>>  > REQ_ATOMIC. But that value is the software limit: it is only used when
>>  > reflink is enabled, and out of place writes through the COW fork 
>> have no
>>  > alignment requirement.
>>
>> We have mkfs atomic write options for selecting atomic write limits - 
>> you have tried that, right?
>>
> 
> Hmm, I did not try that but I restricted the agsize to a power of 2 
> value to
> workaround the limitation.
> 
> Are you talking about this option: max_atomic_write?


Yeah, so there is a mkfs and also a mount option.

For the mount option you again provide a desired awu max. From the 
desired awu max the FS checks whether that is possible (from AG count, 
etc) and then it also sizes relevant "transaction memories" for 
CoW-based atomic writes accordingly (to satisfy the awu max).

> 
> In any case, with default options the atomic values we are exposing is 
> not correct at the moment.
> 
>>>
>>> A filesystem on a > 4TB device that advertises 16k atomic writes then 
>>> reports
>>> an atomic write unit maximum of a single fsblock and an optimal 
>>> maximum of 0,
>>> and rejects any larger RWF_ATOMIC write. That is worse than the same 
>>> filesystem
>>> on a device with no atomic write support at all.
>>>
>>> Compute the software limit from the group size alone, and apply the
>>> alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
>>> what reports the size that can be offloaded to the hardware.
>>>
>>> Results on a 8TB device with 16k hardware atomic support with 4k
>>> blocksize:
>>>
>>> Before patches:
>>> /media/test/hello.txt:
>>>    stx_atomic_write_unit_min:            4096
>>>    stx_atomic_write_unit_max:            4096
>>>    stx_atomic_write_unit_max_opt:        0
>>>    stx_atomic_write_segments_max:        1
>>>
>>> After patches:
>>> /media/test/hello.txt:
>>>    stx_atomic_write_unit_min:            4096
>>>    stx_atomic_write_unit_max:            2097152
>>
>> Here the AG size may not be a multiple of 2097152B, right? If so, when 
>> we try to naturally align the allocation for a CoW write, even if the 
>> AG blocks are naturally aligned (per AG), the disk blocks may not be 
>> naturnally aligned - is this correct? For HW-based atomic writes, we 
>> want naturally aligned disk blocks.
>>
> 
> Correct.
> 
> Just to give more context:
> 
> Trace of calc_atomic_write_unit_max:
> 
>   mount-696   [010]   449.230543: xfs_calc_atomic_write_unit_max: dev 
> 259:0 ag max_write 262144 max_ioend 512 max_gsize 134217728 awu_max 512
> 
> 2097152 comes from awumax being 512 fsblocks.
> 
> root@debian:~# xfs_info /dev/nvme0n1
> meta-data=/dev/nvme0n1           isize=512    agcount=8, 
> agsize=268435455 blks

Well max power-of-2 factor of this is going to be 1.

>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>           =                       reflink=1    bigtime=1 inobtcount=1 
> nrext64=0
> data     =                       bsize=4096   blocks=2147483640, imaxpct=5
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
>>>    stx_atomic_write_unit_max_opt:        4096
>>>    stx_atomic_write_segments_max:        1
>>>
>>> Results on a 8TB device with 16k hardware atomic support with 16k
>>> blocksize:
>>>
>>> Before patches:
>>> /media/test/hello.txt:
>>>    stx_atomic_write_unit_min:            16384
>>>    stx_atomic_write_unit_max:            16384
>>>    stx_atomic_write_unit_max_opt:        0
>>>    stx_atomic_write_segments_max:        1
>>>
>>> After patches:
>>> /media/test/hello.txt:
>>>    stx_atomic_write_unit_min:            16384
>>>    stx_atomic_write_unit_max:            33554432
>>>    stx_atomic_write_unit_max_opt:        16384
>>>    stx_atomic_write_segments_max:        1
>>>
> -- 
> Pankaj

