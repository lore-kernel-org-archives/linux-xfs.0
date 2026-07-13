Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1A237204A;
	Mon, 13 Jul 2026 07:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783927718; cv=none; b=ZEpCcspigOwlesRNNYebCDFpWA8KKFxjdl7mL/MuhJ/bkm/xuRf2yL41Lcl9Uv9/iwb6SSmjYBTwhLDOX4/tUj0gcrUVTWx52r0loGl8Ngs91aXPmmDelICYkfM5Ja4Ch01zV4vlt72kHvgYACSLB8R2RjeAyFBWSDPZi/EXNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783927718; c=relaxed/simple;
	bh=xJywuG49mGXloVCmy0qyuTeaUe2GnFcAKUaomnOOIO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PY9dFa7pY+OE98x09yWmasmZc8Am9tGF0+YMQrvU7cWP7KopIor89NJeWf5nmEgY1k6LIekge1P6gd8pLvuRV4tRNUY/to7wNbFypZT7RYDIY73Gc1Hx2ytnjPjYvkIQSaRryQRVCVMV7BqFHtV3PwclwqDl/BxTRdwm/knDhWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DQW+Vbzb; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DQW+Vbzb"
Message-ID: <58ef1a46-799a-403c-8b7b-1d9656a015b6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783927714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNwwPQEnDjeQZGdestCtajSazEvrm19mxHx7uGcUEIw=;
	b=DQW+Vbzb4uIr/2c6xtUbQmJJkHcYuTDsNAN0nhOUT1Y9TjIotOnPs2FBlcK4LSNCIiqrQR
	/tH2kTrn1IPqAx5yvF6xkR7tK8Mx/6r/9k1YLXN3k5rmAqw14ZJhnFZ6f0sLssl93ogE8d
	DpXSd6nTgJtvySS277wBDp2E638drFU=
Date: Mon, 13 Jul 2026 09:28:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Zhang Yi <yi.zhang@huaweicloud.com>, Pankaj Raghav
 <p.raghav@samsung.com>, zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 djwong@kernel.org, yi.zhang@huawei.com,
 Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20260709083048.3849610-1-p.raghav@samsung.com>
 <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/10/26 10:23, Zhang Yi wrote:
> +CC ext4 list
> 
> On 7/9/2026 4:30 PM, Pankaj Raghav wrote:
>> During the review of WRITE_ZEROES support to XFS, Zhang Yi pointed out
>> some important semantics for the boundary blocks when WRITE_ZEROES
>> command is used.[1]
>>
>> The test cases check the boundary blocks when they are in different
>> states and WRITE_ZEROES are issued that straddle the boundary. Along with that,
>> test cases have been added when a EoF straddles an allocation unit.
>>
>> [1] https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> Thank you for the test! The changes look good to me, and it works well
> with my ext4 fixes as well.
> 
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> 

Thanks.

> Unfortunately, I've found a bug in filefrag that causes delalloc extents
> to be reported with a length of 0. This means this test case can miss
> delalloc extents. The issue is in misc/filefrag.c's print_extent_info(),
> where ext_len is incorrectly set to 0 for the FIEMAP_EXTENT_UNKNOWN or
> EXT4_FIEMAP_EXTENT_HOLE cases. Could you please send a patch to fix this
> as well?
>


I think I see it here:
	if ((fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN) ||
	    (fm_extent->fe_flags & EXT4_FIEMAP_EXTENT_HOLE)) {
		ext_len = 0;
		ext_blks_phys = 0;
	} else
		ext_blks_phys = ext_blks;

I will send a fix soon as a separate patch.

--
Pankaj
