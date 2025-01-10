Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9FF539A;
	Fri, 10 Jan 2025 01:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736472704; cv=none; b=ZPAzq4nnogCR1MXppFF1cZEcgjC+7k8xrbO83Uf736JkhgNrEOtIL3VYf1TYSYwOthm3oZm3GLi4vQULeT7L+m+RZXvTCF4sLi7UYdNn30m+cZW9tQRyUMq5VMXsUdofbdy1e6/RTJgCX4hwg73/E5U/ASlPyaDQnMthcRkOpN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736472704; c=relaxed/simple;
	bh=PJ/UQTww4Aoje9WBglDt2GuU/WReBtIDpPSASFLo0go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FL2JArcTpUDyDJD8YOdEBbXdxKCNHXPl5VQILcGwAaqJQYqa3ECTcGS2omgqaH3B5WR+qpaW5Fbu78gsU6ivAVDek8jQeTNCTBc5pxQNjbyb+mr0MjjtcJgUyjf84JGFLRNb+Sv+gp1EfIGLcYtJfRil5hln8WD4eophZaBfBy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PHJBVOkz; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PHJBVOkz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=8yIMSQMgUDgrb+MmXgSIyfbZ5jHhO7lD9hVirz8NSGE=;
	b=PHJBVOkzUfvgByE3MRfX6GfRDHldxsXYkR9P0SQXfgmNHz6VQoKy9Xi0F24gtl
	Zd8uMvjQ06uCeuQXd6ZmLyJ62RpQKDHVYIKvFg+nZPs3UO1f/6VxrFzAM4Xc6s4G
	AQuJPJiYXgB8IlpQIKr5HOR1cmupGTUeGUOmIVNEMO9lk=
Received: from [10.42.12.6] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCHMrJqeIBndOsZEQ--.40178S2;
	Fri, 10 Jan 2025 09:31:24 +0800 (CST)
Message-ID: <fcc1ce0b-7d6b-4d4a-8ef3-da83c4c4eb7d@163.com>
Date: Fri, 10 Jan 2025 09:31:22 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PygvCgCHMrJqeIBndOsZEQ--.40178S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF45Gw1kXr4UGr1DAr1rXrb_yoWrCF4kpr
	W3KFZ8KFs7tr1xZwnFvr18Xw1rK3s3Xw47JFWFgrykuFn8Gr1SqF40q3WY9aykZr4xXr1j
	v3yqvFy3uF1YvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UseOXUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawDQnWeAbUD3-QAAsm

On 2025/1/10 07:28, Dave Chinner wrote:
> On Wed, Jan 08, 2025 at 09:35:47AM -0800, Darrick J. Wong wrote:
>> On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
>>> On 2025/1/7 20:13, Amir Goldstein wrote:
>>>> Dave's answer to this question was that there are some legacy applications
>>>> (database applications IIRC) on production systems that do rely on the fact
>>>> that xfs provides this semantics and on the prerequisite that they run on xfs.
>>>>
>>>> However, it was noted that:
>>>> 1. Those application do not require atomicity for any size of IO, they
>>>>       typically work in I/O size that is larger than block size (e.g. 16K or 64K)
>>>>       and they only require no torn writes for this I/O size
>>>> 2. Large folios and iomap can usually provide this semantics via folio lock,
>>>>       but application has currently no way of knowing if the semantics are
>>>>       provided or not
>>>
>>> To be honest, it would be best if the folio lock could provide such
>>> semantics, as it would not cause any potential problems for the
>>> application, and we have hope to achieve concurrent writes.
>>>
>>> However, I am not sure if this is easy to implement and will not cause
>>> other problems.
>>
>> Assuming we're not abandoning POSIX "Thread Interactions with Regular
>> File Operations", you can't use the folio lock for coordination, for
>> several reasons:
>>
>> a) Apps can't directly control the size of the folio in the page cache
>>
>> b) The folio size can (theoretically) change underneath the program at
>> any time (reclaim can take your large folio and the next read gets a
>> smaller folio)
>>
>> c) If your write crosses folios, you've just crossed a synchronization
>> boundary and all bets are off, though all the other filesystems behave
>> this way and there seem not to be complaints
>>
>> d) If you try to "guarantee" folio granularity by messing with min/max
>> folio size, you run the risk of ENOMEM if the base pages get fragmented
>>
>> I think that's why Dave suggested range locks as the correct solution to
>> this; though it is a pity that so far nobody has come up with a
>> performant implementation.
> 
> Yes, that's a fair summary of the situation.
> 
> That said, I just had a left-field idea for a quasi-range lock
> that may allow random writes to run concurrently and atomically
> with reads.
> 
> Essentially, we add an unsigned long to the inode, and use it as a
> lock bitmap. That gives up to 64 "lock segments" for the buffered
> write. We may also need a "segment size" variable....
> 
> The existing i_rwsem gets taken shared unless it is an extending
> write.
> 
> For a non-extending write, we then do an offset->segment translation
> and lock that bit in the bit mask. If it's already locked, we wait
> on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.
> 
> The segments are evenly sized - say a minimum of 64kB each, but when
> EOF is extended or truncated (which is done with the i_rwsem held
> exclusive) the segment size is rescaled. As nothing can hold bit
> locks while the i_rwsem is held exclusive, this will not race with
> anything.
> 
> If we are doing an extending write, we take the i_rwsem shared
> first, then check if the extension will rescale the locks. If lock
> rescaling is needed, we have to take the i_rwsem exclusive to do the
> EOF extension. Otherwise, the bit lock that covers EOF will
> serialise file extensions so it can be done under a shared i_rwsem
> safely.
> 
> This will allow buffered writes to remain atomic w.r.t. each other,
> and potentially allow buffered reads to wait on writes to the same
> segment and so potentially provide buffered read vs buffered write
> atomicity as well.
> 
> If we need more concurrency than an unsigned long worth of bits for
> buffered writes, then maybe we can enlarge the bitmap further.
> 
> I suspect this can be extended to direct IO in a similar way to
> buffered reads, and that then opens up the possibility of truncate
> and fallocate() being able to use the bitmap for range exclusion,
> too.
> 
> The overhead is likely minimal - setting and clearing bits in a
> bitmap, as opposed to tracking ranges in a tree structure....
> 
> Thoughts?

I think it's fine. Additionally, even if multiple writes occur
in the same segment, if the write operations are within a single
page, we can still acquire the i_rwsem lock in shared mode,
right?

