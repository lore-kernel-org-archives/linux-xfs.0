Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143D121506A;
	Thu,  9 Jan 2025 08:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736411862; cv=none; b=u4wvM8N7BzDyKDCyq/HVUQdZ31BwIyduyfXncG+ixGJ3z0z5NvMp6w+nX1xLqi+3/xR09pAYVUJ25SmnLh6skzlBShr/uHRVs6hNGupvmmmQ7FLtdm9Vg90SQt2ZNS2PX513ldo/VJoH6bWArYjWh/SPrFOqP+Oa54JOoNljMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736411862; c=relaxed/simple;
	bh=r+fyVn5l4fBX3/77UM5/J3dod99gI6kwTxnX0A47aik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k5TgE3q+kQJTZpOAymhBthGnTOLCB4lUaLmEQUZUJPe7dAAdGS9ALII8EfvSIYzTTDFcvsgZdz3PRGtHEzhTNSJmvrQuViXuuavRCdBVez+y+gNBBWERF5c5hiC/3+YrKp4HOw19MHMV/E0fvZDLIFv+uHgbqwcdqnjvpNc9v0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hj7ef/j+; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hj7ef/j+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=ojV1pqexbLIoOyqNyF+xwG0po0emqQqnNaKEqInXDMc=;
	b=hj7ef/j+4Xzp60IvzBOTCKiZ8RNyMnl8xtfGePuTrwk0UmGTrlgZWG2cVrCwft
	xr21B97/6R11YSGj/FwxkYIHLRa1EvFXSDxY7PZslTMpL+phoZRuKZG5d0CBEg4Z
	T0Wcquo5nL/yMq0Zqn9g2HBl1RrP6nOC685Na81pzC7w4=
Received: from [10.42.12.6] (unknown [116.128.244.169])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAn1tm+in9nkOLOJw--.46063S2;
	Thu, 09 Jan 2025 16:37:18 +0800 (CST)
Message-ID: <b8a7a2f7-1abe-492a-97f8-a04985ccc9ba@163.com>
Date: Thu, 9 Jan 2025 16:37:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Amir Goldstein <amir73il@gmail.com>, John Garry <john.g.garry@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAn1tm+in9nkOLOJw--.46063S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3uF45Cr4UXFy7JF4xZF1kXwb_yoWkAF13pF
	WfKanxKa1Dtr1xAw1qyw18X345KrW8JrW7Xr95Gry8Crn0gr1SqF4xtw1j9FyDJrn7X3Wj
	qr4UKFy7uw1UAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UVUDAUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBoRDOnWd+r7yZhwABs3

On 2025/1/8 19:33, Amir Goldstein wrote:
> On Wed, Jan 8, 2025 at 8:43 AM Chi Zhiling <chizhiling@163.com> wrote:
>> On 2025/1/7 20:13, Amir Goldstein wrote:
>>> On Mon, Dec 30, 2024 at 3:43 AM Chi Zhiling <chizhiling@163.com> wrote:
>>>> On 2024/12/29 06:17, Dave Chinner wrote:
>>>>> On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
>>>>>> On 2024/12/27 05:50, Dave Chinner wrote:
>>>>>>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
>>>>>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>>>>>
>>>>>>>> Using an rwsem to protect file data ensures that we can always obtain a
>>>>>>>> completed modification. But due to the lock, we need to wait for the
>>>>>>>> write process to release the rwsem before we can read it, even if we are
>>>>>>>> reading a different region of the file. This could take a lot of time
>>>>>>>> when many processes need to write and read this file.
>>>>>>>>
>>>>>>>> On the other hand, The ext4 filesystem and others do not hold the lock
>>>>>>>> during buffered reading, which make the ext4 have better performance in
>>>>>>>> that case. Therefore, I think it will be fine if we remove the lock in
>>>>>>>> xfs, as most applications can handle this situation.
>>>>>>>
>>>>>>> Nope.
>>>>>>>
>>>>>>> This means that XFS loses high level serialisation of incoming IO
>>>>>>> against operations like truncate, fallocate, pnfs operations, etc.
>>>>>>>
>>>>>>> We've been through this multiple times before; the solution lies in
>>>>>>> doing the work to make buffered writes use shared locking, not
>>>>>>> removing shared locking from buffered reads.
>>>>>>
>>>>>> You mean using shared locking for buffered reads and writes, right?
>>>>>>
>>>>>> I think it's a great idea. In theory, write operations can be performed
>>>>>> simultaneously if they write to different ranges.
>>>>>
>>>>> Even if they overlap, the folio locks will prevent concurrent writes
>>>>> to the same range.
>>>>>
>>>>> Now that we have atomic write support as native functionality (i.e.
>>>>> RWF_ATOMIC), we really should not have to care that much about
>>>>> normal buffered IO being atomic. i.e. if the application wants
>>>>> atomic writes, it can now specify that it wants atomic writes and so
>>>>> we can relax the constraints we have on existing IO...
>>>>
>>>> Yes, I'm not particularly concerned about whether buffered I/O is
>>>> atomic. I'm more concerned about the multithreading performance of
>>>> buffered I/O.
>>>
>>> Hi Chi,
>>>
>>> Sorry for joining late, I was on vacation.
>>> I am very happy that you have taken on this task and your timing is good,
>>> because  John Garry just posted his patches for large atomic writes [1].
>>
>> I'm glad to have you on board. :)
>>
>> I'm not sure if my understanding is correct, but it seems that our
>> discussion is about multithreading safety, while John's patch is about
>> providing power-failure safety, even though both mention atomicity.
>>
> 
> You are right about the *motivation* of John's work.
> But as a by-product of his work, we get an API to opt-in for
> atomic writes and we can piggy back this opt-in API to say
> that whoever wants the legacy behavior can use the new API
> to get both power failure safety and multithreading safety.

