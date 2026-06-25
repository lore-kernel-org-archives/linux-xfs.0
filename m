Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C1631E852
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389798; cv=none; b=e4GJirqGIGTyFdNc3GPyV9mfpGEQKqYqvQYmEVoF4BSzgrv8Pbkt/W+ppwH50envLoVEzqz36KgY7blCjzbRmc49e732amfwSlogQ2IOfXW5aAjkPR939sH/Z/k/PzZfddJCk7AcVyPeVdC/+7z98pRQK52e+iZ35l85QfD1jDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389798; c=relaxed/simple;
	bh=4Hqm6SAV2+vp4GScvYbK5eaARN362ZBnqBHYt0AfXMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WP2hGO0s3kMzH2fcr0dc7jcMwO+MDpqxs/xmOpJ8oqm/tXQCPYOXsfxNytExDrplV7fwgQM1JOFU5jgT+vmvWPkYNd7obwT4Mi4xue7vvqUtAwxpulD2ts3JYExfacc/UpmQFFXo6fcQ1MqSDi9hDCkwVNmI13zxV0KUp9olrq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mN8YKozD; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mN8YKozD"
Message-ID: <b86337f2-5aa5-4905-9610-35fafed2018b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782389784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZZ0gn/itqor68Q64KcCU2k7JuzqRu3yUTgbLyinAPg=;
	b=mN8YKozDzBIVBzGiVGYR/GFMKd/55GPWEw1YCVzjT4Bnu2MNnq1ikbi05WpHwkASBISAb3
	nrluKM87Z60oJSw7/9bDiP+f5azgPAqFD0J4yVylxslv6EUC0ljY4Nz4GD08kgXzG+pcdF
	9w7ogTq8r4ZsIq837GccGfxNLFiIv14=
Date: Thu, 25 Jun 2026 14:16:11 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: Christoph Hellwig <hch@infradead.org>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 bfoster@redhat.com, lukas@herbolt.com, "Darrick J . Wong"
 <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 andres@anarazel.de, kundan.kumar@samsung.com, cem@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
 <557b2e5c-7c65-48de-87a9-6fba21eca99f@huaweicloud.com>
 <0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com>
 <aj0bNstaTvy3HOkh@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aj0bNstaTvy3HOkh@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 6/25/2026 2:12 PM, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 07:16:47PM +0800, Zhang Yi wrote:
>> I've thought about this more and feel that we need to add one more
>> scenario here:
>>
>> 3) If the blocks at the boundaries are in dirty unwritten or in delay
>>     allocated state, it should be handled the same way as scenario 2.
>>     Additionally, before returning, we need to flush these two boundary
>>     blocks that have been partially zeroed, to ensure that after
>>     FALLOC_FL_WRITE_ZEROES, all ranges are in the written state.
>>
>> What do you think?
> 
> Yes.  Can you send an xfstest addition the exercises these corner
> cases?
> 

I have already created one that does a subset of these cases. I will add more
and send it to the list soon!

--
Pankaj
