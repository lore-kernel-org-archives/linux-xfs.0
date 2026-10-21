Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792595538;
	b=1qcePCjF3ZaXMLjuDWJd1oxM5PWTelI3zX3zc7PJk98ja5iTdrBia2E1AHERJNns8a/7
	 9ZD8PtJ3a+hcNXv8LXpVDM4jM0+13j6ueR4tMMT7S7T4gqqOUhZe3Rh+hGaaZ/wNte0Eq
	 BiK8/0jnlu1GLQ766ehsYVy+KdI0CRwCRmQxtKOxHIH+M814IeouQxb/aEdinblXVpiw3
	 sKRnYwK2ZXW3o4J0AmHT/yLKlIKFp69iPS0fv7R50q0Tf/lVUSEfqnGRbRyPJ/hkZt0nn
	 9L0AF5IaczbSZrz3DhcLBafEA/1TIPN5ObrmI1ldcqAB5yMscwbkoNZQfCRfUO8oSnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792595538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FsHH6aozeXPThpXvJUYVLtQrnQwbfOChlZ8cfIqdctg=;
	b=MAK1uz/025Ksm6Zjg3DavMJvJPgayJHIXT+xP4TOFC8uP+lBPl/inL26EKqCbE7wFXN3
	 4Co/4EckgnvH23U+EYmNJ8LvWgRy0eQLCvQH98FQqlmZkCCDqO94VhlQQJc/OKwuKIRlQ
	 aEuv/eBLayuh4Zpjyb/C52OPUu4hCitMsru+wahuZKM+tXELW4HB6TV4syHK0eXeYlz2u
	 noZUAs1C3u3Ju8TouEgVa3U9nQ3yHHtNOj2eZebLCWKEgLx3d/xnQEvH8fqX6GCKe0S9L
	 NfL71v58lVlzTUP5g9IBu5winGOJUmcWwSB2yoNWL2UYC9s9ktBBQE6M/UdljzbT99A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fRtNArbA;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF1606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 15:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13DF1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fRtNArbA
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso869889f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792595536; x=1793200336; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FsHH6aozeXPThpXvJUYVLtQrnQwbfOChlZ8cfIqdctg=;
        b=fRtNArbAsjB87bQ7Egtqi1qkoryq/3OpgC+NpIKVcrOe3+zlMXYMwOlAI8wBFiWNqz
         /vwIrs8UcevppcI4bM3g8DBDAAPymD3sBjBVJZkceWgpJVAoP88Fri5Aq/xfZc77SNg3
         heAxZ+4juOcdoVkAt/XGapWWe7ioX6XUStxAlzmwxpDhGFXB3ERcql5/GqsTfS0H/qYU
         GbXxFn405gpDNlr5sBH6IWrq7iarI3go7WnfA0KVbRX/9NmUYIhzyNwuyUkllOfxIm1f
         VKxKclYr9bO065thJe8DJ9E9Vckk3PDMFluqv9yYpZUIrjYUjQXqMqXt92ZWv6Np+iS9
         u+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792595536; x=1793200336;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FsHH6aozeXPThpXvJUYVLtQrnQwbfOChlZ8cfIqdctg=;
        b=qxjitPNXFMggufvJBpVX956yIePX9kRTt1Y5nfmtER5KEUAxrc/wJ6BuqU7lqYEwSZ
         qk1u0CvO0rLu89O5n9CuP7LrJEGbcxOmEzSg/QNuSyadgxej7wFv0ZFUl3GqWGgwX/I3
         4GPuPjgM5pdWPKJ5MM4IFE44rUW9AcFD62Sxt4RWnvebT6bvIo0qYJBOA+3cMZUG5E3a
         LHVjnwE9sjghGhmNmPHa1SfkFodCDl0WOQtq9FaU0ZJ0gz4PGAOoZznPgHdYGRzMkPH0
         55enecBCvEU6RZVXmHfwhBnUTi/HcBsjqW+6WvAx5Ip0r6vYN1YXwnbP39RBkmD6UUhF
         weEg==
X-Forwarded-Encrypted: i=1; AKwUvBzusvqKyJjNV633u+D5RJIHL3+kc8vjTS7+RUhpW+dLX3NbB7vEeimGTODNtkSMc7VXzB/soiWFo9o=@vger.kernel.org
X-Gm-Message-State: AFq9FYKPxU2jueh9iZx+l9Fba1UYDKRKAjIAp4fbQwVaqF4LsvRmaZlU
	WDonFy1srdZ5DaR7RB6uokOMRsDSRp+nwH/KsQQI2kaUdmJum4rVFqIn
