Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC126290
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958665; cv=none; b=hqEVL1E485VwQ2CBsnhS2WtNjYr5edG05rB9Ot8hCfbA+WmWFRP7Lv3gnLGkSr2dCcJTJvzoCmXQ+tybinn5KzDXGd4zM1S17EoceTjMpIZlT8GNKewokKZpQeaVcQCsovY/CVYfOVB+X7AHUGIfgvK1HXnHtZurQZzOcHrOIHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958665; c=relaxed/simple;
	bh=TpMwl2oz7EgmR302mml/BLJBQvaM57yfpZzI6Z7p75c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4DfAGQ7LdNYcurjxuZAwO7RhPgNcwnXkJRAGELfxN+wwP6jDwmsQEEts1teMH2uxkAjmzUD6DR4gA3/+IkDQlzCorjgdvRTAszhs+Mq7wxVGKV24s1gQKHk5BbFM5SLd4IgNguLk/oNmWdKInXeDgaAphmnWPiW7k72cH0mtvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IO6TmEXJ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IO6TmEXJ"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6f0c30a1cf8so72678566d6.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958663; x=1749563463; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjoJn2Zm/22QHFjhWW1StoVgQrArf1QtKVAZNo0G9LI=;
        b=IO6TmEXJh52J8AnDPQykvYhKW0OYIaHlj0KWvm5HtqbsHPS7O+KwM+SyR9ww42o0NL
         8Au76VJC/JiKr7/lVwe0/VKri2d8ux3QJGelN0aC768XXNLfO+Fcwklfd+RBSG4G0wKz
         JijYFQSeNXm/njazPqHB3lVDE2qKHhuCiCKv0TkG6VToubtl/JNp07ab0/Y2CpV0zzhI
         6fdBEPs+OrS6KsvxbgwgusRF9RnK+gr4obGNj8hMCasK0+U7gny15Zm7III8CPzsnTnD
         JADACx82Z24EuuT519fb74fel7FSnSesUXcOkoTvTauLvcETJ4yfdi3oo1CNXdA0nW6U
         gSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958663; x=1749563463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjoJn2Zm/22QHFjhWW1StoVgQrArf1QtKVAZNo0G9LI=;
        b=CPzMniIUwoE/FoT5tN3hUdIVDL7tsY4/Bh51THiAv4iMRibxeoWOABc8EJolS4rGSz
         QhvzdoiqU2qdFGa59Ln5DzkzZNm1BO/WxJ/qLfwcaPmxIXXwFvqaC/swBmDCVSGDdOvY
         gRJOAaHexki6i4kV+lI66tRdCsPS40IW59luFHTs+2j42JcpdPwTtGkqBKNJLWxyM6Uy
         KJGvGl5oLy+GTPTHfaOEC0Dp23L/iI1m/My1zOjtm7DNCnWfJXrYUs+vRnDA1n1DGyeB
         urtBZivplO7a9NOJUxEze2W6dKTMVcGgIGT0L91vFFAESUXuGMZvmXRomI50P0/r1eWD
         oesg==
X-Forwarded-Encrypted: i=1; AJvYcCW2DepVpG10el6AJRnl4PScQ9+0GMTYiRBUsbywHfzQLWbzuozJYCStbl0HSXpzNNjI8p3Z0YJQ784=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZRvsYQ+X8RG/IpeUq07xAzFNiYjPMA5w7RBeClr1TLYO/EmUW
	JN4drRelrOd0tUneTEQsZizKSyHw8FciEKmYQaSxYHvWusuqBbyWuFS0bCxB4YaBSIeCCB1pRCP
	1+ciX
X-Gm-Gg: ASbGnct3hthHmjUWshkgy1WRri/wyP7KP4y+yxcpVdDq/v1F1qjg1TfLay1xYUZM58n
	hCHOx+7ILpRigqsqBvTP0jw/x3XoKnaLopx2cNUQZwRmkwCyyZAXfyH1psOpU60tkseFfMoNtqQ
	prZ9g/bFRY0qaUkfzjeXeSanRzauj56MXsErIPj5FIwpvPaxWRdOVnigPOWnMvTqNeFW6XEGHnq
	MuYN2tFF5+5bJTn4KuXvEMTzwnIdF4lFc6+khANztG1vlHoVvGr5XnncFOWFL7pAgZaIeZMelxL
	+4GeuIkKdxNpFwNXtb0vmFnbva6IARJSkaU0DnJB7/+Q81pe2o9DfY8GdP+Bk+OCsn07FlwdP6X
	60VPXuvZ7HCbbJs7CqU+ryu14eLfOPqIvsweQkA==
X-Google-Smtp-Source: AGHT+IEFP32FP1kWWCcJZHDROTyLVsjrCtV3bR6kiIwGVnTYe5RPt72l9Jyf9JX2LfFifGppycDP9g==
X-Received: by 2002:a05:620a:4629:b0:7c5:3c0a:ab78 with SMTP id af79cd13be357-7d0eac62c8fmr1708400485a.14.1748958650816;
        Tue, 03 Jun 2025 06:50:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0f9925sm841658185a.41.2025.06.03.06.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:50:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS2T-00000001hDC-3YG8;
	Tue, 03 Jun 2025 10:50:49 -0300
Date: Tue, 3 Jun 2025 10:50:49 -0300
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
Subject: Re: [PATCH 11/12] mm: Remove callers of pfn_t functionality
Message-ID: <20250603135049.GL386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <4b644a3562d1b4679f5c4a042d8b7d565e24c470.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b644a3562d1b4679f5c4a042d8b7d565e24c470.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:12PM +1000, Alistair Popple wrote:
> All PFN_* pfn_t flags have been removed. Therefore there is no longer
> a need for the pfn_t type and all uses can be replaced with normal
> pfns.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yay!

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
