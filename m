Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9563E1D0B;
	Fri, 11 Sep 2026 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123869; cv=none; b=ey38mFII9I8NUQrb6D6IB9MUPEUcWo+Gxw8s42COHbufFwVjsD/aKz7FAo2hsA3HiSAWPnZdy1X+5yjJX8v/riTcJOBbViVk9vu1rcYDWPz75UlaN8CpL3HJvj2QPPxj8IWUbSNCNHeqLLTYnfya/dUuHkBgSNNMw/zsDMSQzWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123869; c=relaxed/simple;
	bh=kkZvIZshRYmJYWWocAIP8fWh5J1GHpiPuZueNICKsoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nxj+YNx7CwgNC8WMsg6JD2s7wI/7mUJeyIf3W8GNHAWRyJe5/ozMImOm1y1C35haco9qJPxO6XWn10XJCEUV5m3up621DmvYoK+bNWM/jOyMhZt06B6TVsxwRE5MPU+w1D/lrHdmGYNvBcMw+L9MbTvpRs6wQmSglDQwaXxlvqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AIz7jU+N; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AIz7jU+N"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YNIARwvAoaD587kn8kLvRjpjKEQ+aDSYPufdVCROqUQ=;
	b=AIz7jU+N0TKZGvyxZmpvRaHfK9ACzUFrPcPQzf4wOuWlMI2yC9QrgixQZJVyBB4sqnpDo4EFo
	AWZFQYN54yHyznl9+IQKrUxEBy4eo1u8JpDd9DY+Gucla3YzXvz5c1gaj6geiJT6MABM5Myn27x
	OaFLo60/KYV1AvK2D9DAzLs=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hh9zX1WG2z1K9B2;
	Fri, 11 Sep 2026 18:40:08 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id F083640578;
	Fri, 11 Sep 2026 18:51:03 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:51:02 +0800
Message-ID: <b430989d-a146-4db7-ba82-21c5b5e04f11@huawei.com>
Date: Fri, 11 Sep 2026 18:51:01 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
To: Christoph Hellwig <hch@infradead.org>
CC: Brian Foster <bfoster@redhat.com>, <brauner@kernel.org>,
	<djwong@kernel.org>, <cem@kernel.org>, <akpm@linux-foundation.org>,
	<vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux MM
	<linux-mm@kvack.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster> <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
 <aqOp035i41XIrDXg@infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqOp035i41XIrDXg@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/11/2026 3:12 PM, Christoph Hellwig wrote:
> On Fri, Sep 11, 2026 at 08:57:53AM +0800, Kefeng Wang wrote:
>> Another question is the target repository for merging this patch.
>> Both this patch and the previous bug fix are based on the mm-new
>> branch. Merging into xfs separately (if an independent branch exists) might
>> cause conflicts.
> 
> Your first follow up fixes a xfs bug that can have somewhat nasty
> consequences.  So I'd suggest you send us a standalone series that
> we can get into 7.3 and -stable with as few dependencies as possible.
> mm-new can get rebased on top of that, and then we can delay the pure
> cleanups for xfs until after that is merged


Thank you for your suggestion. I rebase on v7.3-rc2 and resend them.
https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/T/#t

