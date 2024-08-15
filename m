Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A9A146A6D;
	Thu, 15 Aug 2024 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723717210; cv=none; b=ssEXZKF7cwseruuAFqbTp64d0OfTGrjMfI5WhAJ3lwSOSpVuQC0NzGFp+Yhas+dZizXnXS16I95WSGlN5gq3Gf7VSULYT9DppvVVBTT6bFWCdkSKn7XltJ98ZncBOZyajMb//JX+uOiZk2DCqEsfYBja+FHbsnqHrsSXqcTj2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723717210; c=relaxed/simple;
	bh=raOaABlj1OsS4zpQCmdxj81O5KH9fSUAIFRNuwOHlBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eJWEm0iFBuT2cCpIeVpSnHY6GRAZS8N93yEHq1H74IvbUVaaTxwTQYlf6zRLGtS1GlIPVuqUhmBprf7gf6/no8jl7XyckFkfGvmWUk7Qn0ER8ZsU6G1oqPdg3qTsbYj4lZzEAIIAOs7iwvP8VVofGfIRUS/0TfO7/X9TnlPmp/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wl1JC0S47z1HGZm;
	Thu, 15 Aug 2024 18:16:59 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 7BC3F180019;
	Thu, 15 Aug 2024 18:20:04 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Aug 2024 18:20:03 +0800
Message-ID: <a4a70b97-aaff-49ce-afbf-e58787647bdc@huawei.com>
Date: Thu, 15 Aug 2024 18:20:02 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/2] Some bugfix for xfs fsmap
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240812011505.1414130-1-wozizhi@huawei.com>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240812011505.1414130-1-wozizhi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf100017.china.huawei.com (7.202.181.16)

friendly ping


在 2024/8/12 9:15, Zizhi Wo 写道:
> Changes since V2[1]:
>   - Split the original patch into two, each for a different problem.
>   - The fix focuses solely on addressing the omission problem and does not
>     involve the precision of intervals.
> 
> This patch set contains two patches to repair fsmap. Although they are both
> problems of missing query intervals, the root causes of the two are
> inconsistent, so two patches are proposed.
> 
> Patch 1: The fix addresses the interval omission issue caused by the
> incorrect setting of "rm_owner" in the high_key during rmap queries. In
> this scenario, fsmap finds the record on the rmapbt, but due to the
> incorrect setting of the "rm_owner", the key of the record is larger than
> the high_key, causing the query result to be incorrect. This issue is
> resolved by fixing the "rm_owner" setup logic.
> 
> Patch 2: The fix addresses the interval omission issue caused by bit
> shifting during gap queries in fsmap. In this scenario, fsmap does not
> find the record on the rmapbt, so it needs to locate it by the gap of the
> info->next_daddr and high_key address. However, due to the shift, the
> two are reduced to 0, so the query error is caused. The issue is resolved
> by introducing the "end_daddr" field in the xfs_getfsmap_info structure to
> store the high_key at the sector granularity.
> 
> [1] https://lore.kernel.org/all/20240808144759.1330237-1-wozizhi@huawei.com/
> 
> Zizhi Wo (2):
>    xfs: Fix the owner setting issue for rmap query in xfs fsmap
>    xfs: Fix missing interval for missing_owner in xfs fsmap
> 
>   fs/xfs/xfs_fsmap.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
> 
