Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E372EA496
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 08:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755765646; cv=none; b=dg3nJvxd6HLsDvmaB9YLra6PGVtEtVkiHlNd197PF5i2HUmLQCHa9a/SJGX/ug9QFsnqnkPnZryQ+VskrsMbwqEvcEIEKGERjoafQPIResPLm8gp7gQzkYJDPJEiTnaNuoWuiTuBQfWSlDT2Gp62vxKKKcMYHgX3uOtJU5M0TbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755765646; c=relaxed/simple;
	bh=g4BUJgMyqXGgq3pfrj2NDvkHsHZCgv4bXHpA1uKrBMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lcnt8i+hW7JshR7ff8rxyZ/G1EtHeP5C7LJqWWQqcTvi6F3oTKw6qImUAvywcagfTlm5RShqndPe8Q/NPgOGvE2ZOGeA6Kt0fnSkCdSNNRSjeXgmNhnkdn99g15taXbrcBBltPpAv1gqn49sQwTDqq8oDXHuYyf1DiHrb84tjt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85432227AA8; Thu, 21 Aug 2025 10:40:38 +0200 (CEST)
Date: Thu, 21 Aug 2025 10:40:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <20250821084037.GA29746@lst.de>
References: <9aG8Tf3X2d-4A9_uy7q50gPfuQH-xjOf3Bdbw4mJ5ITHbBXXDwYG2uqAYoSKE-pRy5iYgqRbd79paOGW-Sk_SA==@protonmail.internalid> <20250818051348.1486572-1-hch@lst.de> <bcwk3ezkikdmkgisfhukyxk3ojtkmbeonnepaxt3pmzof662b6@iddfobua7bme>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcwk3ezkikdmkgisfhukyxk3ojtkmbeonnepaxt3pmzof662b6@iddfobua7bme>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 20, 2025 at 10:23:27AM +0200, Carlos Maiolino wrote:
> Do we need to keep this comment that tied to an userspace tool?

It think it is a pretty good reminder why it is here.

> The issue with randholes is that it uses posix_memalign, and the pointer
> size constraint comes from that.
> 
> I couldn't find any details on why this is required, but I'm assuming
> it's to keep posix_memalign architecture/implementation independent?!
> 
> So, perhaps instead of being 'randholes' specific, it should specify to
> be posix compliant or because posix requires this way?

Posix does not require the alignment to be larger than void *.
Applications that directly feed the value to posix_memalign do.
And maybe that what could go into the comment.

