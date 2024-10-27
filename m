Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AED01E517;
	Sun, 27 Oct 2024 04:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730001938; cv=none; b=H7qDpRtk6kaF6DMD0pnI8SQX/2rx9hdld/H9XvYzL77NCAdYvzqhKP1z5yID8H2bisQuSY6uuvtl0l3GpkSEv2P+zeS3Rv1KaejfB7ZO3tA/vYY4pNqht4n9An0jFH7If/eouYu4nl+cn9zgJYPAnvtTfxjki0ua4XswBsH07Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730001938; c=relaxed/simple;
	bh=/u39L6fOM3MVKTnjv+pj0ryNWFFxhoHQrl+wnYHsIok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W+gWQegTQD3Qli5MlIXS7o7o476UodMN9Dpn4EneoLxFDBP65CR25w5SJ+FFAg9YDciIZQ+rDsIBxpV5QwN2AGXGjrRI6lmfxcxdfIOxnldkxnUfi/IynIG+y+LkZ+fcX4F4aRedahKeVi0Q2vo6BFqzdWKcOkMgNuqrWIqRcT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ec6pRUMH; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ec6pRUMH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=QXs92Vj1eumE7lNUPlAilLfDF8TkiWz3pX76dGci32E=;
	b=Ec6pRUMHaxmlIH1Vfv6yWHQUsF8sPORzW4ej4wiLSLibz5e0E3Kx1HsEQLCDnr
	Q4TqQtPOyFDZ9zVgcs/gD46vr2XPaY0tpjeyxXnOOWRT6UV3mK9pbKeE7iOrchl5
	pRh3RrdzJUNbtffHYSwIOzCo7D8flxScS2qH2iKEhpsGE=
Received: from [192.168.65.169] (unknown [123.114.208.230])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3H2n0ux1nH+HBBQ--.29051S2;
	Sun, 27 Oct 2024 12:05:09 +0800 (CST)
Message-ID: <92065b35-31fa-4df7-b4ce-b79cd0802c1a@163.com>
Date: Sun, 27 Oct 2024 12:05:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Reduce unnecessary searches when searching for the
 best extents
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
References: <20241025023320.591468-1-chizhiling@163.com>
 <ZxtEJN/dTw9JipJe@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <ZxtEJN/dTw9JipJe@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PygvCgD3H2n0ux1nH+HBBQ--.29051S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFy5WFW7Ar4DAFW8Gr47XFb_yoW5Gr1Upr
	Zaya1jkrZ8tw17Gr9rWrsFq343Kw18Wr47Zr909r13C3Z0gF13Kr9Fkr4Y9a4UZr4rW3W0
	9r4ftFy0vw1Yva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U20PhUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxuDnWcbQw4VZQABsK


On 2024/10/25 15:09, Dave Chinner wrote:
> On Fri, Oct 25, 2024 at 10:33:20AM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Recently, we found that the CPU spent a lot of time in
>> xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
>> spaces.
>>
>> The reason is that we conducted much extra searching for extents that
>> could not yield a better result, and these searches would cost a lot of
>> time when there were millions of extents to search through. Even if we
>> get the same result length, we don't switch our choice to the new one,
>> so we can definitely terminate the search early.
>>
>> Since the result length cannot exceed the found length, when the found
>> length equals the best result length we already have, we can conclude
>> the search.
>>
>> We did a test in that filesystem:
>> [root@localhost ~]# xfs_db -c freesp /dev/vdb
>>     from      to extents  blocks    pct
>>        1       1     215     215   0.01
>>        2       3  994476 1988952  99.99
> Ok, so you have *badly* fragmented free space. That going to cause
> lots more problems than only "allocation searches take a long
> time". e.g. you can't allocate inodes in a AG that is fragmented
> this badly - not even sparse inode clusters....

Yes, this usually happens in some systems that use Mysql table 
compression, which continuously punches holes in file, eventually 
causing most fragment lengths to converge to the hole size.

>
>> Before this patch:
>>   0)               |  xfs_alloc_ag_vextent_size [xfs]() {
>>   0) * 15597.94 us |  }
>>
>> After this patch:
>>   0)               |  xfs_alloc_ag_vextent_size [xfs]() {
>>   0)   19.176 us    |  }
> Yup, that's a good improvement.
>
>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 04f64cf9777e..22bdbb3e9980 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -1923,7 +1923,7 @@ xfs_alloc_ag_vextent_size(
>>   				error = -EFSCORRUPTED;
>>   				goto error0;
>>   			}
>> -			if (flen < bestrlen)
>> +			if (flen <= bestrlen)
>>   				break;
>>   			busy = xfs_alloc_compute_aligned(args, fbno, flen,
>>   					&rbno, &rlen, &busy_gen);
> Yup, I think that works fine. We aren't caring about using locality
> as a secondary search key so as soon as we have a candidate extent
> of a length that that the remaining extents in the free space btree
> can't improve on, we are done.
>
> Nice work!
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Thanks!
>

