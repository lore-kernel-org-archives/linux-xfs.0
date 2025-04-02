Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDF518D
	for <linux-xfs@vger.kernel.org>; Wed,  2 Apr 2025 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743587722; cv=none; b=U4zzRkKhGW7YqSE90ixrC0q3k0UHSiqwElSiGmrOax9mVwcLn9AdHblu72R2uHPH0cGSzY0W3k2ZVuJ96Pj5IWUC+CXt//9aVi/t/O/+htBbwOAhMd8de2ShLNFmqU1wOCEk80ehvhbJv6KIi5q9E2GvJyeHXIvnCKWEkPlYzNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743587722; c=relaxed/simple;
	bh=0amBvtok1JzeQO5FpQUWIMWssQGGcX6ztt++eipu/uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfO6O0Z0HD67Mt1gvqoE/GoRl4Ab4vPYli+giTQkk4mjLhtRU292+GveD7V4Dj+gQWcynWbd8qaRSA9F7X+MuTb/+VRI+TgFWOmQ33rE5/Wlm1DUOVMVU049WYunc2vD03u/ijh9l+TVPaZ1dQSs7E++U35yly6/dPutadzMoeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N1VkYsSC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N1VkYsSC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743587720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yBfTmnvoYRVL6sOPe3roEG1p1ZwmMkDVG3mb/ziHMg8=;
	b=N1VkYsSCMo7lePIBjMmC5jBi9GkT1n1x3ovwuiniQPPoy15lu7QRFieBm0ee4DOQZtvTZS
	aWhQWro1T1F3PN2/JmQrG+jNtTXrLV3MEcPNlQ8UK8m1GbLFGPWqLigCFlE5ppnF+KC6Ra
	t4dJXirdNHCm84juCOXFBlOeaUpbn18=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-NVx1KGKTNp6kbPr5l5erlA-1; Wed, 02 Apr 2025 05:55:18 -0400
X-MC-Unique: NVx1KGKTNp6kbPr5l5erlA-1
X-Mimecast-MFC-AGG-ID: NVx1KGKTNp6kbPr5l5erlA_1743587717
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac6ebab17d8so571097566b.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Apr 2025 02:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743587717; x=1744192517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBfTmnvoYRVL6sOPe3roEG1p1ZwmMkDVG3mb/ziHMg8=;
        b=tTSqbmJEAdym8jGap/kaSVHwXpcpuTWmD5DNQwOQ2LfgC8lOIa1Bb3L6hCG5mvYIs9
         qbntD5HuxJmbGYaoZtEiELXBjHvVTSdTxpIg1mufFZtAM6MbqjGEoLjTzXzjtBPhoSv8
         ldXkhGeVcYql3HMQD5J8JuWUsmWjghfwVkIchf4szDge6PiOnFxGW3wPv/TERnighfjL
         43stgDPNONVQgUFfJtK5rxxLOVqKC8w+4lZCcytUwvP8eVRWzmq69BYiS5K0ETlU3JR2
         OIa73Qb4gpGIllHiaaZgydS6PiILW2jzXLa3Cl5HZrK7Pso9RJUGXBXHf0WmaMlbSYBT
         Wgjg==
X-Forwarded-Encrypted: i=1; AJvYcCWK+Qm08+Zrsy6J2oUcmov3rHzaXrjE2sLLdo3LdUAu/6vplGxNZkc9xbiQ81nlC8w8RVNjel1uokA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyYCZ4wdTkMmUy3fylXfdzIP4OX+gL7rms73kZLe46ge8Mxldq
	QOIlo2CWSFuQp9xYnUX4M4fhms/o3ohBMw7zLD717QaDAHhhTdI/vt/gahdiihXfxV2rnYXaWIt
	OvSSf97DLVe0bmcLFfphboLg6D22AVXsOF3lBb6114+Sy4eUU/W+1yJGy
X-Gm-Gg: ASbGnctYl+PY/rrAydHIx3C3bstSCL6oCVTpGQY6kYNUlcpmz65rYBWg1BR/5Cbvknh
	RkGgOv3uueeaZnjKfQV5xLgOCYagr1e/+MwKupiwuWPZxGLKRVYqTNVivWutHdjrmoFg4LzoCNq
	IoSEmGcFVx3OAhw8/MDVFVOFsHxrb60Iai/4kZMDVe/izry5oPId9nLMk0tIQiZh6VIQZD21D4i
	nQ7/ajkIsDJ8RmJE6XADiFShJbvxDzeoYg0i6jJlqWa1oW0IGxm+1u86M1nzoO+SD8aX+l34RwG
	72bHuD2rYtQWrSlTJR4Mk+MkLlIHrZnBEgI=
X-Received: by 2002:a17:907:3da7:b0:ac6:b816:454f with SMTP id a640c23a62f3a-ac7a1adf3ddmr143135466b.54.1743587717456;
        Wed, 02 Apr 2025 02:55:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW4NKZI7SZVZ4xnE50vXYyz9zzxpN8qaZqSlbysZBCx7leepwwoJEyXrIkOI1sv0Vo1HTwfQ==
X-Received: by 2002:a17:907:3da7:b0:ac6:b816:454f with SMTP id a640c23a62f3a-ac7a1adf3ddmr143133566b.54.1743587717070;
        Wed, 02 Apr 2025 02:55:17 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922babbsm891693866b.5.2025.04.02.02.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 02:55:16 -0700 (PDT)
Date: Wed, 2 Apr 2025 11:55:16 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET] xfsprogs: localize the python programs
Message-ID: <3nkclmlothgzwveoxb7fta6reroj4odda6xp6abe2tb42vuoxn@ekgzszu4h7hs>
References: <20250321212508.GH4001511@frogsfrogsfrogs>
 <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>

On 2025-04-01 07:43:25, Darrick J. Wong wrote:
> Hi all,
> 
> We ship two Python programs in the main xfsprogs package, but neither of
> them actually participate in gettext, which means that the output is
> always English no matter what user's locale settings are.  Fix that by
> adding them to the autogenerated message catalog.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=localization
> ---
> Commits in this patchset:
>  * xfs_protofile: rename source code to .py.in
>  * xfs_scrub_all: rename source code to .py.in
>  * Makefile: inject package name/version/bugreport into pot file
>  * xfs_protofile: add messages to localization catalog
>  * xfs_scrub_all: localize the strings in the program
> ---
>  configure.ac              |    3 +-
>  include/builddefs.in      |    1 +
>  include/buildrules        |    9 ++++++-
>  libfrog/Makefile          |   18 ++++++++++++-
>  libfrog/gettext.py.in     |   12 +++++++++
>  mkfs/Makefile             |   11 +++++---
>  mkfs/xfs_protofile.py.in  |   21 +++++++++------
>  scrub/Makefile            |   11 +++++---
>  scrub/xfs_scrub_all.py.in |   62 +++++++++++++++++++++++++++------------------
>  9 files changed, 103 insertions(+), 45 deletions(-)
>  create mode 100644 libfrog/gettext.py.in
>  rename mkfs/{xfs_protofile.in => xfs_protofile.py.in} (85%)
>  rename scrub/{xfs_scrub_all.in => xfs_scrub_all.py.in} (89%)
> 

The patchset looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

