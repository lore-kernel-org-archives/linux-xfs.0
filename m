Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C2C2417CA
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901934; cv=none; b=X/vm5AXWTZQ33kMyLKoY9XymaxgMu7QLT2ajL/BMoUHiXvOhCZMSmPWgN2kErF71xQBsroh/ledH7hfjK9aLmFD6jDR4F5l8IU7V8Vc1AFnFLAVbuc30/ZbBNmBKQnEoQvfjXDUfHAXjUZxyqLl/J6aUABBTb1+/Gq7oFH6BXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901934; c=relaxed/simple;
	bh=8BYY29zN57dfiVuWgZVeI9JOFh/dkU8y1mEk2/m6T8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpOO0WeJjw26vjDi4uLQBctFKuND7B3VXRwgijUctSy/Bw4g1p835BW87hgX7psZYL2ZvQDcwLDARcR++JqL8QeTNvGycfm75RWwt4nlNBKPSr0YqbGJByz1oRCfg8uKV/g0X9OQliHctOSS51lDWjgPubJfhgQxxfb0Y1iSXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71C1368C4E; Fri,  7 Feb 2025 05:18:48 +0100 (CET)
Date: Fri, 7 Feb 2025 05:18:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/43] xfs: make metabtree reservations global
Message-ID: <20250207041848.GB5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-11-hch@lst.de> <20250206205021.GL21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206205021.GL21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 12:50:21PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:26AM +0100, Christoph Hellwig wrote:
> > Currently each metabtree inode has it's own space reservation to ensure
> > it can be expanded to the maximum size.  This is not very efficient as it
> > requires a large number of blocks to be set aside that can't be used at
> > all by other btrees.
> > 
> > Switch to a model that uses a global pool instead in preparation for
> > reducing the amount of reserved space.
> 
> ...because inodes draw from the global pool, so there's no reason to
> compartmentalize each rt rmap btree's reservation like we do for per-AG
> rmap btrees, right?

Yes.

> > -	to_resv = ip->i_meta_resv_asked - (ip->i_nblocks + ip->i_delayed_blks);
> > +	to_resv = mp->m_metafile_resv_target -
> > +		(mp->m_metafile_resv_used + mp->m_metafile_resv_avail);
> 
> This separates accounting of the usage of the metadata btree (e.g.
> rtrmapbt) from i_blocks, which is a convenient way to fix an accounting
> bug if ever there's a metadir inode with a big enough xattr structure
> that it blows out into a real ondisk block. So far I don't think that
> happens in practice, but it's not impossible.
> 

Heh.  I didn't think of that, but yes even if very theoretical at the
moment.

> Clearly, the mapping of before to after is:
> 
> i_meta_resv_asked	-> m_metafile_resv_target
> i_nblocks		-> m_metafile_resv_used
> i_delayed_blks		-> m_metafile_resv_avail
> 
> Makes sense.  And I guess we still consider the reservations as "delayed
> allocations" in the sense that we subtract from fdblocks and put the
> same quantity into m_delalloc_blks.

Yes.

> > @@ -932,13 +932,17 @@ xrep_reap_metadir_fsblocks(
> >  	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);

...

> > +	/*
> > +	 * Resize the reservations so that we don't fail to expand the btree.
> > +	 */
> > +	return xfs_metafile_resv_init(sc->mp);
> 
> I'm not sure this fixes the reservation correctly -- let's say we have a
> busted btree inode with a 100 fsblock reservation that was using 20 fsb.
> At mount, we'll have called xfs_dec_fdblocks for 100 - 20 = 80 fsb:
> 
> 	hidden_space = target - used;
> 	xfs_dec_fdblocks(mp, hidden_space, true);
> 
> Then we rebuild it with a more compact 18 fsb btree.  Now we run
> xfs_metafile_resv_init and it thinks it needs to call xfs_dec_fdblocks
> for 100 - 18 = 82 fsb.  But we already reserved 80 for this file, so the
> correct thing to do here is to xfs_dec_fdblocks 2fsb from fdblocks, not
> another 82.

Hmm, yes.  If only we had a good test for this :)

