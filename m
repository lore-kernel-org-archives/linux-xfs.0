Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF42C330334
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698326; cv=none; b=KrzSUV+fyHhNwStEO7yVF0WncldL7O0Fapn3GXPZXuFhQngH8Tj7zqvCDW0tvQbh5xXLFTF4k6lKRi6hmIXW8lpbqxqpyrWKyqFn80YqSj8KYZtF6fZek1cKs34HhS0rgdkklbYQpjF7V7Ph59CLTAZq0tcjlAI4uwHo5SzpkJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698326; c=relaxed/simple;
	bh=whQFO0imdqg5QUuh6ridbMtxCHkQa/EwXHMd6X70r/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnUU7tJ0INJdz8gsulAHtxE+y9x29tHPWkZbbIJl2KWnIGt6DXdmcpxZBs4g1g5PTvL4Wte1Xnk7xxEw+RiKDfKxpgBC0n+lp8Kc82Qw6LbJodrOWZpVcqpfMeUkG5YbC9M9+TSD5x8t+Kf5eMboswCJ3uBiTz7nzq+dXOA8f5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LE/vJbin; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n8XZk00q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LE/vJbin";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n8XZk00q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769698323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m31pY/sxRUdVfac4+BuGSMMKkDrCtKZLQDSOVfYYwBg=;
	b=LE/vJbin+vML3GMH8ozEbd+Ymh4W+biVwpOENBcAlkwfaXUZ5No4RrpGMt0sDJzqNKJzu6
	/p2nXMiGdRHLsqsEINhB343v2bYgCiWR38eFf6ROFA3Qe3pIyAtEASRfbfz1o/Ph1MES4p
	Sl2y19jl0MBrZEoDlQ+bT4MVzXFz5yU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-A6Ml4bMeNLOBQ0ntoddoTw-1; Thu, 29 Jan 2026 09:52:02 -0500
X-MC-Unique: A6Ml4bMeNLOBQ0ntoddoTw-1
X-Mimecast-MFC-AGG-ID: A6Ml4bMeNLOBQ0ntoddoTw_1769698321
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcfe4494so1156765f8f.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 06:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769698321; x=1770303121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m31pY/sxRUdVfac4+BuGSMMKkDrCtKZLQDSOVfYYwBg=;
        b=n8XZk00qTMzK2Cjxlcj2wK5j2URV+5RJ/SAOd3zOCAmXtv8T6pxPw4zvyK8Lqjiwwl
         I0W0dfjtEbPO0q+yBazr19sqn2x9WnG7xsaVu4/EX/JjCy3tFDVs0+/YRPPEkBIOYKqK
         yAQKpvJOf7HkUyj8HELQHkQdJn9Ir9EVykf6Q7c9PENEZfAQt1M5y+5WjapZwzwpoG0J
         B9o4nZz1yKSuDiAM8vKSVVDp9Aut8I1xY04DYJxPspjkj0xnyXpXCcZ5RqneCQKSEUyc
         4HG5JkCfu+gz+G+vZBOZtTQJJOzxrQbNKcV5g1tAvejl4yKV3Gcm86SKyU72H5tW1HMF
         goPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769698321; x=1770303121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m31pY/sxRUdVfac4+BuGSMMKkDrCtKZLQDSOVfYYwBg=;
        b=nFCqX6BHcKzj5V3V0+opRASq3s+xuOyeVPfAgjethNI7KpdCj9HVYQIc/ENJj/qjm6
         /opC2OTYu8vwquyIza21g/1tIqfdFHWoEI5KE9QWW/zxr5sCwjzPHMDQGUNawih9wap7
         8VfaouqE6UTcT0bF4Od/deuEaqGSZF8wbfXZS53PJX5qJ1tUJrRusnAo7oyKgklweNXa
         6tCwm550sGWpTAOCLKAsBEinkiDfvbfPmWvHEh/r+FfHwZ2U3fT3n1dxetbr8V7KCCCs
         Qrn1vRDIKiRGyjkVFwV1f26Ybi3fimwBDPL1NQ4BRcKIMjdiHqdICvlHj3CSg02dPNF3
         Njhg==
X-Forwarded-Encrypted: i=1; AJvYcCXqYDic+7LxQkHAEf+c1HYvGsg6VlFzqPyusT/ZP1nyUDb4jy8k3ZI0IZGgqmRJHxu4NPllrcfUa0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoMGQwCoQNTGrRQDewufgFfaNO6+hjgldcVpKwaZubjSKQnF8h
	ZtplXGE1IMRbgPLynFmQh7R0O+WBlqY4r3SMXNFqjM8k1WOkc7aD6Ghw56+SRrJDoNUetPeXlKN
	eAQ+orU9odV1hgRMjE/rnVY1TZzICr5KsAHdLfCoW3rhR4AyevC0QURu9Ov2c
X-Gm-Gg: AZuq6aJ6DYzvVAGrm6/bsz7vdVI34LjWzM1OPtFPReKxOYI9neRZFHJLAgIdToIsVn0
	YHQ2Id7clymEl2RvAhbrToLjPJv+5AFJi53AeEQuECoNl5eDEo7fXUlvjBYYOdIAYKsVevwY9mA
	iVXp/Ba1ZV/HjWwQq/cX5BWJmKVENd7o9eWi+m7W1qcAycddvYP47QNDLLLAb7OUwqGrE96l1pt
	ZYzJphoyHvEZH20TDshqZhfPBjGXBfAc+dDTcdeArUnwzhjmgt9ooVy40ESjH7KLz7HYuXaKUGt
	4YORHV2b8cLPNve6ZHjajT18AMJEBpI38ty6/5ASPW/cm+MCOk+v2gR8T9930VQmIQxscxxktEw
	=
X-Received: by 2002:a05:600c:4f4f:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-4806c7cc86dmr120529865e9.16.1769698320791;
        Thu, 29 Jan 2026 06:52:00 -0800 (PST)
X-Received: by 2002:a05:600c:4f4f:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-4806c7cc86dmr120529435e9.16.1769698320273;
        Thu, 29 Jan 2026 06:52:00 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5d31651sm5851205e9.4.2026.01.29.06.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 06:51:59 -0800 (PST)
Date: Thu, 29 Jan 2026 15:51:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: support T10 protection information
Message-ID: <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
References: <20260128161517.666412-1-hch@lst.de>
 <20260128161517.666412-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128161517.666412-16-hch@lst.de>

On 2026-01-28 17:15:10, Christoph Hellwig wrote:
> +static inline const struct iomap_read_ops *
> +xfs_bio_read_ops(
> +	const struct xfs_inode		*ip)
> +{
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +		return &xfs_bio_read_integrity_ops;
> +	return &iomap_bio_read_ops;
> +}
> +
>  STATIC int
>  xfs_vm_read_folio(
> -	struct file		*unused,
> -	struct folio		*folio)
> +	struct file			*file,
> +	struct folio			*folio)
>  {
> -	iomap_bio_read_folio(folio, &xfs_read_iomap_ops);
> +	struct iomap_read_folio_ctx	ctx = {
> +		.cur_folio	= folio,
> +		.ops		= xfs_bio_read_ops(XFS_I(file->f_mapping->host)),

Hmm, can we use folio->mapping->host here instead? Adding fsverity,
read_mapping_folio() will be called without file reference in
generic_read_merkle_tree_page() (from your patchset). This in turn
is called from fsverity_verify_bio() in the ioend callback, which
only has bio reference. 

> +	};
> +
> +	iomap_read_folio(&xfs_read_iomap_ops, &ctx);
>  	return 0;
>  }

-- 
- Andrey

