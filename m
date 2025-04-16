Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA610E9
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744781676; cv=none; b=k+vS7Ny31149fnka+jNHm5/vb56qWlKpwjpBZJu2LrIDQy4Irf4P+vHxYJk7XGVvi09dB/DWjbu7EOyfwy1rw3GFPwPL5YkUAcKt2Vpps/vnInppl5ONi/ZQzSDD8hp/VA5vBU2oGDJ4MSEL8azMiwTKaqLlCpcMOIrsMpQqAQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744781676; c=relaxed/simple;
	bh=cQENq4d2qF9zLWoeQIuCidbL3Kh+6iFTfVPbcfeO93I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0WLWS1c+fhi0IVCrh8mPlkn9LSv0J5dRAGi1O2f0pzrRv3419cUj1aBkq13vS1+amudBcvUfkRZxPhzdQrc547dvUPYjqYEStPs5gGtP0rWBgOz+NvodltSzlsm83TGl5z6RSC4lFnxelC+PUBwwEyWgnN3xNWXW4uuvUbna10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R3BFVT+K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R3BFVT+K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BiE7JhLVi0g3Kwy/MqZuVzmQuObQ3DAK/EikRwcxYLY=; b=R3BFVT+Kk/xCfYcw9Gv1Pi30v6
	R+vjjHLOwQsNrLE3ueYFQwhVOagHUp8j1nPGg9TzqlO7ky6zjNECxEnL2cVhS3WkL7yr+cffT3LI8
	SmxQI9+dGzf2xB3GH47cdotWwDS+CbWjQn6UVJ7YxO75cpHFvS4Xt55uAmapQseYZ/mZUyO6rHCSz
	ZEEFo0sYcu9YrRO96qXBgC5RycQrnwwuCi3T5urttUMDhs8Ikclgk8Hj8B+WhwMszOoca8Ws3ufqI
	s9MZjXzTg96tMvID7hUJg4R7EQOxRx4eE6nztgjwdaOxwqbSeJi/5cfBvzltv6KLWml8cfQEuY1dm
	1Hnq6PXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4vPu-00000008I5O-1BkJ;
	Wed, 16 Apr 2025 05:34:34 +0000
Date: Tue, 15 Apr 2025 22:34:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca DiMaio <luca.dimaio@chainguard.dev>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Scott Moser <smoser@chainguard.dev>,
	Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Subject: Re: Reproducible XFS Filesystems Builds for VMs
Message-ID: <Z_9Bas9rRB4cMibh@infradead.org>
References: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
 <Z_yffXTi0iU6S_st@infradead.org>
 <CAKBQhKWr_pxBT+jXpaitY3gz6wd1WLqyU4JwQoaRhzKWye8UgQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKBQhKWr_pxBT+jXpaitY3gz6wd1WLqyU4JwQoaRhzKWye8UgQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 14, 2025 at 06:53:35PM +0200, Luca DiMaio wrote:
> This is a huge step ahead, but we still are facing some missing features/bugs:
> 
> - we lose the extended attributes of the files
> - we lose the original timestamps of files and directories
> 
> I see that the prototype specification does not include anything about
> those, are there plans to
> support xattrs and timestamps?

I don't think anyone has concrete plans to write this.  But patches
would be happily accepted.

