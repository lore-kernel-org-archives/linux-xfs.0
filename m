Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8697216E24;
	Thu,  9 Jan 2025 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736424678; cv=none; b=PBpGBaVmLoYNk2cixFpI/bikLfSeXeglyKjfyE401q5ZdWparKhV1ZSXx4ysrZnDxdaS5hBHD25Xqw6M286eji31k2lBwPmcgJwsrkhFs2mpLYH8uPWD4wEu5dC5ofPd9FbqG4P7z8k00beKhxGDgTlakbr4tBm19qpw8bZScqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736424678; c=relaxed/simple;
	bh=3UvbEUZNYV2/g883HqNU13P4CgKBC4GiBMQeV6vmYIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxAa2xDEeln2bZw3NSMpRlNUrsK01FUqi2eFC5cFdELcZVELwzi6Oqi1s1Y8VWGw+z9PWBYXUUFcMqdV4wRSIxX5cfo9gmOQ8KLjbrMxqmEK4R26SGx7AZDkFQBqEdYc+p3mDQPJFofIOOlqgBbpy26npAoQdQ+QOlLiNYjbEAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ijOPLLsK; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ijOPLLsK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=+CcyUmEjC6zmvaa6z0vO16bru59SzCPDHuVpW6BLS3A=;
	b=ijOPLLsKoKCOrC/lWp7mrIaM82bTnulZbdVlevS0t4f18f9Aq72/QVo0V6l+j4
	gkNi+KcRfWz10BvIiXTQb8NxVwXRqXa4ncrrXfsiVAd6Y17MPT4a9w0H3UsDUCaM
	aT4yKX7hVW9y/6x3PKbbJRfLn2MbUK7zU0U/vVlSDGtjY=
Received: from [192.168.5.16] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnj4qzvH9n5MP5Ew--.7897S2;
	Thu, 09 Jan 2025 20:10:28 +0800 (CST)
Message-ID: <90e5f9b4-eb1d-4d63-ba22-4a1f564b2ccf@163.com>
Date: Thu, 9 Jan 2025 20:10:27 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Amir Goldstein <amir73il@gmail.com>
Cc: John Garry <john.g.garry@oracle.com>, Dave Chinner <david@fromorbit.com>,
 djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
 <b8a7a2f7-1abe-492a-97f8-a04985ccc9ba@163.com>
 <CAOQ4uxje241QhUeNe=V8KKY+5a27eYd2dc3s+OiCXMPW5WZyPQ@mail.gmail.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <CAOQ4uxje241QhUeNe=V8KKY+5a27eYd2dc3s+OiCXMPW5WZyPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDnj4qzvH9n5MP5Ew--.7897S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGrWfAr1kGFW7uFy3GrWDtwb_yoWrWFW3pF
	WfKa12kr4DKr17AwnFvw15X343K3y0qry7Gr95Jr1xW3Z09F1SqF1xtFyF9a4kJrZ3uw40
	vw409rWxWw45AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UdDGrUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxHPnWd-oLY3MAABsE

On 2025/1/9 18:25, Amir Goldstein wrote:
>>> One more thing I should mention.
>>> You do not need to wait for atomic large writes patches to land.
>>> There is nothing stopping you from implementing the suggested
>>> solution based on the xfs code already in master (v6.13-rc1),
>>> which has support for the RWF_ATOMIC flag for writes.
> 
> Only I missed the fact that there is not yet a plan to support
> atomic buffered writes :-/

I think it's necessary to support atomic buffered writes.

> 
>>>
>>> It just means that the API will not be usable for applications that
>>> want to do IO larger than block size, but concurrent read/write
>>                                 ^
>> To be precise, this is the page size, not the block size, right?
>>
> 
> fs block size:
> 
>          if (iocb->ki_flags & IOCB_ATOMIC) {
>                  /*
>                   * Currently only atomic writing of a single FS block is
>                   * supported. It would be possible to atomic write smaller than
>                   * a FS block, but there is no requirement to support this.
>                   * Note that iomap also does not support this yet.
>                   */
>                  if (ocount != ip->i_mount->m_sb.sb_blocksize)
>                          return -EINVAL;
>                  ret = generic_atomic_write_valid(iocb, from);
>                  if (ret)
>                          return ret;
>          }

Uh, okay, maybe I didn't understand it very accurately. I thought
you were talking about buffered IO. I was quite curious as to why
you mentioned block size in the context of buffered IO.

> 
>>> performance of 4K IO could be improved already.
>>
>> Great, which means that IO operations aligned within a single page
>> can be executed concurrently, because the folio lock already
>> provides atomicity guarantees.
>>
>> If the write does not exceed the boundary of a page, we can
>> downgrade the iolock to XFS_IOLOCK_SHARED. It seems to be safe
>> and will not change the current behavior.
>>
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -454,6 +454,11 @@ xfs_file_write_checks(
>>           if (error)
>>                   return error;
>>
>> +       if ( iocb->ki_pos >> PAGE_SHIFT == (iocb->ki_pos + count) >>
>> PAGE_SHIFT) {
>> +               *iolock = XFS_IOLOCK_SHARED;
>> +       }
>> +
>>           /*
>>            * For changing security info in file_remove_privs() we need
>> i_rwsem
>>            * exclusively.
>>
> 
> I think that may be possible, but you should do it in the buffered write
> code as the patch below.
> xfs_file_write_checks() is called from code paths like
> xfs_file_dio_write_unaligned() where you should not demote to shared lock.

Wow, thank you for the reminder. This is the prototype of the patch.
I might need to consider more scenarios and conduct testing before
sending the patch.


> 
> 
>>>
>>> It's possible that all you need to do is:
>>>
>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>>> index c488ae26b23d0..2542f15496488 100644
>>> --- a/fs/xfs/xfs_file.c
>>> +++ b/fs/xfs/xfs_file.c
>>> @@ -777,9 +777,10 @@ xfs_file_buffered_write(
>>>           ssize_t                 ret;
>>>           bool                    cleared_space = false;
>>>           unsigned int            iolock;
>>> +       bool                    atomic_write = iocb->ki_flags & IOCB_ATOMIC;
>>>
>>>    write_retry:
>>> -       iolock = XFS_IOLOCK_EXCL;
>>> +       iolock = atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
>>>           ret = xfs_ilock_iocb(iocb, iolock);
>>> --
>>>
>>> xfs_file_write_checks() afterwards already takes care of promoting
>>> XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.
>>
>> Yeah, for writes that exceed the PAGE boundary, we can also promote
>> the lock to XFS_IOLOCK_EXCL. Otherwise, I am concerned that it may
>> lead to old data being retained in the file.
>>
>> For example, two processes writing four pages of data to the same area.
>>
>> process A           process B
>> --------------------------------
>> write AA--
>> <sleep>
>>                       new write BBBB
>> write --AA
>>
>> The final data is BBAA.
>>
> 
> What is the use case for which you are trying to fix performance?
> Is it a use case with single block IO? if not then it does not help to implement
> a partial solution for single block size IO.

I want to improve the UnixBench score for XFS. UnixBench uses buffered
IO for testing, including both single-threaded and multi-threaded tests.
Additionally, the IO size tested in UnixBench is below 4K, so this will
be very helpful.


Thanks,
Chi Zhiling

