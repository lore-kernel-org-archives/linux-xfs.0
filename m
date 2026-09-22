Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7054CF5F;
	Tue, 22 Sep 2026 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083074; cv=none; b=u6vG7a9i08TeVp8dZ9tCCUaC/PozhXy4LY06VA480OBer6S1h5XWTwKD4Mp/qI0X+DKpD3irFly3TkxuK3wppNu0qcyDku0Xig5F0jjGCYVbpEB3VshL2+9T9GfyU1Wc5stOCo11Im8U+7OQ6OJa/XfSEjgy55Hddo0PXDmGNPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083074; c=relaxed/simple;
	bh=YABjEExd+hqzO7ghVtgMdywWrwp9buOxGk2M0QWRZ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJj9M1P4MkJdF1jU++fMpsxyz/DV2TpyF1s+gRPKQFqk5XcK8lsSCJpZkmEgN5jqbQ0JWYNtpu5nRgthTKO2UBQk/PHAGRfL7YNUlU1fpDPZLeYTYCST0Cfw/nbewMgvN4EnJJVBbBP+KvUjMY+/Ui2I6GjmOqWVnIKZD+5R9eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LItG2pLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LItG2pLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853CA1F000FF;
	Tue, 22 Sep 2026 13:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083072;
	bh=y0TF6dZ0xnYCANhgcMjOAc6HW+EA3FufymkDE0+X2Zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LItG2pLh3KPQ/p+d7a4wOA0boFie1ob3IDRcXzH6ioMezFCCOsUG1gZ2on/oWtkvx
	 83UOFHHkfLa0FTNOImhUjAA3igZOKxLk/c/ck25MUmiuHXiO9MFD1HMM3X7EcFrK5M
	 +aUQnNpphmiRk4rFyDPfioCQs43V7E75XDmS4NMs7o5Ny9anolntzasNASolpxsnhm
	 Mm2REZ4Ku0cmd2J6oxh8TYoQDZTxDS4QQjcc+9sgiXKzvtg9eXqvFdHz6BujDSMxDx
	 n01AhHf9uZHkgyfNC5pBpylVv/XqCfhE8NQwE7I47cbCt2NJuLKCQXzb8xE8MoR0av
	 b2yz04pVuWGhw==
Date: Tue, 22 Sep 2026 15:17:46 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, djwong@kernel.org, 
	ebiggers@kernel.org, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arJ_y1LCSrYFgOeh@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
 <arIrtgZ3-9zNuru_@infradead.org>
 <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <arJ1KAvP-4fWVvzW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ1KAvP-4fWVvzW@infradead.org>

On 2026-09-22 05:31:36, Christoph Hellwig wrote:
> On Tue, Sep 22, 2026 at 11:13:57AM +0200, Andrey Albershteyn wrote:
> > > And I think you always need to do the offload because fsverity can
> > > synchronously read metadata.
> > > 
> > 
> > hmmm not sure what case you see here.
> > 
> > Without integrity:
> > For data reads we get here. Here, while verifing data page, fsverity
> > requests reads of merkle tree pages which WILL NOT go through this
> > path as no read completion is done for them.
> > 
> > With integrity:
> > For data reads we get here. Here, while verifing data page, fsverity
> > requests reads of merkle tree pages which WILL go through this
> > path as they need integrity verification on the read completion.
> > Therefore, to use this workqueue for merkle tree pages integrity
> > verification we offload data block verification to fsverity
> > workqueue.
> 
> Yes, but we want to be able to use the bio defer path for other
> things including iomap error handling (I'm about to send a series
> for that).  So please always make fsverity do it's thing so that
> we don't add really complicated dependency chains.

ah ok, I see, I will change that

-- 
- Andrey
