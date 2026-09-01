Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6F1379C55
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788241457; cv=none; b=cAxFjhQDF7wV5vAVQh5ph4lfTub7ukjLnY6SQozSrDhOCvVuA5JcGiCjmvcUQWGk20nctZ//gUVvO/84b/+WmRWIahXhlE844MnHeZONFpjfg6O28Fg905ONeS2rP302yRmCFmg22PIM2Ge7mw1i8ov2VLEILHE4zTKzEAhUC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788241457; c=relaxed/simple;
	bh=rmqn6qA/Fewll7jkSHdXf5pxUkGNOhEP/Xbj3mumKEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=QXLCkSVdeNKzoAX108RVLIAiSMLN02ZPi8+KNnC0UHcGBO+5wLL5zISD7Fmx2wsLx/MBdGLPSjWzGWTkSjpZbNV8eUV9/ZzHq4V8IhZ30St8KWySQW3HoselJzXFL4ZGxkXZzkqQzcHD1JhGV51Rw+ZL0RifSaRldo1UyevFJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dNJ1Yc8t; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dNJ1Yc8t"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260901054407epoutp03b769780a490ad0dacf59d8de97f51cc5~RHB81GPJc0846008460epoutp03D
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 05:44:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260901054407epoutp03b769780a490ad0dacf59d8de97f51cc5~RHB81GPJc0846008460epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788241447;
	bh=PRqaBLQgn9f0JWR0KhzDK1ZY5rtDeI+KMrepnRp9h7A=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=dNJ1Yc8ti4kVY05DBaC546h6saFAO/m0RWeszQ3HB0z7C3ZkLk9MCH99bRgHLyLGT
	 5t5vNY2PVdSNiaPdTEobZfd3c1f9F2r05lOXuwekQpfxCG9UnSKpJFngbn16GiCuAO
	 taHeQfdSLMsCOIrtEmrq6Ez8dZmqG6Qmtdku3vys=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260901054407epcas5p1c3b5dce18c36571a6e6033ba72283c19~RHB8mtHNK0936309363epcas5p1O;
	Tue,  1 Sep 2026 05:44:07 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hYvtZ1rXlz6B9m4; Tue,  1 Sep
	2026 05:44:06 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260901054405epcas5p1bf6194b4c37d3eb9d73a57e12be59ef8~RHB7QGvS90797207972epcas5p1P;
	Tue,  1 Sep 2026 05:44:05 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260901054405epsmtip11ef004973710b32113a23cd949d10d98~RHB6oJYW52928029280epsmtip1h;
	Tue,  1 Sep 2026 05:44:04 +0000 (GMT)
Message-ID: <6b870d2e-04af-4899-879a-a4e26157bffd@samsung.com>
Date: Tue, 1 Sep 2026 11:14:03 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: release alleged child inode on metapath unlink
 error
To: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260831141657.GD6072@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260901054405epcas5p1bf6194b4c37d3eb9d73a57e12be59ef8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff
References: <CGME20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff@epcas5p3.samsung.com>
	<20260831064157.758165-1-anuj20.g@samsung.com>
	<20260831141657.GD6072@frogsfrogsfrogs>

On 8/31/2026 7:46 PM, Darrick J. Wong wrote:
> On Mon, Aug 31, 2026 at 12:11:57PM +0530, Anuj Gupta wrote:
>> If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
>> succeeds, release the inode reference before returning.
>>
>> Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
> 
> I have a patch just like this one in my branch so
> 
> Cc: <stable@vger.kernel.org> # v6.13
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 

I noticed that the hunk was placed in the wrong location. It belongs 
after xchk_metapath_ilock_parent_and_child() where the leak can occur. 
The implementation doesn't match the commit description. Really sorry 
for the noise; I will send a v2.

> --D
> 
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/scrub/metapath.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
>> index ff1ff762b300..79fd69d2de68 100644
>> --- a/fs/xfs/scrub/metapath.c
>> +++ b/fs/xfs/scrub/metapath.c
>> @@ -550,6 +550,8 @@ xrep_metapath_try_unlink(
>>   	}
>>   	if (error) {
>>   		xchk_trans_cancel(sc);
>> +		if (ip)
>> +			xchk_irele(sc, ip);
>>   		return error;
>>   	}
>>   
>> -- 
>> 2.25.1
>>
>>
> 

