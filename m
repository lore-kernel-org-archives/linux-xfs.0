Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B55440638
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 10:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457175; cv=none; b=H78EMm60xnohIETDfL1McJQbkn91T5XHu3LOACHoKKHf5woqGRs8TZ4PJUpFxG+I8HTP2c89M1sq61JUkw6+sNbz6ujinHi684dam+aJoUIUmiLmWYshEFPbulLMsSFxEl+6Z1v8z3rsP+j8aGFjEyYbtNmhKzLEGdVpji+87I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457175; c=relaxed/simple;
	bh=eJT3/Tj/XzLxyIaV3d/hT5S8YthHX1l5uJXgL4DiQa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wm/G0Am/Fc4OjDJ6dpDSq2nt6TEFW4SEf1zjQrbBX7Z+Nfq0wi9d+JrQx6V9jzfiuPUXxIG20QIF9VVscoaGLf3Iv4kvmUsaHc8aebUk0C2BU7OrA12J3RIWMCvFkhH5PoMHXSAx3rhc25DjLdzl2zYwOi9ykXDcyFwlcs1ePJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiTZuUtu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiTZuUtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3741F000FF;
	Thu,  8 Oct 2026 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457174;
	bh=FTxe8+CSm4TnO3Qv0IktfvLpQRNzBa9kpsz2CpcZ4J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jiTZuUtu0z/hobLT5APm18HqR4FXyRVpQMejmWitD3z/4gJBDCNCS/IL3G7ukWzqq
	 lSP9+qDpgQrOv5KKwvxnk+W1ry1YlybOKTbaCmUlviGuEEsBYu1NRDbtYvNseAMl/Z
	 NV3nyEA+31xkPsWQoH0iuqfmGbIwKQJzdQbCYrs5EPrng4Pm2UucB4RdSp4JHW3Hde
	 isssrjr/CWutSDFb0bgpVoJWsQoPNvdavn0hU0Tbb31GDYz9pZ9ZaBGSJkYeLnA8AD
	 KDtRXuL2i2ZhNCtWRbAeSMzxQh0Dn+iXRi6+W/CeV9Qb/oxw0RCKnZy/ZxvJLokT++
	 /Mi0PVLtEVhyA==
Date: Thu, 8 Oct 2026 12:59:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Message-ID: <asd3cl5ih8lshJOx@cronus.toxiclabs.cc>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-13-hch@lst.de>
 <20261005214939.GR2705364@frogsfrogsfrogs>
 <20261007134105.GA507@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007134105.GA507@lst.de>

On Wed, Oct 07, 2026 at 03:41:05PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 05, 2026 at 02:49:39PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 05, 2026 at 02:56:22PM +0200, Christoph Hellwig wrote:
> > > Replace the the existing xfs_trans.h with a copy of the kernel versions.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Much nicer to have the same header, though I wonder if we ought some day
> > to move the kernel xfs_trans.h into libxfs/ ?
> 
> That's what the:
> 
>     small cleanups to help code sharing with xfsprogs
> 
> kernel series sent on Sep 25th does.  It got your reviews, so maybe it's
> time to just merge it.
> 
> 

It's going on the next batch, now I'm finally back home I can get back
to my backlog :)
