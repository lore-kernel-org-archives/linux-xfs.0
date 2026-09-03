Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D96A4AFE38;
	Thu,  3 Sep 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443238; cv=none; b=DK9dy2ALsv/oG3gJ6ZQXq+u1mw5MLJE9DFdPxIO+8VmZJTUoBDxeVd8Ouigod8eVDzjz9yg85ET3Df9QsGUFvvGtXCR2/D5GfkYVaaCZLwcCnbsStboprFCwWvfVHagKg0Ma//DvIiuOJPmbt9EqEvxgH7gi+DuYTihIVc3bD+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443238; c=relaxed/simple;
	bh=VB4D2D+LIyigzaxV31yLA9ytUoGxDmOI/6KvHETYMX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PiekFYiMpIBYIl8jBdhj+PE6mN2WJ8iJefQxt8R0RUoYSZ5rzB7UyLMo69W0Prqn2Ju1rz7VeJk3DjOCVvcoCAaVYgh8FBcX1JSGpLEbF8LGyNm7sFauqTEtazMx5R9SEtg84Ei3qXt59xfvKkQRGvpet/JteecSZp1DWSQgoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=XRoVqDL7; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="XRoVqDL7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kuFl+rvMIhi6ut1C9GlGaV8ipseSsDn8WvDAMrSMbkg=;
	b=XRoVqDL7VXST6Vka40uEIvmWLXP9JKZYKKyxRzhUyUgmxjvRlvhtSMS2PYNnDG9Msmb/sb6EN
	MzONpknM5bEqQJHJX8oti+BTvV0tfKHuCgm5mInE3kdHlMZUSpn4QoCV3GtheUCALmAg8t0gQtu
	dsNbqUMM7QhZRliFVt2KjYg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hbLGD68TbzmV8f;
	Thu,  3 Sep 2026 21:36:04 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id BCDFE4057A;
	Thu,  3 Sep 2026 21:46:55 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 21:46:54 +0800
Message-ID: <8b4bfff5-6184-4936-9196-49b34260af66@huawei.com>
Date: Thu, 3 Sep 2026 21:46:52 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
To: Christoph Hellwig <hch@infradead.org>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
 <apgzlDZiLthAD25Q@infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <apgzlDZiLthAD25Q@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/2/2026 10:32 PM, Christoph Hellwig wrote:
> On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
>> index 0a5ebfda90f1..6306ca747f3b 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>>   	 * Writeback from reclaim context should never happen except in the case
>>   	 * of a VM regression so warn about it and refuse to write the data.
>>   	 */
>> -	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
>> -			PF_MEMALLOC))
>> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
> 
> You can drop one set of braces here.  Otherwise this looks good.
> 
Yes, missing it, thanks for your review.

Hi Andrew, I see that you have merged it into mm-new. Could you help fix
it, or I will send a fix patch.
