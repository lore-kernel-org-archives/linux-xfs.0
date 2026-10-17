Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515F13BB133
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792261214; cv=none; b=EJl16FnwmWfIzRMtCQNqPrcTZlQfv3qyWt9gWBsCJA4Hk92dCo6jtwu43U75z6Kt6b6XDF3zRytxf/6EzcYXo57ZYvUpXYJF/wT3yxTZSwNiVIfPP9OgcxW1V+T3YJXWcIKjWpxGDKdchAvAwgRwTBo7rB7AobW4/mSliSC8wR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792261214; c=relaxed/simple;
	bh=P/0GDTwGHDXDyhmHHPUipLMi0vx+OEjqfSvuOQYC05w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=E08XVh7ErHRrX5KmV81tG1mqwW1YjonSrl4PydaeY/1geBPmtc9BJWtEoOjULpYiDt5vU0a75D2jykUrOg/ev2db3vXIBiLnnjZn47mZyx+EdyR+MP3YHSALBMCCcFh2IQHnOOO0aTFcAb22lWbepuMEB/o2OqvH4R6NjI4t2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uB0c7mbS; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uB0c7mbS"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261017182003epoutp033dd732ad03f26ed188ed3af1d411d033~fZBGuLaKb1004210042epoutp03s
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 18:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261017182003epoutp033dd732ad03f26ed188ed3af1d411d033~fZBGuLaKb1004210042epoutp03s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792261203;
	bh=HjR+8NvUm6JM6yYCmt/8o++n6s3zeG703SYTQZCLsiw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=uB0c7mbSE5zuZ91SEC5b+SaBNLmtLKxjBPgtgLq9muKi54om24g6KPPHvy04zdQlZ
	 3vqXbU9+Lfpi22u5I1P4hkBmtWnNs8y34oRGv1N5bprjUo9x5wP8/PFpwSftZgKTXk
	 ZjEqMByJlhYvJ+1J0sXJo+HXkwtR7qiYri4pUF6c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261017182003epcas5p2147c753d1906967f022b7072cc93f7e0~fZBGKXhn50708707087epcas5p2t;
	Sat, 17 Oct 2026 18:20:03 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j6VTZ3410z2SSKZ; Sat, 17 Oct
	2026 18:20:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261017182001epcas5p158e075372faf28dc20485f7f6041558f~fZBEMfriM0307403074epcas5p1p;
	Sat, 17 Oct 2026 18:20:01 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261017181959epsmtip2a9f1b7ef813dc28bfceebbca68562c39~fZBCopLIp3079030790epsmtip2o;
	Sat, 17 Oct 2026 18:19:59 +0000 (GMT)
Message-ID: <bce9928f-8370-4dad-a269-5fdb2c5315b6@samsung.com>
Date: Sat, 17 Oct 2026 23:49:58 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/4] xfs: support dma-buf registered buffers for direct
 I/O
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj1072538@gmail.com>
Cc: asml.silence@gmail.com, djwong@kernel.org, cem@kernel.org,
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, nj.shetty@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20261016092855.GD23141@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261017182001epcas5p158e075372faf28dc20485f7f6041558f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261016093612epcas5p20700b269c0a75415f05d52a8e7a2838f
References: <20261016091919.971295-1-anuj1072538@gmail.com>
	<20261016091919.971295-5-anuj1072538@gmail.com>
	<CGME20261016093612epcas5p20700b269c0a75415f05d52a8e7a2838f@epcas5p2.samsung.com>
	<20261016092855.GD23141@lst.de>

On 10/16/2026 2:58 PM, Christoph Hellwig wrote:
>> +/*
>> + * A realtime file's data lives on the realtime device, anything else on the
>> + * data device. If a file is switched between them after registration, the
>> + * block layer cross-device check refuses the I/O.
>> + */
>> +static int
>> +xfs_file_init_dma_buf_io_ctx(
>> +	struct file		*file,
>> +	struct dma_buf_io_ctx	*ctx)
>> +{
>> +	struct xfs_inode	*ip = XFS_I(file_inode(file));
>> +
>> +	return iomap_file_init_dma_buf_io_ctx(file,
>> +			xfs_inode_buftarg(ip)->bt_bdev, ctx);
>> +}
> Ah, this is where the previous cross check comes from.  What about
> simply disallowing toggling the RT flag with outstanding reservations
> instead?

So, instead of patch 2, this is about setting a new in-core inode flag 
here iff the registration was successful. And checking this new flag to 
refuse toggling RT?
