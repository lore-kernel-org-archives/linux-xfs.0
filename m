Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106E21B9FD
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764614721; cv=none; b=UuwIUeCGCsc63gyDV/zmCtBKFvDx6d3Cbh1seZzOMQ+W7i+Ae5672GEX+13p5eQ7Tk7CaHEoyHbJlQg0QZr+9WJu6499jhAn4xeIhUtaqRg/AxrmEeqyRSQwCcK44MXtl+Mb/PBM6BAcq2OBUDUuBv7yZXSJU2VrmZ0LjPGp/T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764614721; c=relaxed/simple;
	bh=mOJsemcKR9DZo0/dxGQEnbnIpXSn+voDX3RuK5YYCVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFz+ZWk1EwGwBATyBCPLfDYQruGgpfQRSEcgt3LoL8rFcvoG/0u1OcJDOlyYVvUYTB/f8Dzvx8EcIO+XDkQo2NodGSqTy3KVvPkVp+UIDey61BZQTnG8Pzz9LUTDsJkDfWLjB6veVJO0394qYlIn9NvG8uhSZrkjlekpVlKmReQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fTNtRedZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVFj5fA9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTNtRedZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVFj5fA9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764614718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dJcGkhdjlOLfp+TGJg3vPcrN2tLN38VFrM2yKoP4G7s=;
	b=fTNtRedZfewysQkj93GgLIRZrw0FLPB9qrrG+sX9vSLi3r7czBDomFW05ihnCsj8xmIuso
	htMjLuKCKNt62luGcpmP+pNTN1Npom2DH/tlADskeVY3faSg46WKzPUaxibTO6BQHC79pH
	nEA/smzFHpVsSUmjSm1g/xd/At1KeLM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-VcMNd240N9SZXuuV36By5g-1; Mon, 01 Dec 2025 13:45:17 -0500
X-MC-Unique: VcMNd240N9SZXuuV36By5g-1
X-Mimecast-MFC-AGG-ID: VcMNd240N9SZXuuV36By5g_1764614715
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b3b5ed793so3848835f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 10:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764614715; x=1765219515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dJcGkhdjlOLfp+TGJg3vPcrN2tLN38VFrM2yKoP4G7s=;
        b=RVFj5fA9hns/0PGUHvnVtTE/x+mzuSgkO/GvNQFHIdfF3Ioz/dqwqKzSNM3QwDm40a
         wxOQUEEBvbyd7cUhd3diOIPwSWqnKZ7R+yL5pQ8Ghr7kymzPg7+qY3MMOqbTsxtbSNiH
         pPul4VrD6HGyTRXOeCy5Ap/icGFvDgHNJlgWZlrgHL5MPlQ4k89H4Kw26hBmTJklDFSm
         crjtcbeN6nc6A5BGi6bZvbdOPlbMltCtdMone6q4UPI4NiHCLe9ksZdWTzoM6HFdZKLw
         3p92800lpT1g/3TzipaE7XUczq3foP2tny+qvKf7D2D13Mz1VSBB/205DoZy7iFcwJw5
         t0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764614715; x=1765219515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJcGkhdjlOLfp+TGJg3vPcrN2tLN38VFrM2yKoP4G7s=;
        b=T2QKHASmp27pyqhEza8ZkyWHreaA71mvpUitGF0EjAJbgpL7MCXWHRAEil74ZDVvqd
         USJrkJtiSbMvxNIxLdG7WANGFcF4Cm4SoKVVs6Y3d0IZ2uzeYaFhSlsXldbLRwhIgeBc
         9N6H3GqVZB2qW82a7F2hrmXxqzcZqMZXau3QJNHq35BUVmBzoP5MKaF4oz0L6NFh0nbG
         aO49FHSNsoDIj8EUe6mg3iH0BGufvCAGzeZF1Uw74/lRCV9SeaW39uRCqKDBxLudvIKE
         IQh8oXMY0F9BW8twlaTyEuvkEvcMAvKpOGbCJfnwytKq/AtEDQjOjsMCCtXYEqzK81x1
         3mLw==
