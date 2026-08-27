Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141C374A08;
	Thu, 27 Aug 2026 01:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787794152; cv=none; b=RrxchUS7rlKFTUNFHtF0dGyWrRArrJmXq/hGvoCWF/ZNDkIR90LDpnzraTVRi5y9PdJaz+K2k5wyr+vvw2YUHg0nVPllwcetA+BA2uO+RysV03mADBelFC+iG9OWKU+W52GSL7gSH3DeO3p7fc/AF+/w2+ey1HxcLriPNRy7Mls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787794152; c=relaxed/simple;
	bh=5Z9FjJzipq/5UIxPjJqzkX5gI/83dJFQm2jtms39OY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NBmntEphSn/ZXLXQHPLwZhLeLU/sLfv9wX7JVwQYwfyhBxjw63meNv5nuGadsm0XwCn7vLdilPWE2lnkfmjdzFT4DG8oJ0TvQCvwk/qbqEGsl4I7qhnFq6h3IeZxMM8yg0aJlThi1pEvJJdszNELffJNcjSo2mt2EdMwQ+une6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hVkRr5vsfzYQvJj;
	Thu, 27 Aug 2026 09:28:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id CED6F40986;
	Thu, 27 Aug 2026 09:28:54 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX0kHKko9qyyQzDw--.25945S3;
	Thu, 27 Aug 2026 09:28:52 +0800 (CST)
Message-ID: <3f17d214-f69c-47b6-abf6-4437cc5840c0@huaweicloud.com>
Date: Thu, 27 Aug 2026 09:28:41 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
 Alejandro Colomar <alx@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 gost.dev@samsung.com, "Darrick J . Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org
References: <20260820090400.857720-1-p.raghav@samsung.com>
 <aomV6Jt7udtAwwcw@devuan> <f5510b49-2904-4962-a944-4a1fdb31b7d6@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <f5510b49-2904-4962-a944-4a1fdb31b7d6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCX0kHKko9qyyQzDw--.25945S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4xAr45Jr4kAF1xXr45GFg_yoWrKr45pr
	WYy3Z0kan8Wr13u3sa9w48Wr4Fv3ykJr45ur4SqryUZr9xZF1xKFsrJF1F9FZ7Jr1xAF1j
	vryjqFy7WrnxAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/26/2026 10:19 PM, Pankaj Raghav wrote:
> On 8/22/2026 2:41 PM, Alejandro Colomar wrote:
>> Hi Pankaj, Christoph,
>>
>>> Date: 2026-08-20 11:04:00+0200
>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>> Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
>>
>> We use the full path in the prefix.  That is, 'man/man2/...: ...'.
>> Also, we use regular sentence conventions for the first letter after
>> the ':', so s/add/Add/.
>>
> 
> Got it.
> 
>>> This flag was added to the kernel in v6.17. As of now, only ext4 and
>>
>> Please use two spaces after period.
>> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING.d/patches/description#n44>
>>
> 
> Ok!
> 
>>> block device nodes support this flag.
>>>
>>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>>
>> Please include the CC list here too.
>>
>>> ---
>>> Changes since v1:
>>> - Change the phrasing around zeroing and its condition (Zhang Yi)
>>> - Update ext4 support only for extent-based files (Zhang Yi)
>>>
>>> Note:
>>> This feature was recently added to XFS and it is expected to land in
>>> v7.13. I will update this man page again once v7.13 is released.
>>>
>>>   man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 38 insertions(+)
>>>
>>> diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
>>> index ef6586c77..48a8c3468 100644
>>> --- a/man/man2/fallocate.2
>>> +++ b/man/man2/fallocate.2
>>> @@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
>>>   .IP \[bu]
>>>   Btrfs (since Linux 4.16)
>>>   .\" commit f27451f229966874a8793995b8e6b74326d125df
>>> +.SS Writing zeroes in file space
>>> +Specifying the
>>> +.B FALLOC_FL_WRITE_ZEROES
>>> +flag (available since Linux 6.17)
>>> +.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
>>> +in
>>> +.I mode
>>> +physically zeros space in the byte range starting at
>>> +.I offset
>>> +and continuing for
>>> +.I size
>>> +bytes.
>>> +Within the specified range,
>>> +blocks are preallocated for the regions that span the holes
>>
>> What does it mean that "blocks are preallocated"?  That they must be
>> allocated prior to this call?  I suspect not.  Otherwise, we'd be saying
>> 'must be' instead of 'are'.
>>
> 
> I guess preallocate in this context means unmapped blocks where we guarantee
> space for an application.
> 
>> I suspect it means that this call allocates blocks for those regions,
>> but then I'm not sure we want 'pre' there.
>>
> 
> You are right. The blocks are allocated when we use FL_WRITE_ZEROES (they should be marked as MAPPED). I will change it here. I guess the man pages for util linux also needs to be changed[1]. @Zhang Yi, thoughts?

I personally understand the 'pre' in FL_WRITE_ZEROES to mean that
users are calling this interface to pre-allocate filesystem blocks
before they actually start writing data, rather than having blocks
allocated on the fly during actual writes. That said, I don't think
pre-allocated necessarily implies that the blocks must be UNMAPPED. In
my view, UNMAPPED allocations can be considered a form of pre-allocation,
but MAPPED ones could also be seen that way, since at the time the user
calls this interface, they haven't yet written any real data and are
just preparing the blocks in advance. From a user's perspective, both
cases can be understood as pre-allocation.

That's just my take on it, though. It's fine by me to change it to
allocated as well.

Thanks,
Yi.

> 
>>> +in the file.
>>> +After a successful call,
>>> +subsequent reads from this range will return zeros and
>>> +subsequent writes to that range do not require further
>>> +changes to the file mapping metadata.
>>> +.P
>>> +Zeroing is done within the filesystem.
>>> +The filesystem may use a hardware-accelerated zeroing command
>>> +or may submit regular writes.
>>> +The behavior depends on the filesystem design and the
>>> +available hardware.
>>> +.P
>>> +No other flags may be specified in
>>> +.I mode
>>> +in conjunction with
>>> +.BR FALLOC_FL_WRITE_ZEROES .
>>> +.P
>>> +Not all filesystems support
>>> +.BR FALLOC_FL_WRITE_ZEROES ;
>>> +if a filesystem doesn't support the operation, an error is returned.
>>> +The operation is supported only in ext4 (only for extent-based files)
>>> +since Linux 6.17.
>>
>> Christoph, is this correct?  I remember you said something about block
>> device nodes in v1.
>>
> 
> Even though block devices support some of the FALLOC_FL_* flags, I don't see it mentioned here as explicitly supported. That is why I kept it out of the changes. Let me know your thoughts.
> 
> Thanks for the feedback.
> 
> -- 
> Pankaj
> 
> [1] https://man7.org/linux/man-pages/man1/fallocate.1.html

