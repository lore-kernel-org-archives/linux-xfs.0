Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379701EB21
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 667EF68AFE; Thu,  4 Jan 2024 07:26:26 +0100 (CET)
Date: Thu, 4 Jan 2024 07:26:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/15] xfs: use xfile_get_page and xfile_put_page in
 xfile_obj_store
Message-ID: <20240104062626.GE29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-15-hch@lst.de> <20240104002024.GH361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104002024.GH361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:20:24PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 03, 2024 at 08:41:25AM +0000, Christoph Hellwig wrote:
> > Rewrite xfile_obj_store to use xfile_get_page and xfile_put_page to
> > access the data in the shmem page cache instead of abusing the
> > shmem write_begin and write_end aops.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Much simpler, though I wonder if willy is going to have something to say
> about xfile.c continuing to pass pages around instead of folios.  I
> /think/ that's ok since we actually need the physical base page for
> doing IO, right?

Well, as mentioned in the cover letter I'd much prefer to return a folio
here, but we'd first need to sort out the whole hwpoison flag mess for
that first.  There's also a few issues with the xfs-internal xfiles
interface that need attention, but they're solvable.

