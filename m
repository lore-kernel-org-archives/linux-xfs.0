Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50F91C6A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8921368B05; Thu,  4 Jan 2024 07:24:30 +0100 (CET)
Date: Thu, 4 Jan 2024 07:24:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/15] xfs: don't allow highmem pages in xfile mappings
Message-ID: <20240104062428.GC29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-10-hch@lst.de> <20240104000324.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104000324.GC361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:03:24PM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * We don't want to bother with kmapping data during repair, so don't
> > +	 * allow highmem pages to back this mapping.
> > +	 */
> > +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> 
> Gonna be fun to see what happens on 32-bit. ;)

32-bit with highmem, yes.  I suspect we should just not allow online
repair and scrub on that.  I've in fact been tempted to see who would
scream if we'd disallow XFS on 32-bit entirel, as that would simplify
a lot of things.

