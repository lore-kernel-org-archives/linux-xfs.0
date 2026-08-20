Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B72253EE
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 08:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787214143; cv=none; b=TDcMzKws0QYXgKZZ5z37TSuJ7MwXpIE8k4i02nOjp7iKjbHjKUU5JnnKGGFtq8zn/kvbboXicy/f56Pt+CRA2tpsBzOw5BfiGfCTyZKaQVSbvhkd9OQtlzL6mZR3S6d/e1wgJF7K9V4NFQIP24BVEa2LH2bztCbNm+BHvK4Da8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787214143; c=relaxed/simple;
	bh=HeghC4utsOJKrKnOw/sh0BThME8tzf4W6F636QChyCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUJBpzAhZbPA0gjSIeIBBzwIG5V/vw0HRHlZkrJXaM5fl8IIGhqHZ3T+JFUS/NBerhGFBvR67ZpNcGvLR3Rp6nloNQgDqUXhkLLK8EtYbbBGc0RNvyWUImxgMjS0yiCVCJdIzhtzIshQ6lrgdshM59/nJ/P/RMrkeHTWYzaoLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U5peSIWl; arc=none smtp.client-ip=95.215.58.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U5peSIWl"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HeghC4utsOJKrKnOw/sh0BThME8tzf4W6F636QChyCw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787214140; v=1; x=1787818940;
 b=U5peSIWlA9AwRbSmF038xne8UR+NJPHwMw9NWzb8cNSe/XTA+VIXCpve1//zQ0/FZkwncTjs
 KQS2TVm7NvYLZJK8bDzlcSY4rFH+qFqR0Ie+WlwZIDCr1fLppwrsQnIDqXNTU+sqNrcS1vgj38W
 U/uBKRUPaF1//UL8wBc0oGv4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from [192.168.8.135] (87.104.0.147)
	by smtp.migadu.com with ESMTPS id 94853a58d3cdb46f;
	Thu, 20 Aug 2026 08:22:20 +0000
X-Mizu-Trace-ID: 94853a58d3cdb46f
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc206a4d-cbf8-4f8a-96b4-49ea0454fdd3@linux.dev>
Date: Thu, 20 Aug 2026 10:22:15 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Christoph Hellwig <hch@lst.de>, Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
 linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, gost.dev@samsung.com,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260819114022.818734-1-p.raghav@samsung.com>
 <20260819143024.GA1010@lst.de>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260819143024.GA1010@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/19/26 16:30, Christoph Hellwig wrote:
> On Wed, Aug 19, 2026 at 01:40:22PM +0200, Pankaj Raghav wrote:
>> This flag was added to the kernel in v6.17. As of now, only ext4
>> supports this flag.
> 
> block device nodes also support it.

Yeah but I did not notice any mention of block device in this man page, so I didn't mention it.
I will update my commit message in the next version.

--
Pankaj
