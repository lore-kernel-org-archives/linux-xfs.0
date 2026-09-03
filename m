Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728724A6CC9;
	Thu,  3 Sep 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442882; cv=none; b=EtjbYDSCzoCksy6Lhvxs7xOZ0bPFtetOXH5iiyAWYtBAeZpCvn0BaU49y1JiyWD1lKQa+RCahsyUMgQKzJgEcl2SpuAUvk6rGYk/1NHtshLqVKPIcwKQyp9/QqzP+OZNbH6j+bhIywNJ0WnFB6JibpSThJWGzs2nTVV3MDn0S/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442882; c=relaxed/simple;
	bh=X5B6aaAf9wZRYQmYS/gckQIU5qlij3614vsWygZv8pU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iabTpdFlNzR5cZyDxCj2RHoaEHKU001V7nPDd8auqGjZvNhgL4b1IMlRcac8N0zB1th7dmQSDzsTAa7mylOsjE78oprknOjfao6iRgYPlwmcdMcY01ncAgunhU3B0PrsFdmCjYK53PCjKd4WSyPUwXGWyMScA7KDy/t+OokIb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ezLDGvXe; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ezLDGvXe"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fQtyka4OcFhdtfGP0HUFcu8ekTPMTXBkpViLDk0kGes=;
	b=ezLDGvXe7CoZkFO93WGPG98VZOeBPrtQVEwrHshQc1iCFmCaFDWr3bhpgIj19lLKgZwJwva64
	GRUod5vHqxXqZV1CgtFfBYxcMdg7O//e96me8/gBrIeen8Sq72HnKMkWY/rScnVmnqdSUm/x3ub
	OZyvnzxmSR2u/UZ4EXtn1Is=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbL6z5qnRznTx7;
	Thu,  3 Sep 2026 21:29:47 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 53ED640586;
	Thu,  3 Sep 2026 21:41:00 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 21:40:59 +0800
Message-ID: <cff1d446-4994-4321-a37b-09936520fc50@huawei.com>
Date: Thu, 3 Sep 2026 21:40:57 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
To: Andrew Morton <akpm@linux-foundation.org>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)



On 9/3/2026 4:44 AM, Andrew Morton wrote:
> On Wed, 2 Sep 2026 21:16:49 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
>> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
>> is kcompactd or kswapd. Converting these to use kthread_func() frees up
>> two valuable flag bits for future use.
> 
> Well that was popular.
> 
> Sashiko might have found a problem in the existing XFS code:
> 
> 	https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> 

Sashiko looks correct, I sent a fix patch, hoping it will work properly.

