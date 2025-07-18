Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C262A14F9D6
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752847444; cv=none; b=Nskej6vdU4qbyW9uhQRfgERiggRLuK9BIM5adhZYmHquQdcLYq6PShNJkOBTQtevaT/6hKKXjjEcVgEK7MDsysbwiyggfLmIINeJYdV79BcWxkmyxQEFp8WQUIsQ0YVwfE/s08FGFV7KzEqcW6PoiZxY5ZXPETVQPoj2y/bNXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752847444; c=relaxed/simple;
	bh=3WwrFya6stC2Opyc8dAzpaVhfcC6HZoY9SM/k73/v64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/2fUH7+oeb3iC6Zi6lO5o0P76p/cNS0UdPR/E6OH8QWbnVIF9BMFU/02JNNwDpGGsh35XnlK1Si6qgwjFD7j7KQAAthwKFrC3COnW4QW0bFxj1SQjBznvxDCWFW37vWbB3BL+H8vANSJSBPCc1Z2VWHXFcKUmwXWQygRTA2g/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6UmeOpJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6UmeOpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752847441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7f03eY/QK4rrgj6rbvv78R3jZLJax6zcosbZK8lwVtg=;
	b=E6UmeOpJEw1CNrlx5niYciFl8pHOTP2ZxxGtI1acmHDJPa0HDJjPqPTXhHrtIgSGpPWclP
	whw6tc4biq3vLsP04n1qt1YhMRRZ7B52A9FZxsgccKZsNH40RDcJoVoeLJDX/Dr5nKIJ+u
	gvBYajCg0CugJoh7yg9QlAbbTC1vZiw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-wV3npNvdM5-P6GEwnW628Q-1; Fri, 18 Jul 2025 10:03:59 -0400
X-MC-Unique: wV3npNvdM5-P6GEwnW628Q-1
X-Mimecast-MFC-AGG-ID: wV3npNvdM5-P6GEwnW628Q_1752847438
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae0d05f1247so236626266b.1
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 07:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752847438; x=1753452238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f03eY/QK4rrgj6rbvv78R3jZLJax6zcosbZK8lwVtg=;
        b=teBmpUjzQW8ASlqZ5l8jTKrofxPDK40nnrkYSDkJCtNabUB4/j9NyxVMNscwVGjvOv
         Cvkvb9yUUvJhc/faGKegvVP2OzIXS+M0cU1tOXUlFhusqAbzw/4RvEivtkVuICq8Tk4f
         ShXI4vOYLJIa5FAwRVx9o/xfUv700yCkp3Jz6r+PtljbBMKWzkMQan0s0FjOankj5pZJ
         zIutOTcFWcg5c8L4r/RiR98Brrh8u/oN6qjFB9HS6Mkstr6890qcSbj/OXEaqcORDsKt
         dCoZ+ZzK4+FaKnW3HGhqx3ajpKhZJDDIcifuoX377ocXkuindKWqtCy0/llBeKyJ0tzC
         +Igw==
X-Forwarded-Encrypted: i=1; AJvYcCVE3zR3orW6bsLvMb4XxKuX3GCEk6Kuufv9eQwrg1yg4ybHasaAFVwqbEowUFCwMNOKVLFtKFwNM6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq7v/fHAC0uM/s3dbdkgFTs5RUzEB4KSUcOonTkTZJQYvrpAVY
	r8TrRnGfMC1/IQMqFYdQZu/PUU3e92gwrsj2yhqrHTQc2W/oTAcrfzq/MCw5hhviqu53Vrb9lHN
	eaakiBVJXlFSZYW2jbECFUKzZmgLJLPKuj4/KQcbFmITlsmbz7Yv7MjeJkHMv
X-Gm-Gg: ASbGncsMpEdc6CdKNGB8iHcQBfg1tKn2BITJmtBPd7bcRzbjaDspZKcJ9Sb+wEmAN3Y
	OJZZJDA3w5J/bHYP1F+od2OE88Te6SjnJAAYkXjFseLwlU4qyCkh+JunRIbOn/15bY5yCWTx8ef
	5tN5G7OcK6OD+CwsLmJEkhY9KUC4XySmTKYduGCvOSfpeQLg3JyzxTVFTZgwoM9gAEn/4mhlaPW
	2XPn1K+uTRzkLCIrz7t8UO9qcpLOfbUqKISZIjTkcOiAxz8speFBNVNvNCXS9FAq+e2Y96MDeBp
	6rJkCq3nwMgDXMonh5AGCZSx1RLL8tlD4oh/Yrn4ANpd03/j528rtrj59nw=
