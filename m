Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA1A1898FB;
	Sat, 26 Apr 2025 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745631304; cv=none; b=o4fRS4ACcKbgLOFaaVK3aRFfxrCb/3LHSQx/KWxINO+gFYmse1irFQZUjTJtohYq7wLjvt5sbzdsTXjC4o0mupq3UzyFM5PIsSEzxyO5oUdK81bW6Q2gPTWFZD4qgHuJsofNTQzujOtg7Rn6xlHfx5Jw1WK9xdSpPmFH1XHiIwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745631304; c=relaxed/simple;
	bh=X9Q07Iw8Ge5odoZPqL2Sv3x3fr3O4KTILz8tnr1vMBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UtRj+XEUFedK1/LSH6yWwJlkaldTiyAuarXv33VsG3GXxXTNhUOKLR0d1aPOyqKZunTUCSA0v4zSDpLbKjjcXUouaU9WepsiVrAAHvWTyqRTm5kedoe1vfHNlrvMB80nRhXC4daUtkksNrbfvwduMpMBTZ5hFoLQUp2ab/Hpfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gkG81CaL; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gkG81CaL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=1xHokVF6O080vTQ6fGVAu/ld+ZN9rRooZSQLpIx6Wlo=;
	b=gkG81CaL0AH40dajj0ygE7QZyu9Tt13IauC15qc39gp0A+BkCKZAx3v3ewG94p
	1xkinPsjKpfX4vcjnOcCfGdxMrQOm8R3ewbi6rosUjcXvPfyTat18RFUnLqz3gOC
	qSqL09vqQGPj+LHZO9uQv/T9Sg+XnT1HPwZvVdz2bDSBQ=
Received: from [192.168.5.16] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3l0c5OAxoOH7TCg--.45202S2;
	Sat, 26 Apr 2025 09:34:49 +0800 (CST)
Message-ID: <1a389cab-08fe-486b-9fa2-240e6e1a3984@163.com>
Date: Sat, 26 Apr 2025 09:34:49 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] xfs: Enable concurrency when writing within
 single block
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <20250425103841.3164087-3-chizhiling@163.com>
 <20250425151539.GO25675@frogsfrogsfrogs>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20250425151539.GO25675@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3l0c5OAxoOH7TCg--.45202S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF15KFW3tw4xJw1kJF45GFg_yoW5WFWxpr
	Zaya1YkrZ2qry7ArnaqF15Xwn3K3Z7Xr47ZryIgF17Z3Z8Arsa93WSvryY9a1UJrs7Zr40
	9r40kFy8Cw1jyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U2Ap5UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiKQo7nWgMNEZQQAAAsD

On 2025/4/25 23:15, Darrick J. Wong wrote:
> On Fri, Apr 25, 2025 at 06:38:41PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> For unextending writes, we will only update the pagecache and extent.
>> In this case, if our write occurs within a single block, that is,
>> within a single folio, we don't need an exclusive lock to ensure the
>> atomicity of the write, because we already have the folio lock.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   fs/xfs/xfs_file.c | 34 +++++++++++++++++++++++++++++++++-
>>   1 file changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index a6f214f57238..8eaa98464328 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -914,6 +914,27 @@ xfs_file_dax_write(
>>   	return ret;
>>   }
>>   
>> +#define offset_in_block(inode, p) ((unsigned long)(p) & (i_blocksize(inode) - 1))
> 
> Is it correct to cast an loff_t (s64) to unsigned long (u32 on i386)
> here?

I'm not sure if there is an issue here, although there is a type cast,
it shouldn't affect the final result of offset_in_block.

> 
>> +
>> +static inline bool xfs_allow_concurrent(
> 
> static inline bool
> xfs_allow_concurrent(
> 
> (separate lines style nit)

Okay

> 
>> +	struct kiocb		*iocb,
>> +	struct iov_iter		*from)
>> +{
>> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
>> +
>> +	/* Extending write? */
>> +	if (iocb->ki_flags & IOCB_APPEND ||
>> +	    iocb->ki_pos >= i_size_read(inode))
>> +		return false;
>> +
>> +	/* Exceeds a block range? */
>> +	if (iov_iter_count(from) > i_blocksize(inode) ||
>> +	    offset_in_block(inode, iocb->ki_pos) + iov_iter_count(from) > i_blocksize(inode))
>> +		return false;
>> +
>> +	return true;
>> +}
> 
> ...and since this helper only has one caller, maybe it should be named
> xfs_buffered_write_iolock_mode and return the lock mode directly?

Yes, this is better. I will update it in the next patch.


Thanks

> 
>> +
>>   STATIC ssize_t
>>   xfs_file_buffered_write(
>>   	struct kiocb		*iocb,
>> @@ -925,8 +946,12 @@ xfs_file_buffered_write(
>>   	bool			cleared_space = false;
>>   	unsigned int		iolock;
>>   
>> +	if (xfs_allow_concurrent(iocb, from))
>> +		iolock = XFS_IOLOCK_SHARED;
>> +	else
>> +		iolock = XFS_IOLOCK_EXCL;
>> +
>>   write_retry:
>> -	iolock = XFS_IOLOCK_EXCL;
>>   	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
>>   	if (ret)
>>   		return ret;
>> @@ -935,6 +960,13 @@ xfs_file_buffered_write(
>>   	if (ret)
>>   		goto out;
>>   
>> +	if (iolock == XFS_IOLOCK_SHARED &&
>> +	    iocb->ki_pos + iov_iter_count(from) > i_size_read(inode)) {
>> +		xfs_iunlock(ip, iolock);
>> +		iolock = XFS_IOLOCK_EXCL;
>> +		goto write_retry;
>> +	}
>> +
>>   	trace_xfs_file_buffered_write(iocb, from);
>>   	ret = iomap_file_buffered_write(iocb, from,
>>   			&xfs_buffered_write_iomap_ops, NULL);
>> -- 
>> 2.43.0
>>
>>

