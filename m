Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2E20E702;
	Thu, 25 Jun 2026 03:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358633; cv=none; b=iRw72ikHERfRKIBNnSAAxldPJnj7AzEo8bNakMxm9ELgqmbMpgkd0hOTMbcrv+ppZcoxXgJczev3o3H6JacoEcPdc2JrDuLk0Sqi2z1Xsobv0yu5kpH6dIupkBLrkk2O7j00v5Clb8cy4bA/MYjtuu2jIqguaiv1BshTOoNP5gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358633; c=relaxed/simple;
	bh=04D1KDuaKBKsn+0wDWmt4G6BRiFLlHAoh32DWMX9hi4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KdQVQTUxbwIzS0fLSFmUiTHlXrBgxrykA5cX++Glhu//zCHZdRY6w8Qdl3Vbs1UHuPHIACvAM7cechNt17VYTrTL8rC98gqsI58JAdv+CkhMQLI5RGc9mMCRi6EGJ0wiJAP6DtPJVd9P9JguMCgVspk8IQWeebZNY+JuwmJuXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GnxmF/1e; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GnxmF/1e"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782358627; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=vJy2emAttYdxh6ktctykJOVSUN93KNEJT3ldcbOBvDA=;
	b=GnxmF/1e/SSsJyR/3VHhornRSNMpSsY1lKtLT/znUKQg4WLbBbWDLti1rx+L7V69vW7w/SS6j04Dzs2P4PhD/f1HZO2qYUQglG2WviMoIdpJayZzdxPcJOzLmq1CF3aZpXPd1xgZNeV778iLMXzWsKmGCfxO3Xj87ZaJSXs/79M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5a26FL_1782358625;
Received: from 30.221.130.45(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5a26FL_1782358625 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Jun 2026 11:37:06 +0800
Message-ID: <b37bbe74-05d3-49f5-8168-620339b74bb8@linux.alibaba.com>
Date: Thu, 25 Jun 2026 11:37:05 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Joanne Koong <joannelkoong@gmail.com>, hch@lst.de, willy@infradead.org,
 djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
In-Reply-To: <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/25 11:25, Gao Xiang wrote:
> 
> 
> On 2026/6/25 10:47, Joanne Koong wrote:
>> This is submitted to get some feedback on what converting to an in-iter
>> ->iomap_next() model would look like. It revives Matthew's previous RFC [1],
>> which had the same goal.
>>
>> The series merges ->iomap_begin()/->iomap_end() into a single ->iomap_next()
>> callback (patches 1-2) and shows an example of devirtualizing the callbacks on
>> a hot path so the indirect call through struct iomap_ops is avoided (patch 3).
>> This series is on top of vfs.all (commit e7a6d06e3c3e8).
>>
>> A few questions:
>> * is this roughly the in-iter direction you had in mind?
>> * is removing the indirect call still worth it? My understanding is that
>>    indirect calls are cheap on modern eIBRS hardware and the conversion adds
>>    some per-filesystem boilerplate, so I'm unsure if it carries its weight. If
>>    not, do you think the in-iter model is still worth having on its own?
> 
> 
> As I mentioned a year ago, I really hope this way can be proceed
> to avoid iomap iter-callback models:
> 
> https://lore.kernel.org/r/20250905152118.GE1587915@frogsfrogsfrogs
> 
> And in that way, iomap can be more flexible as a fs IO library.

IMHO, hhe main point is not to avoid the indirect call to make it
noticeably faster or to avoid security issues due to
Spectre/Meltdown/...

It just gives more flexibility to specific filesystems to control
the IO path better (since each filesystem might have its own
slightly different IO flow), rather than adding various flags/code
in the iomap core itself to fulfill the current callback model.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>> Joanne
>>
>> [1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u

