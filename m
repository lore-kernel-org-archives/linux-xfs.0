Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ED6CA68
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2652168AFE; Fri, 15 Dec 2023 05:12:51 +0100 (CET)
Date: Fri, 15 Dec 2023 05:12:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/19] xfs: simplify and optimize the RT allocation
 fallback cascade
Message-ID: <20231215041250.GD15127@lst.de>
References: <20231214063438.290538-1-hch@lst.de> <20231214063438.290538-19-hch@lst.de> <20231214213221.GH361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214213221.GH361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 14, 2023 at 01:32:21PM -0800, Darrick J. Wong wrote:
> >  1) xfs_rtallocate_extent extents the minlen and reduces the maxlen due
> 
>                             ^^^^^^^ extends?

Yes.  I'm definitively talking about extents too much in my life :)

> > Move aligning the min and maxlen out of xfs_rtallocate_extent and into
> > a helper called directly by xfs_bmap_rtalloc.  This allows just
> > continuing with the allocation if we have to drop the alignment instead
> > of going through the retry loop and also dropping the perfectly the
> > minlen adjustment that didn't cause the problem, and then just use
> 
> "...dropping the perfectly *usable* minlen adjustment..." ?
> 
> > a single retry that drops both the minlen and alignment requirement
> > when we really are out of space, thus consolidating cases (2) and (3)
> > above.
> 
> How can we drop the minlen requirement, won't that result in undersize
> mapping allocations?  Or is the subtlety here that for realtime files,
> that's ok because we never have forced multi-rtx allocations like we do
> for the data device?

The rtalloc minlen is different from the bmap minlen.  The bmap minlen
is always 1 except for metadata XFS_BMAPI_CONTIG allocations, which
obviosuly can't happen for RT allocations.  The rtalloc minlen starts
out as a single rtextent and is increases when we adjust the physical
allocation location to better align with the previous extent.
