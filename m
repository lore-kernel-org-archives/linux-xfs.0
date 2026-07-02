Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92BD3EDE5E;
	Thu,  2 Jul 2026 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782991483; cv=none; b=XAUrmQF2gnNijoUdmfemcXSgkvU7wSe9re/0StpKSNzN2A9cUrV33kFGK71Od9JLqkYR5YzYz8Rp2EUVjjld1R5P6OtTnAMO25B11lzLzYFLj+ABfdOIhJnaTuullZWHwLcmW3IRzEXz74//I3OwCabKvpQ5IpCYsvFd2V1HuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782991483; c=relaxed/simple;
	bh=BrpgNcgC0a1hHbzfOzJMlyVEGH7cAkX+nQvexq9IRRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTYKkE9YVQbMGeShZSAkOUGIXjPquuMo3X5rw5ZYUKWfbU85zOEl83zlW5X/Y/aY1ll6N46QBFPIzIP7cdZ5lTqEw/o97ESwx69ugLAknQFwhnvadGF+LzLsrdaU8nYboZdubE53z+tOTyDM3gYgufzEJy3w05sNvtXgGZxLOAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBD0F68BEB; Thu,  2 Jul 2026 13:24:38 +0200 (CEST)
Date: Thu, 2 Jul 2026 13:24:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>, "Serge E. Hallyn" <serge@hallyn.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v3 1/5] xfs: fix capability check in xfs
Message-ID: <20260702112438.GA10565@lst.de>
References: <20260702093324.127450-1-cem@kernel.org> <20260702093324.127450-3-cem@kernel.org> <20260702103052.GA6670@lst.de> <akZITB_FDP1nl2_S@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZITB_FDP1nl2_S@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 02, 2026 at 01:17:29PM +0200, Carlos Maiolino wrote:
> On Thu, Jul 02, 2026 at 12:30:52PM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 02, 2026 at 11:33:17AM +0200, cem@kernel.org wrote:
> > > index 6339f4956ecb..205fe2dae732 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -835,7 +835,8 @@ xfs_setattr_nonsize(
> > >  	}
> > >  
> > >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > > -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> > > +					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> > 
> 
> Thanks, I tried to keep the parameters aligned, but I can bring it one
> tab back. Do you mind if I fix it at commit time if -unlikely- no other
> change is required?
> 
> This is what it will look like:
> 
>         error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -                       has_capability_noaudit(current, CAP_FOWNER), &tp);
> +                               ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> +                               &tp);

This still adds an extra tab.  Like much (but not all) of the kernel
we use two-tabs by default, which is also in the other two hinks.  This
now adds a third.  Just keep it as it was:

	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);

