Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E87207653
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 09:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742290071; cv=none; b=RWDydVVo1EnmlEZT03UXSLhvRmeCN4voi5Zg8y1ZK5J0JbReUCoq/7ktVZpYvNS6sfoAqy588/nPdWkF0zBWiT+mqopbuWhSCKrx+pNocxsq8XdlBJRlws7NWAJIsM4mnE8CqyntJLO2xs2AilVaa/ZyrxnbV5k4ThWWJgmdT30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742290071; c=relaxed/simple;
	bh=ETqs9zlXYai+kgRp3EWFxdWdWqjslnJzzeTAbwVLj3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=r4R70EI64aqTPYOhYqjztg7lqULfC8XlPiUqthsM/AicXNgNMCMQq3DV0Xb94HTfwYzCwWiJk4Th3tmNpAJwKa8gZ4ZoGXRVHWXMK57NRC8DY6yzOIfEF4KRM21TDVHA8MS8IHWp6KONDU0lfN5zlVT+RRNe0V9hvGjNBI9PVpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CqqLQ2fW; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CqqLQ2fW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1742290058; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DiPRYQRz38cP9K2h/4MvfjbGKC0jx+86y5rHGNrnJjo=;
	b=CqqLQ2fWNOmbtpITbyf7mVKihNnymnBPRxWQsWfho9ph4Dmy5wq4nGQbRdxi//WA8+0VbGsF2SV4ZcMI82tH14CoLku3T8f0Cr6NbWUCmcNPEvlxXJ2d5J3lJTDrcUZg136/54birNluWqc6vfw1c0kU5zElT4eJ0dp5S3NyOYI=
Received: from 30.74.129.53(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WRseNcR_1742290057 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Mar 2025 17:27:37 +0800
Message-ID: <200fb38d-a6d3-4f8c-9a26-34b32d847718@linux.alibaba.com>
Date: Tue, 18 Mar 2025 17:27:36 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [report] Unixbench shell1 performance regression
To: Christoph Hellwig <hch@infradead.org>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
 <Z9iJgWf_RL0vlolN@dread.disaster.area>
 <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>
 <Z9jFTdELyfwsfeKz@dread.disaster.area> <Z9jUXkfmDYc0Vlni@debian>
 <Z9kqjdXM8i-7bS9o@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs
 <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
In-Reply-To: <Z9kqjdXM8i-7bS9o@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2025/3/18 16:10, Christoph Hellwig wrote:
> On Tue, Mar 18, 2025 at 10:03:10AM +0800, Gao Xiang wrote:
>> Anyway, I've got the community view of Unixbench.  I will arrange my
>> own TODO list.
> 
> FYI, while I agree with all of Dave's observation on Unixbench I don't
> entirely agree with the conclusion.  Yes, we should not bend over
> backwards to optimize for this workload.  But if we can find an easy
> enough way to improve it I'm all in favour.  While everyone should
> know not to do subsector writes there's actually still plenty of
> workloads that do.  And while those are not the heavily optimized ones
> that really matter it would still be nice to get good numbers for them.
> 
> So if you can find a way to optimize it without much negative impact
> I'd love to see that.

Got it.  I will find time digging into more (but honestly, the
priority is not high), if there could be some clean solution, I
will feedback then.

BTW, if any folks are really interested in this case and get
much high priority compared to me (that is one of reasons I
reported it immediately), I really appreciate too.

Thanks,
Gao Xiang
