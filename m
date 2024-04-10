Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E8BA2E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712721862; cv=none; b=ldDC2rg7zlb6R0qy4wYbbmsDXsO2aVlqAWK/QJECGO200pWuJdcWxRxVhnpzoem/kSn0kvKHYP+h+VgKCXfuVgjSJZ1HcXWhgem/qKzbNkpkbA0gehhhjGQ82W2S54zGr6NDJnDQcgLQDggj8XMG6WjW4M8ON24nVeERRLCWevk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712721862; c=relaxed/simple;
	bh=3btuJ+76Vmy93hCvUe+6fmq0GmmE1/SJp9OaqWbdOGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQtJT7qkOEYwIiqVx4jzU8QNsjemlGshatrix2RYH3SCevdWmCZcN6JHhI5gSQBN8wGmnIev9fIfSoTYwv1cqn/vy4wKURSXKlCLm3jYDdq4TOaRL/qOkSJi/1lq/DGIXhh/wnZBCGsnQxCzwf8Bl3jdVyl5yTk7at2vFqs07qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 96BF568B05; Wed, 10 Apr 2024 06:04:17 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:04:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 7/8] xfs: fix xfs_bmap_add_extent_delay_real for
 partial conversions
Message-ID: <20240410040417.GA2085@lst.de>
References: <20240408145454.718047-1-hch@lst.de> <20240408145454.718047-8-hch@lst.de> <20240409231645.GK6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409231645.GK6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 04:16:45PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 08, 2024 at 04:54:53PM +0200, Christoph Hellwig wrote:
> > xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
> > and converts them to a real extent.  It is written to deal with any
> > potential overlap of the to be converted range with the delalloc extent,
> > but it turns out that currently only converting the entire extents, or a
> > part starting at the beginning is actually exercised, as the only caller
> > always tries to convert the entire delalloc extent, and either succeeds
> > or at least progresses partially from the start.
> > 
> > If it only converts a tiny part of a delalloc extent, the indirect block
> > calculation for the new delalloc extent (da_new) might be equivalent to that
> > of the existing delalloc extent (da_new).  If this extent conversion now
> 
>                                    da_old?

Yes.

