Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC9D266
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B64D268AFE; Fri, 15 Dec 2023 07:35:15 +0100 (CET)
Date: Fri, 15 Dec 2023 07:35:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/19] xfs: move xfs_bmap_rtalloc to xfs_rtalloc.c
Message-ID: <20231215063515.GA17669@lst.de>
References: <20231214063438.290538-1-hch@lst.de> <20231214063438.290538-6-hch@lst.de> <20231214204838.GT361584@frogsfrogsfrogs> <20231215040907.GB15127@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215040907.GB15127@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 15, 2023 at 05:09:07AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 14, 2023 at 12:48:38PM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 14, 2023 at 07:34:24AM +0100, Christoph Hellwig wrote:
> > > xfs_bmap_rtalloc is currently in xfs_bmap_util.c, which is a somewhat
> > > odd spot for it, given that is only called from xfs_bmap.c and calls
> > > into xfs_rtalloc.c to do the actual work.  Move xfs_bmap_rtalloc to
> > > xfs_rtalloc.c and mark xfs_rtpick_extent xfs_rtallocate_extent and
> > > xfs_rtallocate_extent static now that they aren't called from outside
> > > of xfs_rtalloc.c.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I never understood why xfs_bmap_rtalloc was there either, aside from the
> > namespacing.  But even then, xfs_rtalloc_bmap?
> 
> Fine with me..

Actually..  Given that it purely is a block allocator and doesn't
do any bmapping at all, the _bmap postfix is rather odd.

Something like xfs_rtallocate_extent would fit better, but the name only
becomes available after the last patch.
