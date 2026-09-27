Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766263B14A7
	for <linux-xfs@vger.kernel.org>; Sun, 27 Sep 2026 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790522320; cv=none; b=aZCbzdwFhDQ7G/5Q7vXYuJMVDuHD+ExBVHjmb9x8NDK2AHdXc5dqGc9kfISx5/ZjaomuYyh+ncDzn9ycEsWkkpBdR85sN/ajF+BawN65qJdZVAyC6GJCtbIWSP6x+dpVs2/q/X+z25wxi4SPwypSbzN2/Xgud17LG75V+5EQXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790522320; c=relaxed/simple;
	bh=xynz6YoZQoPxIAFie147eo8kNmyxMLgUFsBhmTbV1P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPyn6EbEB9NzopIXI5Te+wptbgcrqU+Rr0YLBaFpNQ+bn0aTgJi5bXAIm25Qcf76TjrTT36U8xTtgqrKfuImMZEWFXb/USLicZxO82c7ArXEGlgzNI9NqxI8r3RLHajnfm3mSwt2voxrfmvjaCYfiSoavrV/8RaS1JOzAA77fjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOCHQr/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOCHQr/c"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 06B0B1F000FF;
	Sun, 27 Sep 2026 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790522319;
	bh=TvMGZg1kEBTPoHpuuIqo9uYsuF101lEYzF8igCe11xo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oOCHQr/ciNaOy1sYDmBiu7ukcd2Bl89jFfHES6wbirnLAzW2oqXkN6iEeMhl3FR+7
	 cReTAOWl/r5O1Sw43vmm/EeMnu/b9Ef1HLpZBId7wlIow1Gt+03VohD3pQ8+7oTP8C
	 ypDyLYRVrRHAOvYS9/ddGIlllw7SY39c/haBUHpTM1WVAvVecevjYL4h2ceRy0WHfo
	 KVvC3fMZsZLL1t665nzlB8YGnVmK3rqgoMl6RI5Seg7R/QB3MX81b2B/pKNFmDs6wk
	 5ncS5spK5lJZC3vlMU1X5tQpWl/mcDGyqMmnQePi9fwtjTACpGifhGpkVqnDsFeHXZ
	 Ap9fjnU/wjBKQ==
Date: Sun, 27 Sep 2026 08:18:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] libxfs: unify buftarg handling with the kernel
Message-ID: <20260927151838.GT2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-5-hch@lst.de>
 <20260925223716.GS2705364@frogsfrogsfrogs>
 <20260926055912.GA20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926055912.GA20636@lst.de>

On Sat, Sep 26, 2026 at 07:59:12AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 03:37:16PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 25, 2026 at 07:12:50AM +0200, Christoph Hellwig wrote:
> > > In the kernel, the RT buftarg is set to NULL when not realtime device is
> > > present, but libxfs still allocates one, and all users instead check for
> > > a NULL ->bt_bdev.
> > > 
> > > Switch to the kernel model of never allocating the buftarg, and check
> > > mp->m_rtdev_targp for NULL instead of just ->bt_bdev.
> > 
> > Might want to mention that xfsprogs now matches what the kernel does.
> 
> That's what I mean to say with "Switch to the kernel model".  But if
> that was to subtle I'm open to suggestions for a better wording.

Apparently it was too subtle for me, but on second reading, it's
correct.  Comment withdrawn. :)

--D
