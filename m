Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5D37179
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 04:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706590332; cv=none; b=oHO0Z+23K5pO0NJTigW3K3MK+ry7Ge27bnQRz1T4akiblXfQ5X1ZOr6eJmg9STK7/ZL/2P9+CDZDYa2N6m7V6pvZdBfrgMwwBNitOzGb/970Ag9J+rC4iPrNfqpRBl2as8CLeGDw+i4I/9cs7Mc+po7jcPkmQrz8Uq1KDyBm1jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706590332; c=relaxed/simple;
	bh=NAzGQaEu8Q/LeufWHIKuSaLPrWh6d2YKxYYmjiRCpwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6JIuZFccN8MSn+ssa/CQOIcPHGlALPpMWeD4NlOCb6/9ZYG61gWrxjbc/HmltiUrmv8t0dHsCSI7RrVuhoRQMjz+vZJe9ZbV+DTQc1pyPDlaFHKgkd+Foh3FY9RAz6ie9N/aMe2fGIKhN3n7kFCHt91RRu5/sbhTaLdq9QYSFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3b3fHU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3b3fHU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A171C433C7;
	Tue, 30 Jan 2024 04:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706590331;
	bh=NAzGQaEu8Q/LeufWHIKuSaLPrWh6d2YKxYYmjiRCpwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K3b3fHU7y0TblhTmEuUvgbIrGjErqAXoJYU1XA+3OQX3EP/mycM8KUrZsg0p7XKZo
	 P9KOZwuufMsQOqK1gKJawmTMNTak4oUfUYJ4UF2S318HqAsItgbmWHq3xJvolfNq2o
	 cZjyMGvxzgtfYpJWQFxuU/+sLh1vhAIFas8XfxgjyycrLUeGbaU0Q3VY4Mvw5pFLvX
	 ICk62yPUHiwoFyQMpyZeCsdPSE8JZNKuT0kQybMd32tV8IuG4SRZUH8oOjCDD+ltj5
	 KwhdbWIx5TQWwqShZg8e7anHb33K8FhryqJSb6a5gExZ6Dejwo1CknGcU/yO2U2bpG
	 p6G4Cpm1daBTA==
Date: Mon, 29 Jan 2024 20:52:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: decrufify the configure checks
Message-ID: <20240130045211.GI1371843@frogsfrogsfrogs>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129073215.108519-1-hch@lst.de>

On Mon, Jan 29, 2024 at 08:31:48AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> I've been starting to look into making the xfsprogs build system suck
> less.  This series stops generating platform_defs.h and removes a lot
> of superfluous configure checks.

For the whole series,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I really like ripping out autoconf crap for pre-2.6.40 kernels. :)

--D

> 
> Diffstat:
>  b/Makefile                |   15 -
>  b/configure.ac            |   33 ----
>  b/fsr/Makefile            |    4 
>  b/fsr/xfs_fsr.c           |    2 
>  b/include/bitops.h        |    2 
>  b/include/builddefs.in    |   37 ----
>  b/include/linux.h         |    2 
>  b/include/platform_defs.h |   10 -
>  b/io/Makefile             |   69 ---------
>  b/io/io.h                 |   36 ----
>  b/io/mmap.c               |    8 -
>  b/io/pread.c              |    8 -
>  b/io/prealloc.c           |    8 -
>  b/io/pwrite.c             |    8 -
>  b/io/seek.c               |    5 
>  b/io/stat.c               |    2 
>  b/io/sync.c               |    4 
>  b/libfrog/Makefile        |    4 
>  b/libfrog/paths.c         |    9 -
>  b/libxfs/topology.c       |   37 ----
>  b/m4/Makefile             |    1 
>  b/m4/package_libcdev.m4   |  349 ----------------------------------------------
>  b/repair/bmap.c           |   23 +--
>  b/repair/bmap.h           |   13 -
>  b/scrub/Makefile          |   20 --
>  b/scrub/common.h          |    8 -
>  b/scrub/disk.c            |   30 +--
>  b/scrub/xfs_scrub.c       |    6 
>  m4/package_types.m4       |   14 -
>  29 files changed, 35 insertions(+), 732 deletions(-)
> 
