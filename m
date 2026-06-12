Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34903D648A;
	Fri, 12 Jun 2026 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781249752; cv=none; b=kXZ0sZv7ZMf40AnqwGn8fyuLcTGLP4JqJITw/gIlibDZBzVu7SCIKmCyEDjPGddP/XlfXbuIxOVHotceBC+3yVSI6VAuXkO1wFuahRhET3vWIVgFOn6lL0ZMIXAnf4okEh7eSqHK2hdS6sNHAiz6wMkxF7CUym69GXXNy+48Wvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781249752; c=relaxed/simple;
	bh=bFJfS17E/gkYLeQy0LqRep5GAU5HcAdM0bmDPYun4sI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dDgBh05Aj41QcCal/w+ybT/oBfgHXSjRlhCjVmH7AeRoE2QlvfuhjfFEtgLhq1MvmYKeE/ckVrNblLcbBKSWwEbp7BZSrNNrPAzwTrD0TK8W+xtMTizj7XpiB2WYSJRFjX1iLQVf7uyCtj5C9fRWTOaQJiIu0zWaboHD4NSjk3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VrmsHjm1; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VrmsHjm1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781249740; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=CbovmRFDrsE9EQljGf9/0JLd+m27nru3C9VQHKwKRgc=;
	b=VrmsHjm1i6VMWGC4rTee7iEpVj5Afzwts3bXUxnVnRaEuR4o8P9wR3uBfrWZKloejbV4sBjA+unvsTcToowjNmn8SwdU3EmFDVGN1Yqgl9cLcWDQ/B6uBIFCCyseiyHSNRiLWrGnJPD6uCqARjWZGYb/GD1sFlExFwwn321VtWQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4hsbzz_1781249739;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4hsbzz_1781249739 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 15:35:39 +0800
Message-ID: <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
Date: Fri, 12 Jun 2026 15:35:38 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
In-Reply-To: <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/12 15:19, Gao Xiang wrote:
> 
> 
> On 2026/6/12 15:10, Christoph Hellwig wrote:
>> On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
>>> hmm, currently erofs could return block-sized iomap (if the chunk
>>> size is 4k) even it can be merged with the following chunks.
>>>
>>> Previously it was fairly good since consecutive chunks will be
>>> added to the current bio if possible, but after this patch,
>>> there will be a lot of 4k bios.
>>>
>>> But if iomap goes into this way, I could make iomap_begin maps
>>> more chunks in one shot, but that needs more changes in erofs,
>>> it's fine anyway.
>>>
>>> ... I was thinking the following diff (space-damaged):
>>
>> That should work too for your case.  But we definitively have various
>> cases where merging over iomaps is a bad idea.  You'll also end up with
>> other efficiency gains by merging consecutive entries, especially for
>> direct I/O and when using large folios.
> 
> Yes, optimizing erofs chunk mapping would be more
> efficient, will work out one soon, but Yifan can test
> your patch in parallel.
> 
> Also, if "iomap: submit read bio after each extent" is
> applied, I guess some merging condition in
> iomap_bio_read_folio_range() can be removed since they
> won't be reached in any case. (deadcode)

btw, there may be be some edge cases like:
written | hole | written | hole | written ...

and if bios cannot across multiple iomaps, bios could be
amplified according to the shuffle pattern even all written
data is consecutive on disk (the block allocator may
allocate written blocks consecutively.)

Anyway, I never tried to argue with this cases (yet both
previous buffer-head and mpage codebase will merge this
except for some specific exceptions), maybe it's just a
pure artificial pattern and I'm worried too much.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> 

