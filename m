Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA27113B7A3
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453248; cv=none; b=aOvaM93jau0DELUXL6giUppKV1iR9yUVlM3FHXvg52DFyBj4aFVGJBSPjskYm5nfBt22Pyu6I/vWacnNGKjaRqG/1exKctBxKS2/2kC9Ntequ+9/6xQJt91ofOdVVgWb8jjQfhaxGB9PFQ4R/jk00WKsZyffkaUAp8DWyOBqiDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453248; c=relaxed/simple;
	bh=aY9Pc65V9gEl7WDsLdL9Gc23C4yD1e61EAsgZ3L/6cM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5HCsxGbUodoRV6ALVzkoAOl/nXVknSbni8xhAcVunaYgoNUOzBa1xaNHAV8geU81pEq+GnZBpLOo7+LJ2YVQgcuiphX4txUYfjk+bbLzaq5dZD452KLkBk9g3P+9nK1OuJ9uRmWxxt0iotia1mjCmEc1nv+TJ4N7FxK2Tlesdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ppbwTKdi; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ppbwTKdi"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BD4D31164F;
	Mon,  8 Jul 2024 10:40:38 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net BD4D31164F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1720453238;
	bh=GtdZZ1k/6e7EBvkHU/jaYxE3tY+rhPRfQFM5TRnpVXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ppbwTKdiVXSQjTJfV0EOPxcXfFDsX55o1wlJFrCHYUcVwduRTNFFobOq4+AcJpSRf
	 qtxqLpZMbxJaiyWKzU2VYaKeWDoxbxGvljir6QxSeDyLBxXfxLqus0d2Lhb47V+HC1
	 C9QPMHdmbxjbBQv+xFiO1noCTZswx+6+INnZniOfPS0ZH7yQYYxsXK+qP1ZngtL56y
	 P6gcuRWu/LQmqCGOeHNzTL9XHeVEsOGFYymQPfnkLOQCt0knSa0S7FyDjeem1bLBGZ
	 BtFW+CW2xNmziuZU94NAJzvsd6rOyHiqbFvapRvg2cyYsWBLl26wVwkGuxeZki8GBm
	 GdSWOlnSQfmPQ==
Message-ID: <5ce25a1a-51d7-4cf3-a118-91eeeefe29a4@sandeen.net>
Date: Mon, 8 Jul 2024 10:40:37 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
To: "Darrick J. Wong" <djwong@kernel.org>, Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
 <20240624160342.GP3058325@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240624160342.GP3058325@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/24 11:03 AM, Darrick J. Wong wrote:
> On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
>> xfs_attr_shortform_list() only called from a non-transactional context, it
>> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
>> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
>> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
>> false positives by use __GFP_NOLOCKDEP to alloc memory
>> in xfs_attr_shortform_list().
>>
>> [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
>> Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
>> Signed-off-by: Long Li <leo.lilong@huawei.com>
>> ---
>>  fs/xfs/xfs_attr_list.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 5c947e5ce8b8..8cd6088e6190 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
>>  	 * It didn't all fit, so we have to sort everything on hashval.
>>  	 */
>>  	sbsize = sf->count * sizeof(*sbuf);
>> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
>> +	sbp = sbuf = kmalloc(sbsize,
>> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> 
> Why wouldn't we memalloc_nofs_save any time we take an ILOCK when we're
> not in transaction context?  Surely you'd want to NOFS /any/ allocation
> when the ILOCK is held, right?

I'm not sure I understand this. AFAICT, this is indeed a false positive, and can
be fixed by applying exactly the same pattern used elsewhere in
94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")

Using memalloc_nofs_save implies that this really /would/ deadlock without
GFP_NOFS, right? Is that the case?

I was under the impression that this was simply a missed callsite in 94a69db2367e
and as Long Li points out, other allocations under xfs_attr_list_ilocked()
use the exact same (GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL) pattern
proposed in this change.

Thanks,
-Eric
