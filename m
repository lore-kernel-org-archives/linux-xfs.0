Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307834A794;
	Fri, 26 Jun 2026 05:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452150; cv=none; b=Ha6p/zbDqaNow11c1q4v5H79WZE8QhhI4IQ5NYwXpd5FbXWo5gcD31ZK5YenL7nNye048/SakQJiZj3v+qzyoxsT3pQ7xPLZkaN7dHZKEfylFZWEzA4nDSNG+X3w36hYc208G7GqDdmYbve0F8LIHV8hGLuyjx6N9Bd7OvaDfQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452150; c=relaxed/simple;
	bh=l7cvoDgwgNczSeYTnrIWirGCDEM3dslxgj3ci5l1iMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1ZE7RmRsXTTYlXiy1aMIL4Lt6c1N/CGP2mBak+xBleNZ7dw8NDQ+m3Nr0pxCvSAXpSiOUSbucgaa0mZ44J3BVWEpZ5g/b93f7borZCeYz4ebWQ9GmGq3SrmTHiFy7c4KoWfjD+fjMJmUJw3VhUrKSfTdRMeVW5D/DTJXA+LJgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iQtjiwT6; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iQtjiwT6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782452134; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=poiHsp6kWksHn1sjXAspdJAC2Oce/xTBvc5IOfkhuSI=;
	b=iQtjiwT6iLvDFdI9SnMJ9HmyKHRr8GdkEDyM6BplPxRo397XnolxNDuE+MNI7rVXemY+FM203T7rvoSW+e2dmXJUbApwOKTFmpfmEGPWLlYsr5hyJ6tYXGjwvYFeGfAxM+K6zUgH0nX/cSv1wuMzAEjV6K4v4oSsefqizEWv9MQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5dlLiC_1782452133;
Received: from 30.221.130.253(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5dlLiC_1782452133 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 13:35:34 +0800
Message-ID: <e7012eac-d10f-442d-9681-d95a791e3190@linux.alibaba.com>
Date: Fri, 26 Jun 2026 13:35:33 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, willy@infradead.org,
 djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
 <20260625130206.GC22620@lst.de>
 <4da9a5ac-2a53-4fe2-9283-2e0f6181c248@linux.alibaba.com>
 <CAJnrk1Y_RLezfBq7sfgErGq3uT1t3czA+EWHg44zEXp9VrYF=Q@mail.gmail.com>
 <9bfa2c7a-1b17-41c5-9846-340e6a5b4b66@linux.alibaba.com>
 <20260626051004.GA8968@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260626051004.GA8968@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2026/6/26 13:10, Christoph Hellwig wrote:
> On Fri, Jun 26, 2026 at 10:22:17AM +0800, Gao Xiang wrote:
>> It's just my rough thought, as I said in the previous year, I
>> still don't have a strong tendency but it's my suggestion over
>> these years.
>>
>> Anyway since you're actively working/changing on iomap, so
>> it's fine to just respect your ideas/efforts if you don't
>> think it's worth, but as a record of my thoughts here again.
> 
> This does sound like a lot of work, and I'm not a 100% sold on
> the benefits, although getting rid of callbacks would be nice.
> 
> I'd be tempted to say that as a first step we should move the the
> single callback, as a second stop (after converting everyone to
> the single callback) to inline for performance critical path, and
> then see if we can massage it into a pure iterator without much
> downside instead of trying to do everything at once.
> 
> As you seem to have the strongest opinion here, I'd love to see
> a proof of concept from you to get everyone excited.

I know it's much better to "show the code" but I also think it's
useful to comment ideas now rather than later in case that anyone
is interested so that it could be useful for their adaption.
I hope I could arrange it in my formal todo list, but I've already
had a bunch of other things (erofs fsdax dedupe support as I told
to you since it impacts workloads, and some overlayfs improvement
and more) in my scheduling list.

Although I tend to play with this idea, it's not a blocker on
my main interested use cases for now.  Also see if some
complicated conversion like btrfs and f2fs can make more related
developers interested in following this way.

Thanks,
Gao Xiang
