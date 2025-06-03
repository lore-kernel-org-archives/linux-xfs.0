Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C423956E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958551; cv=none; b=gKrndk3AWR8tR73B/WZiIFB4RqIsOMwMtI9I5kkIY1cqV5awi6XShqFwRdc8zDziYYKB0cxr65Uashr08/FWLu0LUpwlRJ9cHkUau4D/17xTTowP2v4ixCs9XcWnmOQXJ16kIpaBB4n20B82nd3wBEBak1JeiWZiDlShRQ0zuqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958551; c=relaxed/simple;
	bh=z6KLOqm9i0ROrUFmuMKuPSFgLeSRnBoRY1z3awpPe7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIaauHN4urDpkaTJfXrAx429OMXHTMBh9kl4P+E9L3+K3W0QU9mFLabgI8JeINY8OweS1ada9k/qXf9kbMSvSc/B2NxeqxhA9voq2T4Dal9J5RVTeZW+bFudEQx8OUZiUOFrAiwYoRetlL2r6Cmu3PTrV9JESuA2+DT2UYz8rTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jJVQcqeC; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jJVQcqeC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a43afb04a7so29699921cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958546; x=1749563346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ooaH+MVJLI6au3+Z1ecUWfQ+S7G2Wg3KD+ti8ca06oA=;
        b=jJVQcqeCAc0iTCARHARG2NmR+PX11EDVnFDiahfPqaQTUdXWScZbdTlKmMfZhzmJn1
         rDC7kWLDXsIbilCjju0o/WGrcB+N8UcZ4IKxdQlNREzXmxbaXT1X5l8HfKJdYk9pSkfi
         dxbsGMqa62vDKd3pRQANnxKTtc+tv74/hLJqCamxg8F6SrZez31ZVtLH52rBR+blcXJo
         gRwepcr+jYILzItfj77n3cmsg/NqDOZp2EFfpLVFSOX+NgEBtytbNnrPnt/CMYpcao13
         gxCLzNK/ENITed7fzdzsMwHnkVTZ8FOaVKOyFvstoi+OKo6wD9a7wQ/IW+Cj5LmnWpel
         HNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958546; x=1749563346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ooaH+MVJLI6au3+Z1ecUWfQ+S7G2Wg3KD+ti8ca06oA=;
        b=M5NoX2b0rFdHEsKIaFWbSmuCnLdshRLKc4vc5sZ8XRRllk/2jgagH+BVB4HdgLXtzY
         EHudEAJrnb03sejWv/MTi39LC8PFF/bF/zPcwuTWlSvIJ30TSqQBnYQsD4H7bwB4qqhI
         wQnhyspL63m+OAIUuTFtL/JoG9z8DpvL5j5BVOSMathUg+nPRTzCA8h7BPmVY2wfR2G6
         CdynLJrs/uJqdnI+gSC+FRVb4gxuxx1lNjEKTOD7L3xM5mHVi4A0c/V8nQr4bwuCqAsy
         2O7O+K9CtfFmvR3IhVA1xqsGYccHLjjgR23LM4+pGicY9wai50LtIG3IkfGFQ0fPh1yd
         C51w==
X-Forwarded-Encrypted: i=1; AJvYcCW+5trqWKLX3pov2vnPXfSPWWVmEhYHDnriMLfdSbnC5cipQKjVyneqaNwvuRwfhQnwCi+qDAuXIw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLM5JUMrSe8XQ0rmOYfOxCOTxHjXCZ+A0wuiiryRtXbRJx5CdF
	l9+wP2P8t8Swnxf2JInYYEz2dmIbVNEWZ0OviVedLt1fFqGG2y1ILZKo2O0veOi72k8=
X-Gm-Gg: ASbGncutWNFo4PRyDkKC6HoJ/ZgYFz2BGYz70Df2K3UbFEeJ3t6ryx7Xl2yhwFnibmn
	Vw5nTZRDxGSOjARnq85VyhDEzrAPtZKjpfd0aaBC/Aeq12oBAJXSOolJcxZziJFx2xW0/oGJQ3s
	x94KIr0XEt4vjkzlbuDGWYfnTzEm2jbYWpR3ueOzgpo6WQaDCdXOPrmd1l2MLtLotl0pigcsfQl
	LTYzCoLvwlzNoRN0Ju6V2+LNHEdN6hLFOMHKWE3Y8EgvYCvJ6veiJK7D0zWHKe9RdnUb5WpTsNR
	4nNka+jhA65p0H0IaZBJqyiI5u8RYqVpgEG1nurndwyuQL2h1xlIO/X+yRj7CPGRLpo6c2C9PIC
	l67z1fwTUSXKWtF7K2yvFuyI1ipk=
X-Google-Smtp-Source: AGHT+IGIU1g+493Q79vIGhbP57BxcXzG4cORozjsE0WNUaw+m77zFEPhKIIEfe6WhON7WEL1UbHK4w==
X-Received: by 2002:a05:622a:5a98:b0:494:b914:d140 with SMTP id d75a77b69052e-4a4aed8a697mr209908281cf.43.1748958546430;
        Tue, 03 Jun 2025 06:49:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a435772a19sm74189111cf.1.2025.06.03.06.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:49:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS0n-00000001hCF-1wNL;
	Tue, 03 Jun 2025 10:49:05 -0300
Date: Tue, 3 Jun 2025 10:49:05 -0300
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
Subject: Re: [PATCH 09/12] powerpc: Remove checks for devmap pages and
 PMDs/PUDs
Message-ID: <20250603134905.GJ386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <b837a9191e296e0b9f4e431979bab1f6616beab6.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b837a9191e296e0b9f4e431979bab1f6616beab6.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:10PM +1000, Alistair Popple wrote:
> PFN_DEV no longer exists. This means no devmap PMDs or PUDs will be
> created, so checking for them is redundant. Instead mappings of pages that
> would have previously returned true for pXd_devmap() will return true for
> pXd_trans_huge()
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  arch/powerpc/mm/book3s64/hash_hugepage.c |  2 +-
>  arch/powerpc/mm/book3s64/hash_pgtable.c  |  3 +--
>  arch/powerpc/mm/book3s64/hugetlbpage.c   |  2 +-
>  arch/powerpc/mm/book3s64/pgtable.c       | 10 ++++------
>  arch/powerpc/mm/book3s64/radix_pgtable.c |  5 ++---
>  arch/powerpc/mm/pgtable.c                |  2 +-
>  6 files changed, 10 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
