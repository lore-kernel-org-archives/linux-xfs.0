Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9446B54765
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066284; cv=none; b=L7mJJlg0PN9LmwSG2RWTC57d89r/y6spMsjugM7uWpgaXJDL+C0S+ErWN7bVId0ZNogDSw1BOm+2Es67KYhGVOrkHe3qzT8voZiFSszR9wWzq2v/vNPeJVXPb/n3tSbfLgPTe01BT396XzPJW0i23i9kZshk12vWa2+clOMmvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066284; c=relaxed/simple;
	bh=ul42jTYwZGxjG2GzKOvN4n5NeB5R3Te30YyN0168XA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYyR8si3VusyxU9qUxByevOmTOuCoCseV7zMpEfqnGnlVk4aZ3pMjiH7Pesf5VfVuZ01EwkZNO7wIIfPja7NEXMXUVIRin/ihap5fsqiplCZtZX3Js8l4eSx9AjWiYoNn2gNiSFO9iwpqMxfVVUcKa+Q65BVH5ypMSavHi4s/lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 48E0468BEB; Fri, 13 Dec 2024 06:04:40 +0100 (CET)
Date: Fri, 13 Dec 2024 06:04:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: move xfs_bmapi_reserve_delalloc to
 xfs_iomap.c
Message-ID: <20241213050439.GB5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-5-hch@lst.de> <20241212211843.GQ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212211843.GQ6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:18:43PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:29AM +0100, Christoph Hellwig wrote:
> > Delalloc reservations are not supported in userspace, and thus it doesn't
> > make sense to share this helper with xfsprogs.c.  Move it to xfs_iomap.c
> > toward the two callers.
> > 
> > Note that there rest of the delalloc handling should probably eventually
> > also move out of xfs_bmap.c, but that will require a bit more surgery.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Not opposed since we /could/ move this back if userspace ever (a) grows
> a fuse server and (b) decides to use delalloc with it, but is this move
> totally necessary?

It's not totally necessary, we could also mark xfs_bmap_worst_indlen and
xfs_bmap_add_extent_hole_delay non-static and be done with it.  But then
again I'd rather reduce the unused libxfs sync surface if I can.

