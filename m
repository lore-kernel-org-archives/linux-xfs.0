Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19592750ED;
	Fri, 26 Jun 2026 04:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448211; cv=none; b=Uf4WfoUJQta9IRNITKYU/EWpRHiAnz0noB/6NlddKKruOa+GBYo6/xn7bJfOZVBpxxnyOQT5if0w7jz3Gl4rd2xhkGqIkdnSpeoyAxDGoqRvHb/Dt2uCZeU5Q/BINeGFWUdGUsf2nK0Y8yXRre5fCOmqKu/e7cjQ96Qcsd3zaSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448211; c=relaxed/simple;
	bh=MkXrGcX+SOyWe6m5CCgOkADucvhqSWszBwkrXxS81CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGNRR+Gkv0sbnTPxnagq0lE82NHt+2Hs+kQc3FQHYLno3MdZWoYNuzY811EnT7Up3LUzKtH5+V4Pnj7HADml9z3oGKVJGem6QmjTabNsTRt5lWIxlrkEwuOjNTpAqgEOjB8aeNbXw48YD0DbRoenLndbgZBkUr9r2jYscSzbS0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0259B68BEB; Fri, 26 Jun 2026 06:30:03 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:30:03 +0200
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
Subject: Re: [PATCH 1/2] iomap: consolidate bio submission
Message-ID: <20260626043003.GA8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-2-hch@lst.de> <20260625172740.GD6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625172740.GD6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 10:27:40AM -0700, Darrick J. Wong wrote:
> >  
> > +	bio->bi_end_io = end_io;
> >  	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
> >  		fs_bio_integrity_alloc(bio);
> 
> Ah, so the bug here is that all the pagecache readers should have been
> allocating integrity information for the bio before submitting it?

Well, all the ones that set IOMAP_F_INTEGRITY, which really is just
XFS at the momen.  And because if the iomap refactoring for fuse XFS
is now using it's own submit callback and does not get it..

> And
> because it doesn't, iomap_finish_ioend won't do the read verification?

Yeah.

> So the block layer does it for us, and that's why we don't use the ioend
> chaining?  And (I guess) the future userspace interface won't have any
> means to get at the integrity data?

Yeah.

