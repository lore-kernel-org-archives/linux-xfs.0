Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC035B658;
	Fri, 10 Apr 2026 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775865238; cv=none; b=kaUawKJDtswgdEKhr+I8b8fBbOv5yRwL4ZquTuzFqmoegahny6iZbeOio6qv0r0FSfbej/mKN4YmREqVJtSBitsdifFOoyfHB8TLiw0rSygyxC3WDA5p0S6mo9i9Rktl0qPIjcKdCFmEguu9NCNYApmFvINxrScat4VjP1q7kgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775865238; c=relaxed/simple;
	bh=o6Y727obsFVZ+XOV47ks34G5EZJhrwjg4+t7sDHa7hg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iJF6lc4dbGMaTDZHQl203tPD1B+McQGAsCyzPOcxiUxrfJ6FUrnt4aETfCz0VBPvXp/QMEYbpdDLkt/vYwEhBL97bneshk7JeR4UOk9nRcBwtGmRIfGQTES4z3bTwm59BuOXW3/d0IatoyTBhz6StJTuNt9I8yyn0rwO0h8Vq2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hmDRhbjm; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hmDRhbjm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775865232; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=RNH7yjOrTqdECFy4P+AAkfpojvo5A1fv4ak4vr+ZOKE=;
	b=hmDRhbjmo+r4U6W9EMPryyKMsvpc6FsgdqG6B4wuvzqaDXrX6tE9hyCSu/LhRA8x//FozmQgzzENgs5paattlNTb7IqnDCukDj5M1fjWxItM8Im2mBjjyaQoLmKiyHvSH/4lHB1rZJWwb1r2aXadWsiQOJmC6+BZ4zjvjW/c8vg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X0mPuB0_1775865229;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0mPuB0_1775865229 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 07:53:50 +0800
Message-ID: <136497e1-ba93-465f-84cd-e07eba110978@linux.alibaba.com>
Date: Sat, 11 Apr 2026 07:53:49 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
From: Gao Xiang <hsiangkao@linux.alibaba.com>
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
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
In-Reply-To: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/11 07:44, Gao Xiang wrote:
> 
> 
> On 2026/4/11 06:11, Dave Chinner wrote:
>> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>>> option") explains why workqueue aren't great for low-latency completion
>>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>>> is based on the erofs code in the above commit, but further simplified
>>> by directly using a kthread instead of a kthread_work.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Can we please not go back to the (bad) old days of individual
>> subsystems needing their own set of per-cpu kernel tasks just
>> sitting around idle most of of the time?  The whole point of the
>> workqueue infrastructure was to get rid of this widely repeated
>> anti-pattern.
>>
>> If there's a latency problem with workqueue scheduling, then we
>> should be fixing that problem rather than working around it in every
>> subsystem that thinkgs it has a workqueue scheduling latency
>> issue...
> 
> It has been "fixed" but never actually get fixed:
> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
> 
> and workqueues don't have any plan to introduce RT threads;
> 
> If Sandeep has more time, I hope he could have more time to
> test since I don't work on Android anymore: In principle,
> I still think RT thread is needed somewhere for such usage
> since lowest latencies is needed.
> 
> Compared to the scheduling latency issues, interested users
> don't care "individual subsystems needing their own set of
> per-cpu kernel tasks just sitting around idle most of of
> the time". If end users care it more, they can just turn
> it off by Kconfig.
> 
> If you think it's unclean to block subsystems, I'm fine to
> leave it as-is.  I'm not sure how it impacts to others:
> either some subsystems implement RT threads (workqueue or
> block), or leave it as-is; Otherwise there is always such

^ Implement dedicated queues somewhere using
sched_set_fifo_low() for such latency-sensitive work.

> latency issues and unacceptable for end users.
> 
> Thanks,
> Gao Xiang
> 
> 
>>
>> -Dave.
>>
> 