X-Forwarded-Encrypted: i=1; AJvYcCXP+N2kowGnJpxHwY7+90iBmBXX419+Vz/yVBG/1v9KaX69gHMUvNDmxEYQ1dkT2HW3KgAnyRyCNI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl3n0ytR62b2A83D5hmSv2RTgskC9hdAhJIkH5f2NIDtCB8QE+
	FXE6V3GmHwOHuNvtT93ll5uoeaN3T/sO92OFNBonQCJlMbkf+zbf1EiU5oQFxoenaRC+8ynpXu1
	nPfEPosDzthAnv5DUNllAmK2fg1uQ+w7wE1R7NjbZW0Gp357OfM9OYXfouBz+
X-Gm-Gg: ASbGncvmOW3SQodxuK0Z+kMxk5cklwUXQt2QjWe5YtVhIUWKZ0eRLENbXktY1VmnpJz
	WA+9WFk4DWaBvRslND6UMVcmLRqW8wu6/WLV+OxIKxgz+mL3t/MVrvBCPHL0/n4MbBHAhPSUuPE
	fDGTBFyJdyOLXNmJMRZ4iEJPRsZcjW277aYRPQdM54DJiLMQ9INhd6680Guo2qf2xBYDO3j7sXG
	ZLLMTwLqADEJC7Tmxu8HDIAXgtgENi6fc9BWwNr4Yx+3TpzznlSfTcm3kNxKQzJkNcAeOIENoXi
	9VY9L3l1hy6lbugAtskt/J217CT+LDKjcyNH8Zrz1+DX1jzUUEguYnavXCg3CWnSMQqBsAqHbl8
	=
X-Received: by 2002:a05:6000:2411:b0:42b:3a84:1ee1 with SMTP id ffacd0b85a97d-42cc1cbd1f6mr38967593f8f.18.1764614715403;
        Mon, 01 Dec 2025 10:45:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEst0dSxM51WQQWwFluK2SRdLdewqD2Y5l9AU9XMfs47GPxw9KPOLXKRlqZnx5AF/I6zSOYUA==
X-Received: by 2002:a05:6000:2411:b0:42b:3a84:1ee1 with SMTP id ffacd0b85a97d-42cc1cbd1f6mr38967569f8f.18.1764614714770;
        Mon, 01 Dec 2025 10:45:14 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3022sm28083645f8f.4.2025.12.01.10.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:45:14 -0800 (PST)
Date: Mon, 1 Dec 2025 19:44:43 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/25] logprint: factor out a xlog_print_op helper
Message-ID: <bun4fdudr2eeipklvoammomgiy7ntqfl5l7lyfbre6hp4roh26@jzppybk22s4p>
References: <20251128063007.1495036-1-hch@lst.de>
 <20251128063007.1495036-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063007.1495036-17-hch@lst.de>

