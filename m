Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E642D130B
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762965369; cv=none; b=SZxFIy/o+dO059GCVVv7dy2Mz41BrRxzMV0lTnGcj/oF+yuLfs5QgImiV2FccHark0V2OpKHkI/wQiC64nHwZJLZhq7ClTfFPgDMPxO+NWCAoK/05R6vywEerFw9I2qpGGyp5ymrNRo0a2CpYlKF1tP64N44xG3KMA4cJtIXwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762965369; c=relaxed/simple;
	bh=ApUv2n/hs2+W/wcNfjWUDacHtGxcWVnhAWGFbiilRGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oegD5qGTGCP0VpwC2CK9VzawFsRsocyifE6pcn1HOJkQfGtI4oUHtv9N6kj3Y4k0ObxAkZHf4SXTfGtFBekBxj4yeEy92SteYdAjpbCyUTtx/M0Je+Qg4rJ82J7xnXtv4DwAX0lKsjlnUx3FI7bwIovUVirf30EVbxNp7iI9VTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BA+/7Peg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BA+/7Peg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63B9C113D0;
	Wed, 12 Nov 2025 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762965368;
	bh=ApUv2n/hs2+W/wcNfjWUDacHtGxcWVnhAWGFbiilRGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BA+/7Peg7zNjngWTtCzSEwrp+gIFYMWLQZ5M1sIkRwoAaJOvwBlJ/XR1YIIYZ06SJ
	 K95LBfwKMOIf7iV8TXvIMkltVYsw3Vczx8JL5paMsi1XQiSGIFo7k7WiHLjURDKQvc
	 pLif3DrvPRfB1wAYjhfVDizLdXCKh/CbNa3SlfwUj6jSH9/AtVXfMUoix8lu1FCWue
	 ceUcTsNOcUSzwW5R1+UGJi7Fc/TpaZ6c4XczbhsMbmICUMW93wyoPfi4dkup/ke9Kl
	 HIQAhy8hkFhRHBWuo2/2GaFNGhvmRTF0t1OVlUu31N+L7RDjzxlWiuYn2LkVWNY9sZ
	 opY4eUCFtj3ug==
Date: Wed, 12 Nov 2025 08:36:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	david@fromorbit.com, hubjin657@outlook.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: catch used extent array overflow
Message-ID: <20251112163608.GZ196370@frogsfrogsfrogs>
References: <20251111141139.638844-1-cem@kernel.org>
 <NM5nTfOcdVh4Bz31WhekwpUkERNHbF4mHQTkHyzB2nADKWkzKweM2xvo8AyVGHJnBk0joWMby8EL6pNvIVmKQw==@protonmail.internalid>
 <aRNGBoLES2Re4L5m@infradead.org>
 <t2d73maqm4uxsipsacb423dcsg3u6dy3gty3u34wlj3zp4xfgw@lalkwdrmkj2b>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t2d73maqm4uxsipsacb423dcsg3u6dy3gty3u34wlj3zp4xfgw@lalkwdrmkj2b>

On Tue, Nov 11, 2025 at 04:10:57PM +0100, Carlos Maiolino wrote:
> On Tue, Nov 11, 2025 at 06:19:50AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 11, 2025 at 03:10:57PM +0100, cem@kernel.org wrote:
> > > -	int			used = nex * sizeof(struct xfs_bmbt_rec);
> > > +	xfs_extnum_t		used = nex * sizeof(struct xfs_bmbt_rec);
> > 
> > used really isn't a xfs_extnum_t, so you probably just want to use an
> > undecored uint64_t.
> 
> Fair enough. Thanks!

Does check_mul_overflow work for this purpose?

--D

> > 
> > Otherwise this looks good.
> 
