Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2081292DF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709436; cv=none; b=e+1BpxlcqqegT0bnVE5Imo3uV+XJ+eetuYX/uE7HZiYgkA2OoFSlDW7KNXV2o7MV/evMDywLHMPK1OMzWgEG8RXTdjRu8Qu5Be2x8J9La9R9wraSVycjQ9ngVck3i/+fPdNQRaqvNrXf1Ez/qNEbGE76jvCC7adch5LyCqMYawE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709436; c=relaxed/simple;
	bh=hYJRcMYlMROH/hKIXF5O8r7FKM8Ojv/tPFhItGVmTCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFnY9UnyTYrJIwa4FZ52pRrj3xfi/ZuTgQ245PxPvCZhllb9W19Z1KTZZGhP/QXJo+QEx19gNSiY2wKsKdLchVq8dKvr+QXeiWwR4kP6JR7L3YTkSWt8Q3iy7KusUKVj8v8smPmaBcgMIt8wPdzxiwLIIB6Cj0lGbsFHh/krzhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIViRE17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIViRE17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32ECC433F1;
	Fri, 23 Feb 2024 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709435;
	bh=hYJRcMYlMROH/hKIXF5O8r7FKM8Ojv/tPFhItGVmTCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TIViRE17L5NS/4W2OPxJDsiB9Htjn87xfDYtzAG/saB7HArGmp1t9asrW2MRkhZC5
	 h/48BYezCImBGxC4qweDuuqVVfjBbdIMOLhjuWxsF7BYlhZjOOIUmc2p8KK28fKlGa
	 VlVVDAvqKGb0ehfSQG2JcMMX480G6sCGAdIFrdfT5ri5raswtHuUYmZ15XmCCfTopr
	 lJr3yBhUHG+h1kkh8sx3LKZa1PsnTVcKfspe4Ao/XSd8JDQnYr9orhwV0G4cTVos2F
	 zTvTSHsOCxj6hjI+xka5295DKhIORpcAHrlR3dlmcnJofAxeILHPevtWa6AWTguZMV
	 hWj6fOlOKHW+Q==
Date: Fri, 23 Feb 2024 09:30:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240223173035.GZ616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-3-hch@lst.de>
 <20240223163448.GN616564@frogsfrogsfrogs>
 <20240223163737.GA3410@lst.de>
 <20240223164655.GO616564@frogsfrogsfrogs>
 <20240223164916.GA3849@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223164916.GA3849@lst.de>

On Fri, Feb 23, 2024 at 05:49:16PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 08:46:55AM -0800, Darrick J. Wong wrote:
> > > The only "sane" way out would be to always use a deferred item, which we
> > > should be doing for anything using new RT features, but we can't really
> > > do that for legacy file systems without forcing a log incompat flag.
> > > So while I don't particularly like the transaction flag it seems like
> > > the least evil solution.
> > 
> > I had thought about doing that for rtgroups=1 filesystems. :)
> 
> I actually have a patch doing that in my "not quite finished" queue.
> Given that your patch queue already enables it for rmap and reflink
> it's pretty trivial.

<nod> In that case I'm fine with this:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Some day we can deprecate !rtgroups filesystems and this will go away.
Assuming one of us doesn't figure out a better way to do this. :P

--D

