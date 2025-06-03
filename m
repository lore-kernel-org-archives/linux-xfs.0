Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3684E238C26
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958529; cv=none; b=YTTJT9dMmXvlwlhI/8aSGJIUgq1BxihB7l59t0ycdrqJMwkgnzBa/iG7TS2KWir4lSIrhwqAXzleKniEgYVXUT+go5lxcdqA2qzndPC6AGm0bmoirRrR7FDFYZgA+M7aIF8tWOeCvZ2++VJIRCz+yq0Nhb+wBGfRVF8j2ACSLJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958529; c=relaxed/simple;
	bh=RcXEhllfDG955BJXEN1tqIgpRJ2MsHzTBep7rZd+naY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRhPH33J508BPxxwFfeHFgndvbtjeLhNFCkyqgIHWjDwy+3i+BBkn9WqOnNiIv5pxO7jXNyEQd2a/rWT5840Q1QmsG61phSjHMejiGBGMNOKOvKy3m8D+0OrRwG8v3QOpTW6H86tWmkeNaLxx1b7yicUub797/9RgznGoOBVkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=KoP8asrO; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="KoP8asrO"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7d20f799fe9so129065785a.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958525; x=1749563325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSTZfPDDH1MLe7AQH4Yed2Uaqt/hLn+gokhyp0JhueY=;
        b=KoP8asrOMIEJethoS/itlxDSGu3+zKoaKa8sDFbGOOwqgCYGuYTFZfYS8Mnkx+tl2G
         LjxtWypcZcjUxtywmuy3LTV23DzErA2mqesc1QMxuKAF1XQppJ55Q57IUPuLTyiUn0Sk
         YS/uss7FvucPNO97r9KoOsxXLFtUQJm+qNUu/DkymsWRGtNsFPMKPn5wT9vBJuunJkBi
         /ukr6MpVltCAllXmAe7Dx+EhPp2hMVvhbhJNotnIQu7A2DxkaHLbi1S2kV3TyJK+7eoh
         hFWkqGTwpByFV0dpwd0TOBMUr6BTdcw6HqglUcBifaQWg5i7gw3KGyxZEuz/Utn1gmBa
         rs/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958525; x=1749563325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSTZfPDDH1MLe7AQH4Yed2Uaqt/hLn+gokhyp0JhueY=;
        b=My9h24nyXOXiv9DiF/Kwqz361q74lNaa2nV2yBlZja/PviE2Wdi9RPAWtmoi3uhxQ8
         Xpqz1LgRA7LPjjS8R95+rG4q50FNsna9bqWVgZS0FD+/kpPszzt47fQT2QoBWDJkjqTC
         Ke27c5yxcJ2SYNh+qMqauYxaOAbB1jbNhyVZ/azh1z7tsKfdH/EtmQNGgiBm2UP/2uw+
         QItLGPeazbvGcH/vgRXfmsUEZqGArOiotWL3FaUDdCh0ora8f4+tUSjsZ8BWfIH6x0E+
         nN5OJki6VkqLf8Cy2U+kLrsxhy1FGlzmWJJOX8ktbIX3f6xEMyjX6EwLYAzQlOPIoPcV
         Vn/w==
X-Forwarded-Encrypted: i=1; AJvYcCXCmP1dQ4v4jmdw17YZvTR1DMW9J/CEauIB1x21tUjEcrSVGstf//wzepyK+ujCgwTyOx5xgMo5Ul8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj8ZQrF6eGN2iyP6eoWyy2ws3C2iO8T73S9NnnV4EX1VLfVT4c
	72thFWSryq45A6cnLlaK3m6MHl/NATQpk6GqJUaoXmTLIc1dabABSP3pvVGUiCsm2U8=
X-Gm-Gg: ASbGncuUias/jxLfU9Sy1eNLWpoQaN+TbpMwPFdA4q0PUVy9GsArUp/6lK4dmTNwEPg
	6qtcfREj/Pk+QjGmy/zGWskimuGhccon7h6Bk57KX1FYRtPJu13ATevxqjbyqPTLpo6jsCGDTdc
	wWbYIPZBflxfuGfVc4ZXr9kElHvWKCvvrF/rdSOnqrdoI4ygHfitwWEC/QCPmY2TYSHPoN7ReBD
	mjlk8Q47Dr6T8SrmKnErK0utGb6GO1DRNtO3XeNGd8HUe82dqSvajids2N/bmy4L63pNg7piZcr
	68pX1LZd7NEy+KUbttj+CB87RhpNTBuaCJlBHIQ3rA3R/6eeJfuAUMUUPwpAx1cUPkUV2OP+10+
	kpQeQLX40TqJeaCw+eSammJzHjD0=
X-Google-Smtp-Source: AGHT+IH3Vn4y24ccOnNjvyrMKRdXMvoXmINXxWtKUHHRDjsnlypx2qCEJce143rhCfMATkU1PKi1PQ==
X-Received: by 2002:a05:6214:27cb:b0:6fa:acc1:f077 with SMTP id 6a1803df08f44-6facebef794mr265266426d6.35.1748958525108;
        Tue, 03 Jun 2025 06:48:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a10e844sm842209085a.49.2025.06.03.06.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:48:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS0S-00000001hBt-0o7d;
	Tue, 03 Jun 2025 10:48:44 -0300
Date: Tue, 3 Jun 2025 10:48:44 -0300
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
Subject: Re: [PATCH 08/12] mm/khugepaged: Remove redundant pmd_devmap() check
Message-ID: <20250603134844.GI386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2093b864560884a2a525d951a7cc20007da6b9b6.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2093b864560884a2a525d951a7cc20007da6b9b6.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:09PM +1000, Alistair Popple wrote:
> The only users of pmd_devmap were device dax and fs dax. The check for
> pmd_devmap() in check_pmd_state() is therefore redundant as callers
> explicitly check for is_zone_device_page(), so this check can be dropped.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/khugepaged.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
