Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64C14594A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 07:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773645823; cv=none; b=lczXWGIFJJ0TWyCwOeP3MKQZ6iOCIF/v+hYAKScRvTTLRVsJvBDorbth3K5AKvpJooMAUUnnl5h3cgdrHIYsLG6WlXfWQwi0IBXLEunAdWCy/ZT7CQtCxtbHGnmqR3V3H4dMMb11anYUpV6WfL39kEKaZSBrDW4tckKBzWJP4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773645823; c=relaxed/simple;
	bh=nb4KLGx6mJwE7prowxe6Qw/4V44SjApZeyYd5FHN4A8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uQSGMqcGgpgMmeZNmpyKSxktF4UzR3TbYNwdDe5mIHOXnOmm7Zti4mvkuBBdRbKtlZN4xl+qQoULDRttBbmGyJ70wz/cahxQYpH/Vdp6QhBG6Rw2C4ZBlyYF11f5LT9X1KyFmRNQ/jbIP06dggFYXLmYJvte/CkK0/SEJA+7uOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J6LyKszC; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J6LyKszC"
Message-ID: <2200df0c-0e18-4b9d-bf60-65e692a2b92f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773645818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5d5w6HGVmdm/JWT/kQM05DEoSMMa+8rkVt5ciARWawM=;
	b=J6LyKszCILKO0zDUkzbKCCsYUam+BAULom79L7j2MPZK9dx8mEpsrY2ANBur/qb+7ZazbG
	C4aisEnL6WkqZkMmN99YI8wa3Vn6AHpniUjKFe6hK7p/uw2foTpzd3P7NnCwm2TN4bnlqU
	FAQ1M4I7ZhLx4iqyBIjv3Vfs8wQj94s=
Date: Mon, 16 Mar 2026 08:23:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
To: Dave Chinner <dgc@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
 cem@kernel.org, hch@infradead.org, djwong@kernel.org, p.raghav@samsung.com
References: <20260309181235.428151-2-lukas@herbolt.com>
 <abCzhDSVmFx4PtWI@dread>
 <my5vghqmg4npgqpunilj3btbgrvr2s4dbqkm2j6cpw2l3tccrk@p3h3scnzwz6o>
 <abdFmEn7lQKqqbv1@dread>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <abdFmEn7lQKqqbv1@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

>>> So, a helper function in fs/xfs/xfs_bmap_util.c such as this:
>>>
>>> /*
>>>  * This function is used to allocate written extents over holes
>>>  * and/or convert unwritten extents to written extents based on the
>>>  * @flags passed to it.
>>>  *
>>>  * If @flags is zero, if will allocate written extents for holes and
>>
>> s/zero/XFS_BMAPI_ZERO ?
> 
> No, I explicitly meant flags = 0.
> 
>>>  * delalloc extents across the range.
>>>  *
>>>  * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
>>>  * conversion of unwritten extents in the range to written extents.
>>>  *
>>>  * If XFS_BMAPI_ZERO is specified in @flags, then both newly
>>
>> s/XFS_BMAPI_ZERO/(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT) ?
> 
> No I explictly describing what happens when you do "flags |=
> XFS_BMAPI_ZERO;" to any other xfs_bmapi_write() operation
> flag specification.
> 
> i.e. XFS_BMAPI_ZERO is an optional behavioural modifier for
> allocation and/or unwritten extent conversion operations. i.e all it
> does is add initialisation of the new/modified extents to contain
> real zeroes.
> 
> e.g. flags = 0 means "allocate holes/delalloc as uninitialised
> written extents". flags = 0 | XFS_BMAPI_ZERO
> means "allocate holes/delalloc and initialise them to contain
> zeros". Unwritten extents will not be modified by either operation.
> 

Ok, Thanks for the clarification. I was about to send the patches.
I will make this change and send the patches.

--
Pankaj
