Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0BD2E636
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719981230; cv=none; b=DZGaxB0uBRJrOFuUxiKGu/7Sjf5ro12a4swbd+F9mc2U/1ZFKnnps1bKuY4K3/2jz5uUrHxFrNoqLM9UI6aMl7J7MjYa0O1om4IbucfP42kY7hSJzY85ZPxyXlOmTDWneo6O1DEA9JIf9P8Dcowz3W1dYSYiW3QglOTXXMVc0Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719981230; c=relaxed/simple;
	bh=1wyrGhFq0MiLDJE/bt62z89WKaJBuHMQXehtY+fXOFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4m1raGYD8iG5edX8/nfngsWDR0wreoPILytkfffFFscTGZ0vrxbYJEa/41obs8aYHdBFJodAHeCAi0jybaczZ5DDug0AGPVR4B28Jks6WgFWNdRDH2Rzlp/0zZT/01rIeKBgVe4JJaPKLRLwWZvBuhqYQtsxHyMyruk61A3/rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8F2D227A87; Wed,  3 Jul 2024 06:33:45 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:33:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH v30.7.1 7/8] xfs_scrub: improve responsiveness while
 trimming the filesystem
Message-ID: <20240703043345.GE24160@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs> <20240703035227.GX612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703035227.GX612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 08:52:27PM -0700, Darrick J. Wong wrote:
> I then had the idea to limit the length parameter of each call to a
> smallish amount (~11GB) so that we could report progress relatively
> quickly, but much to my surprise, each FITRIM call still took ~68
> seconds!

Where do those magic 11GB come from?

> +/*
> + * Limit the amount of fstrim scanning that we let the kernel do in a single
> + * call so that we can implement decent progress reporting and CPU resource
> + * control.  Pick a prime number of gigabytes for interest.

... this explains it somehow, but not really :)

The code itself looks fine, so with a better explanation or more
round number:

Reviewed-by: Christoph Hellwig <hch@lst.de>
