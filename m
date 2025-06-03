Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE0D239E88
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958499; cv=none; b=X9P09a2/8aHA8YMKy8lLTfRHSbUXTOCVtvaSm6/bEBgImpKLRv2BO16gp/ZhkSre2G8WY2+jJyiXxU3f72R9GlCWi3d6l/vc3lSG8Q7KLdqRZQaXA8Ofoazf3qYAX6YgsXNr/PCRbjZ2FsAsIm0S5pnP4ni7yQXUFc5FlmXQS6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958499; c=relaxed/simple;
	bh=y7QlyC6KXPLMJYPeW/fxUEb7YGMf3rqlxQiF8jReTpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jh4hk//0ddrRqNGnnYZpMmwKfqp6to2hYzLh3CZXCYuLvIVb7w1+JwZ7kJd6e0qgrGvP7u4+t91aodbnDpqiR13ddU2qaHccX0zZt02iK28P1Sjkh7jL+ABQMEVDIJ2H2xY7WcZ4jVUkeCf9PbEwSyqCgB90dZlZmSO+XVRAcRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AjOqEgfZ; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AjOqEgfZ"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7cadd46ea9aso682652685a.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958496; x=1749563296; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ag2KSfmpizoceiuoj+cZXZUUA1usyi82jYygfJs/Bg=;
        b=AjOqEgfZCAKJpwstPgw4JUuuLsAGp4nuxZRwWsRx7CMfzOZNcGorTQaU0A+5m3TJgs
         r4OuHdohJGbuNjZ0ZfPjWtHdlHW0OUVT2MLGLWgssYWADyAl4O71jzDVYgB/hFpePHMF
         82h2pWYP3V1Wpd/Dx4GOY6hgM50TO3Sw38gXNjoK5nIiV0BAazMOQed27p1HtLGXrzfG
         Y41CTIjAqO84UvYK8NETu4qxigoFB31sHhGw/l5w/mwTsZm9iCHyHZFq5TAYGiWTz4G9
         jlH6Zb+lGS1JwhW2YHzLp7uXrXNKjo1ZIRmAJZ8hteKsQOdVlximwGQrn5r+EpsPZYxy
         YDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958496; x=1749563296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ag2KSfmpizoceiuoj+cZXZUUA1usyi82jYygfJs/Bg=;
        b=f6bZnSePJkrSxs6Ear9v1njt07M+Z/DvI31Yh7BRISRe6b/j7DQOtt+KjbjCX6w6TT
         ofy/DSvp71tHoPMtH6ToTJl1edHUk4VotYOdIDYrUNFx+vwo6xjjg9I/L527GGI8+3ru
         riI9jWbwtFmPn6JRckWBdII21WraGBRMf5rVO2A3w36KFc2CF1V7Fw4frTOa2imvQHFT
         6dB7DWSB8Aavjv2JY2u319MvI327Xbx6JA2g9cvP7WwZ5brdoVPfNCTzA6RjWix9Ohgt
         091I4AHY7bjg28MMLtwfbAraP7QL4ckf3mjzhFIrR9GPSCoaZiKU0oZ7t6Dcr+QOy1sl
         omSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvTFIy+ueX+d6NjKvkmlQNdFKp52UG0zMIK0XT5xtQRWPMzNmhG0ykughk0IkGSbMxW5IpYz6+DUM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2oSN+x6TlPXEICwdwl7XPOo/TfE8I/uEWnQL8RiyUGeYQxDUn
	aY8I/QGMJR91CvLXFtxUB6X44orbmzKkvlBJe3hiF0dJBevQcTfSdua9u2m77MqRsIk=
X-Gm-Gg: ASbGncvAprz/XxutPkh5onAGlVYODupDZu8gxOKj2yDBXFlyX/xmqp/2u99mbzIrHT3
	7hvEDZ2tzImiMBWZPjeZTzsEmpFAYoivQ51uIv+EgaEuq2/CGjb9MExbUQV7ALoUECsYed2Fpky
	ZyJBZuCd9lE1khrg7T268iswPYBfSFRh21OSTyKSdy02kFGl/AXjAT+oKOfJwvvOhmjlY08x8zO
	YS3y4kBFOmKnhtIJ8L6aiCVQu31wpEa5HN90nddoZ8K5q2JMbPO5Y/o3v0tLi81JOsxiD5+etuy
	NCp0GU+QLOcH2uan1oRFvVeijceD32sclcPXSchNFnKNFd5IGkCGgfbewGeMb8Dcpn/hdC8G7Gh
	Mqgq3Eg8GBjk02tKalrliGfJHZPw=
X-Google-Smtp-Source: AGHT+IEC7tetoyd4MWB27Cys7lEZRwLgg/tDNDKGL2nO8t1WlsQDGW4e4zhoToAJp9Wky9F+fr/2kQ==
X-Received: by 2002:a05:620a:290a:b0:7c5:544e:2ccf with SMTP id af79cd13be357-7d0a4e57644mr2655730585a.57.1748958495697;
        Tue, 03 Jun 2025 06:48:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0e3fa9sm838696585a.24.2025.06.03.06.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:48:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRzy-00000001hBT-2tOq;
	Tue, 03 Jun 2025 10:48:14 -0300
Date: Tue, 3 Jun 2025 10:48:14 -0300
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
Subject: Re: [PATCH 07/12] mm: Remove redundant pXd_devmap calls
Message-ID: <20250603134814.GH386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:08PM +1000, Alistair Popple wrote:
> DAX was the only thing that created pmd_devmap and pud_devmap entries
> however it no longer does as DAX pages are now refcounted normally and
> pXd_trans_huge() returns true for those. Therefore checking both pXd_devmap
> and pXd_trans_huge() is redundant and the former can be removed without
> changing behaviour as it will always be false.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  fs/dax.c                   |  5 ++---
>  include/linux/huge_mm.h    | 10 ++++------
>  include/linux/pgtable.h    |  2 +-
>  mm/hmm.c                   |  4 ++--
>  mm/huge_memory.c           | 30 +++++++++---------------------
>  mm/mapping_dirty_helpers.c |  4 ++--
>  mm/memory.c                | 15 ++++++---------
>  mm/migrate_device.c        |  2 +-
>  mm/mprotect.c              |  2 +-
>  mm/mremap.c                |  5 ++---
>  mm/page_vma_mapped.c       |  5 ++---
>  mm/pagewalk.c              |  8 +++-----
>  mm/pgtable-generic.c       |  7 +++----
>  mm/userfaultfd.c           |  4 ++--
>  mm/vmscan.c                |  3 ---
>  15 files changed, 40 insertions(+), 66 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
