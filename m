Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB1170809;
	Thu, 16 Jan 2025 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736991534; cv=none; b=c3gyl5ROfD/Wtr7ZjjnGAKF8cou6dHZTl8c8e6aoA/mN+qYM5a87/xCcjmXPnOZh+LnFkCn/HVxVXEK0FsFWTSO4Fzuss+NClL0oaO0X0+lXtaIAecXLwEmjaVd6LVS0rFEPBGVHbt0VntPCBG37/b1ogVXTvpffTHt9jpmqkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736991534; c=relaxed/simple;
	bh=tvVuE4yBvCl2VErz5jZod8vmWl/hwjYIhx6AsK8fzLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s11CTmY4T3urhsPS3XTXDZtuCdTxPdw3UpusQLNw9mjh0i7HvlZVV2VYz+60c5m7F31Up1hg1xHouDdODwbEuN/4HD6GgPmuqV8UAx9XxkDKWhLhjOeiQzKHFEGOHBkHN/mMRoAq2cL4D5iR4ap5jYgMg2x//RerXmK0ncDWEIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=X5Z1skfN; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="X5Z1skfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=d175bTPAmGUNGazj6bhua7UJQ8KazlERVdzEjxnF1ps=;
	b=X5Z1skfNVU0vrpgRPAHBbRcNTv1e8Fj6VqIDka92SnQBp3yNu16/HMqvgwBt2h
	4YSFt5R4sqB9mDwf0UrLU5Z4iSl3WPutFXmav+3LcXrTNwzkUlfdRDpw9Pd4E6wG
	M49pjZUowfQJ/lmvqzNfahs2R5Ea4Z4UN1v/FTkpM6+58=
Received: from [10.42.12.6] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA3F+QSY4hnwJ+MGQ--.37478S2;
	Thu, 16 Jan 2025 09:38:27 +0800 (CST)
Message-ID: <43a586fb-5cee-4668-b15e-f75b294a243a@163.com>
Date: Thu, 16 Jan 2025 09:38:26 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] xfs_logprint: Fix super block buffer interpretation
 issue
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>, Dave Chinner <david@fromorbit.com>,
 Christoph Hellwig <hch@lst.de>
References: <20241013042952.2367585-1-chizhiling@163.com>
 <20250116003350.GD3566461@frogsfrogsfrogs>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20250116003350.GD3566461@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wA3F+QSY4hnwJ+MGQ--.37478S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw47KFW8uw4DKFWxKr4DJwb_yoW5XF43pF
	1fGa42yrWDA345G347ZFZ0yr15XwnxJryDGrsIyryrZr98JFWayry7C348CrZI93ykGF4Y
	yr90kr909F1qva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UTHqxUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiKQrWnWeIYgQWdwAAsA

On 2025/1/16 08:33, Darrick J. Wong wrote:
> On Sun, Oct 13, 2024 at 12:29:52PM +0800, Chi Zhiling wrote:
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
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   logprint/log_misc.c | 17 +++++------------
> 
> Hmm, I don't think this ever got merged...
> 
> but shouldn't log_print_all.c also get fixed?  I think it has the same
> pointer arithmetic problem that could be replaced by get_unaligned_be64
> calls just like you did below.

Indeed, the same issue also exists in log_print_all.c. I will fix it in
the next push.

Thanks,
Chi Zhiling

> 
> --D
> 
>>   1 file changed, 5 insertions(+), 12 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index 8e86ac34..803e4d2f 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -282,22 +282,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>   		if (be32_to_cpu(head->oh_len) < 4*8) {
>>   			printf(_("Out of space\n"));
>>   		} else {
>> -			__be64		 a, b;
>> +			struct xfs_dsb	*dsb = (struct xfs_dsb *) *ptr;
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
>> +			       (unsigned long long) get_unaligned_be64(dsb->sb_icount),
>> +			       (unsigned long long) get_unaligned_be64(dsb->sb_ifree));
>>   			printf(_("fdblks: %llu  frext: %llu\n"),
>> -			       (unsigned long long) be64_to_cpu(a),
>> -			       (unsigned long long) be64_to_cpu(b));
>> +			       (unsigned long long) get_unaligned_be64(dsb->sb_fdblocks),
>> +			       (unsigned long long) get_unaligned_be64(dsb->sb_frextents));
>>   		}
>>   		super_block = 0;
>>   	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
>> -- 
>>
>> 2.43.0
>>
>>

