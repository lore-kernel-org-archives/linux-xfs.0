Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA891485CC3;
	Tue, 25 Aug 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681682; cv=none; b=FGCoTnFSFN/l5XKe2sNPQOWn4okXt1NsjNYrlOR17BBNwXfDPJ/rj3uByzN7n1DSyiOO3m4wOsszCJCA9A//N+IjfVATkf6C4RJKs3ZaEm3OEA8fl902t58sEjqrqUkGbK0Q2RS8yY//blLYQVGarbUs/FqHnqhbulC52nDmNRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681682; c=relaxed/simple;
	bh=TYmsS8qViWkEj03FzEVB0nne2ZkvXvHlcisA/MzAeI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LT/c7V+8i0XCREf+rh4C6xTyNQAKegf6bpj2J+h3WGaz5h4QYRgzcYmmL9rdtGLS7tFp47EyRre2RY6gOfymKfdxxVjf6phnWRzZkN0cuBJY7LkuHQIC8cHwKOkqhmED6EUTeF2R6EmTDt3CLssX1DDLw9AQ9JpLsMMHKI7A7D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVRyQunz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVRyQunz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 661A91F000E9;
	Tue, 25 Aug 2026 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787681680;
	bh=lyQrOKJ0XJf1ElzoVYgjfUEFyWHbJj68Bqy15Azf3RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dVRyQunz40LgsxQBDqWIt5RtcrN5CsXMqZ4+Tz4HznwLq4jn23VbRULD29K+kM1XC
	 E6kGqvzYIsL8qthCpyJkWbqwNC+KfdM4Pu4vdrbLn/wx3q0bRp56pALujf887ubjXg
	 /H+bM1WV1ZzXknH58tQEDr5/hFxRkZeA3b2LfYwgHrtokhu/OnTVMIXhSySjO4eC6O
	 T4cInyCD22e4uZ8H05Q5GMtrSdoMVmvtHbf3wtpUqRl52rKR6XFsJL3FxVCYBuANxK
	 uopg45mLU1PIsxhOkIDb8QrvpB8QXPQvHtHaQWuQlDjwkSRCaytg1WUSqELwUETH3W
	 ovQ36vbWDb8Sg==
Date: Tue, 25 Aug 2026 11:14:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix parent rec lookup initialization in
 xrep_metapath_unlink
Message-ID: <20260825181440.GU6072@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940763.944084.16089302387459334065.stgit@frogsfrogsfrogs>
 <20260825063101.GD24324@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825063101.GD24324@lst.de>

On Tue, Aug 25, 2026 at 08:31:01AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:35:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
> > the child metafile that it's removing, but initializes the parent handle
> > using the child.  This is obviously incorrect, so fix that.
> 
> Eww.  Can we come up with a reproducer for this?

At the moment it would be rather difficult to do that because all the
metadir directory tree paths have to be working correctly for the
filesystem to mount.   I'll see if there's some evil way to do that,
like ... zeroing qflags, corrupting /quotas, and trying to truncate the
(unused) quota files while quota is offline.

> The fix looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
