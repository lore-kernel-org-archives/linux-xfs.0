Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC09239561
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958691; cv=none; b=M6MEukKBvGU0HoVrsEK8dhwbpBVNPZ+KQS5ZgxKuNfAywL4ggF4Ar1+uq10W4Ac4minouhzzYJynydZXx/O+GfTEYjSNrobZrkhW5i0mklvFQAIaTmBZiv1XM4j6MPms27CmL9En6QH8nmDT0UDx4zFf7143nt4WQ1pijkrd5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958691; c=relaxed/simple;
	bh=DZgdvaQsVzy3FEkZ9qjIOfWCU7WN4gcYp04RM+bGGPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqqRF8me4zHkGVEotWDX+a73H9MeDpBO8IS2BYdH/+DyQrBROIMzj3YLarsRNdqLjgMLIl+oVw24R70MC6JL7B6jQV0n5c/g4HEB8kyXGVM485bTejofkjO6sv2Z/aNkK+SQDI3UNfO3U6QHP74rxdKVtekxns6ENMysZWS7u2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dWF9RN0K; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dWF9RN0K"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6f0c30a1cf8so72687076d6.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958689; x=1749563489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzY+cZCL0448RY0GID08t4arF/zf+2+XaBNqbHYkIpY=;
        b=dWF9RN0KcItDy1xVT1JBpjcQeDRKk1dgARPOhYMzBWHRaLe7MembuIsvUAxa/oE9pS
         CC5dh26yyb8/daoqayPGXBlpynOVA1NC6DnnUpJA29FAc7c8tuVoHauGnCXzyQosqZKA
         pOiIquNoG0f7TBaqB+UALf2f49KUSyoxuV38fgLGVsQOSi4pRmp2LNQK/A74tor7EiXn
         YKfFvoUcDhqDm/R2qmgRw3CrYpKrHVycP+WYFKOPVe1BIeF44PweC5iVaUYZA0yEoNZX
         OBfcXuD/KQrWtDxVarbViQCua4WOIHtrMzSDVZ9krzc9I7ELWVvrCFBpE6ZKylYldFbz
         IN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958689; x=1749563489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VzY+cZCL0448RY0GID08t4arF/zf+2+XaBNqbHYkIpY=;
        b=hsStAs2TTEFzKu75tLeguqpBxDwLvCm605Ol1+/DhkHQ2KwdGDOtjaE1n32qgcFUMm
         rsBmvvX8AUul/rcKSGd3l7QaDI3WMIm8dyUxXVwi2hBJyzGEfB7VIBvC1YE/2deUbn6X
         SNiTt2pHDcMpAdNo7HCvc29J3JfCQpMf0ckdrAHOk9DWZUh+673/9xIwUuvWykij4bT2
         jSYkgzcbtPVF/uzUsRfahXj7t1U75jiZTzbgoCwbpy9VYnO29XG+rMFmldfEDNUXmJgt
         GUQoLr3F/IC2p33Wu0CHASST/jlQiKGs3UyfjK/FASLpVsT5+oW6PFH57Cn4/RgJSCHX
         9TAg==
X-Forwarded-Encrypted: i=1; AJvYcCXRTuPVH64gtm+Ev6ptP6Yu5F3YAACumbIx3aT6LmStVoLasJnWtyUYPZ6zFjIqqMpaLeDwUhheoUU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd3XrplZjaWLadV/aWZV3Vr3aKednswickxQbq/UepsaTJfd0m
	vb9wD45/EpH99yVfFyr+HI1R1KI42tDcLzUbx+S8m5Ueyg+cbsa1tePZXQV3yeCqO7sB6j/8YzC
	SI3hx
X-Gm-Gg: ASbGncuArgFChgZCbJmuGb1QqTH3ilNSZFlnmwmJrUnxhTBYCy9zeRhhkOaoyR/7WJP
	peMjJnRvVj3v7IDVbgSKt+xmCz1xCacP2DpWYtQzDZLUib0xjbBQNTAzSi0cPLF5CaXS92eqccG
	qx5HBquxbx4CnnzyFb/1q9R0dnqxJJycIvp8iJkbkWxOVOk4tdbVyUlU4P6oP8XlKsxaw5mUidB
	cPKkWfvrjthDcPwfn8AXKRbP/dsJVSYsryJ68U/w8X8YC0kogSSw8JSFtT+M3htymqcVmZCHBnb
	N6v0a+xcYX6wnxw/3JVlp9IhupgZ7gV9bK0LiAmeOR57JMAbESL0W1smtAtL3BIsUM/eiT2m219
	FIrjaipYA7hItaUlW3bwZo191M2I=
X-Google-Smtp-Source: AGHT+IFvqH9ubcC6dbv0UqQGW5DGDtp+BZ9QNaQHwHo+bs9Vg0oCfSh3AzQ5xeJI5fTattmwccxXPg==
X-Received: by 2002:a05:6214:2aa3:b0:6fa:caa2:19bc with SMTP id 6a1803df08f44-6fad916605amr159392986d6.44.1748958672893;
        Tue, 03 Jun 2025 06:51:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fad0495cf2sm68040826d6.39.2025.06.03.06.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:51:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS2p-00000001hDX-3xh9;
	Tue, 03 Jun 2025 10:51:11 -0300
Date: Tue, 3 Jun 2025 10:51:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
	balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
	John@groves.net
Subject: Re: [PATCH 12/12] mm/memremap: Remove unused devmap_managed_key
Message-ID: <20250603135111.GM386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <112f77932e2dc6927ee77017533bf8e0194c96da.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112f77932e2dc6927ee77017533bf8e0194c96da.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:13PM +1000, Alistair Popple wrote:
> It's no longer used so remove it.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/memremap.c | 27 ---------------------------
>  1 file changed, 27 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
