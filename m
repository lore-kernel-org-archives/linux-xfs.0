Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE2B13BC05
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718948895; cv=none; b=a8r6+h+4GwPE9/p7KRu1JOMipOZEudidBXaLgzepb22d4yA4JMVRZmucxK367UsGnDf+MEodHmlXkxnL4I2ofRDhawqKss7e2rup1gDwb1+DqkdMheDiI8aWIdV+U1R6dVKuD3Sc+flY9kW7TD2CpZIlsPS+64njluuAbY44ATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718948895; c=relaxed/simple;
	bh=0d/UFVcXhUMpeIb3JEQDUNk0YBWcCa6pg1baWrzSkTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbsZz4gZX7PDTIzP/5XLmmNrhrDyeOdM0U3/LP+Y82f8KlYghwKbv7Rs0TvPZ4K0UNn6GWFCvNeRxjbQHXoYINhlnxb3w8DacbWieYAKBymwZKyUVypFnuIh66IhIGdYC+qxLHiJnEj+w4PtSWi/hgD0OwUnVsqa7ZJQR3GwCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F51E68AFE; Fri, 21 Jun 2024 07:48:09 +0200 (CEST)
Date: Fri, 21 Jun 2024 07:48:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <20240621054808.GB15738@lst.de>
References: <20240620072146.530267-1-hch@lst.de> <20240620072146.530267-12-hch@lst.de> <20240620195142.GG103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240620195142.GG103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 20, 2024 at 12:51:42PM -0700, Darrick J. Wong wrote:
> > Further with no backoff we don't need to gather huge delwri lists to
> > mitigate the impact of backoffs, so we can submit IO more frequently
> > and reduce the time log items spend in flushing state by breaking
> > out of the item push loop once we've gathered enough IO to batch
> > submission effectively.
> 
> Is that what the new count > 1000 branch does?

That's my interpreation anyway.  I'll let Dave chime in if he disagrees.

> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c      | 1 +
> >  fs/xfs/xfs_inode_item.c | 6 +++++-
> 
> Does it make sense to do this for buffer or dquot items too?

Not having written this here is my 2 unqualified cents:

For dquots it looks like it could be easily ported over, but I guess no
one has been bothering with dquot performance work for a while as it's
also missing a bunch of other things we did to the inode.  But given that
according to Dave's commit log the іnode cluster flushing is a big part
of this dquots probably aren't as affected anyway as we flush them
individually (and there generally are a lot fewer dquot items in the AIL
anyway).

For buf items the buffers are queued up on the on-stack delwri list
and written when we flush them.  So we won't ever find already
flushing items.

