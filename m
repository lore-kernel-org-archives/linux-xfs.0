Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E624D8DD
	for <linux-xfs@vger.kernel.org>; Mon, 10 Jun 2024 21:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718053644; cv=none; b=NcnZWH2WAGvlaeX8mPJ9yFX4kfXgbtc+gBU9KOrA6G8KM6SZs0or5CxC/pweF98Vg7A/lHeNI3d0sEmMj07UljRZLDlZdcb+3uNxZQ7tSXWzyse8C8c1vm/d7cB6WXQIF3esI3Yl1QckydZsZFj5ITdpwl9YK+z5fPM0UPBuzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718053644; c=relaxed/simple;
	bh=5xjpVn1J8WiZ9nqk6zB437NrrEFADQUvY5vh2zmD4dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+rEwjRIqeYAJXiteR3pPQ2ynJCLCd0TjahddI+JfxfI7By72D0ZwQGncI0qaw1YhUA54UnbaFBWXn0A0m7w08DDxp1KCvEwo6DcJe7zFC0dPtAjzSWgBgc5Wp8rg2TM+Hda3NGQdQM7NJzql8L2jn9BBq8gvCXganQrIqeRft4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rgUhQpTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rgUhQpTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4942EC2BBFC;
	Mon, 10 Jun 2024 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718053644;
	bh=5xjpVn1J8WiZ9nqk6zB437NrrEFADQUvY5vh2zmD4dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rgUhQpToqucYPMcgb0DvASH7MKHsc0Y0g66qL4lK6Oxp7cOg4tWV/d2VCg/2gas/D
	 ZEVuOLF5XIBHNqgmIhkSinojUQBa8PxaRsWWlxUSK9Rhrkw9xnDQ5uvo1wW9CinnzJ
	 hfhFwMUUNN5Ot9R/DSIEKWJE5lo5EIoWEbdZDXxp56OMWj6iHZRlk30Re7hCY7jFOK
	 8LuO/9AeNNvuNjBXafaPCR5X2fU4zMG6c8vl4cX1qr27ZDSiLaJkEp3IPJs35ysdSQ
	 piW58icYqCDmf02oZriQUITzvPFBA3TYDqoZSMeAr57A0gWHrpCdt0g/aXo03Cvm51
	 j8Eyw6hVlf5DA==
Date: Mon, 10 Jun 2024 14:07:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow unlinked symlinks and dirs with zero size
Message-ID: <20240610210723.GU52987@frogsfrogsfrogs>
References: <20240607161217.GR52987@frogsfrogsfrogs>
 <ZmVMn3Gu-hP3AMEI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmVMn3Gu-hP3AMEI@infradead.org>

On Sat, Jun 08, 2024 at 11:33:03PM -0700, Christoph Hellwig wrote:
> On Fri, Jun 07, 2024 at 09:12:17AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For a very very long time, inode inactivation has set the inode size to
> > zero before unmapping the extents associated with the data fork.
> > Unfortunately, newer commit 3c6f46eacd876 changed the inode verifier to
> > prohibit zero-length symlinks and directories.  If an inode happens to
> 
> ", newer commit" above reads really odd.  Maybe just drop the "newer "?
> 
> > +	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
> > +		if (dip->di_version > 1) {
> > +			if (dip->di_nlink)
> > +				return __this_address;
> > +			else
> > +				ASSERT(0);
> > +		} else {
> > +			if (dip->di_onlink)
> > +				return __this_address;
> > +			else
> > +				ASSERT(0);
> > +		}
> 
> No need for else after a return.
> 
> With that fixed:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

It turns out that even this is still buggy because directories that are
being inactivated (e.g. after repair has replaced the contents) can have
zero isize.  Sooo I'll have a new patch in a day or two.

--D
