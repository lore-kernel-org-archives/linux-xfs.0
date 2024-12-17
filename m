Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8865A1F37BE
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734454977; cv=none; b=f4QQjY/f6QuCOxeG5i+A3PI0csK8z7TuW6cYGG4p0ggZuz27iD9TkdKWuD5aUjEOxEUF7c1zBmygRDVz/zARAkf1yH2NbobiSaarA1WPctEUG3KoSYOCdBxL/3MaTmSJRx9yZ5o2ucbfJUNlk7NnhAhlSzNejpiZAGOEAh65U3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734454977; c=relaxed/simple;
	bh=bM14M5he4fYxuUluWUklftZlSUc2gBmESxCkUj7m770=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VI+w+2nXtmgk1qbmP3LbH4JY0BrwEGYIY7RxOMlDQh4VYIG9h06oHQ6euu2y6/a2y5z3uptffYXPcPKulKs+eOlePQ1CJbi1DbJEK9IXDT/tCfn/pZsncoli3btIP+Fyq3sIyXcp8OMYt6439WGejgPGkGQcPPaB9Z0EYf9K3ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qkcu0vNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qkcu0vNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00579C4CED3;
	Tue, 17 Dec 2024 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734454977;
	bh=bM14M5he4fYxuUluWUklftZlSUc2gBmESxCkUj7m770=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qkcu0vNC1rJ6ZsplvCmB1K/hdxYteWEcz7qVge0QASPnfAK05xofpiNHC0Idu6ToF
	 vHQ/7a4zZ+rlW5PjHITjvRXdNr/iL1OkQTdEUJxIT7lVnKWAN32vFPOXwnk15oT/FH
	 BVwZGvOhW3tnrHFZxpUDNuIXvT318a8ZSjObPw8W/HihJHBz3M6FGJ5+S8qYQf/JWc
	 SYpvXX7Y1mI22DjuNdkMhG+j4F4+ULKBlOKExeLoyTduEfIcUuaE+TOC++9RyY5fJw
	 BV2wSUa1FGUvIqX1z862qfyABNf1XQPoQ44svexJSIPYVqxg/ISfG86JcrywGNXYOI
	 Zf30t1fZ6CWIg==
Date: Tue, 17 Dec 2024 09:02:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: support xchk_xref_is_used_rt_space on zoned
 file systems
Message-ID: <20241217170256.GH6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-34-hch@lst.de>
 <20241213224912.GW6678@frogsfrogsfrogs>
 <20241215061349.GB10855@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215061349.GB10855@lst.de>

On Sun, Dec 15, 2024 at 07:13:49AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 02:49:12PM -0800, Darrick J. Wong wrote:
> > > @@ -272,7 +273,6 @@ xchk_xref_is_used_rt_space(
> > >  	xfs_extlen_t		len)
> > >  {
> > >  	struct xfs_rtgroup	*rtg = sc->sr.rtg;
> > > -	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
> 
> 
> > >  	if (is_free)
> > > -		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
> > > +		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
> > 
> > rbmip is already the return value from rtg_bitmap()
> 
> Yes, but it gets removed above.  Because it only has a single user,
> and it keeps me from incorrectly referencing it in the zone branch,
> which I did initially and which didn't end up well :)

Oh right, my bad.  With the typo in the commit message fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

