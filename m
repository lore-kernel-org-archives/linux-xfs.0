Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7F1DF251
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455170; cv=none; b=rFf4S5bqQVIGFmge2XBBCtlT+ed3B0OJ2hVFNjLHxXTMMU+SE+XGjdOx1HhigRiCR3s6ydvraJBJVOnT3fNf79pz40fM9lyg5oYV67gtbgXjfuBkTGyjVS6XkgIcpNk/C796uK9zx31+RNetn2VrwFtmpGOqOrPn5GevWaM+Zdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455170; c=relaxed/simple;
	bh=qjdephfdj8AXQXK6lvksmRq2xM3aqLDxn+JZQkN6VPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSj9bHdb3Ln7zQuabY8pUNU0z4CETe/BjxTovEtPcbUd7Jn0nSGm8NPmqy0A5d25SWxA2ct/MeDL50Bis3ICqubFQyB4UeuAonmts4Nc+rlWW7tXrA0Y+5OqGqlxWq8n2Iuz8GMbonstF3tTiSNlIU2SSn3golBfTn6aXCq8pIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBPqVGfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBPqVGfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB67C4CED3;
	Tue, 17 Dec 2024 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734455170;
	bh=qjdephfdj8AXQXK6lvksmRq2xM3aqLDxn+JZQkN6VPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JBPqVGfDhytHpADr7rPKtDx1PPWIv//NJthH01O0O/eH01KoQbHsWQJ+ut1U86nBk
	 PPD+mdELD7OVu/KOoPeTz+mLvDbCFzBP9EBVkfyree0CO4TIhE8G+J3TV62vpUOvOI
	 m2qy8B3L/9wCK/OHonHjBrTvFO8awbp9eYAUjAsK2pgt2snT7/Ha5gGZcFSjYZ9Ix1
	 ZtC2ObzLlLd1VDJwpqIwGjA9Z90uSZ6MwHVgfuKBpFoU5JOnDvrQhclxOPn/Nlb1tT
	 B+B5YYZc7uMTxmyxsQLwwlVyBdIyhe8viRAsNlTRvtlaStAsIdNmW8VC+3ssgD4zoU
	 WUuyPYua51Gaw==
Date: Tue, 17 Dec 2024 09:06:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/43] xfs: enable fsmap reporting for internal RT devices
Message-ID: <20241217170609.GI6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-36-hch@lst.de>
 <20241213231115.GF6678@frogsfrogsfrogs>
 <20241215062613.GG10855@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215062613.GG10855@lst.de>

On Sun, Dec 15, 2024 at 07:26:13AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 03:11:15PM -0800, Darrick J. Wong wrote:
> > > +		/* Fabricate an rmap entry for space occupied by the data dev */
> > > +		error = xfs_getfsmap_helper(tp, info, &frec);
> > > +		if (error)
> > > +			return error;
> > 
> > Seeing as you report different fmr_device values for the data and rt
> > devices, I'd have though that you'd want the rt fsmappings to start at
> > fmr_physical == 0.  But then I guess for the sb_rtstart > 0 case, the
> > rtblock values that get written into the bmbt have that rtstart value
> > added in, don't they?
> 
> The bmbt values are all relative to rtstart, the daddr translation is what
> adds the offset.  So if we want to take the offset out of the fsmap
> reporting, I'll need new helpers to not add it or manually subtract it
> afterwards.  If that's preferred it should be doable, even if the fsmap
> code keeps confusing me more each time I look at it.

I think it's ok if you can leave it as it is.  Once you move to
"virtual" fmr_device numbers (aka not a dev_t) then it's up to you to
define how the fmr_physical address space works.  It's no longer a
reference to a block device that you can open/pread/etc.

--D
