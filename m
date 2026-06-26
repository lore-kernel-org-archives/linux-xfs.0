Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B2F19DF6A;
	Fri, 26 Jun 2026 04:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448281; cv=none; b=dO0ATqo98GaKNLDJf5DeZXwLD64W+gjhM7kpPrNnO6rjL0qJnKk4Uj3L0tY/D0bEbm77ZNv7CvFNdOR5pO2XqjBDIJBcFroDDEXrT/AKXqi6t/nJ0fD8PbqHdmav4ASeapd5Yc2SAORSr/Pse3A4y+uSU/q35ra8Utv+1xrRQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448281; c=relaxed/simple;
	bh=WJElwibxezKch90RFFEQGKqc8pj55AgE04u4MY3liLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=me+3OqV7vcZ0PxIagOgCtixH2rhbHKSDYRVyKxkxtTVw6OkfMMlaaTb8bQTPRiVc7f/bDgDQ45Gs7EC8LEfjp9g8OX0/8oD5aWA6pRvPVytAz/snndL/JouLnOxX8VKuG57DBDXKf+Z/++/g5t2dgHS5ysoSzJopk67nxvL9ra8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8F7368B05; Fri, 26 Jun 2026 06:31:17 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:31:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626043117.GB8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625174758.GE6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 10:47:58AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > Currently the iomap buffered read path tries to build up read context
> > (i.e. bios for the typical block based case) over multiple iomaps as
> > long as the sector matches.  This does not take into account files
> > that can map to multiple different devices.  While this could be fixed
> > by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> > over iomaps actually was a problem for the not yet merged ext2 iomap
> > port, as that does want to send out I/O at the end of an indirect
> > block mapped range.
> 
> This really puts the onus on block-mapped filesystems (e.g. ext2) to
> merge adjacent maps into extents.  Granted they *probably* already have
> been doing that.

Yes.  In fact the ext2 conversion was the first ask for this change,
because they do not want unlimited merging but kick off I/O at the
indirect block boundary.

> > So instead of adding more checks move over to a model where a bio only
> > spans a single iomap.  Change ->submit_read to be called after each
> > iteration, and pass a force argument to indicate that the bio must
> > be submitted set on the last iteration.  Switch the bio based users
> > to always submit, while keeping the single submit for fuse.
> 
> Is fuse the sole reason for the "force" parameter to exist?  I wonder if
> fuse could drop its submit_read function and call fuse_send_readpages
> after the iomap_read{ahead,folio} function returns?

Probably..

