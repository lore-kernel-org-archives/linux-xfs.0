Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90427E0FF;
	Fri, 12 Jun 2026 07:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248782; cv=none; b=aKzSoRkP+1BIzIe0fHjShDYGjvQAF0t6K9jAX0kmD/TT90mGg1hMgqLoKkAXTt3qF8wCeQofgA7VtTqhz0KcUQKDJC/VLeRbQmnsyxGE4sYH5v7PBK1YzvBoT2MRBYbBo6I7YnKc9yrzkapLMA5xI4yP2xbamluD8qollO7hrDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248782; c=relaxed/simple;
	bh=qNA6AcGOGlZlvLVxCrrl3lImgqAZhQ/35BFlLnfCc0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQfDjLnrqdWf9sVHlFCD7AInBLdqQkmpeucoi99NGhF4eeTP7KO1h/OI6NuQj3Ttj33CK64bLg5BBTKNNScMhOiKmwE9CpeWZUWMJy3itINpDHWMiu5lCLI3OXJaTpol7B3giohH3KLdlhiJ3maHr2ZPu8SjEARm8Hl5FRGAPuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=czRhfndo; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="czRhfndo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781248772; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jQ074OeHnU23SjZznyHVFk9X/huLoQVjQBSjgHjbJk8=;
	b=czRhfndotcBqlwfr0s24hnPlh6bDg3N8Q9+5EpFhSXOABd7Z4xiHrJoj1CkOGSB+CzZwWBwNbImAVUJHhxnL1/IadkjydzT7wb5lkoTiWQk0BGqkPTVROT4kVcrjq9shjTiuJIiWKiaBKvCgyvRwG1Encj068JukQy+VF4mBB5c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4hsroI_1781248770;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4hsroI_1781248770 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 15:19:31 +0800
Message-ID: <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
Date: Fri, 12 Jun 2026 15:19:30 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aiuw0QvFIhEWUPG-@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/12 15:10, Christoph Hellwig wrote:
> On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
>> hmm, currently erofs could return block-sized iomap (if the chunk
>> size is 4k) even it can be merged with the following chunks.
>>
>> Previously it was fairly good since consecutive chunks will be
>> added to the current bio if possible, but after this patch,
>> there will be a lot of 4k bios.
>>
>> But if iomap goes into this way, I could make iomap_begin maps
>> more chunks in one shot, but that needs more changes in erofs,
>> it's fine anyway.
>>
>> ... I was thinking the following diff (space-damaged):
> 
> That should work too for your case.  But we definitively have various
> cases where merging over iomaps is a bad idea.  You'll also end up with
> other efficiency gains by merging consecutive entries, especially for
> direct I/O and when using large folios.

Yes, optimizing erofs chunk mapping would be more
efficient, will work out one soon, but Yifan can test
your patch in parallel.

Also, if "iomap: submit read bio after each extent" is
applied, I guess some merging condition in
iomap_bio_read_folio_range() can be removed since they
won't be reached in any case. (deadcode)

Thanks,
Gao Xiang


