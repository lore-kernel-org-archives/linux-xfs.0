Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902A63B14D1
	for <linux-xfs@vger.kernel.org>; Sun, 27 Sep 2026 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790522522; cv=none; b=eP3b4s6MXNIXQYVEWKiDKe2bk6ylHBs7zwWDWNr5v6jbvlHfVuheOLubMantvwrINGgOf1DHkAMcYLSpua+LLDIJlaKauqVvjhfmUidrq6qSO/lozWSCDIlaV4b4/+pv6/3YZCEGBKkbmeBw5FKWjjulVxwgPL3Z/7sDkNQOfAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790522522; c=relaxed/simple;
	bh=lUBGIxoM3hfbPcn2Z+yJVqQe+7MidJFNrymyvjdstnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kS+sNA1I3XCtobtZrUEJHFwHpEvt6VUNhzg0bG5SQujeXn0PbER6tte+WklIFgqpct88yC/ySCOXmOvVFRvT83QBgmYOpRyehZX9diSiVe3M6oodEQ1/IKAf+6jOYY4tPdgwef7tkZDZdBhvmcvLwiw0QULqx4gb28UgoteTWUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXI0F93U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXI0F93U"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1BBF81F00893;
	Sun, 27 Sep 2026 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790522521;
	bh=cyk/d3JkY78V7mlhOIe3uM0RQIIPZOL/2A73GRvuMV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iXI0F93UgB8ap05iXdJCXgrsEuqfJy9XVC3xEvxoGVUFknsj8gC31bzm+VcYi+Wya
	 AdGbcQJVO4GVD29bkDJqJsluECp7rRHEMTqp+9YHsfa5u0dAO4aOmUVzkUhmaeFS39
	 aUvPVvjPQo3A4HjqF6zDUmA8eASQx9ZkpO09J25Fec9gtnd2vKQplLobpYiEWwwVV2
	 +3+redxBCfjbP/eX/rjMVhee4YVrp1U3OXLqvWygUbj4KASGVZX4OxI/H7HPdwMZYd
	 dr8i14WJfxV6PaJBX/Vt0oEYttNsHg+swM7HPEbvnn/v5POpfTAbGVIdZ4uNHbzf9x
	 DhzCeBVlH/sPQ==
Date: Sun, 27 Sep 2026 08:22:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] libfrog: improve ramdisk handling in
 platform_flush_device
Message-ID: <20260927152200.GU2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-10-hch@lst.de>
 <20260925224720.GX2705364@frogsfrogsfrogs>
 <20260926060254.GB20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926060254.GB20636@lst.de>

On Sat, Sep 26, 2026 at 08:02:54AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 03:47:20PM -0700, Darrick J. Wong wrote:
> > > +	 * Historically the ram disk driver destroyed all data when BLKFLSBUF
> > > +	 * was called.  That has been fixed a long time, but still be careful.
> > > +	 */
> > > +	if (S_ISBLK(st.st_mode) && major(st.st_rdev) != RAMDISK_MAJOR)
> > >  		return ioctl(fd, BLKFLSBUF, 0);
> > 
> > BLKFLSBUF support on ramdisks hasn't been in the kernel since commit
> > ff26956875c2f0 ("brd: remove support for BLKFLSBUF") which was merged in
> > 4.10 in late 2016.  Maybe we should remove it?
> 
> People use xfsprogs on really old kernels.  Now no one really should
> care about data integrity on a ramdisk, but there's not too much downside
> of just keeping it, so I'd rather leave it alone.
> 
> The real question to be is why we even bother with BLKFLSBUF at all.
> It seems to come from e2fsprogs, where that is optionally called from
> ext2fs_sync_device with a a comment:
> 
> 	... and optionally attempt to
> 	flush the buffer cache.  The latter is basically only useful for
> 	system benchmarks and for torturing systems in burn-in tests.  :)
> 
> but despite that comment, all caller do set that flag.
> 
> btrfsprogs and f2fs-tool do not have any calls to BLKFLSBUF.

Yeah, I don't see much point in invalidating the bdev buffer cache after
flushing its contents to disk.

--D
