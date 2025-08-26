Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2B230BDF
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214096; cv=none; b=FHUvcpn6PP8EHh0ftrXcqK3euNLfRfOBFL2ZV4XkAtlDX0zY3FgCBKQTWR9km8bMz9/NZ0RI1gyUs+ox76qG0GxMTfVGEjgnia0avQwoJKImi5hKtrrfP/bA6Ht23sfZOGvp9D3hEyKch1I6SQkZrbtPBsF85roztBnf3nn3ATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214096; c=relaxed/simple;
	bh=7VlW/AmB2Fk1Dc1e2pLT+dMSmyZCkDlSyb8+R5qWjqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhdaHxVXx0I/GcDm1WkGNgpnJktW8sZGS3hOZqfMLNvkfJBoamB839aadCcz4dOkWlIzEnGtgOyE1P354uJildSZ8qPxeFx3bwgrd37+19m8kcYwXtvwWYgnM2vp51vzAm5cYWvG0M+S3zyIwAcSKg3nC8v9NDkIN7T+7T7p0kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE3B967373; Tue, 26 Aug 2025 15:14:47 +0200 (CEST)
Date: Tue, 26 Aug 2025 15:14:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of
 vfs_getattr
Message-ID: <20250826131447.GA527@lst.de>
References: <20250825111510.457731-1-hch@lst.de> <20250825152936.GB812310@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825152936.GB812310@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 25, 2025 at 08:29:36AM -0700, Darrick J. Wong wrote:
> > -		if (xfs_is_cow_inode(ip))
> > -			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
> > -		else
> > -			da.d_miniosz = target->bt_logical_sectorsize;
> > +		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
> 
> ...though one thing I /do/ wonder is whether this roundup() should be in
> the vfs statx code?  Do people need to be able to initiate directio with
> buffers that are not aligned even to pointer size?

I've added Keith to Cc who is on a quest to reduce alignment requirement
as much as possible to add some input.  But as the new statx interface
never had it, adding it now seems off.  Also dword (4 byte) alignment
is pretty common in all kinds of storage specifications, so being able
to support this for things running on top of file systems seems like
a good idea in general.

