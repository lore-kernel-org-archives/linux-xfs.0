Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC22360EDC
	for <linux-xfs@vger.kernel.org>; Sat, 15 Aug 2026 09:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786785126; cv=none; b=lBpEe+4uuqXSArVKpCkMzUwaTVqaNqz8bLiVPm3QTyzFKF5sFufAMZmKwvABH3Kb2MS9kSxD9MlDGjV+uNEGtZPlfd5kwY6oHfQc+aXJnSeqcIKXcdzk+s47VXDMJrDP5nGTGBBmW1iaUE3y5ZtqMtOprhDCOG1r34qo6qpzFy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786785126; c=relaxed/simple;
	bh=qk2xoWGyI99Rzitkh1dMR6i/OWxg6tEsQezIQE4FWuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6/OQDhv84WGigd3D5d4BeDwKeSMKsjbVMo79xvtprLfHgpWS2xecp5H+jVsqRw77+SiqhZbJwyAQf4rn114KEEZEphg49dwPdgcxMRoodvkNNjNnoxVXVBlnILlnuOYCdX6vjiAEzVvIdmFovavbnOf52y+5iNbfuYMl/mjbck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6en6TGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6en6TGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D421F000E9;
	Sat, 15 Aug 2026 09:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786785124;
	bh=jTWfmWswiq3exspfddI7OlGLuKn1/MiTQ1wEQrpFZyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R6en6TGlbecBe6LFe9Y4tN0uT3KGR6VNa+it+cXEIc41HaM8U3bwKCz1N9hW9VgDZ
	 P+E98nAPUlDvjy/+2A+1j7Wt432NitJMeyWdxgrO8ZPlJPbXsy09WEgou20f9tktN4
	 UJivM8RlIbQS4Z+AFxbR8rvrNF+dw7MJJhmhP7aCWb1TEWDgWZtQSfjtai2hKbo92r
	 6qLClr/Xn0OWkq64CF+BYIZ/dh2otJFmdl0BBqLzfk6/EkBstqacjOfiPNKSIouQi2
	 5Z4OAEmBcSIZfWryMzdwVZg6uHfGiTyrqQRkfmFT89Gwz6mzBBnT4MXdsGEq8faP62
	 gfZRSnQfVKHoA==
Message-ID: <6fc9503b-eebb-45c1-a03a-d88163694f2f@kernel.org>
Date: Sat, 15 Aug 2026 18:12:02 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
To: Christoph Hellwig <hch@lst.de>, cem@kernel.org
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
References: <20260813145617.419537-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260813145617.419537-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/26 23:56, Christoph Hellwig wrote:
> xfs_zone_gc_write_chunk relies on bi_bdev to still be valid, which is not
> true when XFS is used on top of a stacked block device.  This can lead to
> misdirected GC writes, writing of plain text when using dm-crypt, or
> miscalculated I/O limits in xfs_zone_gc_split_write.
> 
> Fix this by reassigning bi_bdev.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
