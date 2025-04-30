Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF34E1EEA46;
	Wed, 30 Apr 2025 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746003850; cv=none; b=JYmAlsT3DX4knS3tn7EZ0UnlhQud0wNwD3sT/w/YL/h8XHS6rhvXTZNglP5sz6Z11JcvfL49TMjRNqv7NtjipR5kjWFWpvyEev7ewnPkW5zut89L+UczhbKfVsYBwTo13U/o7DIc2vgEgvlb0Jo/JeOwYwZXYj5yJp47a4+Sw4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746003850; c=relaxed/simple;
	bh=PKzN8iXlBJBK9SwHSpvuXQqkp9QMK953kT+GMiKVbZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ef/3cB9hxDSTUyID3c59dQ+wqEo+etB2dlYFhujQLeF83Yo/qLaG0HCpDZOcuKfQjcUiRuUTeC8/rynUPsCgVpIm6LkWRwLYRMYlhtZ8aDKa9uSxFKGvLPgv2wOyyYNlCniJdoeEdlRlVue1iAsyP43pBf7buG8u+4DzyBhidUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pGIjnToJ; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pGIjnToJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=qZH1Iv4RTrKHulqeYwn77KGwSyTWOgV1PzxST8oMpJQ=;
	b=pGIjnToJVXX4iLXvxQr9dbQ6zaraRnoH17VJrUbUrFl/uUAq/8Bkj7OXm3yX31
	6mpNAji97mLnOXeSX+1gySOtG7b2ILgln71SHPXO7USkfMydZGFybdx+H2xrEe0/
	9RcnH2kXkytzK0PPyC/zg4/KEEyJGAZf7tMiI8rCD1Zss=
Received: from [10.42.12.6] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCXA5h35xFon77_Dg--.24817S2;
	Wed, 30 Apr 2025 17:03:51 +0800 (CST)
Message-ID: <040637ad-54ac-4695-8e49-b4a3c643b056@163.com>
Date: Wed, 30 Apr 2025 17:03:51 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Implement concurrent buffered write with folio
 lock
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <aBGFfpyGtYQnK411@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <aBGFfpyGtYQnK411@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCXA5h35xFon77_Dg--.24817S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3AFyfWrW8Cry5uryUtF4fZrb_yoW3Cr1DpF
	Z5K39rtFs7Kr97Jrn293W8Xr1Fv39aq343CrW5Xw4xCa9xXr12gF1vq3yYkFWDArs2y3yq
	vF40934xGFWqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U2Ap5UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiKRw7nWgMNEZQQQACsW

On 2025/4/30 10:05, Dave Chinner wrote:
> On Fri, Apr 25, 2025 at 06:38:39PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> This is a patch attempting to implement concurrent buffered writes.
>> The main idea is to use the folio lock to ensure the atomicity of the
>> write when writing to a single folio, instead of using the i_rwsem.
>>
>> I tried the "folio batch" solution, which is a great idea, but during
>> testing, I encountered an OOM issue because the locked folios couldn't
>> be reclaimed.
>>
>> So for now, I can only allow concurrent writes within a single block.
>> The good news is that since we already support BS > PS, we can use a
>> larger block size to enable higher granularity concurrency.
> 
> I'm not going to say no to this, but I think it's a short term and
> niche solution to the general problem of enabling shared buffered
> writes. i.e. I expect that it will not exist for long, whilst

Hi, Dave,

Yes, it's a short-term solution, but it's enough for some scenarios.
I would also like to see better idea.

> experience tells me that adding special cases to the IO path locking
> has a fairly high risk of unexpected regressions and/or data
> corruption....

I can't say there is definitely no data corruption, but I haven't seen
any new errors in xfstests.

We might need to add some assertions in the code to check for the risk
of data corruption, not specifically for this patch, but for the current
XFS system in general. This would help developers avoid introducing new
bugs, similar to the lockdep tool.

> 
>> These ideas come from previous discussions:
>> https://lore.kernel.org/all/953b0499-5832-49dc-8580-436cf625db8c@163.com/
> 
> In my spare time I've been looking at using the two state lock from
> bcachefs for this because it looks to provide a general solution to
> the issue of concurrent buffered writes.

In fact, I have tried the two state lock, and it does work quite well.
However, I noticed some performance degradation in single-threaded
scenarios in UnixBench (I'm not sure if it's caused by the memory
barrier).

Since single-threaded bufferedio is still the primary read-write mode,
I don't want to introduce too much impact in single-threaded scenarios.

That's why I introduced the i_direct_mode flag, which protected by
i_rwsem. This approach only adds a boolean operation in fast path.

