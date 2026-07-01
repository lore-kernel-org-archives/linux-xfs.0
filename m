Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53548192D97
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 09:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782898293; cv=none; b=Z8coNkYW5jhFfcCSNAZ6ThJhJ5orIPptwRrvC3uebeVppdk/NXYSjBXjRgYmKnW40Gf4GCV2bKVTLrk9HqgYheQ2Y8yszDT5M2sQoVYsRje3bcgI+sYymxzh1xUqi0k6/WGrewiHALbWIWGfuht2TtgZJV6Bu5+6IG/2+TJmtzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782898293; c=relaxed/simple;
	bh=KzJoAHyyrKUC8+MxS3j85S3ALhz9DD3SqYGiD5nEQZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQNUYvMckimHQppp7tTNlbtoLigNI8J/5CsT1CUpw25kf9V5Evq9AZybtfTcJACgSXf9HhRDSPJtcIqPCZOCyQyqTB8hzpOJBnDe4JHJanrg+w6uR7C7qRZYXFFss5oj/MSu2HTPYRvYbQ16c9NS0kt7bdSOOxDZuaxi3Oj1Vv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0wwh52o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0wwh52o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F320F1F000E9;
	Wed,  1 Jul 2026 09:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898291;
	bh=NIlzmuPXRDaXB61jA8X8JrJUkqRyLRwsA2DRMYbsIZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R0wwh52odYFaBOu98DCGZmPbkE86/pL55yjH9fSVZfneOyoub+hes7lqDCA1C3d+J
	 RgnIWxGp0m2S/1l2HjIjrlMJxlGnNXDz5YR/Ls32vBmyh3HaK//cyL/ZyIBHsPJESE
	 ZtwXSj7/7l5rkg+RxWh9bCvZ8lgnP8UVOE+GYlHnLnid/SwkWHSflRcXx3fuBHL04A
	 J4IrCv69zmYPYQCwB85j7ZIUgU1yF8t0Z+MXmfOM2nHMUBJtfZEnTtU3DNyudCsHVR
	 2OkAuCjAsKpD6EeRyuwhdfwuNst3/FZJpARki/9Xo1BglwY+YQ0VNV+nBHTTMb78Os
	 xYkClxh8Qy9Cg==
Date: Wed, 1 Jul 2026 11:31:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: lift setting __GFP_NOFAIL from
 xfs_buf_alloc_kmem to the caller
Message-ID: <akTeZYyMbJNNDSxF@nidhogg.toxiclabs.cc>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-3-hch@lst.de>
 <20260630005254.GH6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630005254.GH6078@frogsfrogsfrogs>

On Mon, Jun 29, 2026 at 05:52:54PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 17, 2026 at 07:58:03AM +0200, Christoph Hellwig wrote:
> > The current __GFP_NOFAIL setting is wrong in some cases.  Prepare
> > for fixing that by giving control to the caller.
> 
> Simple enough...

/me interprets it as a RwB

> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_buf.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index d3d44e3ff001..dce398337ad0 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
> >  	ASSERT(is_power_of_2(size));
> >  	ASSERT(size < PAGE_SIZE);
> >  
> > -	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
> > +	bp->b_addr = kmalloc(size, gfp_mask);
> >  	if (!bp->b_addr)
> >  		return -ENOMEM;
> >  
> > @@ -230,7 +230,7 @@ xfs_buf_alloc_backing_mem(
> >  	 * smaller than PAGE_SIZE buffers used by XFS.
> >  	 */
> >  	if (size < PAGE_SIZE && is_power_of_2(size))
> > -		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> > +		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
> >  
> >  	/*
> >  	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> > -- 
> > 2.53.0
> > 
> > 
> 
