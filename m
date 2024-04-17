Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC21487DC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368334; cv=none; b=kDv1scLrYOs0Kj8CkUWc/y3M5tiWzAguAYglbcWGOna0fmqgubZ8fJ6lG6I2aEWinMISRqb3uq5vT3/R8jx085Ai7E9rdE2sWqMWreQrJpH7nOoAWJcxwIHWi6W5k32px/w5mm+qIgAcwo+x/WuEOndO2v8TJgAC13iltijH36Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368334; c=relaxed/simple;
	bh=iyXtEl7cXjrpufV/i1mK1td1zSAKpXL8c4PKgDaJgMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IM5pSaN/PRQbD7/qdTf9VVa5VeXJIi7StOAGOhelKlvS4+smNzbKVuibor7PpGxmnz95pQ8bRr/j+go5+R4lENZThG9mIQTUwwunMOM5dydE6XQkg2xL4eWGxiSN+bc0GokPcYIE6t3gZLI5pCRLZ1YIJcwkaJ+EC6zVwl0jTqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqyEbOEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqyEbOEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A573DC072AA;
	Wed, 17 Apr 2024 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713368333;
	bh=iyXtEl7cXjrpufV/i1mK1td1zSAKpXL8c4PKgDaJgMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LqyEbOECxK1YmMxDAcPYzAmwkr7Dom4OwqP3xfXzyTjbF9Lj3I8YIcnsnn90AovXH
	 T1z3r3cqnpJpVHqcSBWO+7vgpuiqcjld8djZhGCcmRbCDPpsyVpO/jpy96jpU1iCC/
	 KlFG8k+64bSX+zxBpJO1uQIjOMLvX4mHVzGLklD7UjlK6hJjkXDsXUPU1+ME8FSM/B
	 wLVqC5Um9+LDjUly+sJMrXDWrIKa08BfPJ5FLDpza07vxcQCM5N2CaK6U7faZm+zcw
	 Vq6ufc3wUp3AJl9xv3Tuisn6josSkex73+caXZ/HpYiVZpYyPQKMQc2B9G/dVQL3YR
	 xP/MceawP6Q5g==
Date: Wed, 17 Apr 2024 17:38:49 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <dhctuexefsu2wd3vduuk4hcwim2k7e2df2h2grcbg43ptp5ago@ygy4luggv277>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <20240417151834.GR11948@frogsfrogsfrogs>
 <Zh_ok7hsmUTpiihC@infradead.org>
 <RCr0vu54dKexAkTyYnuPSN3xj6XabgDVmS1RVQEKIFnZ_5eCzDkxk3IkGsoZ6Kc1hcctxsCrpW8RRYteEDtIIQ==@protonmail.internalid>
 <20240417152357.GW11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417152357.GW11948@frogsfrogsfrogs>

On Wed, Apr 17, 2024 at 08:23:57AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 17, 2024 at 08:19:47AM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > > > on the list and not included in this update, please let me know.
> > >
> > > Ah well, I was hoping to get
> > > https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> > > and
> > > https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> > > in for 6.7.
> >
> > Shouldn't we have a 6.8 follow pretty quickly anyway?
> 
> Yes, but right now you can't build a 6.7 debian package without
> 
> https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/

Hm, I see. Even if I release 6.7.1, it won't change that unfortunately.

> 
> and libxfs doesn't match between kernel 6.7 and xfsprogs 6.7 without:
> 
> https://lore.kernel.org/linux-xfs/171142126323.2211955.1239989461209318080.stgit@frogsfrogsfrogs/

I'll add it before the 6.8 libxfs-sync, I should submit it soon. Things seem not a nightmare for
6.8. So far :)



> 
> --D
