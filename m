Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5A26A1DA
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 07:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746775807; cv=none; b=hBrDVeRWkFDcxdXCr7utzkvf+a0WCYkalXsfP5TgEsN/dtKJKZNzG9J3jkGRnCeNJnLpYjaxLsKRFrVZ5dJG3ySn3AuceBMH/3bJgC8pDpJ7E9tW3aVba83dDGXqtqbNa1zhCy0pdvGjbDkVOzSwzgLBXY/v5ML2DH5zYsazpF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746775807; c=relaxed/simple;
	bh=HkdLa2TB0Z2GJf7hVALZTVRcHEq545Fgm1eMz/JhpnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIzsD4nWZ6YXICx/Mhf6JENE60pgk3CdIEJK4zpDsGQr2yCw7hcOXvSvnK+Ae886Y9WBHJcLHbGVRo9fh2aZlclVfczmmK/mX3v3nA2weH5jKRnmUUvTBnx7Fr9l3U3DazmLSBS6v1l9PbeiXilqJ6e8HXFPow3e3q9NrB70VjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhUDBVpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhUDBVpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE830C4CEE4;
	Fri,  9 May 2025 07:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746775806;
	bh=HkdLa2TB0Z2GJf7hVALZTVRcHEq545Fgm1eMz/JhpnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OhUDBVpqDqgYxjEf+1i44aGxJWlZ7+McvHesT7g1nnLX9KfXoi/iahUMv5s3hHBYn
	 pVYGibEVVJjDWCvGBCegvwW4c6bDADqPVXfiw+v9uzy7sNK8yy4ao7s7MM03K8gRRw
	 hpcibOyoNLmu3iVK86CRp6XCX4TtcekXiVwY3LmCmtnr9Noz2jbT+32gE8p3nMufco
	 wBXQK7dBBuYgZZNLerF5krBezpUcIT6u9mYo90PagNkJAmB7pfIoQ8aaeZeMaGbmVn
	 ZD8/epZ7FfyjnD+P1smB2/0a+6n9gWRKZRiE/3WJjdZxUa53/neh5jIdatd9gs9lin
	 ouNk8DIodu1Dw==
Date: Fri, 9 May 2025 09:30:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
Message-ID: <lenvx6vfzhqham2eflz5greebjezqt2kpagoosz74i7mlpe6g5@4eeccjd5iksc>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-3-cem@kernel.org>
 <qJ1kZ1-U23tsI9VYD6ARNkuWE6SaJ3k4jcf9_uWf4U3sigONTDb4UoAbxq4SPPFj5UkGOKG64QdZleTBo27XfA==@protonmail.internalid>
 <aBwwb7zCngkhpfum@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBwwb7zCngkhpfum@infradead.org>

On Wed, May 07, 2025 at 09:17:51PM -0700, Christoph Hellwig wrote:
> Lot of spurious capitalization in the subject.
> 
> > + * Items that are already in the AIL are first deleted from their current location
> 
> Overly long line.
> 
> > -			/* check if we really need to move the item */
> > +			* check if we really need to move the item */
> 
> I think this got messed up when sending, as it won't even compile.

Ufff, yeah, I did something when sending it but I can't remember what. It
belongs to a working tree, so it's compiling here. I'll fix the subject and send
a proper version of it.

Thanks hch and darrick.
