Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F238429CEE
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 09:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463677; cv=none; b=u1IxHluXNLmHa1pR9iMgcRKxWchTrjY/PmFeteTvxcm6uqUSrwLiPwrd0c5N8rukZMr4wfr2iqLzkZFKJ6FhaSFnivI4F5qu6n0o3atXHGpAu7bPlePUzjRrpQB5iDRxCHez/LXtl0Y9UgBLM6bu0jrZ3oF+kwJ7YHSQ2eOIZ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463677; c=relaxed/simple;
	bh=0n6AdGVS5P+eF2ga1YxPl4XDc/wekF1pE10Og/Yd7Ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kQIxRSa2XqOvq6TsPI/DIZJTOwNZDl9Av4YtBvuYhHhGSxHOLz0nY6AK2L63Dkyt6QBHIZt/qgd9xezh+CmV6B1F3Owdp2mdz2C9uuhoHFj5mdHkoxcKzlAOUNAOaB61FYiAe+235DQjCM5e9BF/PSlb+5MoQNcrtElMrmSb7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=EV+8MFXt; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="EV+8MFXt"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J2zW61WVOZY4rw4igsUliAvDl4bDTDdHAiPPtHE50lg=;
	b=EV+8MFXtwxVxBXnTTXaeylroocrOm9CRKtWyuSRTHpJqwzGGfbhaq77xBnpfuNR42ajww03ec
	ZtjUpemjdnI0v4CEqK2Tp6OF8+CfoHHUX0DG2Giw/jlbpriQigy8Xb6I49WWJ1zvRcyuel17JhW
	ezhG1uatEvLjRlGZR9WI5HI=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hkbdG36TMz1T4Fq;
	Tue, 15 Sep 2026 17:02:42 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 72D6C40579;
	Tue, 15 Sep 2026 17:14:22 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 15 Sep 2026 17:14:20 +0800
Message-ID: <954e1e73-3507-442c-aa95-569dd2e908a8@huawei.com>
Date: Tue, 15 Sep 2026 17:14:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/2] xfs: fix NOFS state corruption in btree split
 worker
To: Carlos Maiolino <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>,
	Dave Chinner <dchinner@redhat.com>
References: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
 <aqkIetDJZa56Qvx_@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqkIetDJZa56Qvx_@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/15/2026 4:58 PM, Carlos Maiolino wrote:
> On Fri, Sep 11, 2026 at 06:42:25PM +0800, Kefeng Wang wrote:
>> xfs_trans_set_context() overwrites tp->t_pflags, dropping the
>> caller's NOFS protection. Replace it with local
>> memalloc_nofs_save()/restore() to fix it, also drop the obsolete
>> kswapd flag inheritance, which simplifying the fix.
>>
>> Note:
>> - rebased on v7.3-rc2
>> - Add ACK/RB
>> - split the patches, suggested by Christoph Hellwig[1]
> 
>> [1] https://lore.kernel.org/linux-mm/aqOp035i41XIrDXg@infradead.org/
> 
> Can you please give me some more context on why are you resending it? I
> received an email from Andrew that he had pulled this patch already from
> the previous series.
> You were Cc'ed on the email so I'm assuming you didn't see it?
> 

Andrew only merged the dead kswapd flags part without the important
bugfix. as Christoph said in above link[1], he suggest me send a
standalone series that we can get the bugfix into 7.3 and -stable with
as few dependencies as possible. So I rebase on v7.3-rc2 and resend
them. If I misunderstood, please correct me.


>>
>> Kefeng Wang (2):
>>    xfs: remove dead kswapd flag inheritance from btree split worker
>>    xfs: fix NOFS state corruption in btree split worker
>>
>>   fs/xfs/libxfs/xfs_btree.c | 22 ++++++----------------
>>   fs/xfs/xfs_platform.h     |  4 ----
>>   2 files changed, 6 insertions(+), 20 deletions(-)
>>
>> -- 
>> 2.55.0

