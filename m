Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D981D1C9B87;
	Fri, 11 Oct 2024 03:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728618876; cv=none; b=iWNl5crHarn1DoASmMnR1UmXdhhVjwvfc2MBx3F4QDtroRjTE6EnkRyHVJIwV9ZVSIWfOIqPTd8A25oahqLPFY4ZS7smXwZqQj2CHKW/yMTUVj4XM92yiSZRljfXzjeIM3x8lQYf8ogquOkf6G7xxN2lhmDEVHEEiZpwUtZKXJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728618876; c=relaxed/simple;
	bh=fnfWRUEX2igQWPtLEXx3mdXcHO1vwnDEMc2KZ6dh6E0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJzVXQ/Iy9IPU+owWtyuxawIuQwVkoS1NzNJBPD9NdKgEvw8ddtxxsW8/DqjuKXN8T7rU5+A0CJMe/cBac7D1psQChdswn8LTucsXRTZhQ/q6Itar/9F29ja034Qu7blKYD/FK6YKKlEECbCHDQS/JYju2ogSt3HzpkNHp1Lw4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=c+Mzvn77; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="c+Mzvn77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=obm2Ru5iM4+XHPs3REutTkeic4SFxEYyLePQA5HQsoU=;
	b=c+Mzvn77Lb0mVGku03KsHNz9u3WGY1shZQRS10VW4/pm1kkMy5vvXu5QtnX6u6
	j0VtOKZ9x8oS/YjQXPwLNcva+l2oOYa3ZBTjWugZZ7i5f8eWwVpM2QaRrk+Zbwz5
	85cgZuGYA3l8CIoFSH8bFMYg9Z/KG53hoMhbtSjtBIQQ0=
Received: from [10.42.116.6] (unknown [111.48.58.10])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3X8dgoQhnDMKLAQ--.40943S2;
	Fri, 11 Oct 2024 11:54:09 +0800 (CST)
Message-ID: <97501a36-d001-b3fa-5b57-8672bc7d71da@163.com>
Date: Fri, 11 Oct 2024 11:54:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] xfs_logprint: Fix super block buffer interpretation issue
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 chizhiling <chizhiling@kylinos.cn>
References: <20241011030810.1083636-1-chizhiling@163.com>
 <20241011032415.GC21877@frogsfrogsfrogs>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20241011032415.GC21877@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3X8dgoQhnDMKLAQ--.40943S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF48try3GFWxJF1xXw18Xwb_yoW5JryDpF
	93tas8Kr47Ary5Kw43Zr4qyw1rGwn7GFWUGrWvyw1rAry5Xr43KF98C34UC3sru3yUJa1F
	q3s0gas09wsrC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UIFAJUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawh1nWcIlYbwswAAs0


On 2024/10/11 11:24, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 11:08:10AM +0800, Chi Zhiling wrote:
>> From: chizhiling <chizhiling@kylinos.cn>
>>
>> When using xfs_logprint to interpret the buffer of the super block, the
>> icount will always be 6360863066640355328 (0x5846534200001000). This is
>> because the offset of icount is incorrect, causing xfs_logprint to
>> misinterpret the MAGIC number as icount.
>> This patch fixes the offset value of the SB counters in xfs_logprint.
>>
>> Before this patch:
>> icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
>>
>> After this patch:
>> icount: 10240  ifree: 4906  fdblks: 37  frext: 0
>>
>> Signed-off-by: chizhiling <chizhiling@kylinos.cn>
>> ---
>>   logprint/log_misc.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index 8e86ac34..21da5b8b 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -288,13 +288,13 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>   			/*
>>   			 * memmove because *ptr may not be 8-byte aligned
>>   			 */
>> -			memmove(&a, *ptr, sizeof(__be64));
>> -			memmove(&b, *ptr+8, sizeof(__be64));
> How did this ever work??  This even looks wrong in "Release_1.0.0".
>
Yes, I was surprised when I find this issue
>> +			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_icount), sizeof(__be64));
>> +			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_ifree), sizeof(__be64));
> Why not do:
>
> 			struct xfs_dsb *dsb = *ptr;
>
> 			memcpy(&a, &dsb->sb_icount, sizeof(a));
>
> or better yet, skip the indirection and do
>
> 			printf(_("icount: %llu  ifree: %llu  "),
> 					(unsigned long long)be64_to_cpu(dsb->sb_icount),
> 					(unsigned long long)be64_to_cpu(dsb->sb_ifree));
>
> Hm?

Yes, of course we can do it this way, I just want the fix patch to look 
smaller :)

I think both ok.


chi

>
> --D
>
>>   			printf(_("icount: %llu  ifree: %llu  "),
>>   			       (unsigned long long) be64_to_cpu(a),
>>   			       (unsigned long long) be64_to_cpu(b));
>> -			memmove(&a, *ptr+16, sizeof(__be64));
>> -			memmove(&b, *ptr+24, sizeof(__be64));
>> +			memmove(&a, *ptr + offsetof(struct xfs_dsb, sb_fdblocks), sizeof(__be64));
>> +			memmove(&b, *ptr + offsetof(struct xfs_dsb, sb_frextents), sizeof(__be64));
>>   			printf(_("fdblks: %llu  frext: %llu\n"),
>>   			       (unsigned long long) be64_to_cpu(a),
>>   			       (unsigned long long) be64_to_cpu(b));
>> -- 
>> 2.43.0
>>

