Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F5435C692
	for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792362540; cv=none; b=R7YS6HKAtAhS2OUPw4Nir2j78e6X8NsaIcQdfce4I2OsYQgNKJuuSI7LqUytDG842c9ngHkOXYFPwOPz/pZISC8NJ3UFWctcECQ3S9pZv+uPTo7sKYJXgUezXMgPCOQeaVK5QzE8SouULZ45YPs8erIDXVXS9wmE+MfNVKnuRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792362540; c=relaxed/simple;
	bh=DfupwPSZCin6aC6UoR/hMPVmIOg1Ka92Z2blxUP6B8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hR6/w3uYg4iShjOAaNEoen5losRBoqTPzu36RSjFnW4J/tLD0wKa2FcsFlCWH+Y05SBki4KI3O+W1KLcsZRze6SVLLhaP4FOe16Y1UzTT7X9zPX2rqxAqXfL/i5ZUpbMaBQncgBdK1UnlO/GTBCuXKs1DQfK21F4R9JHBDffQkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0cibDtL; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0cibDtL"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so1131969f8f.1
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 15:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792362537; x=1792967337; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YuPuYj2KyJGah9hmABQQctga1s9wEhiM9oVruD5npRo=;
        b=j0cibDtLxh/izLswrWPSsQZxFjb5L4EMPQBgcSnjGDit42gu1Pm5oWUsCrfuFTx8nd
         wYdyunGN9El/oKYgG2w3WAYm0sk7eApe6170A44Hd9mgeJuNdh1e/KU4iIOUMEAXzaU3
         VNCxgmRqbBuQMK1tFC8Ss7wwT5CXv6gb+uHeepZrZvqLULJeGZbe416AFBo2XlQDlYK4
         43A+vKFjj7e/2eSEWeetWdnbn+6n4rO33x0NXv3tPPTW37QdsurVr5v5j7d0s55IMXhA
         W9bE69ocS128IIfUjS4jY1tNP2zNYItTsbpAaNtwkQR1T27hfeK4TocFTYZc22mWLe1T
         cdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792362537; x=1792967337;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YuPuYj2KyJGah9hmABQQctga1s9wEhiM9oVruD5npRo=;
        b=t0ZldBXLjF2o9C6NFt8hMy0J50iFy7pzp1QuxES83ekYoD5iG9o8kFPI1x1CJ2CxIT
         pzVf4kvI5uwrRUL1R9GUnQkNEHPducr9KzDU84sgJPhf1uSeBVdWyQbbeWj7QJ3l/uqS
         kiJ7ObEy0h6b+R5kdHYOeKbrxHMt1oyVYFC7HHzE5p3eURq+7OGreRu7msiDm4v9Mkv9
         OFQP5g2vC0Z05lpPpV935AN4UPriEvA5XFRO3rIrA5X/2XFuseikWwH26KKlHLse7U74
         ndtA5BWSnjmYPpiMVSIPv3/6YTAgMNwFLkwDJI/sLcK5nRmUuEZPPehxuuXV52k6H1je
         XoZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZL2Y9RocWQFWtbRo9H9i3s/JEtGtTiX3wM+SFfaM8RQ7bkcU22O63X6KnYZ5u2/03fPx1FnQnBn8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJFuttulw/4RB2K3ShbBwVDzZcVgDYt3KZx2OBv1GwaAh+OyFlj
	pPwUGq6OuTfJjipfRW64ibHs0VF2VCkGvh5DY2jjISGR4Q/XSVN9KcDo
