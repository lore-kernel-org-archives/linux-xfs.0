Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24996A332;
	Tue, 10 Sep 2024 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725995957; cv=none; b=HhqDp28LuiqnH9iZwA3TqoP9EEYilEiwZG13OVfb5YQe+uviRTBdFtuPL4foHkBjyYuiKMa619oaZv3lxSjX3fbU47QK1+MeUkLXP6sk96lYEZd9YRoy4QVbdNLOmpyrkm0BlRjpWdthnaGQJbm6Ced78JAl8tUhXs2beQGL72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725995957; c=relaxed/simple;
	bh=gTOHPPESfK8EehXWWqOIXmMiW/UUGlZU3n9Ca2XsILM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CU3asBtCo5od04ATX2x48t/JPm5e13PExmJU07O9RJFPZ4/LCbRkP6yk75c5yr//s3tUf/17AYojP20a5BwvPkEZlyuYbCPang+as3vG574V1pVTkF4G1Qw2pZgKUd1w4EB2wFDG38M10KPtJyiBiDBNc+WFiUNe9XsMYdEALDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyo5VdwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyo5VdwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE56C4CEC3;
	Tue, 10 Sep 2024 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725995956;
	bh=gTOHPPESfK8EehXWWqOIXmMiW/UUGlZU3n9Ca2XsILM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gyo5VdwZvk9oMgkB1+aUe5/IGzFSPxZu2CKdBF9GNlp9efwdiGnQ9BZ/04vwG2sjU
	 fw51PJU4l/PwlRZfGTS0mg3EtwHeMwrAJDFRy3B8g39NYpRIKKuWAbeupvV85roLrF
	 AmfjLwn6WT22ufVhuURPbIDUAKu4aKQpgB/vp4eKm8N+De9O/7Av2ZUpMA/hFSEaE1
	 JfZJ47UmtCuM3IQAIv7uLkdmzVH8RLygViPPDFja4jHgDqRrazytc8XQWlNSnvyauo
	 j7Uo7/7EUB/0pCYWIhapF4jmqFuA8cwlwQtVpFmgxS0IwXr656uO4fR+bdCL27Mr64
	 hrJ2QL3u54K5Q==
Message-ID: <0ad933b9-9df5-4acc-aa72-d291aa7d7f4d@kernel.org>
Date: Tue, 10 Sep 2024 21:19:12 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Netdev <netdev@vger.kernel.org>, linux-ide@vger.kernel.org,
 cassel@kernel.org, handan.babu@oracle.com, djwong@kernel.org,
 Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 kernel-team <kernel-team@cloudflare.com>
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
 <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
 <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org>
 <c9096ee9-0297-4ae3-9d15-5d314cb4f96f@kernel.dk>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <c9096ee9-0297-4ae3-9d15-5d314cb4f96f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/09/2024 20.38, Jens Axboe wrote:
> On 9/10/24 11:53 AM, Jesper Dangaard Brouer wrote:
>> Hi Hellwig,
>>
>> I bisected my boot problem down to this commit:
>>
>> $ git bisect good
>> af2814149883e2c1851866ea2afcd8eadc040f79 is the first bad commit
>> commit af2814149883e2c1851866ea2afcd8eadc040f79
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Mon Jun 17 08:04:38 2024 +0200
>>
>>      block: freeze the queue in queue_attr_store
>>
>>      queue_attr_store updates attributes used to control generating I/O, and
>>      can cause malformed bios if changed with I/O in flight.  Freeze the queue
>>      in common code instead of adding it to almost every attribute.
>>
>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>      Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>>      Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>>      Reviewed-by: Hannes Reinecke <hare@suse.de>
>>      Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
>>      Link: https://lore.kernel.org/r/20240617060532.127975-12-hch@lst.de
>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>>   block/blk-mq.c    | 5 +++--
>>   block/blk-sysfs.c | 9 ++-------
>>   2 files changed, 5 insertions(+), 9 deletions(-)
>>
>> git describe --contains af2814149883e2c1851866ea2afcd8eadc040f79
>> v6.11-rc1~80^2~66^2~15
> 
> Curious, does your init scripts attempt to load a modular scheduler
> for your root drive?

I have no idea, this is just a standard Fedora 40.

> 
> Reference: https://git.kernel.dk/cgit/linux/commit/?h=for-6.12/block&id=3c031b721c0ee1d6237719a6a9d7487ef757487b

The commit doesn't apply cleanly on top of af2814149883e2c185.

$ patch --dry-run -p1 < ../block-jens/block-jens-bootfix.patch
checking file block/blk-sysfs.c
Hunk #1 FAILED at 23.
Hunk #2 succeeded at 469 (offset 56 lines).
Hunk #3 succeeded at 484 (offset 56 lines).
Hunk #4 succeeded at 723 with fuzz 1 (offset 45 lines).
1 out of 4 hunks FAILED
checking file block/elevator.c
Hunk #1 FAILED at 698.
1 out of 1 hunk FAILED
checking file block/elevator.h
Hunk #1 FAILED at 148.
1 out of 1 hunk FAILED

I will try to apply and adjust manually.

--Jesper
