Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00F3C3BF4
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 10:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773137466; cv=none; b=tRc+ArP2zyGctSY+eqvPI0YDPxN9GWqkYM26wYW3O8eyeF3KTBimY2FjL3Ol6/pgQ33OVkPLKM4t/11MMDDjqS+kNOc5MIcLliAm3y49nb365wYR1rfYTkSNuVs5C/JYKCQ41N32tl24BCv6SYuBlpJrgqwj8zvyVC8e6q3yIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773137466; c=relaxed/simple;
	bh=GN7X0/QZwarMYZWKw4So34IjNaDKg0dYq3fkGMHYl3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIRyzreMbHRRVsjVFCB4E6O49HwEbL87SwSywD//NW1OTMGmpH6L4nnlfWATsDqGSH4LLP/lu+P2k7KMhG3IUeHLhSMw7FUGrWFGLlAYaUrgai8kZCO+UIuj2G6ehCHvjO0lSoRhXHnmy5M02auz/RuvVoYRcvJvUoGkfU1+7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EA5zkUbt; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EA5zkUbt"
Date: Tue, 10 Mar 2026 10:10:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773137462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MkxUBh9F8rVfeM6nUeZ+EcCZIJOkqentHraq/X5sVrQ=;
	b=EA5zkUbtONYtZeR8UY0adnHQtSNYSeZbz/AWdEmAPu40AtsVi7BIR6XhcDMqec1ZhcfOAb
	CY35DB/mY+cV5G16b2XqbGwz1QwrhPLyGOFAK9FDqNNlEJR6luCpFGHBb9fFF8ubHlCrA9
	CkCCYEv/qN9QGn4o5eIOG5DejG+J2gY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org, 
	cem@kernel.org, hch@infradead.org, p.raghav@samsung.com, pankaj.raghav@linux.dev
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <j2nfikz4ugqs6u25jpf7mlxhvzpiochp7eu4yslm6tjpwprcmu@e33c7htr3cd3>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <20260310004400.GU6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310004400.GU6033@frogsfrogsfrogs>
X-Migadu-Flow: FLOW_OUT

> 
> I can't help but think this would be cleaner as:

I agree. I think it looks much cleaner as a standalone function instead
of merging it with existing zero range function.

> 
> static int
> xfs_falloc_write_zero_range(
> 	struct file		*file,
> 	int			mode,
> 	loff_t			offset,
> 	loff_t			len,
> 	struct xfs_zone_alloc_ctx *ac)
> {
> 	struct inode		*inode = file_inode(file);
> 	struct xfs_inode	*ip = XFS_I(inode);
> 	unsigned int		blksize = i_blocksize(inode);
> 	loff_t			new_size = 0;
> 	int			error;
> 
> 	trace_xfs_zero_file_space(ip);
> 
> 	if (xfs_is_always_cow_inode(ip) ||

Why should we check for this here but we don't do this check in xfs_falloc_zero_range()?

There is a comment in xfs_falloc_allocate_range():

	/*
	 * If always_cow mode we can't use preallocations and thus should not
	 * create them.
	 */
	if (xfs_is_always_cow_inode(XFS_I(inode)))
		return -EOPNOTSUPP;

Don't we also use preallocations in xfs_falloc_zero_range()?

> 	    !bdev_write_zeroes_unmap_sectors(
> 				xfs_inode_buftarg(ip)->bt_bdev))
> 		return -EOPNOTSUPP;
> 
> 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> 	if (error)
> 		return error;
> 
> 	if (xfs_falloc_force_zero(ip, ac)) {
> 		error = xfs_zero_range(ip, offset, len, ac, NULL);
> 		if (error)
> 			return error;
> 
> 		return xfs_falloc_setsize(file, new_size);
> 	}
> 
> 	error = xfs_free_file_space(ip, offset, len, ac);
> 	if (error)
> 		return error;
> 
> 	len = round_up(offset + len, blksize) -
> 		round_down(offset, blksize);
> 	offset = round_down(offset, blksize);
> 	error = xfs_alloc_file_space(ip, offset, len);

missed passing XFS_BMAPI_PREALLOC here.

> 	if (error)
> 		return error;
> 
> 	error = xfs_falloc_setsize(file, new_size);
> 	if (error)
> 		return error;
> 
> 	return xfs_alloc_file_space(ip, offset, len,
> 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> }
> 
> ...assuming there's even a point to WRITE_ZEROES on a zoned file?

Don't we return EOPNOTSUPP if it is a zoned file as
xfs_is_always_cow_inode() checks for it anyway?

--
Pankaj
