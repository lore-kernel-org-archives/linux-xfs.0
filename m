Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B1A17A586;
	Fri, 11 Sep 2026 00:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789088289; cv=none; b=uT2ne6w2hRbV0ij7gBdgbmZVHtlyfnnf7Dx0xelMh0XKxdbHW1d8H8c9GQee2DsJkKInDMLomISN1qOyBv45iXce51yHM4U+Ko93Ey/fNn2Udobbes3c876gjO8wrZUk2p7QkArm8ViH87IY3rZR7eiQVB/vnbT2nWVTy1ZNCMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789088289; c=relaxed/simple;
	bh=yKRaBflyg+L2oIiSnsCVIfcGth/aWHUyPXksJV+XyAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LHZfTddzBfvbk6fvgWS/eQHfBsLauQ+rV0mxD+Am4hQCUS5GYZui01vh5Xr8PAymm4vORkQmaAD4vBssy9inTWYFkVFJGCop0l+78t2emnia5lY94YeEVUWou9KBMUpP0YjtnvTRHxP60rEH6WDNSl/pn49F8dm3JD9zJxl3Fng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oJ8nYRlU; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oJ8nYRlU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=06ewrVmtpiUthW0f0X+LeH7QcawiHpWQIKkhx26qBG4=;
	b=oJ8nYRlUe0gbBczxWto/aUXlXyWSDiEjP/Mf743T2ujLnGFToOXhADQtS5kDyjj6qYd002ERB
	JMPiNcP7oElOizkrrypqA8tIlk077fMEj/x4k7Dh1dh9iG2Puu8vd9Wqt7VQSgF//LBM/D+N3PR
	ADwJzBiCpYdFOtsCtfve/5g=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hgwq84sgdzLlX5;
	Fri, 11 Sep 2026 08:47:00 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C2254056C;
	Fri, 11 Sep 2026 08:57:56 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 08:57:54 +0800
Message-ID: <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
Date: Fri, 11 Sep 2026 08:57:53 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux MM
	<linux-mm@kvack.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqLqeTsbKBMEsl-G@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)

+Cc list

On 9/11/2026 1:35 AM, Brian Foster wrote:
> On Thu, Sep 10, 2026 at 10:07:41PM +0800, Kefeng Wang wrote:
>> Open code the helpers so that tp->t_pflags access is explicit, reducing
>> the risk of misusing them outside the transaction owner thread as seen
>> in xfs_btree_split_worker().
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> Any reason this is not cc'd to the list? That aside:

Oh，my bad, sorry for missing it, should I resend it?

Another question is the target repository for merging this patch.
Both this patch and the previous bug fix are based on the mm-new
branch. Merging into xfs separately (if an independent branch exists) 
might cause conflicts.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 


Thanks.
