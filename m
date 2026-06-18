Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B33E8352;
	Thu, 18 Jun 2026 10:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777655; cv=none; b=Iwn+pD0hBt+nx+aw4lQY2epmBsq8PsglP2IFEa7zrxGZ7b5R9DA/1bLTSYuXPZU1uMtrSs1ll8Dc6Ja8AxffGQQ2Ky35kr6m89tvcCMYXpFU7XXgV4s5Dl2r10cKczVb0j32OCATS0L/okRCXV5BJ8wer95K0Q+jx5CXhCbcM84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777655; c=relaxed/simple;
	bh=W+REBdMGYTxLb01x1vKCnkXDYLWEvsnKvonP/Lnk7Co=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kbzmOA2knc4PpNhv23e+ivrT4qWTd4Xar1Wbg9RV5nB9TLv7+AUgC/FcZzQt0CytAOAhIsvtcwgZAIxekrC5iVlO2N0YulwNGaJ+rNH5OL8Qy3jw2KCbmtAAPAbCTmhzQIsIc8xEgW5GHacYM+3yVHPEXUBC8DzHMK2RHp9Pbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LBrWBu9P; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LBrWBu9P"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781777645; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eerrCQHtQPERvlXigMz86+eoZJQlWaUak7vPFaPCx5g=;
	b=LBrWBu9PPj8WfjyKRxdtv7E/N2ZRwXEjeRpCtNTRkEFM7ZyT0wHm3TMIQligLEEGzPle4YQiXNva/sl6z3aRN3zraGrFucYQLMMUBNxeOWpy2Gf6Kn7zjh3zS4FCafZqzFA1xsHIqxUe52hktl6tDVcvG6+MZShOEy2x1mcaoWA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X56WYpf_1781777644;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X56WYpf_1781777644 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 18:14:05 +0800
Message-ID: <7a38b823-59f3-419e-9070-cbc848f6f1fe@linux.alibaba.com>
Date: Thu, 18 Jun 2026 18:14:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>,
 "zhaoyifan (H)" <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 yekelu1@huawei.com, jingrui@huawei.com, zhukeqian1@huawei.com,
 Ritesh Harjani <ritesh.list@gmail.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
 <ajOzy2NPD2GlXcNt@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ajOzy2NPD2GlXcNt@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2026/6/18 17:00, Christoph Hellwig wrote:
> On Thu, Jun 18, 2026 at 03:16:03PM +0800, zhaoyifan (H) wrote:
>> Hi Christoph,
>>
>>
>> This patch works well under my workload (at least correctness-wise). Thanks.
> 
> Thanks.
> 
> Gao, do we need any erofs updates to go along with this to not regress
> behavior where it would have merged before?

I think this patch can go alone seperately because the
correctness is okay and cross-subsystem git merge is
a bit of churn.

I've pushed an chunk merging patch individually to -next
for this cycle too, and it should fix too many bios issue,
but even without that patch it won't impact the correctness
(just less performant.) I assume both patches will upstream
in the near future.

Thansk,
Gao Xiang
