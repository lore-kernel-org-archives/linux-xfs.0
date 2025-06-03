Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17012376E4
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958472; cv=none; b=qN+6rfnNxZpvk43Y14NLqKOHD4JNmFrwIeACoGL37IejVC5ZH2i3x1rqWRlCGILS26eEd1Du6q8iv+wgAEByWW63TUDNdMSjthQSZ3kUwTs+SP4+DR7PCOwEFHDc0gUz18hUolST8vzXnE9R8qrRzbZwaTf4D+Cf79PAutDQSZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958472; c=relaxed/simple;
	bh=QuA4bLScr7zZl9oRdPCFKpAujll0Lr/hMN/nG963i68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LehaUMj4xmO8CXvPqKBTLVmp+ObomDmfQZzsbHRjVxAgIKZtO8Vq3ZXlttpbY6aXOyLgSxdkQ1rB10IaPksPQUG0NChVxWrAetR0rJGL0x9ws+/3d4PYZqM1M/ytqcoWQNLB3Y8+cWfzWHkTKYOZFa4q895QC4ubkH8lbmvg2lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bcbblDxg; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bcbblDxg"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-606477d77easo3289717eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958470; x=1749563270; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpF3njOJtHrMyikmrAfZ4zzOg2YUvEVFUbKoE3kb2rM=;
        b=bcbblDxgaCWpXfttqmUcdoBoYMbuay6D8z7S4RlHmwfg9FWEFerb/mKsF3806mT3F1
         +aspVIhWyWVbnQL4vAxjsApLcyRisrxoBGXPJFuWGESq65R/E+xIevTVOjpR74I0/y2o
         5hgqYceelth0nebvZWKjpqdAlbrdxBVpwbWFiPfwOhNYuoOHO2OJc/R3u77bzDsgxOz3
         YPNH9j40XI1UuIvlytU1x5oB+i+0ifWfYOF/ym+YnoStzsmbtcqTOIzU1lgtZPvyCgqZ
         xxo2WEYmh1a8DDHv+pocQwyFijicYQvSbWw8VrKRF5p5RkG7jhn0rwkNMcsVe37DyV1d
         2BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958470; x=1749563270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpF3njOJtHrMyikmrAfZ4zzOg2YUvEVFUbKoE3kb2rM=;
        b=G2HS7F4uWC5xVpkCWQ7QjiSKNW/QYtE6xlhPgy4myWv1JIUJLoK4yVrgVO6gWSlPyi
         bt4oSzZi5tFrJGk9dh4ZzK5MxDfupCyK4ZTAIehMFf5aRKcKPtJs4eb4KLf00jjJ3EOy
         PWIhbrfO+eNeb/vyjsWi7l3ejhqvyyIwoEfBxBueV54GBRpERanl8hiUmPoKxpmzqb+Y
         9FAyXIbwqfVktwmdkZZTYmTpK79WCrJ5fOY+eTI8UThIpSc9yTdKpZr0PiKO6lxdQLZJ
         16OxIJiK6/RjjNFGe5v9yevLdeAauyJEU61Faq3kbX+KFC+ESd/OOXAgFZyTWcrXtQfN
         NErA==
X-Forwarded-Encrypted: i=1; AJvYcCXu9DGhKuAt9sDP6J51eoisgfGo0IpwNG6Zkt6YDKloMwRCs03OFDsWHRqEkcK0Zb4p3Ex4aq6ho48=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzb1LKbmTgTbh8nJ6X5y8+KrIzx5qtgULvgQYmD8iV5smFxlU6
	Gg+YkpHduMsvQ6t7KXPqmNWID8W8mTj5g4g8heI1fXHMmGSh8iZxqT7Vq5sxENyerbAfLvpcp14
	IRq6K
X-Gm-Gg: ASbGncvwvKk8HaPqV2FLpkNyJYEeEZiiBc7iKpfcTXmDExLYeWRQdtcuxBSRiX/Jvzq
	iivIF0chqtuyFIPxAps7/B0AzLm964eWI6n2xorIGtFD8FKeGpy1XmHKeFesFeoy6iV/drSMO8B
	ujlhpCBczbOtHXmo39h426pu2Zd/0xRIBH5iBSvHEzYTQT2FBKjYvLEwIOS0w3ME5pKxk+NMjy0
	kj2eIimflD7GzeyjxrCRakwUi38Bh1hp6luDE6bvUJjVauJXxmx7XbuzqmSCw8Se13MFs2O42t+
	oTO8M3i/PDpxHWsv8UrsSJRuSsuQogBjvTTuZPHIeGYW+kWNYAfRaquEof1ioiVjyF4x8FKsHNC
	jgz+NDy1G4qDcrZLBOQInbSZV+f0=
X-Google-Smtp-Source: AGHT+IEn/uCXnqGk9mGrQEIlQbsguMg4s70jmRhOs28+dV79kPuZtTFgI19mnXFgGkPMbOXTAF/Qjg==
X-Received: by 2002:a05:620a:278d:b0:7c5:d71c:6a47 with SMTP id af79cd13be357-7d211676724mr394455585a.8.1748958459265;
        Tue, 03 Jun 2025 06:47:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a195d7dsm840098585a.78.2025.06.03.06.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:47:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRzO-00000001hB3-1CmA;
	Tue, 03 Jun 2025 10:47:38 -0300
Date: Tue, 3 Jun 2025 10:47:38 -0300
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
Subject: Re: [PATCH 06/12] mm/gup: Remove pXX_devmap usage from
 get_user_pages()
Message-ID: <20250603134738.GG386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <c4d81161c6d04a7ae3f63cc087bdc87fb25fd8ea.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d81161c6d04a7ae3f63cc087bdc87fb25fd8ea.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:07PM +1000, Alistair Popple wrote:
> GUP uses pXX_devmap() calls to see if it needs to a get a reference on
> the associated pgmap data structure to ensure the pages won't go
> away. However it's a driver responsibility to ensure that if pages are
> mapped (ie. discoverable by GUP) that they are not offlined or removed
> from the memmap so there is no need to hold a reference on the pgmap
> data structure to ensure this.

Yes, the pgmap refcounting never made any sense here.

But I'm not sure this ever got fully fixed up?

To solve races with GUP fast we need a IPI/synchronize_rcu after all
VMAs are zapped and before the pgmap gets destroyed. Granted it is a
very small race in gup fast, it still should have this locking.

> Furthermore mappings with PFN_DEV are no longer created, hence this
> effectively dead code anyway so can be removed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/huge_mm.h |   3 +-
>  mm/gup.c                | 162 +----------------------------------------
>  mm/huge_memory.c        |  40 +----------
>  3 files changed, 5 insertions(+), 200 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
