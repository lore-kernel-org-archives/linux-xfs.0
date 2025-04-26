Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A46F1DED6F;
	Sat, 26 Apr 2025 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745630945; cv=none; b=fZGBori0FbHTrfglNSE2wLH1bHMWB5WGNIZ4A3Mh2mgH7uuS33/drsD/VGULiewE24NDH9HSZgXonzg1ZoWrDGxnf/AVouS0Ik26eDIJNnqn0Za7TUYUEa66H5ufVhS1IhJB8VafwR/S+ObP8DvC2Xu83Fm6uIAmPgcNkHy+1/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745630945; c=relaxed/simple;
	bh=RUik0+Zs96tMlrQ8z8iVQ+kw2DfiMiv93ATkuYZD348=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rl6qdyDLM/EQdSTrAomiYeESeS+ix1ycStUKep8ZSlQiir1Y7ug0H3dNwVqCrxQk6Pa8ro7+KdkBBJitbQIEAz50j+1HPMNBU+Jqxhs5ob7YWPh27CdONJEKrbFh9nzXAzn9/zjjSb7kEKQ2RNFhxATScuJj2TroQ0Ps/PR0VTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aUtGl8A7; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aUtGl8A7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=5bdmOhm8OuZBuvuyYjy8I4BJ912cr49M4cgTyStbuKg=;
	b=aUtGl8A79Js1vOnO/7dQW0GnrYfHFaJCMzTkt2lYg6B84rg1pOcAJSYsWNuF8o
	pPvJtl26SF/A/L6YDzTSCO7fHaRCLcVPzZHejHZP7n5WhkfY0ADymHeBwkMk8w+a
	ihS+zIV8tA5jw7XEesPGmin4NjldySnnhVE/wQFa1LqdA=
Received: from [192.168.5.16] (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCXP2bGNgxoWJGTCQ--.42880S2;
	Sat, 26 Apr 2025 09:28:40 +0800 (CST)
Message-ID: <c59c3ffd-975a-4b61-abe1-25bd8a005b9d@163.com>
Date: Sat, 26 Apr 2025 09:28:38 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] xfs: Add i_direct_mode to indicate the IO mode of
 inode
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <20250425103841.3164087-2-chizhiling@163.com>
 <20250425151208.GN25675@frogsfrogsfrogs>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20250425151208.GN25675@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCXP2bGNgxoWJGTCQ--.42880S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JFy7Jr4kAr47Kr18tw4rGrg_yoW7CFW5pr
	ykKayYkFs7try29rn7Xr1Uurs0gay8Wr4j9r40q3W7u345Cr1S9r4Ivr129as8XrsxZr4v
	vF4FkryDu3W5tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U20PhUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxk6nWgLoz9W8wABsq

On 2025/4/25 23:12, Darrick J. Wong wrote:
> On Fri, Apr 25, 2025 at 06:38:40PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Direct IO already uses shared lock. If buffered write also uses
>> shared lock, we need to ensure mutual exclusion between DIO and
>> buffered IO. Therefore, Now introduce a flag `i_direct_mode` to
>> indicate the IO mode currently used by the file. In practical
>> scenarios, DIO and buffered IO are typically not used together,
>> so this flag is usually not modified.
>>
>> Additionally, this flag is protected by the i_rwsem lock,
>> which avoids the need to introduce new lock. When reading this
>> flag, we need to hold a read lock, and when writing, a write lock
>> is required.
>>
>> When a file that uses buffered IO starts using DIO, it needs to
>> acquire a write lock to modify i_direct_mode, which will force DIO
>> to wait for the previous IO to complete before starting. After
>> acquiring the write lock to modify `i_direct_mode`, subsequent
>> buffered IO will need to acquire the write lock again to modify
>> i_direct_mode, which will force those IOs to wait for the current
>> IO to complete.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   fs/xfs/xfs_file.c  | 37 +++++++++++++++++++++++++++++++++----
>>   fs/xfs/xfs_inode.h |  6 ++++++
>>   2 files changed, 39 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 84f08c976ac4..a6f214f57238 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -206,7 +206,8 @@ xfs_ilock_iocb(
>>   static int
>>   xfs_ilock_iocb_for_write(
>>   	struct kiocb		*iocb,
>> -	unsigned int		*lock_mode)
>> +	unsigned int		*lock_mode,
>> +	bool			is_dio)
> 
> Is an explicit flag required here, or can you determine directness from
> IS_DAX() || (iocb->ki_flags & IOCB_DIRECT) ?
> 
> Hmm, I guess not, since a directio falling back to the pagecache for an
> unaligned out of place write doesn't clear IOCB_DIRECT?

