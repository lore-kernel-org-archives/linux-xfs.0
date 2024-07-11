Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ACA17BBB
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720672576; cv=none; b=kXUGQ2hPwV2VHW0KtSZ34nsFP8f0cTN/eKEI6IgPYXFppPpGAN9gwupm/KqoMXloREFdIyQqXeGBU1wR7/KygKnhLfr1GMGLMK9xnTAiCDjAnl7jLcNZBnh2uzvA1zr2uitMD+8a1iDFiDJeraHGVfv5G6ZQOGr5GJUO/zuLCAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720672576; c=relaxed/simple;
	bh=I//Iy/Y357AJvYNy4aQ7O5ObsibkRaTMnoFLsJppkBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFRg5mDFjTqA3XmOa2lL8E1tqQhgxUsmQbPlQIkrhK+l5qM3RrMchZveYH62pxfKH6wMB8PlzFZn/ZFfpuHeJ3Ht/pSEkMH6CQ9CNxHyCdSn+fgKumxns25Lbx0Lg3MgR2ZKy0AROO9Pgp7nNh/IXGUE+N4X1GblY5hDeLb3lgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0xS4sbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0xS4sbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590CAC116B1;
	Thu, 11 Jul 2024 04:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720672575;
	bh=I//Iy/Y357AJvYNy4aQ7O5ObsibkRaTMnoFLsJppkBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T0xS4sbJI+4q/22LL2H4YeQ3u28XFr9YYpFTU8VEGknEqWzT3GiD1DP/nO7go+q0S
	 Z3Z0MlO9FySAJ49xMrEczAzN14DpzJw0idd/nPkwiUBijtUoMXX0dJXEh6VyiN+Ei/
	 qrPi5y8x0bIrMh28aIiysKGLvOH+iqbRj5uWbJdzRMt8jKJdgSArTkzD00oDj9+ja2
	 +AjnfUsV2Qv5vz4iIfXhY9wUMUngHD0WF+KG858Nqwj/ohE7m4UdH4yuw7tMtEbdqp
	 Fk9mP1nhFMkHD31oakyucIiYOcgEdlAw5D41yFzwro6uSqcUFcO6Q8JgWsGgZtEO2l
	 aiBoHJlG4xeHg==
Date: Wed, 10 Jul 2024 21:36:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <20240711043614.GL612460@frogsfrogsfrogs>
References: <20240711003637.2979807-1-david@fromorbit.com>
 <20240711025206.GG612460@frogsfrogsfrogs>
 <Zo9Zg762urtBzY1w@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo9Zg762urtBzY1w@infradead.org>

On Wed, Jul 10, 2024 at 09:03:15PM -0700, Christoph Hellwig wrote:
> On Wed, Jul 10, 2024 at 07:52:06PM -0700, Darrick J. Wong wrote:
> > > -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> > > +		da.d_mem = bdev_dma_alignment(target->bt_bdev);
> > 
> > bdev_dma_alignment returns a mask, so I think you want to add one here?
> 
> Yes.
> 
> > Though at this point, perhaps DIOINFO should query the STATX_DIOALIGN
> > information so xfs doesn't have to maintain this anymore?
> > 
> > (Or just make a helper that statx and DIOINFO can both call?)
> 
> Lift DIOINFO to the VFS and back it using the statx data?

<shrug> Is there anything that DIOINFO provides that statx doesn't?
AFAICT XFS is the only fs that implements DIOINFO, so why expand that?

--D
