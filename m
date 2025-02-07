Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF59194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902297; cv=none; b=e6gbHXKqa4Ip5uIqeuB1T7fR3W/FKyIixSe19ZItYktahlSSD2yXUGGu3NKP9QCXh8H0slKzU+Jls10j28dkjWIK20hiFxeHTXksQuMLU+lyyqC/MrwAyyMvWhbrDRKapw4EKumxafD+bi0lMR+ynan9RplF93K+WoHguuN7LjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902297; c=relaxed/simple;
	bh=UMUmuxIYiI5yMpxuRMtDBFLep9IV0Ogiq9EtmjhSZRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7A3jKX/SQqxZkyrR99PWI3AE4L6rACyQq3pAQCR90h+vaYZuB7HxBkwi5Iay++Tpu8oN2aTfzG0r25yhs/SnkvzIiptNKoNhWpAaVXEMWiKez7RytGhyOcAokz7kbsefAlaH38sNw/RF8OrKKdNK3l2xEfCGW9BcAQtk0zthtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O22Ean+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O22Ean+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74741C4CED1;
	Fri,  7 Feb 2025 04:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902295;
	bh=UMUmuxIYiI5yMpxuRMtDBFLep9IV0Ogiq9EtmjhSZRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O22Ean+01RNBlJhPG/dD++lfeFhhu8/mS0S+ddv6xtzGPv9JftkTTzN1JhylIeLDY
	 EJbq9gKkimlVjHadCftYkLt5q7TrWsGQve57sSZrdrD9W+61SrY3P4Iaf8Gg8qnkOE
	 7fnBg6a05i8IOO7bdO0+LJ46QyIkCwAjgyQDqW+4/EjEWelKAjenWvzhVp2bi5LcE0
	 SImilE2iV60E1bNe3sTBvYtpoT8mTzfo7p23bwqcBlzQhf0b7kwUpsWeAwfUOdcjWw
	 u4wkvVzGBdLe7HFD5e1STQL4xWfaLQurVlEi/97Ru8k4L8RO8GDiCV7QpLLSwH3Hae
	 MMqB65kgSpebg==
Date: Thu, 6 Feb 2025 20:24:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/43] xfs: make metabtree reservations global
Message-ID: <20250207042454.GH21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-11-hch@lst.de>
 <20250206205021.GL21808@frogsfrogsfrogs>
 <20250207041848.GB5467@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207041848.GB5467@lst.de>

On Fri, Feb 07, 2025 at 05:18:48AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 12:50:21PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:26AM +0100, Christoph Hellwig wrote:
> > > Currently each metabtree inode has it's own space reservation to ensure
> > > it can be expanded to the maximum size.  This is not very efficient as it
> > > requires a large number of blocks to be set aside that can't be used at
> > > all by other btrees.
> > > 
> > > Switch to a model that uses a global pool instead in preparation for
> > > reducing the amount of reserved space.
> > 
> > ...because inodes draw from the global pool, so there's no reason to
> > compartmentalize each rt rmap btree's reservation like we do for per-AG
> > rmap btrees, right?
> 
> Yes.
> 
> > > -	to_resv = ip->i_meta_resv_asked - (ip->i_nblocks + ip->i_delayed_blks);
> > > +	to_resv = mp->m_metafile_resv_target -
> > > +		(mp->m_metafile_resv_used + mp->m_metafile_resv_avail);
> > 
> > This separates accounting of the usage of the metadata btree (e.g.
> > rtrmapbt) from i_blocks, which is a convenient way to fix an accounting
> > bug if ever there's a metadir inode with a big enough xattr structure
> > that it blows out into a real ondisk block. So far I don't think that
> > happens in practice, but it's not impossible.
> > 
> 
> Heh.  I didn't think of that, but yes even if very theoretical at the
> moment.
> 
> > Clearly, the mapping of before to after is:
> > 
> > i_meta_resv_asked	-> m_metafile_resv_target
> > i_nblocks		-> m_metafile_resv_used
> > i_delayed_blks		-> m_metafile_resv_avail
> > 
> > Makes sense.  And I guess we still consider the reservations as "delayed
> > allocations" in the sense that we subtract from fdblocks and put the
> > same quantity into m_delalloc_blks.
> 
> Yes.
> 
> > > @@ -932,13 +932,17 @@ xrep_reap_metadir_fsblocks(
> > >  	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
> 
> ...
> 
> > > +	/*
> > > +	 * Resize the reservations so that we don't fail to expand the btree.
> > > +	 */
> > > +	return xfs_metafile_resv_init(sc->mp);
> > 
> > I'm not sure this fixes the reservation correctly -- let's say we have a
> > busted btree inode with a 100 fsblock reservation that was using 20 fsb.
> > At mount, we'll have called xfs_dec_fdblocks for 100 - 20 = 80 fsb:
> > 
> > 	hidden_space = target - used;
> > 	xfs_dec_fdblocks(mp, hidden_space, true);
> > 
> > Then we rebuild it with a more compact 18 fsb btree.  Now we run
> > xfs_metafile_resv_init and it thinks it needs to call xfs_dec_fdblocks
> > for 100 - 18 = 82 fsb.  But we already reserved 80 for this file, so the
> > correct thing to do here is to xfs_dec_fdblocks 2fsb from fdblocks, not
> > another 82.
> 
> Hmm, yes.  If only we had a good test for this :)

You could populate an rt filesystem with a lot of small mappings, then
use magic debug switches to xfs_repair to rebuild the rt btrees with
half full leaf and node blocks, and then force online repair to rebuild
it.  Then it'll rebuild them with 75% full blocks.  Come to think of it,
IIRC online repair also has secret debug knobs for that kind of thing.

--D
