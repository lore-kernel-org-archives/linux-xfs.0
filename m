Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B00576EB0;
	Tue, 22 Sep 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098397; cv=none; b=YWwk2Uw4t6zN89aR2F3m55nOEKCdl2LODXS92R5APrNyhTRb6ngZ8A/Hn5fAYh6atO+BpQwwnjmGXqFmXUGKlaADf247MfBo1jGGw0WQbKnl+9CS8Tu23Uj4TZUqfF6/NXCexyck4hCHy0NAvRWk2+te1wW7RLJEfpng28NZGco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098397; c=relaxed/simple;
	bh=Np+RFk8+F34m7ovR2ABmlcC7OG98R+6eOhHdB4fJmNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mv9+yZqvklG3b29YuY6+ZYSmoT2irAFyyerKm+a8sfwiFusRP495WrXvBp4V40T0uQa2sPI5xaMurYKJ4XQHKvCmLBMTcM/aeLTzJ7RKp2nvC1JEM13MObQmCztikFCGwez/nLPSAjdOZNqln5A56R2yb6vNmAILh7tcM87zLXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgNYRuLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgNYRuLE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D28861F008A1;
	Tue, 22 Sep 2026 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098387;
	bh=UFTppGzx/FFN+ZCr5cJn54ExNe73CSxESIptY+IBLuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QgNYRuLEggUj+DUTZv1+uXqozFolZGPeEdar7eqb7pojw2jwxmM8HU7pB725hvjqp
	 jbcczjoyRfE6/9fICXExKnp58i2kDI4kKDurQVnto9i4/3kasBHBV+kFtEBYHrS31d
	 zQ1VjFf1ro9n6R9smcFu/jHQ08PEMwEVCUrZb6+Tp/DjOaPYhUbh9KALFZHBTSpdjE
	 CvNydCQ+Rrg6jM3lCjKYnuTBeSK6ga4fdaP2WV/bcTRaFH8qnPI6Pvx4R8IRxQ8s17
	 /rMESueEMBH6c1IjJRu717fY/KLx+/RG8eCJQ1m6JjKB87yVddy53AVnhrXTE11vaL
	 khimjVWv7rCIg==
Date: Tue, 22 Sep 2026 10:33:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: clean up after failed metafile relinking
Message-ID: <20260922173307.GT2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120636.181988.3123812677951717201.stgit@frogsfrogsfrogs>
 <arIPV0aMk6MlHe3v@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIPV0aMk6MlHe3v@infradead.org>

On Mon, Sep 21, 2026 at 10:17:11PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:16:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Once we start a metadir update to link in a file, we have to commit or
> > cancel it, just like any other operation.  LOLLM pointed out that I
> > forgot that, so fix it.  This fixes a bug in xfs_repair.
> > 
> > However, in commit e80fbe1ad8eff7, we made xfs_metadir_cancel a static
> > function within xfs_metadir.c, so we can't just add a xfs_metadir_cancel
> > call to xfs_dqinode_metadir_link.
> > 
> > Instead, create a new xfs_metadir_link_file helper in xfs_metadir.c that
> > takes only the xfs_metadir_update object, and handles everything from
> > start to finish.  This enables us to make xfs_metadir_commit a static
> > function too.
> > 
> > Cc: <stable@vger.kernel.org> # v6.13
> > Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes
> 
> AFAIK all this isn not used at all in the kernel, so a stable tag
> feels a bit odd.

Will remove.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
