Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676501428E2
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244474; cv=none; b=TDbEhEwLkuf6pCbEU5Fz+NZ4pQWr1v6LBXngfgje0lXZJSY46eOijsl684fkfJ+Irc/uu4gcfI8x8UT2yoGYgCrrdsQ+kZG4adhbjL9iuObSYyRnTmw+g6aG2WBZR2VFiqyMKCCkDKe2zbuPg/p0HjRqC9J//etj/hCaSohkziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244474; c=relaxed/simple;
	bh=RKJLkuhZGM4/INrL/ttrD1p/WvLtVSzbIuPNujKgPrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6QgJLiIuJ2OPr0i08O7j6ki507Hf0+Wlh+22givkQq7618fQ8XB6oxybzpeWS1l087QZWp9NN1opKMAZCjJ0XFFJ944JJCxS1WUoz8a3cccbrnqpteIFtp2LTsT2NxX+KI8I6PTX6/CJAseuE80kqdnrhkHxuvUYaujOKVqB7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8016A68D05; Mon, 24 Jun 2024 17:54:27 +0200 (CEST)
Date: Mon, 24 Jun 2024 17:54:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: check XFS_IDIRTY_RELEASE earlier in
 xfs_release_eofblocks
Message-ID: <20240624155427.GC14874@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-9-hch@lst.de> <20240624155022.GL3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624155022.GL3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 08:50:22AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 23, 2024 at 07:34:53AM +0200, Christoph Hellwig wrote:
> > If the XFS_IDIRTY_RELEASE flag is set, we are not going to free
> 
>          XFS_EOFBLOCKS_RELEASED ?

Yes.

> > the eofblocks, so don't bother locking the inode or performing the
> > checks in xfs_can_free_eofblocks.
> 
> It'll still be the case that ->destroy_inode will have the chance to
> delete the eofblocks if we don't do it here, correct?

Yes.

