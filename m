Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C6B3016E3;
	Wed, 15 Apr 2026 06:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233113; cv=none; b=fRPZebTL92CP6T0+889/3wh16wSsI3heWiNGnZqYZzq3XWj7NlAMAqmrPaAz2fE0kctX243omJwoNrc7EBPalu6S5y0UavVOLXISpZbM8e7MZpGFC4m4BPYK1+Xr9weVXM9DO91Ov4fBzEgbR4VA5lFamy8hRY4iklSiPTCp7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233113; c=relaxed/simple;
	bh=/sLDlG+g3TWPppV6llCcXLve4ZPz3TocgKkmCXrlq2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8D+ty9J6S0b3NhMLHRjxW3CLJo84e5/iVq344vSQGb6DZCllaqYU+k1cpTGGMeIBQ54+y/bpqpCNmXj4StuO7I2uXn+RbhEDYNMQlcgdKceLl8DRrHSMeSCUUsPRMR/l3nqCEUVwvV+9Oh7x7kEel3walgjBezElsz3i0EmbIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZSA6CRRk; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZSA6CRRk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776233106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Y3Bvp+KpwAJJ/lnzTS+tDvjyO24nE7JkQWZFHl55Uq4=;
	b=ZSA6CRRkPLs5ZaCQ+6UMjRTROp81wY4lCM7fmr3/Grz00KOKMPQd8907JicuQo/do1TrK15kWBCl6YC4pdzBNYUkB2c/9hLWn3cl9q6xGQCpDmIpPboijSe+8nZk2Nw/y9xl51zofZEYfVRQ1AlTzbHFdtEndMTO4ZTxn78Xgo4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X13erf3_1776233103;
Received: from 30.221.132.134(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X13erf3_1776233103 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:05:04 +0800
Message-ID: <58d1a07d-e266-4d58-9be9-f1445a68599c@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:05:02 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Thomas Gleixner <tglx@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Anuj Gupta <anuj20.g@samsung.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
 <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
 <20260415055552.GD26893@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260415055552.GD26893@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/15 13:55, Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:

...

> 
>>> Tejun asked Sandeep if setting the workqueue thread priority to
>>> -19 through sysfs (i.e. making them higher priority than normal
>>> kernel threads) had the same effect on latency as using a dedicated
>>> per-cpu RT task thread. THere was no followup.
>>
>> I think the issue is that people are not already working on the
>> same topic:
>>
>>   - Unlike large subsystems like XFS, people don't already work on
>>     EROFS unless they have new requirements or urgent production
>>     issues;
>>
>>   - The original latency issue was already considered as "done" in
>>     2023, and I'm not sure if Sandeep could have the bandwidth to
>>     pause his current work and test more setups according to this
>>     ongoing discussion in 2026.
> 
> Which unfortunately might explain the sad state of Android.  You
> really need dedicated people around and help to improve core
> infrastructure, instead of adding random Kconfig choices.

Sigh, let's not regard it as a technical problem, and it's more
of a non-technical development resource issue among different
resource groups & vendors.

The detailed background is much much more complex than I could
write all down explicitly here, but at least I will try to
contact with Sandeep and more related people to test again
in 2026 if a cleaner approach can be worked out.

Thanks,
Gao Xiang
