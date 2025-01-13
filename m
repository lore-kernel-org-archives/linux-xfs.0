Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDD232368
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 07:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752434; cv=none; b=JVyfbQd3jl6in+ZHTd8zbr6y7O06wEfmewawmuCDX38PwK8KZP2wvue3rZfRYY45nrnUza8dGzTgR9RVmZzkP8yM1VT3cFtFlhWFDV/SwpWsd6iFZvnfkZ2zV3TpPvhUcpMEUQsiqg9+TIctsL8xkJNdaEcmwSQQBUL0MMC0S6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752434; c=relaxed/simple;
	bh=VEAzvxaYFfGh0E6OAErOF6K7iWk9uH/PYFeBPJHUFBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjKaJnTIZZPbEn8r7zigOLogAKivoxU+T1eTWjSmQdr0FhMraV63n0hFulwnk+oBwuRIkbEtvWWeomPG6ylJDpxWW6b08JMpmGF+y7QzYGhg5DV/T9hfsw9z+/BLFwILANPdtv5hiLn5DpRmMY7EHHKbpo+wC3SBQ4o0u9fB/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LE7Uw7tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LE7Uw7tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF7C4CED6;
	Mon, 13 Jan 2025 07:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736752433;
	bh=VEAzvxaYFfGh0E6OAErOF6K7iWk9uH/PYFeBPJHUFBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LE7Uw7tOjfBxSF0urhe1jQ36gksKl6FRXZRKttiV61oEsj1zvCNvaknRmtgiXg4vW
	 /fK7lFNbnp2SzphWtMIi7v1azNuzBTIc2WY8FgJwYqfZhjfgny4pwsJWVRxfYd3QrI
	 zLqA1GQV44LwDZv1pNK+tBbJy6jrmPFa1SPoIHdTAI2qKkttOn/+Hn9Ot7Pzhz1QkV
	 w41HIYeaBrRw/i32nGjodZhs87lMLu4MIAGS3AFh3qgJSKn+FxMlKJsW2yqp0mcOq/
	 72s3HBw+jDhJ/yDvONDpaioc7pWBqFypTXIrfX9xMxiSdCRJM/+OK3bMExeYPYmi8E
	 kCaUkrD+jY4mg==
Date: Sun, 12 Jan 2025 23:13:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: fix buffer refcount races
Message-ID: <20250113071353.GA1306365@frogsfrogsfrogs>
References: <20250113042542.2051287-1-hch@lst.de>
 <20250113050846.GU1387004@frogsfrogsfrogs>
 <20250113051435.GA23103@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113051435.GA23103@lst.de>

On Mon, Jan 13, 2025 at 06:14:35AM +0100, Christoph Hellwig wrote:
> On Sun, Jan 12, 2025 at 09:08:46PM -0800, Darrick J. Wong wrote:
> > > This might actually be able to trigger the first one, but otherwise
> > > just means we're doing a pass through insert which will find it.
> > > For pure lookups using xfs_buf_incore it could cause us to miss buffer
> > > invalidation.  The fix for that is bigger and has bigger implications
> > > because it not requires all b_hold increments to be done under d_lock.
> > 
> > Just to be clear, should this sentence say
> > "...because it *now* requires"?
> 
> Yes.

<nod>

> > > This causes more contention, but as releasing the buffer always takes
> > > the lock it can't be too horrible.  I also have a only minimally
> > > tested series to switch it over to a lockref here:
> > > 
> > >     http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-buffer-locking
> > 
> > Will take a look; some of those patches look familiar. ;)
> 
> Well, the first batch after these fixes are the buffer cleanups I
> reposted last week that you've mostly but not entirely reviewed.  The
> reminder only really depends on them for changed context.

That should be done now. :)

--D
