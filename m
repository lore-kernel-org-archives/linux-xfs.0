Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587BC11185
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 23:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460774; cv=none; b=pvfXfD6vLLjIoqGYwVtv3kEuiWXS+P9fO8Rb4A+lqgQXP9sMP5hZaGU9slN5gDlWezRnhE0o3wu5//1qa9iLD76ynadmEmFOENoNx5z9DoAz0mNpChCiIlh4sM4VEyYF7PylGV8UY/hGBT4FsV1ollm6yoX+129ptkRXmqNtrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460774; c=relaxed/simple;
	bh=T1LYuEkrh9ef8rcgO3Bnq99O582HQ64+iWfC1JXbJuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhsnrFIBKKTtdBMCS23TlD5DRxoxv3VXdPHXsEDWxUfNQMkMHYjlHXYNwx+SJAhM1/1nVUulPK+GpGWFbKAtKgexydKwIMfdk1YlejUlx/rhydKos+04VfEaO7bET8nlKyUkgTAJXfPLKvgjJkK3wxewqUdk8IPTQSE63leJCgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxJBPMil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxJBPMil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F52EC433F1;
	Thu, 14 Mar 2024 23:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710460774;
	bh=T1LYuEkrh9ef8rcgO3Bnq99O582HQ64+iWfC1JXbJuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uxJBPMilf/UMebP5Ce46ImMoNtOtJk6urY7mv1RA56i5QY+t5RtZ+CWXGmAQ2/uKc
	 TXUgWkD8BVqKMGY13IrE7dnvnwJBFjqAZd4JAnrRIXQDUXrCcurErBt1FnNv3iV9ZB
	 2bAPLShXnF7ru6ALrcwy0NXF1KRYz042SZ0UrU3ixuTwquwgM7HompOaHMNGdsrIqT
	 WbI7uyrN7Mo6RoQyuPoiZ4dNFA1z3ZWcX7gSQ13J5m3pJuM+yIhbgK9T7cQjl/if1D
	 cdPaXGN6+PEWBc7SuZTIYUnze3KvmR2h37rTU7lUHCP33YvL/FfENF9gKO4pA6bwdR
	 S682MLz+DwjBQ==
Date: Thu, 14 Mar 2024 16:59:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, "Darrick J. Wong" <djwong@djwong.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_repair: support more than 2^32 owners per
 physical block
Message-ID: <20240314235933.GV1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>
 <ZfJa4PjWo5l5SwWA@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfJa4PjWo5l5SwWA@infradead.org>

On Wed, Mar 13, 2024 at 07:03:12PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 12, 2024 at 07:15:42PM -0700, Darrick J. Wong wrote:
> > +	if (nr_rmaps > MAXREFCOUNT)
> > +		nr_rmaps = MAXREFCOUNT;
> > +	rlrec.rc_refcount = nr_rmaps;
> 
> use min() here?

Done.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