> 
> The two valid IO exclusion states are:
> 
> +enum {
> +       XFS_IOTYPE_BUFFERED = 0,
> +       XFS_IOTYPE_DIRECT = 1,
> +};
> 
> Importantly, this gives us three states, not two:
> 
> 1. Buffered IO in progress,
> 2. Direct IO in progress, and
> 3. No IO in progress. (i.e. not held at all)
> 
> When we do operations like truncate or hole punch, we need the state
> to be #3 - no IO in progress.
> 
> Hence we can use this like we currently use i_dio_count for
> truncate with the correct lock ordering. That is, we order the
> IOLOCK before the IOTYPE lock:
> 
> Buffered IO:
> 
> 	IOLOCK_SHARED, IOLOCK_EXCL if IREMAPPING
> 	  <IREMAPPING excluded>
> 	  IOTYPE_BUFFERED
> 	    <block waiting for in progress DIO>
> 	    <do buffered IO>
> 	  unlock IOTYPE_BUFFERED
> 	unlock IOLOCK
> 
> IREMAPPING IO:
> 
> 	IOLOCK_EXCL
> 	  set IREMAPPING
> 	  demote to IOLOCK_SHARED
> 	  IOTYPE_BUFFERED
> 	    <block waiting for in progress DIO>
> 	    <do reflink operation>
> 	  unlock IOTYPE_BUFFERED
> 	  clear IREMAPPING
> 	unlock IOLOCK
> 
> Direct IO:
> 
> 	IOLOCK_SHARED
> 	  IOTYPE_DIRECT
> 	    <block waiting for in progress buffered, IREMAPPING>
> 	    <do direct IO>
> 	<submission>
> 	  unlock IOLOCK_SHARED
> 	<completion>
> 	  unlock IOTYPE_DIRECT
> 
> Notes on DIO write file extension w.r.t. xfs_file_write_zero_eof():
> - xfs_file_write_zero_eof() does buffered IO.
> - needs to switch from XFS_IOTYPE_DIRECT to XFS_IOTYPE_BUFFERED
> - this locks out all other DIO, as the current switch to
>    IOLOCK_EXCL will do.
> - DIO write path no longer needs IOLOCK_EXCL to serialise post-EOF
>    block zeroing against other concurrent DIO writes.
> - future optimisation target so that it doesn't serialise against
>    other DIO (reads or writes) within EOF.
> 
> This path looks like:
> 
> Direct IO extension:
> 
> 	IOLOCK_EXCL
> 	  IOTYPE_BUFFERED
> 	    <block waiting for in progress DIO>
> 	    xfs_file_write_zero_eof();
> 	  demote to IOLOCK_SHARED
> 	  IOTYPE_DIRECT
> 	    <block waiting for buffered, IREMAPPING>
> 	    <do direct IO>
> 	<submission>
> 	  unlock IOLOCK_SHARED
> 	<completion>
> 	  unlock IOTYPE_DIRECT
> 
> Notes on xfs_file_dio_write_unaligned()
> - this drains all DIO in flight so it has exclusive access to the
>    given block being written to. This prevents races doing IO (read
>    or write, buffered or direct) to that specific block.
> - essentially does an exclusive, synchronous DIO write after
>    draining all DIO in flight. Very slow, reliant on inode_dio_wait()
>    existing.
> - make the slow path after failing the unaligned overwrite a
>    buffered write.
> - switching modes to buffered drains all the DIO in flight,
>    buffered write data all the necessary sub-block zeroing in memory,
>    next overlapping DIO of fdatasync() will flush it to disk.
> 
> This slow path looks like:
> 
> 	IOLOCK_EXCL
> 	  IOTYPE_BUFFERED
> 	    <excludes all concurrent DIO>
> 	    set IOCB_DONTCACHE
> 	    iomap_file_buffered_write()
> 
> Truncate and other IO exclusion code such as fallocate() need to do
> this:
> 
> 	IOLOCK_EXCL
> 	  <wait for IO state to become unlocked>
> 
> The IOLOCK_EXCL creates a submission barrier, and the "wait for IO
> state to become unlocked" ensures that all buffered and direct IO
> have been drained and there is no IO in flight at all.
> 
> Th upside of this is that we get rid of the dependency on
> inode->i_dio_count and we ensure that we don't potentially need a
> similar counter for buffered writes in future. e.g. buffered
> AIO+RWF_DONTCACHE+RWF_DSYNC could be optimised to use FUA and/or IO
> completion side DSYNC operations like AIO+DIO+RWF_DSYNC currently
> does and that would currently need in-flight IO tracking for truncate
> synchronisation. The two-state lock solution avoids that completely.

Okay, sounds great.

> 
> Some work needs to be done to enable sane IO completion unlocking
> (i.e. from dio->end_io). My curent notes on this say:
> 
> - ->end_io only gets called once when all bios submitted for the dio
>    are complete. hence only one completion, so unlock is balanced
> - caller has no idea on error if IO was submitted and completed;
>    if dio->end_io unlocks on IO error, the waiting submitter has no
>    clue whether it has to unlock or not.
> - need a clean submitter unlock model. Alternatives?
>    - dio->end_io only unlock on on IO error when
>      dio->wait_for_completion is not set (i.e. completing an AIO,
>      submitter was given -EIOCBQUEUED). iomap_dio_rw() caller can
>      then do:
> 
>          if (ret < 0 && ret != -EIOCBQUEUED) {
>                  /* unlock inode */
>          }
>    - if end_io is checking ->wait_for_completion, only ever unlock
>      if it isn't set? i.e. if there is a waiter, we leave it to them
>      to unlock? Simpler rule for ->end_io, cleaner for the submitter
>      to handle:
> 
>          if (ret != -EIOCBQUEUED) {
>                  /* unlock inode */
>          }
> - need to move DIO write page cache invalidation and inode_dio_end()
>    into ->end_io for implementations
> - if no ->end_io provided, do what the current code does.
> 
> There are also a few changes need to avoid inode->i_dio_count in
> iomap:
> - need a flag to tell iomap_dio_rw() not to account the DIO
> - inode_dio_end() may need to be moved to ->dio_end, or we could
>    use the "do not account" flag to avoid it.
> - However, page cache invalidation and dsync work needs to be done
>    before in-flight dio release, so this we likely need to move this
>    stuff to ->end_io before we drop the IOTYPE lock...
> - probably can be handled with appropriate helpers...
> 
> I've implemented some of this already; I'm currently in the process
> of making truncate exclusion work correctly. Once that works, I'll
> post the code....

Thank you for sharing your thoughts, I will be waiting for that.

> 
> -~dave

