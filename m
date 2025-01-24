Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD0A1DB13B;
	Fri, 24 Jan 2025 07:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737705546; cv=none; b=sE7iIFhysSYQ//XD2mkmEYeJTEPFSwjsTHrOUN7VSPNauMf0DWE1PkYAoQejJL19IEQj5zAuJDmrHfotAz56usAVCxGwY8tXllbvQKZNPFTFkqZ4JYd0eRZSu2KkP2LIlPWlM5jE2kcb8MSI/fJagSQLvN1ZmH6Ai6Ig3Romkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737705546; c=relaxed/simple;
	bh=+JMCLgX+cCsCLfya232eGxLISOuKUHrGIchgNS9cYFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vd1FniTpwKeEIp4oWXDeJAFTL0Tbl2CVGdSKBP3/DkA74s/gIqauHd+BdFddWnLmoUXteBScVwbR3Urq47zntEhNJ/o/Hr+4Vdn8GJl7wqQXw4myjd1DGFvRtO2VupsZI41cGpGE8K+yX8ibdhXl7NbycTaFaGysdO339uVf5cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ClOWQGoP; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ClOWQGoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=k7BNiZeauamU+zOH+F0kigT/sIVaaMlFeJsEK7tin/Q=;
	b=ClOWQGoPVKI8HI4pQFKuxRUqxZuMUQaZe3BTWAFYX5wxcEsGRS983E/5/n22v7
	jWTigMLm8dKzBWTD6uR0JFpXmxQFK69k7FiLAjbnYsGcavISFywDXDOjYdG/3Wip
	gpNXQnjceRUQVjgju/6enIyyWBTyZaHyhH9VzzhEnZcdg=
Received: from [10.42.12.6] (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3n8X3R5NnY7WvIA--.54671S2;
	Fri, 24 Jan 2025 15:57:43 +0800 (CST)
Message-ID: <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
Date: Fri, 24 Jan 2025 15:57:43 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
References: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs> <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org> <Z4grgXw2iw0lgKqD@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z4grgXw2iw0lgKqD@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3n8X3R5NnY7WvIA--.54671S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur43AF47ZrWkGr1rKr1UGFg_yoWrZFW5pF
	WrKasxKr4DKrWkZ3s29w4xXa48Zws3Jr43GF98Xr1kuay5WFySqF4ktw1YyrWDAr4xtr4j
	vrWUZ34fCas0vFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UeuWJUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBoRbenWeTQj1JjgAAs4

On 2025/1/16 05:41, Dave Chinner wrote:
> On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
>> On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
>>> Sorry if this is out of left field as I haven't followed the discussion
>>> closely, but I presumed one of the reasons Darrick and Christoph raised
>>> the idea of using the folio batch thing I'm playing around with on zero
>>> range for buffered writes would be to acquire and lock all targeted
>>> folios up front. If so, would that help with what you're trying to
>>> achieve here? (If not, nothing to see here, move along.. ;).
>>
>> I mostly thought about acquiring, as locking doesn't really have much
>> batching effects.  That being said, no that you got the idea in my mind
>> here's my early morning brainfart on it:
>>
>> Let's ignore DIRECT I/O for the first step.  In that case lookup /
>> allocation and locking all folios for write before copying data will
>> remove the need for i_rwsem in the read and write path.  In a way that
>> sounds perfect, and given that btrfs already does that (although in a
>> very convoluted way) we know it's possible.
> 
> Yes, this seems like a sane, general approach to allowing concurrent
> buffered writes (and reads).
> 
>> But direct I/O throws a big monkey wrench here as already mentioned by
>> others.  Now one interesting thing some file systems have done is
>> to serialize buffered against direct I/O, either by waiting for one
>> to finish, or by simply forcing buffered I/O when direct I/O would
>> conflict.
> 
> Right. We really don't want to downgrade to buffered IO if we can
> help it, though.
> 
>> It's easy to detect outstanding direct I/O using i_dio_count
>> so buffered I/O could wait for that, and downgrading to buffered I/O
>> (potentially using the new uncached mode from Jens) if there are any
>> pages on the mapping after the invalidation also sounds pretty doable.
> 
> It's much harder to sanely serialise DIO against buffered writes
> this way, because i_dio_count only forms a submission barrier in
> conjunction with the i_rwsem being held exclusively. e.g. ongoing
> DIO would result in the buffered write being indefinitely delayed.
> 
> I think the model and method that bcachefs uses is probably the best
> way to move forward - the "two-state exclusive shared" lock which it
> uses to do buffered vs direct exclusion is a simple, easy way to
> handle this problem. The same-state shared locking fast path is a
> single atomic cmpxchg operation, so it has neglible extra overhead
> compared to using a rwsem in the shared DIO fast path.
> 
> The lock also has non-owner semantics, so DIO can take it during
> submission and then drop it during IO completion. This solves the
> problem we currently use the i_rwsem and
> inode_dio_{start,end/wait}() to solve (i.e. create a DIO submission
> barrier and waiting for all existing DIO to drain).
> 
> IOWs, a two-state shared lock provides the mechanism to allow DIO
> to be done without holding the i_rwsem at all, as well as being able
> to elide two atomic operations per DIO to track in-flight DIOs.
> 
> We'd get this whilst maintaining buffered/DIO coherency without
> adding any new overhead to the DIO path, and allow concurrent
> buffered reads and writes that have their atomicity defined by the
> batched folio locking strategy that Brian is working on...
> 
> This only leaves DIO coherency issues with mmap() based IO as an
> issue, but that's a problem for a different day...

When I try to implement those features, I think we could use exclusive
locks for RWF_APPEND writes, and shared locks for other writes.

The reason is that concurrent operations are also possible for extended
writes if there is no overlap in the regions being written.
So there is no need to determine whether it is an extended write in
advance.

As for why an exclusive lock is needed for append writes, it's because
we don't want the EOF to be modified during the append write.

The code is like that:
+       if (iocb->ki_flags & IOCB_APPEND)
+               iolock = XFS_IOLOCK_EXCL;
+       else
+               iolock = XFS_IOLOCK_SHARED;


If we use exclusive locks for all extended writes, we need to check if
it is an extended write before acquiring the lock, but this value could
become outdated if we do not hold the lock.

So if we do an extended write,
we might need to follow this process:

1. Get read lock.
2. Check if it is an extended write.
3. Release read lock.
4. Get write lock.
5. Do the write operation.


Thanks,
Chi Zhiling

