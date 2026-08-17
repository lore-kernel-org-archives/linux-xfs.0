Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BFC32B135;
	Mon, 17 Aug 2026 07:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950167; cv=none; b=ZpwGxHIe0xQHur4YlNfdupt6ZGtiojqRgd8QwWbdkRonlYIvWCtjP3bC0YbshxsrYGToW2w45skO7mvOF+qsQ551g/ORYTKmWHAGxifg5TgzC+VS/lx0RTnWFFG426WYXA0e43UN6nRQJalptNnW3qGQP8iElvVTtVX5NIIK7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950167; c=relaxed/simple;
	bh=merkgYT2X3hdUwYkn8izr2McZwmb+5v1wsrNai+UYek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL7F++zCGLN0AZTVeDhHkExpEDHvY5MhuxL9m5VNtZY1meUVRoskqdc83G9y3vLnjmPk6cUwLltPzC6Dj7lQ2ifBmQuhPYsnmLhBLh8eGyzWiqKQYL9I5CKQQgYv4O0WM8Mwzj2AVSnt9NYaHLSDjxlRbdMWq3S+s6ehU5pGwZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 437CF68CFE; Mon, 17 Aug 2026 09:02:41 +0200 (CEST)
Date: Mon, 17 Aug 2026 09:02:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 00/25] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260817070240.GA17371@lst.de>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 14, 2026 at 11:24:17AM +0200, Andrey Albershteyn wrote:
> Hi all,
> 
> This is next revision of fsverity for XFS.
> 
> Range-diff with v14 also below.
> 
> Patches without review:
> [PATCH v15 07/25] block: add task-context bio completion
> [PATCH v15 08/25] block: don't delay bio task completions
> [PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
> [PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with fsverity
> 
> The patchset include some patches from lazy-bounce@hch-misc series for
> BIO completion in task context

A different version of that landed in the block tree.  So let's hash
out how we want to handle this for the 7.4-rc merge window after the
dust for the current merges settles.  I can have the lazy bounce series
ready early for the merge window, and should be able to send it out
once all depdendency trees hit mainline.  Does that sound good?  Or
should we split the minimum requirements into a separate branch?

