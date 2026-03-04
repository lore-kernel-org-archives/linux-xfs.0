Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5899B351C36
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 08:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772612414; cv=none; b=hdddZ+gr3UMhGxoJFIHSS0iNMDRyt0eOhWEHHWgfwB7TAfcKoidLcvjUtqsD4Dgr4f8S9t7tJ2D/w71JbGqTY+Ivod3n1l3GM6yxEEELvFeKUyFmuu7UQBB+BahPf+H1oWcR5cKRmWAbOLvZyptl8LLj+yywNI9uGZbdodeaVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772612414; c=relaxed/simple;
	bh=+jJt0K2VWhBkXMTPvaVREVKlMIvm8FDZvZANxH8CfWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C++I8GTZ2m9bt0o87cTwTjflmAJW3zCNRTf6VzuVZ/IWeE8r/Wr+Tb3Hkp12Z33+1BRjn6td7W8bBW3GuA2ZXX93zDVNE0D6xceUpMzWMmIcOyl0w8sF0CADYPS8aPuPf0PYWkCJTK/pT/RSWwRbi2ZQ8adawSdMfCSF8b4Xi6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o9HGjHGZ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o9HGjHGZ"
Date: Wed, 4 Mar 2026 08:20:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772612410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCKF0vuvl/45bzumtTGogzhmOkDvmZk4E2bcjv8myZc=;
	b=o9HGjHGZ7iswncVeAeo/Oi4fU/j25IgsGAVubWjkOIYKAyHct2iB1TEhjPaTeWNcYn3quG
	neAUAdieBo2D1hnpvO/zl+GWN9D77WVEiN9dkt5iEfzIeeKOUbuqM93ldvQBQAgdqVrdWz
	B3ljv4ZN1xbfK3rQBRICBOifExv07sk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com, dchinner@redhat.com, "Darrick J . Wong" <djwong@kernel.org>, 
	gost.dev@samsung.com, andres@anarazel.de, cem@kernel.org, lucas@herbolt.com
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Message-ID: <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab9Lgt-HUaNq-FL@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 03, 2026 at 07:24:30AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 27, 2026 at 03:08:41PM +0100, Pankaj Raghav wrote:
> > Currently, xfs_alloc_file_space() hardcodes the XFS_BMAPI_PREALLOC flag
> > when calling xfs_bmapi_write(). This restricts its capability to only
> > allocating unwritten extents.
> > 
> > In preparation for adding FALLOC_FL_WRITE_ZEROES support, which needs to
> > allocate space and simultaneously convert it to written and zeroed
> > extents, introduce a 'flags' parameter to xfs_alloc_file_space(). This
> > allows callers to explicitly pass the required XFS_BMAPI_* allocation
> > flags.
> > 
> > Update all existing callers to pass XFS_BMAPI_PREALLOC to maintain the
> > current behavior. No functional changes intended.
> > 
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 5 +++--
> >  fs/xfs/xfs_bmap_util.h | 2 +-
> >  fs/xfs/xfs_file.c      | 6 +++---
> >  3 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0ab00615f1ad..532200959d8d 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -646,7 +646,8 @@ int
> >  xfs_alloc_file_space(
> >  	struct xfs_inode	*ip,
> >  	xfs_off_t		offset,
> > -	xfs_off_t		len)
> > +	xfs_off_t		len,
> > +	uint32_t flags)
> 
> Messed up indentation.
> 
Oops.

> Given that we've been through this for a lot of iterations, what
> about you just take Lukas' existing patch and help improving it?

I did review his patch[1]. The patches were broken when I tested it but I
did not get a reply from him after I reported them. That is why I decided
to send a new version.

[1] https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/

--
Pankaj