Because DIO can fallback to buffered IO, I think checking 
(iocb->ki_flags & IOCB_DIRECT) is not accurate.

That's why we need to add an additional argument.

> 
> How does this new flag intersect with XFS_IREMAPPING?  Are we actually
> modelling three states here: bufferedio <-> directio <-> remapping?

Yes, and these three states are mutually exclusive.

That's a good suggestion. I think we can include XFS_IREMAPPING in the
new flag as well.

> 
>>   {
>>   	ssize_t			ret;
>>   	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>> @@ -226,6 +227,21 @@ xfs_ilock_iocb_for_write(
>>   		return xfs_ilock_iocb(iocb, *lock_mode);
>>   	}
>>   
>> +	/*
>> +	 * If the i_direct_mode need update, take the iolock exclusively to write
>> +	 * it.
>> +	 */
>> +	if (ip->i_direct_mode != is_dio) {
>> +		if (*lock_mode == XFS_IOLOCK_SHARED) {
>> +			xfs_iunlock(ip, *lock_mode);
>> +			*lock_mode = XFS_IOLOCK_EXCL;
>> +			ret = xfs_ilock_iocb(iocb, *lock_mode);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +		ip->i_direct_mode = is_dio;
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> @@ -247,6 +263,19 @@ xfs_file_dio_read(
>>   	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>>   	if (ret)
>>   		return ret;
>> +
>> +	if (!ip->i_direct_mode) {
>> +		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>> +		ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_EXCL);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ip->i_direct_mode = 1;
>> +
>> +		/* Update finished, now downgrade to shared lock */
>> +		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>> +	}
>> +
>>   	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, NULL, 0);
>>   	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>>   
>> @@ -680,7 +709,7 @@ xfs_file_dio_write_aligned(
>>   	unsigned int		iolock = XFS_IOLOCK_SHARED;
>>   	ssize_t			ret;
>>   
>> -	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
>>   	if (ret)
>>   		return ret;
>>   	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
>> @@ -767,7 +796,7 @@ xfs_file_dio_write_unaligned(
>>   		flags = IOMAP_DIO_FORCE_WAIT;
>>   	}
>>   
>> -	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
>>   	if (ret)
>>   		return ret;
>>   
>> @@ -898,7 +927,7 @@ xfs_file_buffered_write(
>>   
>>   write_retry:
>>   	iolock = XFS_IOLOCK_EXCL;
>> -	ret = xfs_ilock_iocb(iocb, iolock);
>> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
>>   	if (ret)
>>   		return ret;
>>   
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index eae0159983ca..04f6c4174fab 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -51,6 +51,12 @@ typedef struct xfs_inode {
>>   	uint16_t		i_checked;
>>   	uint16_t		i_sick;
>>   
>> +	/*
>> +	 * Indicates the current IO mode of this inode, (DIO/buffered IO)
>> +	 * protected by i_rwsem lock.
>> +	 */
>> +	uint32_t		i_direct_mode;

I think we can add i_remapping to this new flag, and rename it to
i_current_state, so it can be remapping, DIO, or BIO.

The rule remains the same: it should be protected by i_rwsem, with the
write lock held to change it.

> 
> Yeesh, a whole u32 to encode a single bit.  Can you use i_flags instead?

Sorry, It's a mistake, But I don't think we can use i_flags instead.

I tried using i_flags for this, but i_flags is protected by
i_flags_lock, which means that for every IO operation, it always
requires an additional acquisition of i_flags_lock to check this flag.


Thanks

> 
> --D
> 
>> +
>>   	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>>   	/* Miscellaneous state. */
>>   	unsigned long		i_flags;	/* see defined flags below */
>> -- 
>> 2.43.0
>>
>>

