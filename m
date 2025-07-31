Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A258F2264BF
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753978571; cv=none; b=H4soMSjv8UI3auCqHN+8rqZIA2oKeeS+Ml2SEnK25JkLENBjLhBnV1sWbAqqSeuz5z0q31SXPF+G2dAIvWl/Zx5gEfXJ3WmYvCHGuCv/4cvZiBR6ypE61/B0AWw5dRFv3F6UAptr9fHxCa+jFP0V9jtbYhC6rI4eFWtqtE3MvhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753978571; c=relaxed/simple;
	bh=pbj+1yS3Ct4QgODuy3LO8NstxwmotXNy09YVRcWv3yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7XIUD2SZkSsi3p+0HK2BnD8EdS2x/B4OywaauzzRD1BBSG60x0+piGar7+keZQuwTW47UaiVtNGGZ1205pSgIna1PEGYqHi/7xHVzA4Y5EJcUami59Hphh4oJVvz6VGLi+N7wJ2Qxu10NZHtTCf+ZQl+cckdCgB+MD2DNJmC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 006BD68AA6; Thu, 31 Jul 2025 18:15:58 +0200 (CEST)
Date: Thu, 31 Jul 2025 18:15:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix frozen file system assert in xfs_trans_alloc
Message-ID: <20250731161558.GA10215@lst.de>
References: <20250731141941.859866-1-hch@lst.de> <20250731155941.GT2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731155941.GT2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 31, 2025 at 08:59:41AM -0700, Darrick J. Wong wrote:
> >  retry:
> > -	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> >  	tp = __xfs_trans_alloc(mp, flags);
> > +	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> 
> Empty transactions can run during a freeze, so please put back the
> original warning and comment:

Empty transactions don't end up in this code path any more.

