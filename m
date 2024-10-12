Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A95A92D;
	Sat, 12 Oct 2024 01:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728695642; cv=none; b=mmjjg4vL4D/+5SRLTDEihAJdSCg6YvZWw+tPAbA9EtZNPAJJzfARxX4r1m5tLtv9OzsynvuWsyiF9sZ8+VyTMjfX+Go7J0QpuSoqiPRQcsL49cM/hYjJvmLACoJpwYiI0QMuaZLxi6uBgIK+7FP4lS/bsEomSwZQ1hA1nYrKi1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728695642; c=relaxed/simple;
	bh=jIdofv9mw0ci4EkzRp6gSQgD3N20rORvNdf8SbKCIqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F7pr7beVhLOr1/U4+FpjpZcD1FhsGtMz1k3/u4CG5PfyQg/VMFjiGxsu9Mq47bCTN7WACDorBzQDM2dR/xP8VAQ9y/lsLU7kPp/LRDwG6hOBWuJuZqWz49KA07baOL60QFuQ+UuPmE6wieSH7TRXVJcn8pNDpKG5ymMnYHlj6Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=b07FtsNw; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="b07FtsNw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=7w+5TS9DyI2/JekiB+pTt8ngNbWg6866NKAEMBY408Y=;
	b=b07FtsNwW/t1WvgoV5uEqq23P9SPxWBbIChGyN1rP4k/7j+ITBxx77+X3Ot7e0
	tOhFeHCdN75q+5udXGwDrxwK27Ec1b+JubcN92TCyxaCvribyPp2SQtpq05MQ2wI
	+QjsjG8GxBnPwKKur8BIF82jjeG/LKro3ePN4VajFa3Kk=
Received: from [10.42.116.6] (unknown [111.48.58.10])
	by gzsmtp3 (Coremail) with SMTP id sigvCgBn9x1MzQlnk2NBAA--.14792S2;
	Sat, 12 Oct 2024 09:13:49 +0800 (CST)
Message-ID: <497e55eb-27a4-ed0f-a872-6918fc1e4586@163.com>
Date: Sat, 12 Oct 2024 09:13:48 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] xfs_logprint: Fix super block buffer interpretation
 issue
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20241011075253.2369053-1-chizhiling@163.com>
 <20241011163640.GV21853@frogsfrogsfrogs>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20241011163640.GV21853@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:sigvCgBn9x1MzQlnk2NBAA--.14792S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWftFW3Wr1xJr1kZrWxtFb_yoW8KrWkpF
	1fKa4ayrZrZ345W347ZrZ0yr1rtwsxJry7Gr42yr15AF95Ar4Yvr9ru348CrZrC39rJF4Y
	yr98Kr909w4qva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UI2NNUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBaw92nWcJvE7p5gAAsc


On 2024/10/12 00:36, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 03:52:53PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
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
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   logprint/log_misc.c | 17 +++++------------
>>   1 file changed, 5 insertions(+), 12 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index 8e86ac34..0da92744 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>   		if (be32_to_cpu(head->oh_len) < 4*8) {
>>   			printf(_("Out of space\n"));
>>   		} else {
>> -			__be64		 a, b;
>> +			struct xfs_dsb *dsb = (struct xfs_dsb *) *ptr;
> Nit: tab between type and variable    ^ name

Thank you, I will fix it soon


chi

>
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> --D
>
>>   
>>   			printf("\n");
>> -			/*
>> -			 * memmove because *ptr may not be 8-byte aligned
>> -			 */
>> -			memmove(&a, *ptr, sizeof(__be64));
>> -			memmove(&b, *ptr+8, sizeof(__be64));
>>   			printf(_("icount: %llu  ifree: %llu  "),
>> -			       (unsigned long long) be64_to_cpu(a),
>> -			       (unsigned long long) be64_to_cpu(b));
>> -			memmove(&a, *ptr+16, sizeof(__be64));
>> -			memmove(&b, *ptr+24, sizeof(__be64));
>> +			       (unsigned long long) be64_to_cpu(dsb->sb_icount),
>> +			       (unsigned long long) be64_to_cpu(dsb->sb_ifree));
>>   			printf(_("fdblks: %llu  frext: %llu\n"),
>> -			       (unsigned long long) be64_to_cpu(a),
>> -			       (unsigned long long) be64_to_cpu(b));
>> +			       (unsigned long long) be64_to_cpu(dsb->sb_fdblocks),
>> +			       (unsigned long long) be64_to_cpu(dsb->sb_frextents));
>>   		}
>>   		super_block = 0;
>>   	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
>> -- 
>> 2.43.0
>>
>>

