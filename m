Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69651DA21
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818469; cv=none; b=h+SUBayIix6TN5xMhWuXTJN+7qKe9HGIhZSyAxk87DqAkZetaW2tZIU6dEzLaGEEy8162ImkZ6Q/QrAp8ReahKFmnNfvgMW6EpPiVDVMWPR5eJXPbm4gc8d1Ktnh76R7ptHV46cGxf9ZM2SuZHhwUpXW1uvoj/7vIS/zlrUyNcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818469; c=relaxed/simple;
	bh=+gZ314cttpjB1q2KQm/JFilDXSyLfkG9uB9eF/QgxYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbgVyAUf6qB6ZqWhcrZ/6bi/EdhVdsoJ59M1QlMXjjpVKu0dsIAvGqqbOTToOzLyVJLCVqwGmOg5qw7olGkzrmTvRAmhHOi1AQtwIJsrJE05L9RV8y/iOtSVN0FsZlL1FhEph2z7xLQK18QdqMOEyfxi2y9r40lcG3CBXLnlhDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85AE768B05; Wed, 28 Aug 2024 06:14:24 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:14:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
Message-ID: <20240828041424.GE30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 27, 2024 at 04:35:01PM -0700, Darrick J. Wong wrote:
> This helps us remove a level of indentation in xfs_iroot_realloc because
> we can handle the zero-size case in a single place instead of repeatedly
> checking it.  We'll refactor further in the next patch.

I think we can do the same cleanup in xfs_iroot_realloc without this
special case:

This:

> +	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> +	if (new_size == 0) {
> +		kfree(ifp->if_broot);
> +		ifp->if_broot = NULL;
> +		ifp->if_broot_bytes = 0;
> +		return;

becomes:

	if (new_max == 0) {
		kfree(ifp->if_broot);
		ifp->if_broot = NULL;
		ifp->if_broot_bytes = 0;
		return;
	}
	new_size = xfs_bmap_broot_space_calc(mp, new_max);

But either ways is fine with me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
