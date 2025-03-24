Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0232641C5
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742836504; cv=none; b=gGX42FG7UMm/WN5kQBSqyDmqQfXufzXzlx4gnpg27l1T2EIJEmNRxnQjyQno4FDLoxk/fCnmXuCke6WSgAF/aWbxigblXf1Gt/UmFhKGmBTfaZkiSztne5hBmbvhoHxr0vaIGPfoBbJ/GaYDuCnFDmQREtb6ls2eHtDEWKCcYBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742836504; c=relaxed/simple;
	bh=6JyVpqKgVOp0IOSAz6/edAOFIBW+k/AkQFChDgfvhnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzOVMwQZF8FKcVzQroWoM6XPsIxmmMe5cQ5nnOGn62CV6+l1XQ2/M36SRK7SqzPoybrjYHnvnCwt773L4BIioTYmcaAT0YE7AVnFsjKGrLg1IVd9GdcP33eAL+3R353e9HwKQ0h3TGkGKDWE2oKMYnxWEAcnS8D6HkbsWSpGTUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5KmSuOX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5KmSuOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742836501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iy6NJ2gJOtewldYXenZnM5+jMTSF74a1eCxTbu23CKw=;
	b=A5KmSuOXV6gGlpcLqt7joMjA9Va9FaJ+06bmBpbagbc4YwdVuGKq++9uoD8SvDa+VYE8G6
	GH6huSyjIRJ6YJtjFvM+OpSScRu+s+obp3XQlMM5dudN9K9arcUbiec8Lx1OnyBCfnpJ+h
	O8tuR9g3qNosvpiMBpeRqY/rlR9WfKU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-g1ZgO3aHPhSnspR92aWn1g-1; Mon, 24 Mar 2025 13:15:00 -0400
X-MC-Unique: g1ZgO3aHPhSnspR92aWn1g-1
X-Mimecast-MFC-AGG-ID: g1ZgO3aHPhSnspR92aWn1g_1742836499
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e5cc488f27so3520823a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 10:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742836499; x=1743441299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iy6NJ2gJOtewldYXenZnM5+jMTSF74a1eCxTbu23CKw=;
        b=THRFqguyEOGDB2fbPGWjw0ZMmQ4uKcgfj4sNkxHxtTXSMZFM/Hw8qBGwb0Au+7aplI
         w8jgTv/yWSHW+AwFqBP/AxXh5N2EAYjfuVOYZf1OD6OYU6L9PSsRgbVNcLVh6CzQD+qG
         iVRDKIrfL4w6ULjIXgWbBYhInjkwumgDkikQ69F/cAmDEAfYOuw9k88h/pF6GOPlZ/fQ
         qUq1/oS96ZkxA8NT31HaxMI5iGvZwLqcpTzj/NkvZ8teokH1hoOnXhsbv2PH1pc2i9On
         iPwXpFUCY6Pmg10h/pNi3LgOwymXoJgNKTofDZCLmLF+vgTqmBVrqHjmE0vF5At+ZNHN
         B5Dw==
X-Forwarded-Encrypted: i=1; AJvYcCW4NksR55jkCu16UDLvoFccguJBTk7tWJueIeFaoFvwbGwcQ2CnGpVJZPiEKV611jR/F12pfpF5CDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaNjx1PrBtGLwweh9Q5+EjTy+/R4CDxrtwFphSiA2DqUeb00+u
	EiNEEvf7Z/4QmOgTmbnuX+46yLHUO3K3lpzvIuRetL779Zwc7wwD7ouOoYk/ZDktHhKvj+33zaL
	LdUYJDQjq2bjQyBEac+sL9dD+yHGURcaPWhMcCm02mwDHUYguft38sfbrluRTA2oD
X-Gm-Gg: ASbGncsSaXHnKjfDF7w2oIseWEBEo2EZnsPVMTTjcRdZGTtwFQYjF/jaYoIkYksx+j5
	6FuWMh7QmRNFZrYwRZSHpT8sHtg2DvYD0H3XRYnKg21uK2mHVWChM+KljDjzmrpZWZmsLdo65Ja
	wcFMSZnGktEVGukWCgGc4bf00XpdxXXN/nkTESzYZRfVZipphKtcEdVESBiiNz03ffwZdrEaeUb
	dFl2GfRavHu+KrVxg8JKGXxrBeP5p8cgxYU3sZVIY/ciYC5mAcGn6LtKyJ/+2QjYtlMskeamBVL
	2dRIFUIC04c7YHKI9vHVld25iW2sZDTTirA=
X-Received: by 2002:a17:906:730d:b0:ac1:e881:8997 with SMTP id a640c23a62f3a-ac3f2087ebamr1346036866b.3.1742836499120;
        Mon, 24 Mar 2025 10:14:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7Cs03VQlR279VXk2xUxkF5buzbOyHvU2+6meM4ajYYaYl88zL0cNmpkk1RhkJ7pGRiNYL1A==
X-Received: by 2002:a17:906:730d:b0:ac1:e881:8997 with SMTP id a640c23a62f3a-ac3f2087ebamr1346034466b.3.1742836498684;
        Mon, 24 Mar 2025 10:14:58 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd3aa21sm716403566b.158.2025.03.24.10.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 10:14:58 -0700 (PDT)
Date: Mon, 24 Mar 2025 18:14:57 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs_repair: fix wording of error message about leftover
 CoW blocks on the rt device
Message-ID: <q6sqwanjsdb7mketxdtufvsp24gtaz3vbjeanmvjutcevwvpev@oxirec7wl7eb>
References: <20250324170951.GR2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324170951.GR2803749@frogsfrogsfrogs>

On 2025-03-24 10:09:51, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the wording so the user knows it's the rt cow staging extents that
> were lost.
> 
> Fixes: a9b8f0134594d0 ("xfs_repair: use realtime refcount btree data to check block types")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  repair/scan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 86565ebb9f2faf..7d22ff378484aa 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2082,7 +2082,7 @@ _("invalid rt reference count %u in record %u of %s\n"),
>  				case XR_E_UNKNOWN:
>  				case XR_E_COW:
>  					do_warn(
> -_("leftover CoW rtextent (%llu)\n"),
> +_("leftover rt CoW rtextent (%llu)\n"),
>  						(unsigned long long)rgbno);
>  					set_bmap_ext(rgno, b, len, XR_E_FREE,
>  							true);
> 

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

