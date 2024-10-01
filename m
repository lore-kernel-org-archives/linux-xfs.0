Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF2919922D
	for <linux-xfs@vger.kernel.org>; Tue,  1 Oct 2024 08:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727772562; cv=none; b=Xwz1r0nHtz2DbBmh6qQah3aoeN23xZv7J/7SoADmIz8pTtTDIj9V6QIw4oIO01XmFHHtSd/In36g2byTsRDyyxmz4xK7L8QhVkW5hjak4ZZR2/ceYWyuw7sn9f8KcKis0Nd4TAXJ+pjCIWuNsM+EyD4tUsna5P1FjOW96JjYsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727772562; c=relaxed/simple;
	bh=b5yi3A/VqrQ1qdC+ULOkxxsHgHWGlL/uTSgc5d+bs/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MB7wmmHZdyVHmsbM6WwofSXna1WtTfYKaonRQ9RtjQI+UY5ZctbqtoOlRBP2QE9Zl4VakFCd17G/ebISFHGLkOsX2vaKFX9xqpYbtrjzZVMJ0mE6+MsYJc8xCPvnS2QEa45vNZiElhI3bzAQ626L38ZhHyPc8l4hTXsERy3Y85A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 757D9227A87; Tue,  1 Oct 2024 10:49:18 +0200 (CEST)
Date: Tue, 1 Oct 2024 10:49:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <20241001084918.GB21122@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-4-hch@lst.de> <20240930165019.GS21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930165019.GS21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 30, 2024 at 09:50:19AM -0700, Darrick J. Wong wrote:
> > +int
> > +xlog_recover_update_agcount(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_dsb			*dsb)
> > +{
> > +	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
> > +	int				error;
> > +
> > +	xfs_sb_from_disk(&mp->m_sb, dsb);
> 
> If I'm understanding this correctly, the incore superblock gets updated
> every time recovery finds a logged primary superblock buffer now,
> instead of once at the end of log recovery, right?

Yes.

> Shouldn't this conversion be done in the caller?  Some day we're going
> to want to do the same with xfs_initialize_rtgroups(), right?

Yeah.  But the right "fix" for that is probably to just rename
this function :)  Probably even for the next repost instead of
waiting for more features.
