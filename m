Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890B541F5D1
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787753961; cv=none; b=POzZVRfUQEFN+AnKHMQN21sJdIPcTFg8XJHGU6qOAeeUIv47LhxLIM+H9+xiHNcL9+WpyvRlJucvkDaF1w1AuT6OFWSQJf9Q50D4We5PIwANi+R26nR8dQBF+xheWLCo1L4YwuQ6DMDEXfG/yLvXiryOt8WN3yBYu9aH5zPYbDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787753961; c=relaxed/simple;
	bh=BFzrvzHlHAe4/1F+TkJf7+r1fkLn4+kV0pIxSnDCEKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HVLOYj1bAfjHWyTSN7clitfTgC2QkQzQQemaNwe86AK3YM+tG3/4/Cp6Wv+dmii6Nzx5lFTMZs1iilVFN1+fJGbD3RPGYfseEZ1LdpMBbuAGnn9SwzMBtiloVVv5kWyf/EoCeYySqiA7bexWfrDJPFvsW53SPieIdZt3HkfQjFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WGhpE9RH; arc=none smtp.client-ip=95.215.58.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WGhpE9RH"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BFzrvzHlHAe4/1F+TkJf7+r1fkLn4+kV0pIxSnDCEKQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787753956; v=1; x=1788358756;
 b=WGhpE9RHNzWYz8vjamNzy1IE6A29o3CL+lBz8kXJGvrBOEb3pqjAIrC/y91599RI1g2nVRxd
 M3PrarumPq784QLZ3J0EysE5FDh9h/BLn165zHiGc5gTFDjG4f7Ma5P1UyWrS+5X5Grjway9uFx
 XUtoeP9cr/fOZYgPrOeroq0U=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from [192.168.8.140] (87.104.0.147)
	by smtp.migadu.com with ESMTPS id b5317998026f67d0;
	Wed, 26 Aug 2026 14:19:16 +0000
X-Mizu-Trace-ID: b5317998026f67d0
X-Migadu-Flow: FLOW_OUT
Message-ID: <f5510b49-2904-4962-a944-4a1fdb31b7d6@linux.dev>
Date: Wed, 26 Aug 2026 16:19:11 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Alejandro Colomar <alx@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, hch@lst.de, Zhang Yi
 <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
 "Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
References: <20260820090400.857720-1-p.raghav@samsung.com>
 <aomV6Jt7udtAwwcw@devuan>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aomV6Jt7udtAwwcw@devuan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/2026 2:41 PM, Alejandro Colomar wrote:
> Hi Pankaj, Christoph,
> 
>> Date: 2026-08-20 11:04:00+0200
>> From: Pankaj Raghav <p.raghav@samsung.com>
>> Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
> 
> We use the full path in the prefix.  That is, 'man/man2/...: ...'.
> Also, we use regular sentence conventions for the first letter after
> the ':', so s/add/Add/.
> 

Got it.

>> This flag was added to the kernel in v6.17. As of now, only ext4 and
> 
> Please use two spaces after period.
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING.d/patches/description#n44>
> 

Ok!

>> block device nodes support this flag.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> Please include the CC list here too.
> 
>> ---
>> Changes since v1:
>> - Change the phrasing around zeroing and its condition (Zhang Yi)
>> - Update ext4 support only for extent-based files (Zhang Yi)
>>
>> Note:
>> This feature was recently added to XFS and it is expected to land in
>> v7.13. I will update this man page again once v7.13 is released.
>>
>>   man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
>> index ef6586c77..48a8c3468 100644
>> --- a/man/man2/fallocate.2
>> +++ b/man/man2/fallocate.2
>> @@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
>>   .IP \[bu]
>>   Btrfs (since Linux 4.16)
>>   .\" commit f27451f229966874a8793995b8e6b74326d125df
>> +.SS Writing zeroes in file space
>> +Specifying the
>> +.B FALLOC_FL_WRITE_ZEROES
>> +flag (available since Linux 6.17)
>> +.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
>> +in
>> +.I mode
>> +physically zeros space in the byte range starting at
>> +.I offset
>> +and continuing for
>> +.I size
>> +bytes.
>> +Within the specified range,
>> +blocks are preallocated for the regions that span the holes
> 
> What does it mean that "blocks are preallocated"?  That they must be
> allocated prior to this call?  I suspect not.  Otherwise, we'd be saying
> 'must be' instead of 'are'.
> 

I guess preallocate in this context means unmapped blocks where we guarantee
space for an application.

> I suspect it means that this call allocates blocks for those regions,
> but then I'm not sure we want 'pre' there.
> 

You are right. The blocks are allocated when we use FL_WRITE_ZEROES (they should 
be marked as MAPPED). I will change it here. I guess the man pages for util 
linux also needs to be changed[1]. @Zhang Yi, thoughts?

>> +in the file.
>> +After a successful call,
>> +subsequent reads from this range will return zeros and
>> +subsequent writes to that range do not require further
>> +changes to the file mapping metadata.
>> +.P
>> +Zeroing is done within the filesystem.
>> +The filesystem may use a hardware-accelerated zeroing command
>> +or may submit regular writes.
>> +The behavior depends on the filesystem design and the
>> +available hardware.
>> +.P
>> +No other flags may be specified in
>> +.I mode
>> +in conjunction with
>> +.BR FALLOC_FL_WRITE_ZEROES .
>> +.P
>> +Not all filesystems support
>> +.BR FALLOC_FL_WRITE_ZEROES ;
>> +if a filesystem doesn't support the operation, an error is returned.
>> +The operation is supported only in ext4 (only for extent-based files)
>> +since Linux 6.17.
> 
> Christoph, is this correct?  I remember you said something about block
> device nodes in v1.
> 

Even though block devices support some of the FALLOC_FL_* flags, I don't see it 
mentioned here as explicitly supported. That is why I kept it out of the 
changes. Let me know your thoughts.

Thanks for the feedback.

--
Pankaj

[1] https://man7.org/linux/man-pages/man1/fallocate.1.html

