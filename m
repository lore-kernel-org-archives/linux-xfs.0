Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C8E4CA285
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008942; cv=none; b=pbIcRHav+EjMpQR2yk34Q0GnPH0nnL0clO3I5Prp9y112hw3GOqqnwAOvBnlLaIfqShHuwIvEI5GBr38ntCo3fBD+RRhMcIQQlONvxSQlxZ8tBsu//YMBtv/P6QH2KFE8IMtQDXUgYsHepIcKZZ24N1kGbNAlqMi86DQ/cspY8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008942; c=relaxed/simple;
	bh=3Yl8XoDNIRfwzAOdv+Nc36fpJ1rZoxUXG3I1zGWlnL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNjm3Gq2Vl4GjY6M/P24buxt0jpkLPFJDVwcgImyLDHWSat9RgD8n+NNbhIHnO4yHofKCvCMN/s//RsZwDtMPg9qqbaU2vFm1qUDure6+Ohw9AtZ5LfF/nBixMPIRMRs22psgrS58aW5D9FmFPjKv6u5CxZ/0/Ib13lahm9U1eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S4yzHWWZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S4yzHWWZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+j1J969Tnwn2jxUXNxDainnY9rzHux4LIgbAYwSOu7k=; b=S4yzHWWZzt2keQ7uAtXfcdJLJS
	qZpfmFg+se1Zv2NgKUtOovQw3XM/Dk3xLj2Ac1UsMuiceWM8h71P4h4VZOsd+dgBbWVgUABzKZ5XQ
	1lmFnM5MGNNuU52YbAV23oqK4KdD0kj24htvDYSKwBRQYTvEIsP0HomqXOZPqXKa5W2nbHWIKKyix
	aoODFRAkenQtSfIlb8pdeCaEEgOJTuMtssar4CGqrH0YBINYclw/gNhkPk+6LUnOFVOxbuPuWtP7n
	JLuwx4oCDhY+MgcOXrTFEhlwhFYnMyrRg0pfI5m+XddHn1Gh/SLvK4CVKVJselerHoQyE+87vh4Ba
	YawswVbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1via2G-00000005iBW-3Ikd;
	Wed, 21 Jan 2026 15:22:20 +0000
Date: Wed, 21 Jan 2026 07:22:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: speed up parent pointer operations when possible
Message-ID: <aXDvLIufYilqY-Ab@infradead.org>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695972.202851.10720887475428645960.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695972.202851.10720887475428645960.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:39:46PM -0800, Darrick J. Wong wrote:
> and fall back to the attr intent machinery if that doesn't work.  We can
> use the same helpers for regular xattrs and parent pointers.

Not just can, but do :)  This should really help with ACL inheritance
as well.

> +/* Can we bypass the attr intent mechanism for better performance? */
> +static inline bool
> +xfs_attr_can_shortcut(

This is really a could and not a can, it might still not be possible
and we bail out.  Maybe reflect that in at least the comment, if not
also the name?

> +	if (rmt_blks || !xfs_attr_can_shortcut(args->dp)) {
> +		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
> +		return 0;
> +	}
> +
> +	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> +
> +	error = xfs_attr_sf_removename(args);
> +	if (error)
> +		return error;
> +	if (args->attr_filter & XFS_ATTR_PARENT) {
> +		/*
> +		 * Move the new name/value to the regular name/value slots and
> +		 * zero out the new name/value slots because we don't need to
> +		 * log them for a PPTR_SET operation.
> +		 */
> +		xfs_attr_update_pptr_replace_args(args);
> +		args->new_name = NULL;
> +		args->new_namelen = 0;
> +		args->new_value = NULL;
> +		args->new_valuelen = 0;
> +	}
> +	args->op_flags &= ~XFS_DA_OP_REPLACE;
> +
> +	error = xfs_attr_try_sf_addname(args);

This mirrors what the state machine would do.  Although I wonder if
we should simply try to do the replace in one go.  But I guess I can
look into that as an incremental optimization later.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
