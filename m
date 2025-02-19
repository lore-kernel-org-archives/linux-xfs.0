Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDB1B4154
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944404; cv=none; b=BRTkWeDMqbxN8O4Huuanp22JDFYRTYgzy2zsJ9D+9ntWZkOlFWl7cU57uHtGiKWZrZT7qEzaNZWNjBlId0e1XhbXDg6KUyd6LQe1LV3qO7yxhhYfh32b2nCZMZRkIDzFhjN7qT71kuYW1iT457sIR/ijvc1DCUqxlLrzQ7iYIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944404; c=relaxed/simple;
	bh=Ih9jlS3Hxnj/EWQ6Er/5WsJftMBQL76Pcl+viH2akqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxgtHTgxYnRsyC2zniLjI60xv6wA4HbTOtNNvPZ5h0pJR/VeIqBTUed/5iSkBEfN6mjEYonacu47i2pkVL8Bf14NbwMIghvk/q4QvLcA3nPhSSUKCLNGXQHJKWY8tktTKqrfQid1J99OMYcDIO7ZD17Hx9Qy2DTh9cL6q2LLHDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWp3Ndem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWp3Ndem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9031DC4CED1;
	Wed, 19 Feb 2025 05:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739944403;
	bh=Ih9jlS3Hxnj/EWQ6Er/5WsJftMBQL76Pcl+viH2akqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EWp3NdemrvKr3Jgo/PF9lUOIj0gAg+dE1e+K/yVP4rFlIrCiNE99qLAX9SW4MUCWF
	 cjapr7qf1YVFi1l5wXDsNAnIxrMgXaNGt4AwS1ipo2PqYuJKrgAk7zG/mh6BB4DnNt
	 Mapb+l3ytUziniF9BbUH0Kg/Asuv+X47XIMbFIwJFLd+9FKYKv395olWqJw8aJ434Q
	 lCm2c5sD+S1Jw3hRBAtcayb3BwaQKYCdEC4R+jJEXleghFVKtqN84qVAWdkbN9+zwE
	 ULTUN1XMbclXgiZ6oECy5TzrpHkAVyjCEeu0tBVKbSSHwFeSBZQ1n2oYowAFP0sxP3
	 4wfJaGM/CJ79Q==
Date: Tue, 18 Feb 2025 21:53:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs,xfs_repair: don't pass a daddr as the flags
 argument
Message-ID: <20250219055323.GU3028674@frogsfrogsfrogs>
References: <20250219040813.GL21808@frogsfrogsfrogs>
 <20250219053717.GD10173@lst.de>
 <20250219054515.GT3028674@frogsfrogsfrogs>
 <20250219054851.GA10520@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219054851.GA10520@lst.de>

On Wed, Feb 19, 2025 at 06:48:51AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 09:45:15PM -0800, Darrick J. Wong wrote:
> > > The patch itself looks fine, although I don't really see the point in
> > > the xfsprogs-only xfs_buf_set_daddr (including the current two callers).
> > 
> > Eh, yeah.  Want me to resend with those bits cut out?
> 
> As long as the helper is around there's probably no reason not to use
> it.  Removing it would probably pair pretty well with passing a daddr
> to xfs_get_buf_uncached.  Or maybe killing xfs_{get,read}_buf_uncached
> entirely in favor of just using xfs_buf_oneshot more..

<nod> I think I'd rather rid of it entirely and fix the _uncached API to
take a daddr.  It's not like we can't pass in DADDR_NULL if we *really*
don't know where it's going.

--D