X-Gm-Gg: AYBFou1q0KDd1avkedsA1erEuGoqhqRJd+sOyrDeH5rAhHd9gqkcSFtxcvjGh+zdq8Q
	bvmkPo2PJJA5Jd5j60YrsqWaq8JJQqFt9Jt4pjTa92Dqr6h2+sZYSVXLwDgZa45ubbzsd01pu60
	kyZqn089/B9FdB50LaQtFbRQR3wNuBRGo2eyiBJr+plAh/G50l9Uaqugw8OHQQI7FT0bTZGA7Ah
	CTKTJ0h7iz4g18krmulI4Dz840pKej9tS4Y43bjM7LdRi/LPgF+SSYIHF03krhOrONiqjgcLOWD
	YBjY+BVAf/3El1iEPeSm1B5xCitKRHs7Zk+PJuQ2o5HfST/VwLkpkYdVmuFxb9HVMgYBmvOIWAa
	QdHX/pPnQ5cP9BRTKlUxvdmxr2lQpa3RykPcC+PNaDDftdFLO91/LiYGgFpQCUgs+16IyXkp9Bs
	gs0xFJj76rOFOEY5eNX5FNrDzqYxiyeyh2gmLzUBDBtjNFkI2qyKQE9ATtl/rL8gD6qbR0sPasf
	Lqq0iUIQgS5YhnJI3hBy1PhkzmwxiA7lvXA9OvJgdBybroDfVTsnRHafw/YmKCn+vVhtqXbyxcs
	eU0PBhhe2e4Ff4GaBDGel3CIMjf2fNX2zqezJ0jHAfEZ6GN1
X-Received: by 2002:a05:6000:2f86:b0:48d:fd0e:a117 with SMTP id ffacd0b85a97d-48e079759c0mr14316716f8f.5.1792362537508;
        Sun, 18 Oct 2026 15:28:57 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f5b2dsm20677990f8f.31.2026.10.18.15.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 15:28:56 -0700 (PDT)
Message-ID: <0fe67d0f-54cf-4076-9e4d-ad23d05e7099@gmail.com>
Date: Sun, 18 Oct 2026 23:28:53 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/4] xfs: support dma-buf registered buffers for direct I/O
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj1072538@gmail.com>
Cc: djwong@kernel.org, cem@kernel.org, brauner@kernel.org, axboe@kernel.dk,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 nj.shetty@samsung.com
References: <20261016091919.971295-1-anuj1072538@gmail.com>
 <20261016091919.971295-5-anuj1072538@gmail.com>
 <20261016092855.GD23141@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261016092855.GD23141@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/26 10:28, Christoph Hellwig wrote:
> On Fri, Oct 16, 2026 at 02:49:14PM +0530, Anuj Gupta wrote:
>> From: Nitesh Shetty <nj.shetty@samsung.com>
>>
>> Add the init_dma_buf_io_ctx fop for XFS files.
>> XFS picks the device and calls the iomap layer with
>> the relevant device.
>>
>> Refuse the iterator from every CPU-copy path: DAX, buffered
>> fallback from a -ENOTBLK direct write, and read/writes
>> without O_DIRECT.
>>
>> If a file is switched between the data and realtime devices
>> after registration, the block layer cross-device check refuses
>> the I/O.
>>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> ---
>>   fs/xfs/xfs_file.c | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 426a67b813a7..f97d5acfaf68 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -340,6 +340,11 @@ xfs_file_read_iter(
>>   	if (xfs_is_shutdown(mp))
>>   		return -EIO;
>>   
>> +	/* a device mapping can only be read by a direct I/O bio */
>> +	if (iov_iter_is_dmabuf_map(to) &&
>> +	    (IS_DAX(inode) || !(iocb->ki_flags & IOCB_DIRECT)))
>> +		return -EOPNOTSUPP;
> 
> Maybe move this into the actual methods for dax/buffered instead
> to avoid extra conditionals?  Same for the write side.
> 
>>   
>> @@ -1209,6 +1219,9 @@ xfs_file_write_iter(
>>   		ret = xfs_file_dio_write(iocb, from);
>>   		if (ret != -ENOTBLK)
>>   			return ret;
>> +		/* the page cache cannot copy from a device mapping */
>> +		if (iov_iter_is_dmabuf_map(from))
>> +			return -EOPNOTSUPP;
> 
> I suspect these random fallbacks are going to cause trouble, but
> I'm not really sure what to do about it either.

Folks did mention it to me before. For a slow path we can try
do something like amdxdna_cbuf_clear() does:

dma_buf_vmap(dbuf, &vmap);
if (!vmap.vaddr)
	return -EFAULT;
memset(vmap.vaddr, 0, dbuf->size);
dma_buf_vunmap(dbuf, &vmap);

But I can already imagine it triggering some interesting
behaviour like buffer migration, which will be too penalising
for things like clear on a hole. And we'll need to be careful
about deadlocking here.

-- 
Pavel Begunkov

