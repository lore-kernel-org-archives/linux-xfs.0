Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57B22563;
	Wed,  8 May 2024 02:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715135192; cv=none; b=e/nhHVeh1Dh72tJTiOgUoULopxDZFNaKm5DaIo8M987j2yWSc8xsWMNBvTXBfvIEZ8RJ9X7sdtGhDhxyJJcWbUPhlDksG52ug4Bfjd5sEkK84W9kOLWrwuHOBk4SccerG3IbfC/u3vF3iDrmCcqDaIdfOo0em3uxHQfPYEfNyBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715135192; c=relaxed/simple;
	bh=gQBDHlJVjn9IyeGe/AMBB67ceGlqQXb/p8wQRVumnQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbZltV+kvkVmvubBuf1da+fNDIz+VebITDhOumzFCCNbCuJT+p+zBsVTysV1Lnp5C45mZMhP1F7/fvmzL3zLTKzTrLABKTngj6zAbH3IVg1VjjwaOnrfg0+JDp5RQYLfmrSp84AyDeqyMOZneOUd/fr7IeAymJa2xtl55oTNZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCYEKP4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCYEKP4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C627C2BBFC;
	Wed,  8 May 2024 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715135192;
	bh=gQBDHlJVjn9IyeGe/AMBB67ceGlqQXb/p8wQRVumnQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iCYEKP4Y46BnvDzYK0hkbvNOSYpuVwJuXnNVAgtsNfMwNr0Nbu1zZ2lgViUzZwE3k
	 qTdUcf+Il5IPruDUmVvuvxzO8PHki8fWPsMFIk8pOlKYvqCE0ZLmw6UIGIK6fQUC49
	 GKdaTyuuCswsKHhqORs5EMQi0++o9wqjNUdMHURuncKNhwDbSb2clxfONybevdcpEl
	 gXGz27boGIWIturmt+7w4CuHY2zaPQiDFp9mSf7vAgvi+MhXEHQ3PBRy9OGYE6kldU
	 8XU4AH8REH8RT1lapYgwLgUbW8EoJd7jwAodysljoALXEZ/eIxCa5rlLgf0IkP7lt9
	 3Hxa2q4woEqAg==
Date: Tue, 7 May 2024 19:26:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <20240508022631.GF2049409@frogsfrogsfrogs>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
 <ZjrVaynGeygNaDtQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjrVaynGeygNaDtQ@dread.disaster.area>

On Wed, May 08, 2024 at 11:29:15AM +1000, Dave Chinner wrote:
> On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> > The fxr->file1_offset and fxr->file2_offset variables come from the user
> > in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> > Check the they aren't negative.
> > 
> > Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> > From static analysis.  Untested.  Sorry!
> > 
> >  fs/xfs/xfs_exchrange.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> > index c8a655c92c92..3465e152d928 100644
> > --- a/fs/xfs/xfs_exchrange.c
> > +++ b/fs/xfs/xfs_exchrange.c
> > @@ -337,6 +337,9 @@ xfs_exchange_range_checks(
> >  	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
> >  		return -ETXTBSY;
> >  
> > +	if (fxr->file1_offset < 0 || fxr->file2_offset < 0)
> > +		return -EINVAL;
> 
> Aren't the operational offset/lengths already checked for underflow
> and overflow via xfs_exchange_range_verify_area()?

Oh, yeah, they are.  I was just thinking surely I wrote some tests to
pass in garbage offsets and bounce back out...

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
