Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969C240803C;
	Wed,  8 Jul 2026 09:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502106; cv=none; b=uJsVzQV77JvWp0ioDEeLXYUtYVeWIt4sWX1mUG0i0b3XBZnUu+eMJYue0T1O+edsR1tH9LJtO3jtoTCR98OcgJGE3JVrcFmLhsYxPb/v/wMlr83hVcR/ty4zhtjibEUEzJUmU0BH74MtePMr3bx5xCb3J96IA8FPZb0FCqYj8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502106; c=relaxed/simple;
	bh=kJMr095KhFKscfUeglCwKw0tZO36tC3tpi723lspdXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7wPpGnBqH1Gc5sk8pgV+sT/I52nkPD/baZsaBttzKdqu0wuVi+l1bongy84ei18n9tbagfCcegDbErwK/s6/SeiCyc6tNFi7xiXdt1DchTE+QMGANo9l1spcfesfaVCiohwDfUDkQ/Eo5wtAPKkmaTDxPS6OpYadpI328IFWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21A1B68B05; Wed,  8 Jul 2026 11:15:02 +0200 (CEST)
Date: Wed, 8 Jul 2026 11:15:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: use rtrefcount btree cursor in
 xchk_xref_is_rt_cow_staging
Message-ID: <20260708091501.GC5902@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726151.1271589.2993932219666082877.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726151.1271589.2993932219666082877.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:03:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that we pass the wrong btree cursor here.  We want the
> rtrefcount btree cursor, not the non-rt one.  This is fairly benign
> since it only affects tracing data.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

