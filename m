Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D39226863;
	Mon, 11 May 2026 09:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778490605; cv=none; b=D5zfeCs3CzLgjdOE5gH0ZbpnBkmFvwz5BNAUa90l+fM38I+OnCEIXbpyKqa4qzWd+0ASE/KaxKMcYZKFjpqkXWycrQdqYHIC39QmHrCT8fAWvGUr//5ZPeGjLH4162rfrxZGTkOL8MNAxgRdKwvMyPJqw5+1zqJDlJ040qL40MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778490605; c=relaxed/simple;
	bh=xPgviTcnz014bvcvI8kcuHVmr5yAr+cOjYX7ZQoWQhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SmOIXyhen+y28JYCWI6hPwSYM4LAtM0o7oTLwC2fZoHH1qarwGZa7nRFYLmWSLWc971H5aplZluQxtLK2Or3r/PSIOwXJML8fezwejlo/Twb5MXYZFXOOFuo4v8q5zOxDUzaIMNlzGLjsC+xacSFb1QuCxdBBnxS6fSHj0aIc6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DkubyBjo; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DkubyBjo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=caS1KVmkLkv8bhEjQee0pI36AukJGJ9TkMWvlFZMJN8=;
	b=DkubyBjoRXpBBf6xlTdymFum8kQ+OjlT/FUeeg24h09aanPQxWKVLQ2KS86B9A
	vq8XW96ZZm6n45MTd5vJeIwCN2uDsTig0EC36sodgI0opBcRBG5Bd2+jFQ1JR/e2
	D6jX89bhqerCCP4yZKgnpsYHcg/fHxEUkDyQYoOl0hVkA=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBHRvHHnAFqqVzoAg--.24546S2;
	Mon, 11 May 2026 17:09:28 +0800 (CST)
Message-ID: <00f28748-8244-4fb7-a61d-a08bf90630a9@163.com>
Date: Mon, 11 May 2026 17:09:27 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: add dirty page control to iomap_zero_iter
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 sj1557.seo@samsung.com, yuezhang.mo@sony.com,
 Chi Zhiling <chizhiling@kylinos.cn>, Namjae Jeon <linkinjeon@kernel.org>
References: <20260510064737.437597-1-chizhiling@163.com>
 <20260511085757.GB1186@lst.de>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20260511085757.GB1186@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wBHRvHHnAFqqVzoAg--.24546S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr1xKrWDAFyrtry5CFWkXrb_yoW8tr4UpF
	WkKF4vkF4xJ3yxZFs7tF98Zry0van3Jr4xGrWYg34YyrZ8ZFn8tr1q9FWI93WIyryjkw1F
	vr4q93s7tr1YyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UeuWLUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+Ak00WoBnMmohQAA3H

On 5/11/26 16:57, Christoph Hellwig wrote:
> On Sun, May 10, 2026 at 02:47:37PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> This patch prepares the iomap framework for exFAT's upcoming migration to
>> iomap. During testing of the exFAT iomap branch with xfstests generic/299
>> on a VM with 8GB RAM and a 40GB disk, system unresponsiveness was observed.
>>
>> iomap_zero_iter() lacked dirty page throttling, which could cause memory
>> pressure when exFAT's valid_size mechanism triggers large-scale zeroing
>> operations during writes beyond valid_size.
>>
>> Align iomap_zero_iter() with iomap_write_iter() by adding
>> balance_dirty_pages_ratelimited() to throttle dirty page generation during
>> large zeroing operations. Also add cond_resched() to provide voluntary
>> rescheduling points during long-running loops.
> 
> The balance_dirty_pages_ratelimited looks good.  Now with lazy preempt
> we really should not need more cond_resched calls, though.

Okay, will drop it in next version.

Thanks,

> 
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>
>> exFAT iomap migration:
>> https://lore.kernel.org/linux-fsdevel/20260507124238.7313-1-linkinjeon@kernel.org/
>>
>>   fs/iomap/buffered-io.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index d7b648421a70..f6955786c8ad 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -1543,6 +1543,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>   		size_t offset;
>>   		bool ret;
>>   
>> +		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
>> +
>>   		bytes = min_t(u64, SIZE_MAX, bytes);
>>   		status = iomap_write_begin(iter, write_ops, &folio, &offset,
>>   				&bytes);
>> @@ -1571,6 +1573,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>>   		if (WARN_ON_ONCE(!ret))
>>   			return -EIO;
>>   
>> +		cond_resched();
>> +
>>   		status = iomap_iter_advance(iter, bytes);
>>   		if (status)
>>   			break;
>> -- 
>> 2.43.0
> ---end quoted text---

