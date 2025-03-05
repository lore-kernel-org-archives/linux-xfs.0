Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735161FCCE8
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217554; cv=none; b=pORR22ldjmXChOOuN1Kg3N9aQo7Y6qXa0ykONqb0W+THe9pE971Hq7tFE4KbuMStKXS80Co2ML37z+VkT/zRMKAMz0jo+Ax+I+BflbtbN+YJvbqpX4NXQJHv0FShMNLbRXKGgDTSQg9rnfFMvRyBK5WEf/imd+fnE3hwmM8VYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217554; c=relaxed/simple;
	bh=i/085TtlrRV9uPYYJuglhDq8zs8aOagyeAySABsp/yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JahkMrHW1+O38ZECrbF9YB7S0dJJhsisD5dBz8GIme/TmvLPMmvX18gY3fnWksrplcdI0u5Kwyrz8CpnSq+kHJafBg+YnPz6YQiqwcVgokw/nGMf8gFcLmZD2KeUGU/ijNKpwBFNsAnFfXpqBcAMpLV/PWPp52JRIzDvqeiVxkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5EE3A68BEB; Thu,  6 Mar 2025 00:32:26 +0100 (CET)
Date: Thu, 6 Mar 2025 00:32:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator
 fallback
Message-ID: <20250305233225.GA613@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-7-hch@lst.de> <20250305181812.GI2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305181812.GI2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 05, 2025 at 10:18:12AM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * For buffers smaller than PAGE_SIZE use a kmalloc allocation if that
> > +	 * is properly aligned.  The slab allocator now guarantees an aligned
> > +	 * allocation for all power of two sizes, we matches most of the smaller
> 
> Same suggestion:
> 
> "...which matches most of the smaller than PAGE_SIZE buffers..."

Hmm, I thought I had fixed that, but I for sure now have now.