On 2025-11-28 07:29:53, Christoph Hellwig wrote:
> Split the inner printing loop from xlog_print_record into a separate
> helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  logprint/log_misc.c | 134 ++++++++++++++++++++++++--------------------
>  1 file changed, 74 insertions(+), 60 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index f10dc57a1edb..873ec6673768 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -966,6 +966,72 @@ xlog_print_region(
>  	}
>  }
>  
> +static bool
> +xlog_print_op(
> +	struct xlog		*log,
> +	char			**ptr,
> +	int			*i,
> +	int			num_ops,
> +	bool			bad_hdr_warn,
> +	bool			*lost_context)
> +{
> +	struct xlog_op_header	*ophdr = (struct xlog_op_header *)*ptr;
> +	bool			continued;
> +	int			skip, n;
> +
> +	print_xlog_op_line();
> +	xlog_print_op_header(ophdr, *i, ptr);
> +
> +	continued = (ophdr->oh_flags & XLOG_WAS_CONT_TRANS) ||
> +		    (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> +	if (continued && be32_to_cpu(ophdr->oh_len) == 0)
> +		return true;
> +
> +	if (print_no_data) {
> +		for (n = 0; n < be32_to_cpu(ophdr->oh_len); n++) {
> +			printf("0x%02x ", (unsigned int)**ptr);
> +			if (n % 16 == 15)
> +				printf("\n");
> +			ptr++;
> +		}
> +		printf("\n");
> +		return true;
> +	}
> +
> +	/* print transaction data */
> +	if (xlog_print_find_tid(be32_to_cpu(ophdr->oh_tid),
> +			ophdr->oh_flags & XLOG_WAS_CONT_TRANS)) {
> +		printf(_("Left over region from split log item\n"));
> +		/* Skip this leftover bit */
> +		(*ptr) += be32_to_cpu(ophdr->oh_len);
> +		/* We've lost context; don't complain if next one looks bad too */
> +		*lost_context = true;
> +		return true;
> +	}
> +
> +	if (!ophdr->oh_len)
> +		return true;
> +
> +	skip = xlog_print_region(log, ptr, ophdr, i, num_ops, continued);
> +	if (skip == -1) {
> +		if (bad_hdr_warn && !*lost_context) {
> +			fprintf(stderr,
> +	_("%s: unknown log operation type (%x)\n"),
> +				progname, *(unsigned short *)*ptr);
> +			if (print_exit)
> +				return false;
> +		} else {
> +			printf(
> +	_("Left over region from split log item\n"));
> +		}
> +		(*ptr) += be32_to_cpu(ophdr->oh_len);
> +		*lost_context = false;
> +	} else if (skip) {
> +		xlog_print_add_to_trans(be32_to_cpu(ophdr->oh_tid), skip);
> +	}
> +	return true;
> +}
> +
>  static int
>  xlog_print_record(
>  	struct xlog		*log,
> @@ -979,8 +1045,9 @@ xlog_print_record(
>  	int			bad_hdr_warn)
>  {
>      char		*buf, *ptr;
> -    int			read_len, skip, lost_context = 0;
> -    int			ret, n, i, j, k;
> +    int			read_len;
> +    bool		lost_context = false;

missing tab

> +    int			ret, i, j, k;
>  
>      if (print_no_print)
>  	    return NO_ERROR;
> @@ -1073,64 +1140,11 @@ xlog_print_record(
>      }
>  
>      ptr = buf;
> -    for (i=0; i<num_ops; i++) {
> -	int continued;
> -
> -	xlog_op_header_t *op_head = (xlog_op_header_t *)ptr;
> -
> -	print_xlog_op_line();
> -	xlog_print_op_header(op_head, i, &ptr);
> -	continued = ((op_head->oh_flags & XLOG_WAS_CONT_TRANS) ||
> -		     (op_head->oh_flags & XLOG_CONTINUE_TRANS));
> -
> -	if (continued && be32_to_cpu(op_head->oh_len) == 0)
> -		continue;
> -
> -	if (print_no_data) {
> -	    for (n = 0; n < be32_to_cpu(op_head->oh_len); n++) {
> -		printf("0x%02x ", (unsigned int)*ptr);
> -		if (n % 16 == 15)
> -			printf("\n");
> -		ptr++;
> -	    }
> -	    printf("\n");
> -	    continue;
> -	}
> -
> -	/* print transaction data */
> -	if (xlog_print_find_tid(be32_to_cpu(op_head->oh_tid),
> -				op_head->oh_flags & XLOG_WAS_CONT_TRANS)) {
> -	    printf(_("Left over region from split log item\n"));
> -	    /* Skip this leftover bit */
> -	    ptr += be32_to_cpu(op_head->oh_len);
> -	    /* We've lost context; don't complain if next one looks bad too */
> -	    lost_context = 1;
> -	    continue;
> -	}
> -
> -	if (be32_to_cpu(op_head->oh_len) != 0) {
> -		skip = xlog_print_region(log, &ptr, op_head, &i, num_ops,
> -				continued);
> -		if (skip == -1) {
> -			if (bad_hdr_warn && !lost_context) {
> -				fprintf(stderr,
> -			_("%s: unknown log operation type (%x)\n"),
> -					progname, *(unsigned short *)ptr);
> -				if (print_exit) {
> -					free(buf);
> -					return BAD_HEADER;
> -				}
> -			} else {
> -				printf(
> -			_("Left over region from split log item\n"));
> -			}
> -			skip = 0;
> -			ptr += be32_to_cpu(op_head->oh_len);
> -			lost_context = 0;
> -		}
> -
> -		if (skip)
> -			xlog_print_add_to_trans(be32_to_cpu(op_head->oh_tid), skip);
> +    for (i = 0; i < num_ops; i++) {
> +	if (!xlog_print_op(log, &ptr, &i, num_ops, bad_hdr_warn,
> +			&lost_context)) {
> +		free(buf);
> +		return BAD_HEADER;
>  	}
>      }
>      printf("\n");
> -- 
> 2.47.3
> 

-- 
- Andrey

