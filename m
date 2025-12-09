Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324802FFF94;
	Tue,  9 Dec 2025 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765301658; cv=none; b=XpB5ezHor8te3f7GmCM7GsJFpH5F5vqXMqA+kN58qsG/C7Cln7Bzt/pPFY1drSCPrteCZ+qPKmuuX5yUxI4MO2of8yedtqHhLh2BELdoBytqEh5P7opGW4dw/ZgAac4Qe8FN4ACKDpL3u3e4LaGzODETkOPTNUubZKXMJwKn0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765301658; c=relaxed/simple;
	bh=dBmf0w9vdH88AmTM/VN61PnHeT+RtZaWitCVD1n/MJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mxUFnK/CmKkA2J5gSUfG0oK432lchgKsCkSqUVMRFdCa4yyaMP9zQvS2FLhhnSvce3H1CnP7GqlHg0PSMdJ82FLWfKlniYrprrLMYpCDnaB+hQwyZuyJa98uFB9hBZf890KT0OKkrMMJ7HaxeoOB6OsGCCal6GzwWt2pX1Gt4AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42FDE175D;
	Tue,  9 Dec 2025 09:34:08 -0800 (PST)
Received: from [10.57.46.210] (unknown [10.57.46.210])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AF1E3F762;
	Tue,  9 Dec 2025 09:34:13 -0800 (PST)
Message-ID: <3451a93a-e4d5-4017-b4e3-e58fae3751f8@arm.com>
Date: Tue, 9 Dec 2025 17:34:10 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
 Will Deacon <will@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Sebastian Ott <sebott@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
 <d1d76dcb-5241-4290-ae69-7d20e4461b9b@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <d1d76dcb-5241-4290-ae69-7d20e4461b9b@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-12-09 5:29 pm, Chaitanya Kulkarni wrote:
> On 12/9/25 03:50, Robin Murphy wrote:
>> On 2025-12-09 11:43 am, Sebastian Ott wrote:
>>> Hi,
>>>
>>> got the following warning after a kernel update on Thurstday, leading
>>> to a
>>> panic and fs corruption. I didn't capture the first warning but I'm
>>> pretty
>>> sure it was the same. It's reproducible but I didn't bisect since it
>>> borked my fs. The only hint I can give is that v6.18 worked. Is this a
>>> known issue? Anything I should try?
>>
>> nvme_unmap_data() is attempting to unmap an IOVA that was never
>> mapped, or has already been unmapped by someone else. That's a usage bug.
>>
>> Thanks,
>> Robin.
> 
> Ankit A. also reported this.
> 
> Apart from unmapping, by any chance do we need this ?
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index e6626004b323..05d63fe92e43 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -637,7 +637,7 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>    	pte = READ_ONCE(*ptep);
>    	if (!pte) {
>    		WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
> -		return -ENOENT;
> +		return 0;
>    	}
>    
>    	/* If the size matches this level, we're in the right place */

Oh, indeed - I also happened to notice that the other week and was 
intending to write up a fix, but apparently I completely forgot about it 
already :(

If you're happy to write that up and send a proper patch, please do - 
otherwise I'll try to get it done before I forget again...

Thanks,
Robin.
