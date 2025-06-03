Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8B23505F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957823; cv=none; b=G3TL3rZcpPF4YABmb4anLZ44BXvjFBZDvkXb5ch848ZnIYIhvYKlo5eJ5XlhZLhNMkPn7ghumdIpmOG4GtZ/XE05E465tAOKQpUt0o7gCbtg9MtM+4zyXvxNjPBT/6u71Y9LBfLN4ucL9ICkhvxODR9CpziU8F1eZufUSfpq2IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957823; c=relaxed/simple;
	bh=MfnZO5lFJA5kphVhQXFmjyYwzPaWj6A9QLg5HcsjC6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExHtv/ZbQNj/KrhNno2uzJHulVYhx2HOEEopNTpD/3atVSKt2GbPmUbQmlW1ypiJFgnmkUXWjfmEqOwH2DTyld7pFxYJ014H82oEXNBXnr3mBwOorakkgjdMT8Qdb7LBUqn/I2qDuzimyWUiXkpCANMAusyAxncLSEPZQhzjoIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QdRqef0e; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QdRqef0e"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7d09f11657cso510011285a.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957821; x=1749562621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M2tOvYIRYhJ3zgazeT9iy9SxHIfkqCxujQJZWAlLZ4g=;
        b=QdRqef0eufvBDPsFNSKgItk8ioK5rW0bITD7h/gaJVlsLti5kJbkAWQoNEmZWRe68Y
         Q4oF4tefxOI7cERsX4wsVaBuaHz22hTf4BcC/yjkMVx+8DuPCBDLYZ3A+RWTRvaraqNs
         e7pqxu3qqrej8RwTwZermIn33SpopTq52Y2nm/rfb3Wh5IxZqh6cLkWQPdwWIBjD+YoN
         aiioFJ+ghZ9yPVDMy/MALzaSX/kPFwincvLa9cv4TcSSylFCgKj10d+Rbd3GZwiNMEHs
         ubZ2U/8vLM8FJ3hFzQB993FiXCNvO+ks/3rtygYKqSmy9D7l/904PPCBEYVreULiWIuI
         rFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957821; x=1749562621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2tOvYIRYhJ3zgazeT9iy9SxHIfkqCxujQJZWAlLZ4g=;
        b=abH28t60X1IWSM2cmbSMk3T0GRZ1XLpq4nAfctS48y8H/sdQK2q0T+t5UXH5VyOsdF
         3Tn4iJBT9ncrlmRnT8oTd99acbU9TFFPZMDfBgtddD0XF455Ll6AhmacojPJmyMDW3Nq
         OdF7GS5neyjLuVSzgfPEwL1hXHITya6NRmSCgloJbF3mNHjOV4ncEyXktuI1yXOtUi99
         jVZl5xIbeNDHeKxbigmc5oC4R/htJfeNYdlmXjYX2oe9l7O7pp4uwu6/JKfPQp1EhNwf
         wkk/gV0edeZ+cuS96zJjc4Sd5CMAK7m5+AcjIkAk+MwF/9MshJBmhlozu7SaWlO4Eckj
         XsEw==
X-Forwarded-Encrypted: i=1; AJvYcCWlPJ/p8qQxNyyhAoHUJ4o3vXiNXclboqI/W3HgXrCBk/HPhomTsT2kw4usuEJ2YKekeXxDXF3Ckw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YynRN4A9948ejdfE343V4bWQSU9q3Y5xkwJZLuwrv0ZwhYjh1qG
	lKC+O02d+ZgizlrDE24nMKAHD3Te8dc1yl7aNFEIxik1+/8PmPzqralkaIia2HvOIhI=
X-Gm-Gg: ASbGnctW9/5m4HZuA/DxVd+ea7d1X3a7mgDj/4U3GgPIK9P42Jsi8u069sUyUdGQZtC
	AvLaq3FOi9p0kdtGWe2uhJlyAaJoJ3ZesTJJkweMGvj25KUzCZK+5hmBGwy7CtUObPiuThRwyGm
	kFQ0w00NmYB7nnwWAnDCtj/3heAMblnGxtxcC8UcAE46KxlU377NRSErv8/ExrbZMg1jzdtD6fb
	WdH5SOdF26ky3sLbX5OkyswtFwHs1QvVxBibKlswax6WyJ5XrfRMJJ0wrRKDpcmPO98kKdsj1Zk
	aK/+cnCkK5dY4IXGoOWg4A/V5zL9bN0u9OvvcfwK/PXoJmTdCNz8ebSHuMUNaHMEezc1v3w4Cxw
	01tOKJ57j8KwvToJ4mLqgp54uV/o=
X-Google-Smtp-Source: AGHT+IF/1nQKKWghBymIv6kapapYp3T/T+mDb2uBcjAQYD1rkFwd/p2CMx7wy82AG8RXeUKzw729SQ==
X-Received: by 2002:a05:620a:4408:b0:7c5:3d60:7f8d with SMTP id af79cd13be357-7d0a1fb91a0mr2626422385a.19.1748957820692;
        Tue, 03 Jun 2025 06:37:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0fa38fsm842635185a.35.2025.06.03.06.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:37:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRp5-00000001h5Y-2rWO;
	Tue, 03 Jun 2025 10:36:59 -0300
Date: Tue, 3 Jun 2025 10:36:59 -0300
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
Subject: Re: [PATCH 03/12] mm/pagewalk: Skip dax pages in pagewalk
Message-ID: <20250603133659.GD386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:04PM +1000, Alistair Popple wrote:
> Previously dax pages were skipped by the pagewalk code as pud_special() or
> vm_normal_page{_pmd}() would be false for DAX pages. Now that dax pages are
> refcounted normally that is no longer the case, so add explicit checks to
> skip them.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/memremap.h | 11 +++++++++++
>  mm/pagewalk.c            | 12 ++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)

But why do we want to skip them?

Like hmm uses pagewalk and it would like to see DAX pages?

I guess it makes sense from the perspective of not changing things,
but it seems like a comment should be left behind explaining that this
is just for legacy reasons until someone audits the callers.

Jason
