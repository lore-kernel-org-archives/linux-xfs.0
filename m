Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D76B567D
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 01:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714528066; cv=none; b=Jgjk2Nlo+yi5D27DR0gDiZbBPGSea5pw5kbwKrA2aeySyFFzaLh5QJqmPwzWlcf1i9DxjFSGijG40kfyULAMyT+g1nRFrvrWDJg8WLFpuvhgoTKaLUROtZ6P9C6ZciApDAEWyVdg+PcnzSBEF3oVbIZ9q7yajPTAZdEO18aQVVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714528066; c=relaxed/simple;
	bh=1BevPDrC06ybAYlvpZi7vW1hZEysUlTpN+aYC4MLwG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sp4BrctUoBD7oidtpju6BUQ4uiOVbsDbNYOCwMI6U5ftKv1raCt64KLjiorYZlbd2C6Fvj7Ar7AOxx4akyNVxLrVgQAUPgp+URKnKEaRNax1ccV2sAPgBr1FPRmvyQV9YRQKm1GecakZUFWnc0Z0sQjfDq8ceLvf+P/vQT+SerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Egtkymk9; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Egtkymk9"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-22edbef3b4eso1728213fac.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 18:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714528063; x=1715132863; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X2lTibDiFI0ZoiOE7Og2GQjpallD6n8zJfYR3muw4DE=;
        b=Egtkymk99E8HdIFt7CFI80d1oLSo/+q0ExuR+ZmXm6FjAh1KoWY5xXmrKdaZH8JX0S
         lss1PXc6PE2l+fG8yob+pZZV3VdDPuu9R0xUWRNSnIGfnLc+ikTID02PKGqgFL76BhGZ
         4TxbDicveQ2bPgAxk/x/jTNcPBx/6IUiS4qVbhr1t1ajg6oPaGkXcUDWt9/fFf6Q4Q3R
         ISxo1xktJScvePyFsyhVwWVtpwAElt8xmMUuGTL1LWrc1n6d0Uu8paQsnVuGSV3G0V4H
         vqnXE770Q/n9LYMNfRRbmwxdB3xAclqWRM+8RRIvp0N6BzgmTKtJ67dsdf5IVSR7FmXt
         QGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714528063; x=1715132863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2lTibDiFI0ZoiOE7Og2GQjpallD6n8zJfYR3muw4DE=;
        b=tg03ZVSYJbOqR2lzdDtCgFOMAcgWALUXHCAEtoiyPvesEp9/9BWNNBpv+QnKwmWmEy
         ceiNXzcxmLzZwUJIOzcybxXNYQxJtZSwiqKbD225jIETMysiFMOvDcmievhTxgQk0Zq1
         nugvvwj38EOvhOmN9xMKbWnjUzT0awfbY+dY6Qcgwah6xrlFMvx0zVTI5XyDuHYM0BqN
         8Q5MmxUs6wDH6eqkXyjhsChloo0iRWHi2LNRVkcYNAFnRlwOXMIChJY3o0jP2ONV8VRg
         eaJR698pzQLmAfcbZHEsoq9cQ/OXKqFZue3XxxQ2+FXNc3DTHqpwI+h3yq8gYXiRFFeB
         EqCA==
X-Forwarded-Encrypted: i=1; AJvYcCVXBPFm1AUjJHzcu1NwI2ReE9DgLRSeXPcIsWjkUAsSJiwqTOEaRNzgSXsyydLs70a+a9Ah76gasfzwPs1tY29DVPbGI1p9P1h7
X-Gm-Message-State: AOJu0Ywkz3lPLJCBono6pjcnI213LxBmkHPDN0/FBqOzA1exGW5iePx1
	5pCFeuB/ZL78F2YvpSCYeb+4bRjDB0wp20Kl+In0/9comW5We4wAshdxCoLupTY=
X-Google-Smtp-Source: AGHT+IEmewIJwY7Yi1W0lOvUPHQD+aXLDxZ98fdhOHrZpRU1dqWfUjvKTaI2jboHvumLvPnDmIO3YQ==
X-Received: by 2002:a05:6870:4414:b0:23c:bc3a:6ccb with SMTP id u20-20020a056870441400b0023cbc3a6ccbmr1237203oah.19.1714528062942;
        Tue, 30 Apr 2024 18:47:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id i11-20020a056a00004b00b006e4432027d1sm5918046pfk.142.2024.04.30.18.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 18:47:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s1z4N-00Gq9H-2k;
	Wed, 01 May 2024 11:47:39 +1000
Date: Wed, 1 May 2024 11:47:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	willy@infradead.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, mcgrof@kernel.org, p.raghav@samsung.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH v3 17/21] iomap: Atomic write support
Message-ID: <ZjGfOyJl5y3D49fC@dread.disaster.area>
References: <20240429174746.2132161-1-john.g.garry@oracle.com>
 <20240429174746.2132161-18-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429174746.2132161-18-john.g.garry@oracle.com>

On Mon, Apr 29, 2024 at 05:47:42PM +0000, John Garry wrote:
> Support atomic writes by producing a single BIO with REQ_ATOMIC flag set.
> 
> We rely on the FS to guarantee extent alignment, such that an atomic write
> should never straddle two or more extents. The FS should also check for
> validity of an atomic write length/alignment.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/iomap/direct-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index a3ed7cfa95bc..d7bdeb675068 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -275,6 +275,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
>  static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		struct iomap_dio *dio)
>  {
> +	bool is_atomic = dio->iocb->ki_flags & IOCB_ATOMIC;
>  	const struct iomap *iomap = &iter->iomap;
>  	struct inode *inode = iter->inode;
>  	unsigned int zeroing_size, pad;
> @@ -387,6 +388,9 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
>  		bio->bi_write_hint = inode->i_write_hint;
>  		bio->bi_ioprio = dio->iocb->ki_ioprio;
> +		if (is_atomic)
> +			bio->bi_opf |= REQ_ATOMIC;

REQ_ATOMIC is only valid for write IO, isn't it?

This should be added in iomap_dio_bio_opflags() after it is
determined we are doing a write operation.  Regardless, it should be
added in iomap_dio_bio_opflags(), not here. That also allows us to
get rid of the is_atomic variable.

> +
>  		bio->bi_private = dio;
>  		bio->bi_end_io = iomap_dio_bio_end_io;
>  
> @@ -403,6 +407,12 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		}
>  
>  		n = bio->bi_iter.bi_size;
> +		if (is_atomic && n != orig_count) {
> +			/* This bio should have covered the complete length */
> +			ret = -EINVAL;
> +			bio_put(bio);
> +			goto out;
> +		}

What happens now if we've done zeroing IO before this? I suspect we
might expose stale data if the partial block zeroing converts the
unwritten extent in full...

>  		if (dio->flags & IOMAP_DIO_WRITE) {
>  			task_io_account_write(n);
>  		} else {

Ignoring the error handling issues, this code might be better as:

		if (dio->flags & IOMAP_DIO_WRITE) {
			if ((opflags & REQ_ATOMIC) && n != orig_count) {
				/* atomic writes are all or nothing */
				ret = -EIO
				bio_put(bio);
				goto out;
			}
		}

so that we are not putting atomic write error checks in the read IO
submission path.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
