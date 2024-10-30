Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C871E0DE6
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 08:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730276665; cv=none; b=kP3Er1YcNll6iv3NzAW5XAgicwoaeXpTzD0krU+2boEVj/7CCW25HL/NZeHywyuD0oWfPxRmPz2kAGlJtsCxq7lNSu1arPki37yfLJvDo+tTr6nIgqgpNeqfXlyWzgDsSe9MjB1ONy91bgmz06BWcj0nl3GuxMPN9IILRdUzjtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730276665; c=relaxed/simple;
	bh=6/KCSEHL0bPeV8vkebornipfXAVIx3D8A9g61In7qK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjD6+9hXVVWwnUiVfaslRcLRO8Kofd9jktcqk3OckEgVsjDIAbl9khGR1rFWefUzHpP4ChR5rN1V8eEcxDGXOzAvGFCjrOWcQHMeba+e/PR4bXRradoxFJNmKwRsb7+hpGblHzlVahI00vtf0VLMHxkX/yHaSeZWmTc3EodJDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AlyaoJmS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AlyaoJmS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730276659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8HzENhThXZJHw7HEXI2tc2W81wApxk4YUtVOooW4Y4Q=;
	b=AlyaoJmSNbILgcQiLzO/Xc3a/AX6KHNImoAvkoU0+nd6JHR8BWKvru5AFVrcG0RPbAbLn/
	wih2lHXNhALF3D77dy1q0Xm1YJAphdopBcQNByBHk5MzgzbufWalQhv0mMDZc1RofLGxpY
	q4Ki9sHrureQKdSeLKXQWs+6os/uRuU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-n2QdTav2M6WcEdXYjQUQXw-1; Wed, 30 Oct 2024 04:24:17 -0400
X-MC-Unique: n2QdTav2M6WcEdXYjQUQXw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e51a31988so8969157b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 01:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730276656; x=1730881456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HzENhThXZJHw7HEXI2tc2W81wApxk4YUtVOooW4Y4Q=;
        b=INFf8e+0TGxDSlsvFwyxjcAP9F2AWYDTMpGaxFf43oAvD4Y1NhL03vXN00s/PE0/tz
         xIWYxY9uVJQQEIu7JJYWBaYAeApANbOuiWb2uGlwJQB3GXXkLNwCEzUPNnYkdgdZXmat
         aRXwrWMPf2B23QINnr/UZyk9aitMbRG19XeYF6JTLR8/escE6votJwxO/8fwWNwXr3WO
         9swDNAw4cj9DQ9GMrn0Nnx9ttSbkztKxlBdGyadCl4AHjEVOXO7SenA+1jOXzFNOmEpX
         z584oK76bvd08x/mx900qRJLgmQsls4XGCeUiMQA7xRmR7pvDyRA96EHzNkmbjrNOsGq
         BZJA==
X-Forwarded-Encrypted: i=1; AJvYcCWP7OLVpBy1JaAysmm2begGP8Erj4i5ab098rv77sF9CewbHmpIJtmjRgp+NA9r1VSq57s17P22zU8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx670LWTjtGGQcEsKbi1wogdZ6E7l91VkRSEdFoMYORBgZ0Uhuq
	apqltBewTl4X9VS9yeZJR+G8HmT/XOeFhffRy3AmwkWHFbbmAPrxyrPAyLXx2Mc68Rz8Qf/mMCt
	lD9p9AwJfboAOyhKoSoKsQE1GuFC9hqAjkurK45JOn+zX06LhgMzt+Hpn9+7C/c6Nd0o3
X-Received: by 2002:a05:6a20:e68c:b0:1d9:1907:aa2b with SMTP id adf61e73a8af0-1d9a83a66a8mr17082996637.1.1730276655926;
        Wed, 30 Oct 2024 01:24:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF60KwfWN++axEaCcsvJO5Y9cIzs1Hv8qXkFcnK7G3o2DhylVm293dchMNOmA9djrRPAx9XFg==
X-Received: by 2002:a05:6a20:e68c:b0:1d9:1907:aa2b with SMTP id adf61e73a8af0-1d9a83a66a8mr17082986637.1.1730276655630;
        Wed, 30 Oct 2024 01:24:15 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a0b82asm8790222b3a.111.2024.10.30.01.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 01:24:15 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:24:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241030082411.nadgz24gjilmzsop@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241030043659.GA32170@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030043659.GA32170@lst.de>

On Wed, Oct 30, 2024 at 05:36:59AM +0100, Christoph Hellwig wrote:
> Still looks good to me (but I'm a horrible test reviewer, so that
> might not count much :)):

You review always counts much :)

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