X-Received: by 2002:a17:907:3d91:b0:ad8:9844:1424 with SMTP id a640c23a62f3a-aec6a679745mr256733766b.61.1752847437948;
        Fri, 18 Jul 2025 07:03:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGL5L7xyx/GAQu0UBBfJG5/U3fVkMG2iFfJlLejFDLSpsq/uY4hPy7lwcxw1lhaQvlYDeTpjw==
X-Received: by 2002:a17:907:3d91:b0:ad8:9844:1424 with SMTP id a640c23a62f3a-aec6a679745mr256725866b.61.1752847437276;
        Fri, 18 Jul 2025 07:03:57 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6cad6b4fsm127840366b.151.2025.07.18.07.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:03:56 -0700 (PDT)
Date: Fri, 18 Jul 2025 16:03:56 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, catherine.hoang@oracle.com, 
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] libxfs: add helpers to compute log item overhead
Message-ID: <ibrbluxwn2khlzvvexfzmzskizedcbcojhgdntf4xz6p2lgkcy@pazvaqqmbtdi>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
 <175255652185.1830720.4881929981063380399.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175255652185.1830720.4881929981063380399.stgit@frogsfrogsfrogs>

On 2025-07-14 22:17:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add selected helpers to estimate the transaction reservation required to
> write various log intent and buffer items to the log.  These helpers
> will be used by the online repair code for more precise estimations of
> how much work can be done in a single transaction.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  libxfs/defer_item.h |   14 ++++++++++++++
>  libxfs/defer_item.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> 
> 
> diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
> index 93cf1eed58a382..325a6f7b2dcbce 100644
> --- a/libxfs/defer_item.h
> +++ b/libxfs/defer_item.h
> @@ -39,4 +39,18 @@ struct xfs_refcount_intent;
>  void xfs_refcount_defer_add(struct xfs_trans *tp,
>  		struct xfs_refcount_intent *ri);
>  
> +/* log intent size calculations */
> +
> +unsigned int xfs_efi_log_space(unsigned int nr);
> +unsigned int xfs_efd_log_space(unsigned int nr);
> +
> +unsigned int xfs_rui_log_space(unsigned int nr);
> +unsigned int xfs_rud_log_space(void);
> +
> +unsigned int xfs_bui_log_space(unsigned int nr);
> +unsigned int xfs_bud_log_space(void);
> +
> +unsigned int xfs_cui_log_space(unsigned int nr);
> +unsigned int xfs_cud_log_space(void);
> +
>  #endif /* __LIBXFS_DEFER_ITEM_H_ */
> diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> index 6beefa6a439980..4530583ddabae1 100644
> --- a/libxfs/defer_item.c
> +++ b/libxfs/defer_item.c
> @@ -942,3 +942,54 @@ const struct xfs_defer_op_type xfs_exchmaps_defer_type = {
>  	.finish_item	= xfs_exchmaps_finish_item,
>  	.cancel_item	= xfs_exchmaps_cancel_item,
>  };
> +
> +/* log intent size calculations */
> +
> +static inline unsigned int
> +xlog_item_space(
> +	unsigned int	niovecs,
> +	unsigned int	nbytes)
> +{
> +	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
> +	return round_up(nbytes, sizeof(uint64_t));
> +}
> +
> +unsigned int xfs_efi_log_space(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
> +}
> +
> +unsigned int xfs_efd_log_space(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
> +}
> +
> +unsigned int xfs_rui_log_space(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
> +}
> +
> +unsigned int xfs_rud_log_space(void)
> +{
> +	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
> +}
> +
> +unsigned int xfs_bui_log_space(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
> +}
> +
> +unsigned int xfs_bud_log_space(void)
> +{
> +	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
> +}
> +
> +unsigned int xfs_cui_log_space(unsigned int nr)
> +{
> +	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
> +}
> +
> +unsigned int xfs_cud_log_space(void)
> +{
> +	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
> +}
> 

-- 
- Andrey