Okay, I understand what you mean.

> 
>>>
>>> I need to explain the relation to atomic buffered I/O, because it is not
>>> easy to follow it from the old discussions and also some of the discussions
>>> about the solution were held in-person during LSFMM2024.
>>>
>>> Naturally, your interest is improving multithreading performance of
>>> buffered I/O, so was mine when I first posted this question [2].
>>>
>>> The issue with atomicity of buffered I/O is the xfs has traditionally
>>> provided atomicity of write vs. read (a.k.a no torn writes), which is
>>> not required by POSIX standard (because POSIX was not written with
>>> threads in mind) and is not respected by any other in-tree filesystem.
>>>
>>> It is obvious that the exclusive rw lock for buffered write hurts performance
>>> in the case of mixed read/write on xfs, so the question was - if xfs provides
>>> atomic semantics that portable applications cannot rely on, why bother
>>> providing these atomic semantics at all?
>>
>> Perhaps we can add an option that allows distributions or users to
>> decide whether they need this semantics. I would not hesitate to
>> turn off this semantics on my system when the time comes.
>>
> 
> Yes, we can, but we do not want to do it unless we have to.
> 99% of the users do not want the legacy semantics, so it would
> be better if they get the best performance without having to opt-in to get it.
> 
>>>
>>> Dave's answer to this question was that there are some legacy applications
>>> (database applications IIRC) on production systems that do rely on the fact
>>> that xfs provides this semantics and on the prerequisite that they run on xfs.
>>>
>>> However, it was noted that:
>>> 1. Those application do not require atomicity for any size of IO, they
>>>       typically work in I/O size that is larger than block size (e.g. 16K or 64K)
>>>       and they only require no torn writes for this I/O size
>>> 2. Large folios and iomap can usually provide this semantics via folio lock,
>>>       but application has currently no way of knowing if the semantics are
>>>       provided or not
>>
>> To be honest, it would be best if the folio lock could provide such
>> semantics, as it would not cause any potential problems for the
>> application, and we have hope to achieve concurrent writes.
>>
>> However, I am not sure if this is easy to implement and will not cause
>> other problems.
>>
>>> 3. The upcoming ability of application to opt-in for atomic writes larger
>>>       than fs block size [1] can be used to facilitate the applications that
>>>       want to legacy xfs semantics and avoid the need to enforce the legacy
>>>       semantics all the time for no good reason
>>>
>>> Disclaimer: this is not a standard way to deal with potentially breaking
>>> legacy semantics, because old applications will not usually be rebuilt
>>> to opt-in for the old semantics, but the use case in hand is probably
>>> so specific, of a specific application that relies on xfs specific semantics
>>> that there are currently no objections for trying this solution.
>>>
>>> [1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.garry@oracle.com/
>>> [2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
>>>
>>>>
>>>> Last week, it was mentioned that removing i_rwsem would have some
>>>> impacts on truncate, fallocate, and PNFS operations.
>>>>
>>>> (I'm not familiar with pNFS, so please correct me if I'm wrong.)
>>>
>>> You are not wrong. pNFS uses a "layout lease", which requires
>>> that the blockmap of the file will not be modified while the lease is held.
>>> but I think that block that are not mapped (i.e. holes) can be mapped
>>> while the lease is held.
>>>
>>>>
>>>> My understanding is that the current i_rwsem is used to protect both
>>>> the file's data and its size. Operations like truncate, fallocate,
>>>> and PNFS use i_rwsem because they modify both the file's data and its
>>>> size. So, I'm thinking whether it's possible to use i_rwsem to protect
>>>> only the file's size, without protecting the file's data.
>>>>
>>>
>>> It also protects the file's blockmap, for example, punch hole
>>> does not change the size, but it unmaps blocks from the blockmap,
>>> leading to races that could end up reading stale data from disk
>>> if the lock wasn't taken.
>>>
>>>> So operations that modify the file's size need to be executed
>>>> sequentially. For example, buffered writes to the EOF, fallocate
>>>> operations without the "keep size" requirement, and truncate operations,
>>>> etc, all need to hold an exclusive lock.
>>>>
>>>> Other operations require a shared lock because they only need to access
>>>> the file's size without modifying it.
>>>>
>>>
>>> As far as I understand, exclusive lock is not needed for non-extending
>>> writes, because it is ok to map new blocks.
>>> I guess the need for exclusive lock for extending writes is related to
>>> update of file size, but not 100% sure.
>>> Anyway, exclusive lock on extending write is widely common in other fs,
>>> while exclusive lock for non-extending write is unique to xfs.
>>>
>>>>>
>>>>>> So we should track all the ranges we are reading or writing,
>>>>>> and check whether the new read or write operations can be performed
>>>>>> concurrently with the current operations.
>>>>>
>>>>> That is all discussed in detail in the discussions I linked.
>>>>
>>>> Sorry, I overlooked some details from old discussion last time.
>>>> It seems that you are not satisfied with the effectiveness of
>>>> range locks.
>>>>
>>>
>>> Correct. This solution was taken off the table.
>>>
>>> I hope my explanation was correct and clear.
>>> If anything else is not clear, please feel free to ask.
>>>
>>
>> I think your explanation is very clear.
> 
> One more thing I should mention.
> You do not need to wait for atomic large writes patches to land.
> There is nothing stopping you from implementing the suggested
> solution based on the xfs code already in master (v6.13-rc1),
> which has support for the RWF_ATOMIC flag for writes.
> 
> It just means that the API will not be usable for applications that
> want to do IO larger than block size, but concurrent read/write
                               ^
To be precise, this is the page size, not the block size, right?

> performance of 4K IO could be improved already.

Great, which means that IO operations aligned within a single page
can be executed concurrently, because the folio lock already
provides atomicity guarantees.

If the write does not exceed the boundary of a page, we can
downgrade the iolock to XFS_IOLOCK_SHARED. It seems to be safe
and will not change the current behavior.

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -454,6 +454,11 @@ xfs_file_write_checks(
         if (error)
                 return error;

+       if ( iocb->ki_pos >> PAGE_SHIFT == (iocb->ki_pos + count) >> 
PAGE_SHIFT) {
+               *iolock = XFS_IOLOCK_SHARED;
+       }
+
         /*
          * For changing security info in file_remove_privs() we need 
i_rwsem
          * exclusively.

> 
> It's possible that all you need to do is:
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c488ae26b23d0..2542f15496488 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -777,9 +777,10 @@ xfs_file_buffered_write(
>          ssize_t                 ret;
>          bool                    cleared_space = false;
>          unsigned int            iolock;
> +       bool                    atomic_write = iocb->ki_flags & IOCB_ATOMIC;
> 
>   write_retry:
> -       iolock = XFS_IOLOCK_EXCL;
> +       iolock = atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
>          ret = xfs_ilock_iocb(iocb, iolock);
> --
> 
> xfs_file_write_checks() afterwards already takes care of promoting
> XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.

Yeah, for writes that exceed the PAGE boundary, we can also promote
the lock to XFS_IOLOCK_EXCL. Otherwise, I am concerned that it may
lead to old data being retained in the file.

For example, two processes writing four pages of data to the same area.

process A           process B
--------------------------------
write AA--
<sleep>
                     new write BBBB
write --AA

The final data is BBAA.

> 
> It is possible that XFS_IOLOCK_EXCL could be immediately demoted
> back to XFS_IOLOCK_SHARED for atomic_writes as done in
> xfs_file_dio_write_aligned().
> 



Thanks,
Chi Zhiling

