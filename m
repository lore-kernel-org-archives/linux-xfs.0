Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDDE3254B0;
	Thu, 25 Jun 2026 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393777; cv=none; b=ItfqIMSdGVmXvCefuU5UasR+qgZq4eQBxV5j8SbxTq/Z+AZO2QgftEWhczc52eB6mhYNOAh0GbLU4+KgQRr+wEqwi6c9ZACTcGRD525UMQYlwiUOT9Z0xx1+ZFnLfkjBe/GvHlDdHIQwW1/EzhMvTXLHfvhNBM7+MDgIp+wlkuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393777; c=relaxed/simple;
	bh=BaKBfavKVcNVwKcL1UKqGvhVxgPVmHX7YbiNzxX0VSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd1fGPVen53TxZ2JaUy+eTN7OjcrZiUr7CbUsIM6u5mx8cVO0KiwgBUff/P9faWXiXEZeGjHcnBmQnha17tb39DqFo79g3OSraEWFSPxTyAdx1uI3Jmld61H3pmo7kwEg/B1PqRhlub0pXAWy/ST7ygguQdA+EptI0d/lVHmKqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA0BE68BEB; Thu, 25 Jun 2026 15:22:51 +0200 (CEST)
Date: Thu, 25 Jun 2026 15:22:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260625132251.GA24598@lst.de>
References: <20260619050937.444488-1-hch@lst.de> <20260619050937.444488-3-hch@lst.de> <20260624174404.GS6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624174404.GS6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 10:44:04AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 19, 2026 at 07:09:29AM +0200, Christoph Hellwig wrote:
> > This test currently disables log concurrency scaling, but even the
> > data device concurrency scaling can create mismatching output on
> > systems with a large CPU count.
> > 
> > Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  tests/xfs/216 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/216 b/tests/xfs/216
> > index 1749647c11f7..ce8bb528410b 100755
> > --- a/tests/xfs/216
> > +++ b/tests/xfs/216
> > @@ -23,7 +23,7 @@ _cleanup()
> >  _require_scratch
> >  _scratch_mkfs_xfs >/dev/null 2>&1
> >  if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> > -	loop_mkfs_opts="-l concurrency=0"
> > +	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
> 
> /me notes that -lconcurrency is not compatible with -llogdev and the
> loopdev is not formatted with SCRATCH_MKFS_OPTIONS, so this won't work
> to disable the concurrency= mkfs options if fstests is being run with
> SCRATCH_LOGDEV set.

Arrg.  I hate our option parsing mess.  Any good idea how we'd get
the desired result?  Unless there's something easy I'd be tempted to
leave it to the first person using an external log device and large
cpu counts..

