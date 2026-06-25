Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506E73254B0;
	Thu, 25 Jun 2026 13:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393704; cv=none; b=gJ3a8b8G8UiWa9r3UiZ/E2vWI2UZNnYlVis6gRn56XzCP2Lx53BtT+aSiPtWheSzjFrHq3ilAIPRMJABirw8eRa6z0tXIUOZtUmxlfVTb0CtKBfFm6G519vTWnzuu/d9dtwd//x0we9PYyQ0BMgQP+Sw9R6Zgelmsrx38u+KaW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393704; c=relaxed/simple;
	bh=ZZWP0RQ6thB6c1KDQx9h67xh1diITwJXcdbbY95J5vw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JDMRte0hT9JsYe8CKH8Lf1ojltLU71ThCdAXBHQb7fpSxNkM8JgSywGWEnRjh0ayEcKTmDtZSRqGI0o7LIxmQReVbCOwLmBF2WfRX3nMD37OVzdc0LYffitTvPwf10gA1849+1RYCpEnBPdriFfw4SafoaEmyX6xgs8AY/xSCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Be46Soy+; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Be46Soy+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782393698; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GRdL109HStGH3sJC79+Zwf20Y+gZgeZfBmT1pdhSXno=;
	b=Be46Soy+C6Fok8ikPKtVJNe3mjYJYDmE85a+M7wR81FN8kX54E5a3Hnf5Z6C8MvV7dlsSeoQ6DP/sndibPloSqcHpR4xDElUtRRnJ6vn4/MPXL7ibmAcbxA+Zf+htOqINyVHaJ0OkSj80Ypvo9PihxLRvbj/XdIGO7fXiu791IU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5beFXO_1782393697;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5beFXO_1782393697 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Jun 2026 21:21:37 +0800
Message-ID: <4da9a5ac-2a53-4fe2-9283-2e0f6181c248@linux.alibaba.com>
Date: Thu, 25 Jun 2026 21:21:36 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, willy@infradead.org,
 djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
 <20260625130206.GC22620@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260625130206.GC22620@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/25 21:02, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 11:25:54AM +0800, Gao Xiang wrote:
>> As I mentioned a year ago, I really hope this way can be proceed
>> to avoid iomap iter-callback models:
>>
>> https://lore.kernel.org/r/20250905152118.GE1587915@frogsfrogsfrogs
> 
> Oh, I guess this is where passing the iomap and srcmap separately
> from the iter come from.  But for this to make sense we'd have to
> be able to pass a const iter.

... anyway, I hope iomap folks could consider my humble
suggestion, since I'm afraid that this callback model in
the long term won't scale well in very slightly different
details (along with more and more iomap users), so rather
than just converting more callers, I guess it might be
better to consider non-callback model as a direction
anyway.

Thanks,
Gao Xiang
