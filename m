Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E4B4D09F5
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281840; cv=none; b=pWYvl0fITN4o8NiC1NRmbwm33+V7ReEyZpBNlCuXfvbOWntHgHvZMkRvUS7SHOzFmqsWV7yILXdkZQyQNsa51TKgmkPDevZioaZIanyv4CxmTTIaJbUGyrNIHoeAa+Z/vv3aDPizV/IuUlsI2SInJeKmcl6QzxTHvoJYwZ8Cqn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281840; c=relaxed/simple;
	bh=Q0w/vhpgu2EydIkmjFr5BvuOLBPSJ/l21Xfmn9tO7ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2eaAq3iE9JslyL50uEmCIoacB40n7XwTwBs82YxBKmVgJVrEPAVbyxbqnNjiljnsm9TdOClxgYgS7LayDWJpzHf7+uFRGvBzLYOpM6zKpitfsDcVO1QMRTCUlibDapVtq9Xh3/6ir6fFAf9LvGTNsar+A43IlSojAs7O5JZMxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0avickO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0avickO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C27071F000FF;
	Thu, 24 Sep 2026 20:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281829;
	bh=NsBb2a+2MnL87YqP8rxQIrdpmy0NIM3zGlzIxgBW2w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V0avickO6ipGTtfzvJfK3oFEEGcOGynpAiy1+SZvtuat4nliCPK2Q/6seDOQhO5D1
	 2nc1N6J54mTpFAZx/lyhmMrNCl3OosT/s6nXtL3rcty0RdjwBO41xdri2snEwVB99c
	 5b6eo8bWFswZcYxORkUNwb3RCXrJSnZEiJulcdnW+HsLcknnnkqV/pWHAdxALpEEDL
	 Al6rRb4gVWw3aUtgdM4XkfDaLCFvxeEqZ1tcu931ZjaJteREoaAjwUsfeNEzeWa4vU
	 ggkzCbkTPt5AxYYttRSyLA6kMvwStgv6fLNjjS7bIOtn0zroT+tVXAjrFmU3NTisXY
	 nFgOkHzaDYj4g==
Date: Thu, 24 Sep 2026 13:30:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/32] man: fix alignment of the rtstart field in
 ioctl_xfs_fsgeometry.2
Message-ID: <20260924203029.GA2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-2-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:51PM +0200, Christoph Hellwig wrote:
> Using tabs for indentation messes up man page rendering, so use spaces
> for rtstart to match the other fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This could go into 7.3.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man2/ioctl_xfs_fsgeometry.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> index 037f8e15e415..6d30610b71be 100644
> --- a/man/man2/ioctl_xfs_fsgeometry.2
> +++ b/man/man2/ioctl_xfs_fsgeometry.2
> @@ -50,7 +50,7 @@ struct xfs_fsop_geom {
>  	__u32         sick;
>  	__u32         checked;
>  	__u64         rgextents;
> -	__u64	      rtstart;
> +	__u64         rtstart;
>  	__u64         rtreserved;
>  	__u64         reserved[14];
>  };
> -- 
> 2.53.0
> 
> 
