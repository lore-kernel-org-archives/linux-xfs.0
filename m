Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F42C3259;
	Thu, 25 Jun 2026 03:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782357967; cv=none; b=fEw3KPnjFdl6frofbPxc8AfZhNy8r6ahIiPXuJAhvTgqFqw33yqK4Zi2vzrtwdx5aGQiCu3EXACo462ChMHyeJFZOoClc3Gru3JmfEVHg2lE4JNQCI+QYjZLUq/ihTsX9TLBSEWeZhT2nARb0RU2XHdyENLnk1VT5VyuYfIAe50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782357967; c=relaxed/simple;
	bh=DdSaW6I81upshqjCohK595iX8L7RUI6EQvQjMEbUniA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTsjIN/T6zzNtiIzLca1D0J8UNvtwT3Rk0oEvXFOwBZ22gmNCSgrAWb/vGVcqIkQYpOqHvW2mSlni8yGhSEfu5UEBeWWwpbjr7v2btTN5OsvxoMubmzsSjRoIlaT878wfRnpfskgvoMFHbdyYpOWtrpA9/+SJCao0BudB9LPSTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=M1Un2UKv; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="M1Un2UKv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782357956; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8MpM7JNbyYo7T3td4OKJBAoT5jQ9NBaK7W2q0i0GGl4=;
	b=M1Un2UKvmjyTt4HUeiH3T/X1PJcKvZwHQgXWXv41m2q1gM5F/8nDEaiMJdTf7ZCXVfi/wdt8WJK1n9Tpwl1Mnrm0FdoorQSnc0DYeazHswwh14f/EiBxBLSIfU4en20ghDWIriOjCwIIu7hqNmCOC5FQ8XJArBLPCog2U8/gMfs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5a-g4C_1782357954;
Received: from 30.221.130.45(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5a-g4C_1782357954 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Jun 2026 11:25:55 +0800
Message-ID: <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
Date: Thu, 25 Jun 2026 11:25:54 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
To: Joanne Koong <joannelkoong@gmail.com>, hch@lst.de, willy@infradead.org,
 djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260625024723.1611000-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/25 10:47, Joanne Koong wrote:
> This is submitted to get some feedback on what converting to an in-iter
> ->iomap_next() model would look like. It revives Matthew's previous RFC [1],
> which had the same goal.
> 
> The series merges ->iomap_begin()/->iomap_end() into a single ->iomap_next()
> callback (patches 1-2) and shows an example of devirtualizing the callbacks on
> a hot path so the indirect call through struct iomap_ops is avoided (patch 3).
> This series is on top of vfs.all (commit e7a6d06e3c3e8).
> 
> A few questions:
> * is this roughly the in-iter direction you had in mind?
> * is removing the indirect call still worth it? My understanding is that
>    indirect calls are cheap on modern eIBRS hardware and the conversion adds
>    some per-filesystem boilerplate, so I'm unsure if it carries its weight. If
>    not, do you think the in-iter model is still worth having on its own?


As I mentioned a year ago, I really hope this way can be proceed
to avoid iomap iter-callback models:

https://lore.kernel.org/r/20250905152118.GE1587915@frogsfrogsfrogs

And in that way, iomap can be more flexible as a fs IO library.

Thanks,
Gao Xiang

> 
> Thanks,
> Joanne
> 
> [1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u
