Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1B3803EE;
	Thu, 22 Jan 2026 18:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769108223; cv=none; b=hH8rSt/fMoFAxoAA7Sd3BaGAZdiO2miIigQoWL1mz9fOvzMdzoGgVOCDm8rCg7k/zIUNoHXcrUakEPhCtZGALvUeVOhobpFL+s49MALHFNXrjex3NvW6Cqoo2fgZF6wrYsLWcC9riRFDjw2PGJ+ZwPqeS2jcEobapaI8kW70nBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769108223; c=relaxed/simple;
	bh=GkSe09akKcm9FFbHmy//M2pq+/shNCmaT0+ESEm8bOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0wzIzSn9HP2R+Uj+AKgqSsGvDceuDrIAROK4FOhhJZI/S24QtV1gEdlRdobaIXcT3b6bjO7nvOqrR2vPl3kYcB+5KOawLiReALm8EkhvkSCqxtDmfBhl+QuLub2yUodkl/rFFwbd5vWuDNHblgUHV91bzQXABkxDqSrKDbp/0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKuza4by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKuza4by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F03C19423;
	Thu, 22 Jan 2026 18:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769108222;
	bh=GkSe09akKcm9FFbHmy//M2pq+/shNCmaT0+ESEm8bOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKuza4by4Emdz4//jVhcVhcj35ptuy53ZJN6QPKbzU2UesG3N80yTOUul7svkUJvb
	 MmICWFEXeyjEiXQsc5NVVTeJWAMKoglSmRcPSgAvk3ogZORXtT7MbmNqeELwziVRjB
	 3ydKsBGXWMOcdPN9nQ3IWsrRJLwx/lyJaO7c1T/FAjx9/fkQt+cePrJNWco9jW7vJ9
	 ZcTHr94FOo1yezjYmvLiCFcHGNu/NnFEhwz6F6JPRCeruZAVYuLMn2FOrKm2hk8PdU
	 T7rcUgpZe15IOkyfUJQ2COikmHNfjczufDvWUeL8k52pYusHLqFmSVuiFNd3duysE/
	 qqEnC3ERMLidw==
Date: Thu, 22 Jan 2026 10:57:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check the return value of xchk_xfile_*_descr
 calls
Message-ID: <20260122185701.GO5966@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
 <176897723563.207608.1472219452580720216.stgit@frogsfrogsfrogs>
 <20260121070323.GA11640@lst.de>
 <20260121182208.GH5945@frogsfrogsfrogs>
 <20260122055748.GA23964@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122055748.GA23964@lst.de>

On Thu, Jan 22, 2026 at 06:57:48AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 21, 2026 at 10:22:08AM -0800, Darrick J. Wong wrote:
> > > xchk_xfile_*_descr is used to pass the name to xfarray_create or
> > > xfblob_create.  I still think it would make this a lot more robust if
> > > those took a format string and varags, and then we'd have wrappers for
> > > the common types.  Even if that still ends up doing kasprintf underneath,
> > > that would be isolated to the low-level functions that only need to
> > > implement error handling and freeing once.
> > 
> > Alternately we just drop all the helpers and kasprintf crap in favor of
> > feeding the raw string ("iunlinked next pointers") all the way through
> > to shmem_kernel_file_setup.
> 
> But wouldn't we get duplicate names for different inodes?

Yes, but that's only used for readlink of /proc/$pid/fd/* so (AFAICT) it
makes tracing more confusing but doesn't affect functionality.
xfs_healthmon just passes in "xfs_healthmon" and I can run healers on
multiple filesystems just fine.

anon inodes are ... uh ... magic.

> Anyway, I did a quick take at format string / varags version of the
> helpers, and that works out nicely, but that _descr macros still confuse
> me a bit.  Maybe I'll have something until the start of your Thursday.

--D
