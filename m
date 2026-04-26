Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BD52556E
	for <linux-xfs@vger.kernel.org>; Sun, 26 Apr 2026 06:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777185329; cv=none; b=WyMYW9W7SJr6tFgGzQ4JSMyuA3bZJ53sCRT0EqP374AM5WAtewnS6eM0h4qLBpM4Qv656d/2T+Atf1nbKjrJNCqeMqP6Ch9/v+OBQl/F0AZKcNFQBFKu0uQlAJIRj+v/WcRgJyB/76BprJndz/XhZt++uZv6mxr7hmy/cRqVBeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777185329; c=relaxed/simple;
	bh=7NmT0oeXOl8pEf4QBisw7SqVfu9PeMM8dz0/Vx4+pHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=il217cS1m8N1KERjRM906De5Z4LJ4vF7ywF7GkkMz3J7NaKGxACXhr5bnktj8p33K4OhHjwcVOk6nZtOhl3gYe10yAmeU+eQCJ0dhXjVzo2Ph0hJ16zN+8/Ae+t1A6Z0WhdHL79bowYmAmoMDPiytYMhlXvVfkn/bRxDXFmrtqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uBHBO74c; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uBHBO74c"
Message-ID: <63f16faa-f1a2-4ba5-a834-72da3584dbae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777185326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVe0PnsZ9IGeBgT35sLBHBpm6tHR/Ta05G1/Vjj3o3E=;
	b=uBHBO74coE6huy6glGijJNhlN688T3n7kI3lie+/b4DIZDundV1hw5ZCFNpuOh1TkdYAq5
	tSGFukVtsT6ZQ7OOm/xvSoX6uBkM9G2t7S3w7U5JedhebVHOg+vo9ElmE5BHa780MAe7PK
	5izxE2L+8j5pOd5LRfoBsmhR4NpFm9s=
Date: Sun, 26 Apr 2026 08:35:12 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/3] xfs: add xfs_bmap_alloc_or_convert_range function
To: Christoph Hellwig <hch@infradead.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
 gost.dev@samsung.com, andres@anarazel.de, kundan.kumar@samsung.com,
 cem@kernel.org
References: <20260420105539.3644999-1-p.raghav@samsung.com>
 <20260420105539.3644999-2-p.raghav@samsung.com>
 <aet1hhhRPGg5eGmK@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aet1hhhRPGg5eGmK@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/24/26 15:52, Christoph Hellwig wrote:
>> +/*
>> + * This function is used to allocate written extents over holes
>> + * and/or convert unwritten extents to written extents based on the
>> + * @flags passed to it.
> 
> You can and should use up all 80 characters for comments.
> 
>> + */
>> +int
>> +xfs_bmap_alloc_or_convert_range(
>> +	struct xfs_inode	*ip,
>> +	xfs_off_t		offset,
>> +	xfs_off_t		count,
>> +	uint32_t		flags,
>> +	bool			update_isize)
>> +{
> 
> Please keep this function in the same please as the generalized
> version it was base on so that git diff/show shows what changed.
> If you have to move it around for later patches do that in
> an otherwise no-op prep patch.
> 

So IIUC, you are suggesting to add this function in xfs_iomap.c itself and move it to
bmap_util.c in an another prep patch.

>> +		} else {
>> +			/*
>> +			 * We might allocate data blocks (needs resblks + 1 split) or
>> +			 * convert an unwritten extent (needs 0 data blocks + 2 splits).
>> +			 * Ensure we have enough block reservation for the worst case.
>> +			 */
>> +			resblks = XFS_FILBLKS_MIN(count_fsb, XFS_MAX_BMBT_EXTLEN);
> 
> Please avoid the overly long lines.
> 

I will change them all in the next version. Thanks for your comments.

--
Pankaj
