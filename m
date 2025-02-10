Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D061C01;
	Mon, 10 Feb 2025 01:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739151950; cv=none; b=aVIMMVAvInF4Xw0t2sRmN4HnXNx1CTOHpd6CAuaV9bqSVf4VMEXcyjG1RiVbWtClp2FYq0kbctTXpu0N1k6QGF8WL5C3fyzaLQpfIfjH1tBB2nyps+W0PdZHJWgAnZ4mcuPDaNFreOMeHFxDMrpY7TBs7pTPX1UF8hM6Vippffo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739151950; c=relaxed/simple;
	bh=yHiPQYOMLNtpDz9ADOQOT6F1jS0rQaPqU+qsUDT93OU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBu+SoKeaB6YrEtV9DZLHu9mmcXsolzhJW7BeB4OHXYg5dJo/4Kkuxa6NiRjL+Flyc4kq1GTQ1/0BWcCo0Jwsbb/tc323rJudZif0zE9hksdniYOvMGV9tIBD9abNUekKgh5/R1rSjTLhdKpyT+fIQGUfw218CzthEaLYj+KxIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RljtDMBY; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RljtDMBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=xS64DTyeEN7997Exm6dUty5M0KNw9Y+0LQYT+oCDOBI=;
	b=RljtDMBYFGsUJri9nF7OTBLXYg3+2Zhpy+QlLgj1W0a2taT8FL/qQSf/66aO88
	lh6joHjfLofVkOuFb0TLuz/MI35SFfGzJ5g70mbtcFgqDuPiSwCbha77oY3/uVOa
	27VAkX2DHvgbqrbZF1LGSUrOHdQ7QqWasQXhpGC74ivnw=
Received: from [10.42.12.6] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCXz_oLWqlnG+9tLQ--.51528S2;
	Mon, 10 Feb 2025 09:44:44 +0800 (CST)
Message-ID: <1cd75bf6-875f-400a-9158-d747e422ad78@163.com>
Date: Mon, 10 Feb 2025 09:44:43 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
 cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
References: <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs> <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org> <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
 <Z5fxTdXq3PtwEY7G@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z5fxTdXq3PtwEY7G@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCXz_oLWqlnG+9tLQ--.51528S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF45tFyrZr1kJryUtw18Krg_yoWrCFW3pr
	WrKa4qyr1qgr1xArnFka18Xw1Fgw48Jw43Gr95Xr18uFy5GFyFgF4Svr4j934rArZaqr42
	qw4jkas7Cas8ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UeMKtUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxrvnWepVplDQAAAsl

On 2025/1/28 04:49, Dave Chinner wrote:
> On Fri, Jan 24, 2025 at 03:57:43PM +0800, Chi Zhiling wrote:
>> On 2025/1/16 05:41, Dave Chinner wrote:
>>> IOWs, a two-state shared lock provides the mechanism to allow DIO
>>> to be done without holding the i_rwsem at all, as well as being able
>>> to elide two atomic operations per DIO to track in-flight DIOs.
>>>
>>> We'd get this whilst maintaining buffered/DIO coherency without
>>> adding any new overhead to the DIO path, and allow concurrent
>>> buffered reads and writes that have their atomicity defined by the
>>> batched folio locking strategy that Brian is working on...
>>>
>>> This only leaves DIO coherency issues with mmap() based IO as an
>>> issue, but that's a problem for a different day...
>>
>> When I try to implement those features, I think we could use exclusive
>> locks for RWF_APPEND writes, and shared locks for other writes.
>>
>> The reason is that concurrent operations are also possible for extended
>> writes if there is no overlap in the regions being written.
>> So there is no need to determine whether it is an extended write in
>> advance.
>>
>> As for why an exclusive lock is needed for append writes, it's because
>> we don't want the EOF to be modified during the append write.
> 
> We don't care if the EOF moves during the append write at the
> filesystem level. We set kiocb->ki_pos = i_size_read() from
> generic_write_checks() under shared locking, and if we then race
> with another extending append write there are two cases:
> 
> 	1. the other task has already extended i_size; or
> 	2. we have two IOs at the same offset (i.e. at i_size).
> 
> In either case, we don't need exclusive locking for the IO because
> the worst thing that happens is that two IOs hit the same file
> offset. IOWs, it has always been left up to the application
> serialise RWF_APPEND writes on XFS, not the filesystem.
> 
> There is good reason for not doing exclusive locking for extending
> writes. When extending the file naturally (think sequential writes),
> we need those IOs be able to run concurrently with other writes
> in progress. i.e. it is common for
> applications to submit multiple sequential extending writes in a
> batch, and as long as we submit them all in order, they all hit the
> (moving) EOF exactly and hence get run concurrently.
> 
> This also works with batch-submitted RWF_APPEND AIO-DIO - they just
> turn into concurrent in-flight extending writes...
> 
> IOWs, forcing exclusive locking for writes at exactly EOF is
> definitely not desirable, and existing behaviour is that they use
> shared locking.
> 
> The only time we use exclusive locking for extending writes is when
> they -start- beyond EOF (i.e. leave a hole between EOF and
> kiocb->ki_pos) and so we have to guarantee that range does not have
> stale data exposed from it while the write is in progress. i.e. we
> have to zero the hole that moving EOF exposes if it contains
> written extents, and we cannot allow reads or writes to that hole
> before we are done.

Sorry for the late reply.

I'm not sure why stale data would be exposed. If we zero this hole
first, then write data, and finally update the i_size, before we move
the EOF, other operations won't be able to read the data in this hole,
So I think the stale data won't be exposed.

And I think an exclusive lock is indeed needed here. The main reason is
that we need to zero this hole, and the offset of this hole is based
on EOF, so an exclusive lock is required to ensure that the EOF is not
moved.

Thanks,
Chi Zhiling

> 
>> The code is like that:
>> +       if (iocb->ki_flags & IOCB_APPEND)
>> +               iolock = XFS_IOLOCK_EXCL;
>> +       else
>> +               iolock = XFS_IOLOCK_SHARED;
>>
>>
>> If we use exclusive locks for all extended writes, we need to check if
>> it is an extended write before acquiring the lock, but this value could
>> become outdated if we do not hold the lock.
>>
>> So if we do an extended write,
>> we might need to follow this process:
>>
>> 1. Get read lock.
>> 2. Check if it is an extended write.
>> 3. Release read lock.
>> 4. Get write lock.
>> 5. Do the write operation.
> 
> Please see xfs_file_write_checks() - it should already have all the
> shared/exclusive relocking logic we need for temporarily excluding
> buffered reads whilst submitting concurrent buffered writes (i.e. it
> is the same as what we already do for concurrent DIO writes).
> 
> -Dave.

