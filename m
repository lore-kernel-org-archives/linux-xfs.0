Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8079FD51A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725367; cv=none; b=lRLydn+C36JbPOagnivkdT3xGCg6I8fSb6Wt/n1tMDox+557jTLURz2TwEfDs77iPWi5aLC8Ib5oTvsHH7pPz5C/9h80y8mbZxRg57JAGZjZt9R2BrEN7lcR1E1KuO749ZtRVOFtomeM2YNoTIc0HZmjM6XBgCpSFbMdQFnNGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725367; c=relaxed/simple;
	bh=hrAi7ZdJAqk6lKry+43muKpNkT4H6q346eoY6HSbdXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGwbYZORuKEfCVne2E9r+tmcmv7j95oXZxpm1TwYpEY5gpPlenOi+BxlEmVPdYbESe+I5vWeaFoFvCwGVgQWjy7PRBj1mDm6Vg7XNozZwfmPCjvYjAZa5XJ7BQ/t+oyo1F2s/z/z2Dr+do/IWuuG4ZkN7534IQwfTELicxyLqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A8PI0z29; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A8PI0z29"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ODaU8vfMaKixvjzLoNU3gA1AFqu32AWR5XUzGA7UnvQ=; b=A8PI0z29tPjT6/4Fj66UYPEMrH
	I/3T1nGuRG5MWFqAlNUQ6TIdt9rLJAi57O8egF51SCsUamNJrSLVZRK+Puzkj+HAuURaSSM9HQppb
	FvHi9K60/tYIFS6/MKF2Nl3szvmaHxZKPcXzYEd/q4ZrJrgtlFPhezsWE70KKBgnbUD9sibcULa0u
	ZacppBIdmc1lD+ZsqbnLArXBkbb+0atHXRpoOE0D9wL5pJEnsotLB8oZAS8965P3tpEcMAFWARO79
	Vm9eoxFiy9ocLb+VuTGR6EN06TiAfk7XbONKIr70PdtlkJUs203JUlVvztkvgk+G3RakvPrLsMql7
	jI2LcMPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ6f-000000056sL-47Wx;
	Wed, 10 Apr 2024 05:02:46 +0000
Date: Tue, 9 Apr 2024 22:02:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: rearrange xfs_da_args a bit to use less space
Message-ID: <ZhYddbKtG8CezHQP@infradead.org>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968452.3631393.6758018766662309716.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968452.3631393.6758018766662309716.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:50:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A few notes about struct xfs_da_args:
> 
> The XFS_ATTR_* flags only go up as far as XFS_ATTR_INCOMPLETE, which
> means that attr_filter could be a u8 field.
> 
> The XATTR_* flags only have two values, which means that xattr_flags
> could be shrunk to a u8.
> 
> I've reduced the number of XFS_DA_OP_* flags down to the point where
> op_flags would also fit into a u8.
> 
> filetype has 7 bytes of slack after it, which is wasteful.
> 
> namelen will never be greater than MAXNAMELEN, which is 256.  This field
> could be reduced to a short.
> 
> Rearrange the fields in xfs_da_args to waste less space.  This reduces
> the structure size from 136 bytes to 128.  Later when we add extra
> fields to support parent pointer replacement, this will only bloat the
> structure to 144 bytes, instead of 168.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Eventually we should probaly split this up, at lot of fields are
used only by the attr set code, and a few less only by dir vs attr.

