Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4DA387361;
	Fri, 10 Apr 2026 23:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775864692; cv=none; b=oFhHpNcob07woYQuObbE5Tw963eVLM9SB6K3VF/9MgiCCaQGvac6sNsegXSgzLHLoEAQ5hIHoRFYrNI9iAB3+QcZa0dfOYlW12txjwFv45TdtC80NaSOaHmvhoaa1a5EkCZjXCvH4HeXeYwjzBpLMwEzNIkAwTAVyPAa+lG/41o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775864692; c=relaxed/simple;
	bh=pit/Q/uY4fhe9wzjCs3sh2iYocEfgoIZLc2nbI6VqbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KicGaerx7cvONRt+hY2H9HOsdjRPqeW1xp+ymndAewyjBasstsHzaCZrR7ysDO+4ULCESCzfHC/avNrba7nxUhoeMjwbeCiDO9cq0gAeTzhoQbNickojPOjmWFJkin4kDJx4elOeXgmkhIMI3494zx83JMmpUH6XzJ0ZnlswiF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SX7HG5EB; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SX7HG5EB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775864686; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W3lO6GXVv7klJnoi8dvFD4CH0/qjcMgEJJcFSxyeaJs=;
	b=SX7HG5EBcs8MSqTlYMBEdoECl1lFo4MejPADm9UVlNKgsv77PcWs6xRmPW1uQPp5GJ1MZ7KbL8Qj3FFbnDYyptb7x/kxEmNQqhps/PnCISRw0ZQYoVZs9znCCCAPalNRAkszyn+dYreOKd9dmQjZau25BY/JKjFn5ASa1smF8sI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X0mL5yD_1775864683;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0mL5yD_1775864683 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 07:44:44 +0800
Message-ID: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
Date: Sat, 11 Apr 2026 07:44:43 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <adl1iqhldFvJwSw-@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/11 06:11, Dave Chinner wrote:
> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>> option") explains why workqueue aren't great for low-latency completion
>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>> is based on the erofs code in the above commit, but further simplified
>> by directly using a kthread instead of a kthread_work.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Can we please not go back to the (bad) old days of individual
> subsystems needing their own set of per-cpu kernel tasks just
> sitting around idle most of of the time?  The whole point of the
> workqueue infrastructure was to get rid of this widely repeated
> anti-pattern.
> 
> If there's a latency problem with workqueue scheduling, then we
> should be fixing that problem rather than working around it in every
> subsystem that thinkgs it has a workqueue scheduling latency
> issue...

It has been "fixed" but never actually get fixed:
https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com

and workqueues don't have any plan to introduce RT threads;

If Sandeep has more time, I hope he could have more time to
test since I don't work on Android anymore: In principle,
I still think RT thread is needed somewhere for such usage
since lowest latencies is needed.

Compared to the scheduling latency issues, interested users
don't care "individual subsystems needing their own set of
per-cpu kernel tasks just sitting around idle most of of
the time". If end users care it more, they can just turn
it off by Kconfig.

If you think it's unclean to block subsystems, I'm fine to
leave it as-is.  I'm not sure how it impacts to others:
either some subsystems implement RT threads (workqueue or
block), or leave it as-is; Otherwise there is always such
latency issues and unacceptable for end users.

Thanks,
Gao Xiang


> 
> -Dave.
> 

