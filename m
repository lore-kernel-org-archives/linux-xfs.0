Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE913B19C4;
	Thu, 18 Jun 2026 10:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781780045; cv=none; b=ZEjQcDwOZnPhXMV68yOGc+q6NSy7wpmyRC53KwtU7rx5HPEagakrc/vsQhis4jWB3srSjmW/mCbb4F5LLp3bn67bEePmNqPMT9WvJjqxABFJHspR2TPZ+je9cg5yKx1fBVzih3frYwVy7uMgA3wS6sNThkkFl1Es+XBQJfM6W2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781780045; c=relaxed/simple;
	bh=+JcJnLqHc6qHbEdjpjkJ62l8TIcEJlxQaI0kJSbcCMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUUvSA6U1gISENk8Dzf+TssTHUb/ajjerav0Uye9UZr6fyfG0UJdFWvSKlKdf5XLyEUGtU8gB3fTxOE0c2j69jW/euR4coX1zgz7Rm0NVJFoe7flzwo6t0B1pkzua0x3v57wTeCQuNxOpHcKoTW/UMagwQBLNzU8OTudolDtah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WKmi8MXv; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WKmi8MXv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781780040; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tEOH4b2VpB+R+W//mgS8StroH3m8ebqKTodvw52Ib3A=;
	b=WKmi8MXvpD9yn8Oy2sNzj+JoNjctliE2Ww1cLJ9v2HILtcIPW7eiR79r0Bi0NpIigQKBsJhA7JUUycZfZHfPpc3hpYtSRG3ZVCbhOGwlgqA2cPt8/n5MV1QzcgeDpR2CrEenQS7sZ+HlNwRhtQUyLzWYCbOdOs08LO6C50L2a1M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X56mOtU_1781780038;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X56mOtU_1781780038 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 18:53:59 +0800
Message-ID: <256c70c6-d4aa-493c-b777-ea9ab6298c93@linux.alibaba.com>
Date: Thu, 18 Jun 2026 18:53:58 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>
Cc: "zhaoyifan (H)" <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
 <ajOzy2NPD2GlXcNt@infradead.org>
 <7a38b823-59f3-419e-9070-cbc848f6f1fe@linux.alibaba.com>
 <ajPIIU1JB9e0ksBt@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ajPIIU1JB9e0ksBt@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/18 18:27, Christoph Hellwig wrote:
> On Thu, Jun 18, 2026 at 06:14:03PM +0800, Gao Xiang wrote:
>> I think this patch can go alone seperately because the
>> correctness is okay and cross-subsystem git merge is
>> a bit of churn.
>>
>> I've pushed an chunk merging patch individually to -next
>> for this cycle too, and it should fix too many bios issue,
>> but even without that patch it won't impact the correctness
>> (just less performant.) I assume both patches will upstream
>> in the near future.
> 
> Thanks.  I'll get this patch dusted up for a formal submission in a bit
> and will send it out.

Thanks for the patch in advance too.

Thanks,
Gao Xiang
