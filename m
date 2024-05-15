Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF211591EE;
	Wed, 15 May 2024 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715796214; cv=none; b=Qm8IVJ6gc+pQmEH8/ahXZGhvLM9Y7ZbaohWAmU/Kxa91eAh+XMI6+snALn/7WcuHnpbn/eeHayUSjHWUdfLlHkmu9poQvz8LU6A6vUcirMKOaMDRxrWm3CYdAIqubTma9tWCxiVXScD6VOUUA7awIJlCbh1z8qJU2U4kBiyp+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715796214; c=relaxed/simple;
	bh=5X2L77nXB/OM/RzCqNTxyiWqujjSTYNzbV369GdoO+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Srpb/q6wnLs2GJLyMvYFQWnDxseZOo5nLm6LjQCFnH5e9IragFujEpY3+uyj9X7McxAlCd9TkNpHx58I60wMve7tsE20EfGe2b9tO5d4w560oLNLSAdnWDfawcp0VQoFjb+Ns0fmuJ66f28jKI/IL7P6uZP5R0Snf58ccbUbpQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k63Aif1D; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k63Aif1D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j6lvNwTR7juDXHFmLR219nVkRJJsHRnipz5EZK+QZtA=; b=k63Aif1DXgPw07j1HQefCmIgiH
	ZHVuOED5L1S83EM0V0fzSF78MyVQRAo41TouSKNO8IWDhPJt2slZEH1ncOU5HygsGpaPZvL1khDgb
	FCGQVXnnZcKxhW4t2L8VWw7Jcw1a5Ven0bCm0xF3kcMvU8I9n+bpoTUXCBMr+iE6xHvzHsjKddRiv
	NcGxFlIKmsT2Rh0npKIll+5HZV5U8CwhSc/wCM/oNVB1+BWeuA/yWbX19D12+WT62tbBSIliEea7Y
	MZjqqj4fhFPeZCoNNANafi0H5MiZNYB6Pp+A1pVKxt7bIkRMAVwkS8kOZXLYEx9H4Gu3iLs7DxZxA
	ehRchXuA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s7IyG-0000000AkmV-1EXu;
	Wed, 15 May 2024 18:03:20 +0000
Date: Wed, 15 May 2024 19:03:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: david@fromorbit.com, djwong@kernel.org, hch@lst.de,
	Keith Busch <kbusch@kernel.org>, mcgrof@kernel.org,
	akpm@linux-foundation.org, brauner@kernel.org,
	chandan.babu@oracle.com, gost.dev@samsung.com, hare@suse.de,
	john.g.garry@oracle.com, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, p.raghav@samsung.com,
	ritesh.list@gmail.com, ziy@nvidia.com
Subject: Re: [RFC] iomap: use huge zero folio in iomap_dio_zero
Message-ID: <ZkT46AsZ3WghOArL@casper.infradead.org>
References: <20240503095353.3798063-8-mcgrof@kernel.org>
 <20240507145811.52987-1-kernel@pankajraghav.com>
 <ZkQG7bdFStBLFv3g@casper.infradead.org>
 <ZkQfId5IdKFRigy2@kbusch-mbp>
 <ZkQ0Pj26H81HxQ_4@casper.infradead.org>
 <20240515155943.2uaa23nvddmgtkul@quentin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515155943.2uaa23nvddmgtkul@quentin>

On Wed, May 15, 2024 at 03:59:43PM +0000, Pankaj Raghav (Samsung) wrote:
>  static int __init iomap_init(void)
>  {
> +       void            *addr = kzalloc(16 * PAGE_SIZE, GFP_KERNEL);

Don't use XFS coding style outside XFS.

kzalloc() does not guarantee page alignment much less alignment to
a folio.  It happens to work today, but that is an implementation
artefact.

> +
> +       if (!addr)
> +               return -ENOMEM;
> +
> +       zero_fsb_folio = virt_to_folio(addr);

We also don't guarantee that calling kzalloc() gives you a virtual
address that can be converted to a folio.  You need to allocate a folio
to be sure that you get a folio.

Of course, you don't actually need a folio.  You don't need any of the
folio metadata and can just use raw pages.

> +       /*
> +        * The zero folio used is 64k.
> +        */
> +       WARN_ON_ONCE(len > (16 * PAGE_SIZE));

PAGE_SIZE is not necessarily 4KiB.

> +       bio = iomap_dio_alloc_bio(iter, dio, BIO_MAX_VECS,
> +                                 REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);

The point was that we now only need one biovec, not MAX.

