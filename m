Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D45208C6
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142507; cv=none; b=Gg3mdRvWFLXicJYA8LdKBqGefCNLAJpIpECxnuOtmYDf8Szck3FZx0WFaCGyZZL2xDx2gH4nLPlHv+MJ4Ou+Sbi68ZUGIAGvmmXi2tGTTwCxjnubSuLhTscCQNoZF2R5QHfCrVZu+0Kdaa8ozlFy1euu1bkqMqyHpspYWs2eATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142507; c=relaxed/simple;
	bh=jWnozQaKSk7OjKA9lgrzLrIBNRMLnz+90IXDg4tmi9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Im49rN/oo7tsG5D0X3c7nTCfncQnZzwOxDaMksEf38bAnFOo7mtdBFCGAeCQtVOjz+mqVouNAyfgYJ2GPbJsCwoX4EBWocSBFh7vW+oUtTN/qDeyV9lTZvE+uTsAUz0XHwYa/vxB+U7XPJqY1sB0wA7q5C/777nEwYF+tuzUWZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vz1sElmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vz1sElmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908EAC433F1;
	Wed, 28 Feb 2024 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709142506;
	bh=jWnozQaKSk7OjKA9lgrzLrIBNRMLnz+90IXDg4tmi9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vz1sElmg+oKkGMI488n6TtHcQCf44NGjlwhr67DK+vYVLj3hICINqonjmfdmwWP7M
	 URwbLqZ4Oe7U/3dQQ+zwTUdSw1HZdzU2RxfBOHW79+4dFKHiIP1iiHgYUs/XJj5ipd
	 FRHBNa1bTGnjiAWu9hlF5LMX6P8UTJqFoNaASlzF+Mwp52j/vGBgtRCt5PS0/RFEeS
	 oGyJHXGeleFX/0FvV3qIM9QAtqw3t3in+fUbav6UhMezNLQp82uE1wj8G2I4C84C2j
	 xwc+D00ESRV3CP653ieRCnnYKhBj+1O8elkfOK7s02315CAYeMO+BpL5zZKLA6nDll
	 hTjsvsNB1WATQ==
Date: Wed, 28 Feb 2024 09:48:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <20240228174825.GK1927156@frogsfrogsfrogs>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013644.939212.14951407608685671445.stgit@frogsfrogsfrogs>
 <Zd9YsjLkMZ5fccF0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9YsjLkMZ5fccF0@infradead.org>

On Wed, Feb 28, 2024 at 08:00:50AM -0800, Christoph Hellwig wrote:
> > +/* Discard pages backing a range of the xfile. */
> > +void
> > +xfile_discard(
> > +	struct xfile		*xf,
> > +	loff_t			pos,
> > +	u64			count)
> > +{
> > +	trace_xfile_discard(xf, pos, count);
> > +
> > +	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
> > +}
> 
> Can you split this xfile infrastructure addition into a separate patch
> instead of hiding it here?

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
