Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8677B361668;
	Tue, 25 Aug 2026 06:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787641071; cv=none; b=OF8kbzYJukEZsIgN7uMlITohtxmg8Zab8CWrDc8YyJSK94qq+QDqgEfQofl0r82HesKfaZtwdboWpjRFxK/VU9IM5hu66IhlyhED2KSyiBFWokYsRybXK0Hhya1p7WtsS6xDd/X98XPdM0dfE4HbYOrcfsMWvbjX+zAT+NWWIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787641071; c=relaxed/simple;
	bh=l/JRAod7mcBLilL/tCxlbykTE5OwoELDGlJp6rgCQsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwNDlyLiGcjP/Rz/aT5D1+PwCovtB5WqWQV7eKyJymftjBgHOKIK2Z51pEI40Qy+v02FTHVWvKWe2uYOMKCIT2y4c3yqJGSDAEJ8BKs5QxR4SGppJdCpC+YOL062Dqa/PueflRJKyUIzXcXUn7lPe2/lWHNY+BcRGZk98vuMLX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05BEF68BFE; Tue, 25 Aug 2026 08:57:46 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:57:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, djwong@kernel.org,
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk,
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v4 5/6] xfs: write stream based AG placement
Message-ID: <20260825065745.GB24808@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd@epcas5p2.samsung.com> <20260717125538.508925-6-joshi.k@samsung.com> <20260819072902.GA2332@lst.de> <aac9db64-691c-4632-879e-bbf88784249d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac9db64-691c-4632-879e-bbf88784249d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 21, 2026 at 06:03:29PM +0530, Kanchan Joshi wrote:
> On 8/19/2026 12:59 PM, Christoph Hellwig wrote:
> > On Fri, Jul 17, 2026 at 06:25:37PM +0530, Kanchan Joshi wrote:
> >> If AGs are fewer than write streams, write streams are distributed into
> >> available AGs in round robin fashion.
> > 
> > I think we should just limit the number of available write streams
> > to the number of AG, as otherwise we'll get into a bit of a mess.
> 
> To confirm: given above quoting, for the other two cases (i.e., Streams 
> <= AGs), are you open to stream-based AG-sets modulo inode hashing (that 
> you suggested to skip in previous patch)?

Yes.  Even inode hashing might be ok, but I think it mostly papers
over other issues.

> And is this point only for the case when Streams > AGs?

Yes.

> This case can happen for hw streams, but for pure software streams, we 
> will not hit this case because the filesystem determines the stream 
> count based on the AG count.

Right.

> 
> > And for the case of the hardware write streams query them in mkfs
> > to align the AG geometry to that.
> 
> If this is only for the streams > AGs case, the filesystem can just 
> clamp down to match, turning it into a 'streams = AGs' case.
> And that means no changes in mkfs. Is that fine?

Well, it is fine.  But number of available write streams might be
a very useful hint to mkfs as mkfs tries to guess the available
concurrent, and the write streams are how the device exposes that.

