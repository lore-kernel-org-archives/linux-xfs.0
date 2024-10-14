Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0014D599;
	Mon, 14 Oct 2024 05:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885127; cv=none; b=Zbp4VWF/Sy9x2lInMo8jCEiQME40gYmxsAFJ8kgr8AIMqnOW6gFJurUg8cdXbqlsy3sxH0xSVPCMMWzyt3Kf6eIDzVaf3kWaTW/qRMjN+O3Rp1EYMSKtPI2koJIKt+sZ3GBnAx2xSaHUyvXEytrJoOXqH4Z5rbliL0fjx2CG0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885127; c=relaxed/simple;
	bh=x4G5y/MhATiyHWvGFtKbz3FgItdjpRowaMrHeJ6Ylt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ksIPPf7n2Ma8UJJbpTBkfVPy6arkI5JQ9f71CMXH1uxk1lLv7tDIbN1AhPqEoINoUtqbxkW5qMdAijQjmXaLBuH9wqmuFlkQNJBv0h/aAwuVuCC9nJ17R1kyT/BToRfCMsKcxJKJD+U4/aXL2NbsVPFoAcaGhSnWgnt9M5mYvTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SstgT4s7; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SstgT4s7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=+rb0ko5WsyUgP2uL/EjheTWqi0B4NN6RCvjVe6taWYo=;
	b=SstgT4s7obHFW4KoX1sQy9CHUz6rNTP4oQI0bfYzOA5aaXyXvsN5A6OsVzhX+A
	EMmR4r7geTKRK/W737J9GImZ5Sj44jT45FJfjfJhfP60IGqDvjsx4IowVjGnvhMA
	SmbqkiTPUrKY2SE48IOGCH8uia0Sg+xS0WsmcjTZqVqN8=
Received: from [10.42.116.6] (unknown [111.48.58.10])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3vwdjsQxnMAcoBA--.1867S2;
	Mon, 14 Oct 2024 13:51:33 +0800 (CST)
Message-ID: <bf893b28-f0a6-9863-0da1-4abdee24592d@163.com>
Date: Mon, 14 Oct 2024 13:51:30 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] xfs_logprint: Fix super block buffer interpretation issue
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 chizhiling <chizhiling@kylinos.cn>, Christoph Hellwig <hch@lst.de>
References: <20241011030810.1083636-1-chizhiling@163.com>
 <20241011032415.GC21877@frogsfrogsfrogs>
 <97501a36-d001-b3fa-5b57-8672bc7d71da@163.com>
 <ZwrzxggtS96n72Bm@dread.disaster.area>
 <e0ae8eb7-360a-40c4-8c84-dd439d7161fd@163.com>
 <ZwxOrVCJ/+2GoGjg@dread.disaster.area>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <ZwxOrVCJ/+2GoGjg@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vwdjsQxnMAcoBA--.1867S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCry5uw17ZFWUGFWUXF1xGrg_yoW5Xr1Upr
	93ta4qyr4DCr1Utr12vw1rtryrKwnrtr1UWrn5Xr1rAr90qr4Yyr4DGF15uFyDWr4kAw1Y
	qr15G3sI9F1qy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ufu4UUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawF4nWcMrBNRGAAAsS


On 2024/10/14 06:50, Dave Chinner wrote:
> On Sun, Oct 13, 2024 at 12:00:22PM +0800, Chi Zhiling wrote:
>> On 2024/10/13 06:10, Dave Chinner wrote:
>>> On Fri, Oct 11, 2024 at 11:54:08AM +0800, Chi Zhiling wrote:
>>>> On 2024/10/11 11:24, Darrick J. Wong wrote:
>>>>> On Fri, Oct 11, 2024 at 11:08:10AM +0800, Chi Zhiling wrote:
>>>>>> From: chizhiling<chizhiling@kylinos.cn>
>>>>>>
>>>>>> When using xfs_logprint to interpret the buffer of the super block, the
>>>>>> icount will always be 6360863066640355328 (0x5846534200001000). This is
>>>>>> because the offset of icount is incorrect, causing xfs_logprint to
>>>>>> misinterpret the MAGIC number as icount.
>>>>>> This patch fixes the offset value of the SB counters in xfs_logprint.
>>>>>>
>>>>>> Before this patch:
>>>>>> icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
>>>>>>
>>>>>> After this patch:
>>>>>> icount: 10240  ifree: 4906  fdblks: 37  frext: 0
>>>>>>
>>>>>> Signed-off-by: chizhiling<chizhiling@kylinos.cn>
>>>>>> ---
>>>>>>     logprint/log_misc.c | 8 ++++----
>>>>>>     1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>>>>>> index 8e86ac34..21da5b8b 100644
>>>>>> --- a/logprint/log_misc.c
>>>>>> +++ b/logprint/log_misc.c
>>>>>> @@ -288,13 +288,13 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>>>>>     			/*
>>>>>>     			 * memmove because *ptr may not be 8-byte aligned
>>>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> This is important. I'll come back to it.
>>>
>>>>>>     			 */
>>>>>> -			memmove(&a, *ptr, sizeof(__be64));
>>>>>> -			memmove(&b, *ptr+8, sizeof(__be64));
>>>>> How did this ever work??  This even looks wrong in "Release_1.0.0".
>>>>>
>>>> Yes, I was surprised when I find this issue
>>> I"ve never cared about these values when doing diagnosis because
>>> lazy-count means they aren't guaranteed to be correct except at
>>> unmount. At which point, the correct values are generally found
>>> in the superblock. IOWs, the values are largely meaningless whether
>>> they are correct or not, so nobody has really cared enough about
>>> this to bother fixing it...
>> Because I got a log which shows that the fdblocks was (-8),   it caused
>> the filesystem to fail mounting again. 'SB summary counter sanity check failed'
> What kernel? Because AFAIK, that was fixed in commit 58f880711f2b
> ("xfs: make sure sb_fdblocks is non-negative") in 6.10...

It's a 4.19 kernel. As you said, the fdblocks is meaningless, I think 
that patch (commit 58f880711f2b) is enough to fix the issue.

Thank you for your reminding.


chi

