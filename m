Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EC73D575
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 19:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913531; cv=none; b=oq19lZrgG6w7W6exbWvFRiqy6CniaKcMNX0d5smJCrC2Iu/wJUBxNmm6FEJ4yX3NjrzGaRGK+LLi5DzyAGgHp7fKsQplI80UCTH11rCm1/4OBo1aLTuBn1DdgxOwoEbGKqN2xvg5ErhKLldBxgCQscKLFwb7G6nZeImVv7qyNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913531; c=relaxed/simple;
	bh=Dd+ydHMSy7zX1FGIsk3nWI+9T/NABj7eQlgh1Kl0pu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpWiVbxJh1yJohDKo1eOTQwnv+NVNGwW5OGzChpY58sP3Af/FWLx/25BjLjSJ2LEmW4o+3B1nqr+e+Rl5sGhelGnGj+ZeY30D/FjQRYT2RK7gcg1opf4NSQd+q4yO3aIIE8eC7NdgXKJXmgxGGi9gAwVKUeht+53lSbVWWBu3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7gqZ200; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7gqZ200"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB9EC2BD10;
	Thu, 20 Jun 2024 19:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718913530;
	bh=Dd+ydHMSy7zX1FGIsk3nWI+9T/NABj7eQlgh1Kl0pu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7gqZ200Zvy+hZ2XYSA9RXNLYvw8hEaVcFPkcnL+wjAetAwL+ihf1HPbzofVvY1Q2
	 p40FsxJ7uOuVmUme3MG+DHAGxhVQLfuAhIfaZeph1WikoeD65g2fVDx6qwRbvrmmnp
	 bDQ6Pvuanzsf1PRd6o7rOVExzH2uoRlxDF5q6f2N0qL8ruZrPmYbw3505vYu30R+V2
	 2bANM1JqEvtQNcxnXY/MiFCznsqkpgwPPREXOKEBX05OosgA2H6DFCqYH0PLBxWcvd
	 1ofx0IIZdeYolsV/SoWZs/ZAi4oLhb9bWnr6Mw2zDfdG8c3Odj6yDXYQT5oq8dEosq
	 ZihOeuyQpH7Tw==
Date: Thu, 20 Jun 2024 12:58:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Konst Mayer <cdlscpmv@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: TRIM does not propagate real-time sections
Message-ID: <20240620195850.GI103034@frogsfrogsfrogs>
References: <2UXR5417C74F3.27N1XQP68WXAD@gmail.com>
 <2W73T39BGMHNW.28KW9QVYJD5M1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2W73T39BGMHNW.28KW9QVYJD5M1@gmail.com>

On Thu, Jun 20, 2024 at 10:52:52PM +0700, Konst Mayer wrote:
> We are using Linux 5.15, by the way.
> 
> Konst Mayer <cdlscpmv@gmail.com> wrote:
> > Hello,
> > 
> > In our setup, we created a dedicated real-time section on top of RAID0
> > (backed by multiple SSDs). The rest of the filesystem resides on another
> > device.
> > 
> > When we ran the "fstrim" command on the mountpoint (mounted with -o
> > rtdev=/dev/md/raid), the discard does not propogate to the real-time
> > partition, and only the partition with metadata gets trimmed.
> > 
> > Is there a solution to this?

https://lore.kernel.org/linux-xfs/167243867907.713699.3220336734546600556.stgit@magnolia/
https://lore.kernel.org/linux-xfs/170404846975.1763756.7829043057977943548.stgit@frogsfrogsfrogs/

--D

> > Best regards,
> > Konst
> 
