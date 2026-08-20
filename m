Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD9377034
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787214082; cv=none; b=q8Si9rW40oYMeUkirg1i+w0CjIPv2NTiETOXCaM/2u5K+rRWTKgh1z+wE5xu0KZzy2cX+NNj3Lw613e5To1ysuhAraU1Cr0eRuOLHQDo3chfo4YTorGPV2nAt5l4w0mkD+Nu6tam/1/a3jOiMTzyfmhblv34GzlFxSEyJG5NJuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787214082; c=relaxed/simple;
	bh=d1jsNWuE7ULunmJ8bkSavDLs3vrprYcUarJdoXM2dpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9MnDg+q5t3e3DC7tbE9hqmJzaBC7sA7jpiLtD+JI1owBihBnEUmvHIkMhExLEHeL9wV/kB3LBovWtNQwfq+g8/vJlzb+B4aee8od2q3ey+xoLAZhyRjpgJFQ3OhPosXkzaILB6OGJ/GWLLDyHebqQtMUy8F5cNyojQkH/mNqTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BY7EAL6W; arc=none smtp.client-ip=95.215.58.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BY7EAL6W"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d1jsNWuE7ULunmJ8bkSavDLs3vrprYcUarJdoXM2dpU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787214077; v=1; x=1787818877;
 b=BY7EAL6WGxfDbG4l6MPbp9U5kGh86tE/WaJIDRnuL81KXEd46OGZ4FtHPVJht9GxOw/wwnS3
 93sSeyrEEfQLVSiEVvSH4/Mh4b8Ia5Dkwlw6b8+RnDITXYyWbqQwnT+4TcCbikUNewndTI4MOGp
 TITq7ksssbvPjYOEdQmCu/ZM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from [192.168.8.135] (87.104.0.147)
	by smtp.migadu.com with ESMTPS id e6c688cadc82bb73;
	Thu, 20 Aug 2026 08:21:07 +0000
X-Mizu-Trace-ID: e6c688cadc82bb73
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb1857d0-f5ce-4fc2-81ac-06b39a1421f6@linux.dev>
Date: Thu, 20 Aug 2026 10:21:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Zhang Yi <yi.zhang@huaweicloud.com>, Pankaj Raghav
 <p.raghav@samsung.com>, linux-man@vger.kernel.org,
 Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, gost.dev@samsung.com, hch@lst.de
References: <20260819114022.818734-1-p.raghav@samsung.com>
 <a2939c81-a9c0-4b26-ac2c-17e3773125b5@huaweicloud.com>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <a2939c81-a9c0-4b26-ac2c-17e3773125b5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> FALLOC_FL_WRITE_ZEROES itself is relatively flexible. It does not
> mandate that the filesystem must implement zeroing via unmap write
> zeroes. That depends on the specific implementation of each filesystem.
> Currently, ext4, xfs, and block devices (bdev) support this operation
> through that approach, since writing zeros directly on devices that do
> not support unmap zeroes can be very slow and thus of little practical
> value.
> 
> Therefore, I would suggest referring to the description in, for
> example, fallocate(1):
> 
> https://man7.org/linux/man-pages/man1/fallocate.1.html
> 
>   "Zeroing is done within the filesystem. The
>    filesystem may use a hardware-accelerated zeroing command or may
>    submit regular writes. The behavior depends on the filesystem design
>    and the available hardware."
> 
> What do you think?
> 

You are right. It is up to the FSs to implement however it wants.
I will use this framing instead. Thanks.

>> +This approach means that the specified range will be physically zeroed out
>> +on the device (including partial blocks at the either end of the range).
>> +.P
>> +No other flags may be specified in
>> +.I mode
>> +in conjunction with
>> +.BR FALLOC_FL_WRITE_ZEROES .
>> +.P
>> +Not all filesystems support
>> +.BR FALLOC_FL_WRITE_ZEROES ;
>> +if a filesystem doesn't support the operation, an error is returned.
>> +The operation is supported only in ext4 (since Linux 6.17).
>                                       ^^^^
> ext4 (only for extent-based files)
> 

Sounds good.

--
Pankaj
