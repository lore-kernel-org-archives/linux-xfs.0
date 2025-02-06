Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0645F1A3174
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738853960; cv=none; b=lrcaeHexGXfgF/zvyIF82OPzmpBWYPq1MWtkX8agd82sLIB3A/aBg5llZLTtVMUpPOOIVwoELh6wS64WxMqcHp48noxevJsZba35GBOYcCKRS+pEKjmVTexePV5WoGUjSCOy/bWwrljv84aRy35q6r/tCx86v4LhOYhKGegaGqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738853960; c=relaxed/simple;
	bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILHH5iOHEaE1u1Po3S4vDp+tdCkOe0bUK+UfhE3ZaPnNySRzKcWmPaHYIvByuRdd/7mWItJR1G44hRhwdiIRNnlgJUYhjyBwfZTOxwjPluJAzgMfvRIo7g08aHGK+8p0w61uJcNobLOvz0c5wRzMVGeD3og8xfFZ/L2fM/B1Y6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=igrQxKZE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="igrQxKZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738853958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
	b=igrQxKZElbRVzkWpjpNynOVBY92px8U+QgAUsMxACL9Lu49CVcy9nLi5eb+XJufMVfjnSi
	SZRjSwu+HIKp8KdY08yTnVyzU/8xHCfzU9/Sd+1W0Z8nH/r8ZiheGNWcyeT7+kPvC0ApdJ
	QVAd8tAKXEd+XmAG8jPTce59NiByvhY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-vLEjKt4AMrO1yxRpLOMNDg-1; Thu, 06 Feb 2025 09:59:16 -0500
X-MC-Unique: vLEjKt4AMrO1yxRpLOMNDg-1
X-Mimecast-MFC-AGG-ID: vLEjKt4AMrO1yxRpLOMNDg
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2fa166cf656so652761a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2025 06:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738853955; x=1739458755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
        b=CWSM8n78HicMz7w/C3sINrJ6iDsBmrBiZ4ixaPRQG4V+0hKFBEZqgRv7qjLSeO7705
         F8z2LtZlgmNryX5ljc2D+NuN5RoZtMaH5er63M8R9GFHN8S88958RB6xCT0wWaAecypH
         4diRimmO2vzNZI2W3U4TIWVAY2mU3WnHuaZeyTOoA8TAiFduk81n4GFNzFRa53d6APEm
         GtbYrMRJNGEht8tkTq9B9kTO+l4buCJ9GSTeqB7gix+sbNb5R/z2IXI6Ymc4xIg0A/mT
         CMlJ0Oj530FTs2Y3kdJCM3N2LJN4kBxgw4O8tMXiHZRKDbH27fX5jtRCwfafYi4hB7cr
         xvcA==
X-Forwarded-Encrypted: i=1; AJvYcCWvCoMF+UOd5H0JaEFCk2KB5I9JyiVbvn+XU5tJ/dKOu+Pfk5Up2MJnsCAZDuviKHVK4fbheAxAGXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqOv92XG3H8mP6hdnKgBXScZEjxujfqpHDdvEymGuugc4e+uHa
	ivZO8ZtWyxCITzDR++7dZXBExi1zlx2GghUXKq57yte8+CxzMfTbMeo+0ibQzNWMN9HwnR+4ztx
	ovsD5KGFPK3Etb4rnxA0o+ld3eivmgyTxcsRHzzXkmIQ4+AsrrszfBJ8q6Od8lmuAd+VkyxtlaE
	4LUEhQaCZhKkzS8xh1hA7nwiYr6e8tlO9j
X-Gm-Gg: ASbGncv9gfgAn+wEyF4CftYFF5CS7rlv/DGIQSO/CYSomIHQUv07VMJrrgr5NBv98Z7
	srdyAgUwLJ2uf65zEhpcEul87NMixtKeyQJnkwR16zeGCoLmYyOHVvmh9zDBkCuMI
X-Received: by 2002:a17:90b:2786:b0:2ee:e518:c1d8 with SMTP id 98e67ed59e1d1-2f9e082f33emr11110484a91.30.1738853955573;
        Thu, 06 Feb 2025 06:59:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWpQlGfjL4+bcsd9CXoOi/pDbHuiuuwkJUWCLm8Y4KSWCpEnRWVj/utErs2ioiglleYEOHWPatBsG9+Rhw180=
X-Received: by 2002:a17:90b:2786:b0:2ee:e518:c1d8 with SMTP id
 98e67ed59e1d1-2f9e082f33emr11110445a91.30.1738853955312; Thu, 06 Feb 2025
 06:59:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <bfae590045c7fc37b7ccef10b9cec318012979fd.1736488799.git-series.apopple@nvidia.com>
 <Z6NhkR8ZEso4F-Wx@redhat.com> <67a3fde7da328_2d2c2942b@dwillia2-xfh.jf.intel.com.notmuch>
 <Z6S7A-51SdPco_3Z@redhat.com> <20250206143032.GA400591@fedora>
In-Reply-To: <20250206143032.GA400591@fedora>
From: Albert Esteve <aesteve@redhat.com>
Date: Thu, 6 Feb 2025 15:59:03 +0100
X-Gm-Features: AWEUYZm-M5VdAvcj3hSDqRtWWsY2KSl-UpKtCd6mALNvZQI6X9XPfCW9uUgmKYc
Message-ID: <CADSE00+2o5Ma0W6FBLHwpUaKut9Tf74GKLCU-377qgxr08EeoQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/26] fuse: Fix dax truncate/punch_hole fault path
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Dan Williams <dan.j.williams@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com, 
	gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	logang@deltatee.com, bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, 
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au, 
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com, 
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, 
	david@redhat.com, peterx@redhat.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com, 
	hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name, 
	loongarch@lists.linux.dev, Hanna Czenczek <hreitz@redhat.com>, 
	German Maglione <gmaglione@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

On Thu, Feb 6, 2025 at 3:30=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
>
> On Thu, Feb 06, 2025 at 08:37:07AM -0500, Vivek Goyal wrote:
> > And then there are challenges at QEMU level. virtiofsd needs additional
> > vhost-user commands to implement DAX and these never went upstream in
> > QEMU. I hope these challenges are sorted at some point of time.
>
> Albert Esteve has been working on QEMU support:
> https://lore.kernel.org/qemu-devel/20240912145335.129447-1-aesteve@redhat=
.com/
>
> He has a viable solution. I think the remaining issue is how to best
> structure the memory regions. The reason for slow progress is not
> because it can't be done, it's probably just because this is a
> background task.

It is partially that, indeed. But what has me blocked for now on posting th=
e
next version is that I was reworking a bit the MMAP strategy.
Following David comments, I am relying more on RAMBlocks and
subregions for mmaps. But this turned out more difficult than anticipated.

I hope I can make it work this month and then post the next version.
If there are no major blockers/reworks, further iterations on the
patch shall go smoother.

I have a separate patch for the vhost-user spec which could
iterate faster, if that'd help.

BR,
Albert.

>
> Please discuss with Albert if QEMU support is urgent.
>
> Stefan

