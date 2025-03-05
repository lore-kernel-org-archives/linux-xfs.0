Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A042E3365
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217935; cv=none; b=Vq/J+0IHWndUuaD7+8/O7g9U6QBj0MOta9ROC1HjZHtvvm3kAOrZz74o36HgE6cu29GN1w/h+FeERoo2XWGK99o2r4tQ7P7IRwTYzzDN5eBtowJjFa6ekTnDFngrZk4V1ZpEzogL7y2VPgCCbR7upI7sxcV2wVxSFwig/YQFWO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217935; c=relaxed/simple;
	bh=xqnmTPKhq/+3Bv6SsgN7LJoO7g24g7gMMcmqMbXHFhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bA7tnMXr5gZb6LUGomrSdYhmMT87pXVvJgd0qLVhfrShnjsJs8NkpaZnTzPVg7mjBo1EKp2pwoAr4ytkX5EGVMEYG7+Tk6MS3w6ih0/W7tLdyiXlCz+ER5Qo3cKs7+32kKxYvv7ETzaXHNVkMpZmGO5mhE++lRMFtwmckl2dWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1455468BEB; Thu,  6 Mar 2025 00:38:49 +0100 (CET)
Date: Thu, 6 Mar 2025 00:38:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator
 fallback
Message-ID: <20250305233848.GD613@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-7-hch@lst.de> <Z8i76YPOvLgFt1Dq@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8i76YPOvLgFt1Dq@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 08:02:33AM +1100, Dave Chinner wrote:
> > +	if (!(flags & XBF_READ))
> > +		gfp_mask |= __GFP_ZERO;
> 
> We should probably drop this zeroing altogether.

Maybe.  Not in this patch or series, though and whoever wants to submit
it needs to explain why the rationale used for adding it in commit
3219e8cf0dade9884d3c6cb432d433b4ca56875d doesn't apply any more.

