Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF9A1D68D
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFB2868AFE; Thu,  4 Jan 2024 07:28:05 +0100 (CET)
Date: Thu, 4 Jan 2024 07:28:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: factor out a xfs_btree_owner helper
Message-ID: <20240104062805.GH29215@lst.de>
References: <20240103203836.608391-1-hch@lst.de> <20240103203836.608391-5-hch@lst.de> <20240104011400.GL361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104011400.GL361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 05:14:00PM -0800, Darrick J. Wong wrote:
> > @@ -1875,25 +1874,18 @@ xfs_btree_check_block_owner(
> >  	struct xfs_btree_cur	*cur,
> >  	struct xfs_btree_block	*block)
> >  {
> > -	if (!xfs_has_crc(cur->bc_mp))
> > +	if (!xfs_has_crc(cur->bc_mp) ||
> 
> I wonder, shouldn't this be (bc_flags & XFS_BTREE_CRC_BLOCKS) and not
> xfs_has_crc?  They're one and the same, but as the geometry flags are
> all getting moved to xfs_btree_ops, we ought to be consistent about what
> we check.

Sure.
