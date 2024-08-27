Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EBF1C6897
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769864; cv=none; b=CMF9AaCRi0Kdm3cZQX6rhRSTu4uJubZnk7ao6+/2+5IpshtqzQQvB4tR4QEafX8v89UZn45bHuKkhmiE+bRcojP1RXy535dR4hNlIuccXvqb37bUU0mmKLzu+kI3WWppytAVqdpI5rBWDc/XRm1BRBo5lfQju3MDgiYmHqNcfT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769864; c=relaxed/simple;
	bh=EuMio4ZpF2zLvTLuVLUrsOWwyPLuxWrCWLVVfI/rmTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZRHubrAhjoHHfg9HadwK4aFesVaYEllMGS5WGAwtEhfKhZMNx6ysfr6capNYlZJ21JtMUpJitPfyjxPaaHzq+YCQnMdkZuBXNf/aQ91hmFslD4bxFplwSj6+6b8SOuQqCrwPHA2FKzKsi3+VUDj5LlZiUpVOBIvmuYBCeDfkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJEe9NFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJEe9NFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA1AC6105E;
	Tue, 27 Aug 2024 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724769863;
	bh=EuMio4ZpF2zLvTLuVLUrsOWwyPLuxWrCWLVVfI/rmTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HJEe9NFFvQf3zGvmFkcIbcL2DVl9M+a4nVTyljcks5MTZqdM8vvTh84Jbcgij+zta
	 5DWbW824dn6D4LCy6UW+8cdYMplWlsa+lUzC6yVJvCV3kbid+JaxT1GgQzS0DF5Gxf
	 8Cooz2tvk8Wslad5Gw0syq5EVQ4Eb0gWNVKkUZaf6FO1+m0AdKSQgrTLl8SkAiuG+C
	 7AIIU287oioOWUOnCJ7/q/oWiuZwGSFleGhirZOcblIh4XOQFSmbbAcZmytg4SLJQR
	 ecDD406YhqBxQkaiYeIxreK89xRkGAx/jz3vKuCSAlT13cgzaWRHw0knYjSk+CToWG
	 xkHBN1ap+qdnw==
Date: Tue, 27 Aug 2024 07:44:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <20240827144423.GO865349@frogsfrogsfrogs>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
 <Zs3CuTVfX1f2oZTD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs3CuTVfX1f2oZTD@infradead.org>

On Tue, Aug 27, 2024 at 05:12:41AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 01:50:22PM +0200, cem@kernel.org wrote:
> > +	struct xfs_attrlist_cursor	cur = { };
> > +	char				attrbuf[XFS_XATTR_LIST_MAX];
> > +	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> 
> Not really changed by this patch, but XFS_XATTR_LIST_MAX feels pretty
> large for an on-stack allocation.  Maybe this should use a dynamic
> allocation, which would also remove the need for the cast?
> 
> Same in few other spots.

Yeah, the name list buffer here and in scrub could also be reduced
in size to 4k or something like that.  Long ago the attrlist ioctl had a
bug in it where it would loop forever, which is why scrub allocated such
a huge buffer to try to avoid falling into that trap.  But that was
~2017, those kernels should have been retired or patched by now.

--D

> Not really something to worry about for this patch, so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
