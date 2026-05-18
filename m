Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE66748125E
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110204; cv=none; b=TL2D56LCg+oNnUIGNDUncArlzvHj8GjAkL8nSgBjVrjtMgsc2Z8oomndd0ARgLpSU7KBfMBsUEWNI8dQalBaYDo8gPjX/IaQLVCkT/7YDYNlXcM+19boalgwxqZZQRwywJoBdrOHSE3WKFGn6C83whuZsu++MlUczZLPIQ8VT20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110204; c=relaxed/simple;
	bh=WDQ8xHcK0D02WZYo/VfAOVpf/qM/HKAl2AcJ/u8z/FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzIH2kHH0dd+SZIHWjt9FNnwq7GAEPIQqKcdI5wgyLzoYxPC93HJlbvgeig8NACAp5YwuMXDh2hl0BSX5gT0KoT4lYDKKsQex120+Z1BWCEGOUKXZoBURj0gB7YZlucAlRu3oSOIfsuY2ZntjQSHeBjBqQq4ehe5B2FvDTg36zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 88E7168CFE; Mon, 18 May 2026 15:16:39 +0200 (CEST)
Date: Mon, 18 May 2026 15:16:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <20260518131639.GA7774@lst.de>
References: <20260515135103.4042407-1-hch@lst.de> <20260515135103.4042407-6-hch@lst.de> <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 18, 2026 at 01:14:31PM +0200, Carlos Maiolino wrote:
> On Fri, May 15, 2026 at 03:50:26PM +0200, Christoph Hellwig wrote:
> > Add a small wrapper for initializing the rmap owner to i_ino.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This and the previous one, provides very little gain IMHO, do you intend
> to get rid of xfs_rmap_ino_owner and xfs_rmap_inode_bmbt_owner? It seems
> to me they could simply be replaced by these new helpers instead of just
> wrapping them into these new ones.
> A little disclaimer: I didn't look into the next patches yet to see if
> it will all make sense later.

My direct aim was to reduce uses of i_ino so I looked for common
patterns.  I also generally prefer APIs that pass typesave objects
over those passing integers as handles wherever possible.