X-Gm-Gg: AYBFou1Y8fg9pW+wEMRncJ8+t99AzyLIiXij9VsG3tvdY5s3wG3CYYnkI2GoWhBHzq6
	5sYa6mjyRYt8yKdnv/0VNCr8rpYwW16RJ3n/0GYzPG4hRAYUvYKmvUvtkiSbdWtlg50jwZPXTs2
	kZgmxLHQAFKTXcLhl9btW8O5yUyezhSyOFdt4h2iP5ikWEkiIl8rAPF5MJ2Z0F3r3TBWUWK7L1d
	50VaXY6lx7W76RiOXgfySs7JGnmcBw135xZVSTlB+x9M1GPHgZ8BpF0taUcVyrL8oI0WeQq8rq6
	5XwMqqUTm15dz1u4N1XcFzD0533xhAgzzM/Ni7f1wheYCiTM0114mjpGg7zE+z1DEof+E6yFwmH
	f0qm7dcRILlgcEzIHnWeZeyLY/I9NrTxBghICNl6he6hWRsXpMZegkcZS+z01bDvnOxjXYzX6QK
	lvOSQs/aOCZBPP668sxaFv7+zN9mNGABUfFuUtRW+N4hpc2u74GUZ2gyfZyrlXdsqXjBSU4LJCS
	gXjyLtEEtv0NbwV4WmYrT6aq5dqOMHOUexQS//iM+efurkIEejxOmbKPFH6ZbfIELPyi16GPJY0
	DK7UFD2s3HyW22aMvM0e5O6mKdaKdkQ/lJUjBzZHSDzuxa/qTEictCzEV2hENRLmgRPq9S9bZpI
	klTa21VY=
X-Received: by 2002:a05:6000:46d6:b0:48d:f831:2681 with SMTP id ffacd0b85a97d-48e264ce32cmr3497388f8f.38.1792595536092;
        Wed, 21 Oct 2026 08:12:16 -0700 (PDT)
Received: from [10.54.182.141] (82-132-213-19.dab.02.net. [82.132.213.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm6396517f8f.3.2026.10.21.08.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 08:12:15 -0700 (PDT)
Message-ID: <5f542a8d-c6c1-4c5d-b0c6-f761af2e126a@gmail.com>
Date: Wed, 21 Oct 2026 16:12:15 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/4] block: refuse a dma-buf bio for a disk the buffer was
 not registered on
To: Anuj Gupta <anuj1072538@gmail.com>, hch@lst.de, djwong@kernel.org,
 cem@kernel.org, brauner@kernel.org, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 nj.shetty@samsung.com
References: <20261016091919.971295-1-anuj1072538@gmail.com>
 <20261016091919.971295-3-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261016091919.971295-3-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/26 10:19, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
...> +static bool bio_dmabuf_map_valid(const struct bio *bio,
> +				 const struct iov_iter *iter)
> +{
> +	return iter->dmabuf_map->ctx->registered_devt ==
> +		disk_devt(bio->bi_bdev->bd_disk);
> +}
> +
>   /**
>    * bio_iov_iter_get_pages - add user or kernel pages to a bio
>    * @bio: bio to add pages to
> @@ -1300,6 +1312,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>   	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>   		return -EIO;
>   
> +	if (iov_iter_is_dmabuf_map(iter) && !bio_dmabuf_map_valid(bio, iter))
> +		return -EXDEV;
> +
>   	if (bio_iov_iter_set(bio, iter)) {
>   		if (iov_iter_is_bvec(iter) &&
>   		    !bio_iov_bvec_aligned(bio, mem_align_mask))
> diff --git a/block/fops.c b/block/fops.c
> index 18a755f6e0b0..b36dde10a4ac 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -19,6 +19,7 @@
>   #include <linux/iomap.h>
>   #include <linux/module.h>
>   #include <linux/io_uring/cmd.h>
> +#include <linux/dma-buf-io.h>
>   #include "blk.h"
>   
>   static inline struct inode *bdev_file_inode(struct file *file)
> @@ -938,6 +939,7 @@ int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
>   			     struct dma_buf_io_ctx *ctx)
>   {
>   	struct gendisk *disk = bdev->bd_disk;
> +	int ret;
>   
>   	if (!(file->f_flags & O_DIRECT))
>   		return -EINVAL;
> @@ -945,7 +947,10 @@ int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
>   		return -EOPNOTSUPP;
>   	if (bdev_has_integrity_csum(bdev))
>   		return -EOPNOTSUPP;
> -	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
> +	ret = disk->fops->init_dma_buf_io_ctx(bdev, ctx);
> +	if (!ret)
> +		ctx->registered_devt = disk_devt(disk);
> +	return ret;
>   }
>   EXPORT_SYMBOL_GPL(bdev_init_dma_buf_io_ctx);
>   
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> index b9bbeca1744f..d42a79f2ac9b 100644
> --- a/include/linux/dma-buf-io.h
> +++ b/include/linux/dma-buf-io.h
> @@ -50,6 +50,8 @@ struct dma_buf_io_ctx {
>   
>   	void					*dev_priv;
>   	const struct dma_buf_io_ops		*dev_ops;
> +
> +	dev_t					registered_devt;

That wouldn't work well with multiple devices. Maybe reject it in
xfs / iomap for now?

FWIW, a generic solution is for xfs to own the ctx passed on
registration instead of forwarding it to block, allocate an array
of new ctxs for each device and register them separately. This
should even be able to support dynamic device registration.

-- 
Pavel Begunkov

