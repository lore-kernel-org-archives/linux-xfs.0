Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D91B3F3B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761632; cv=none; b=j1G+ybWhwVMT7/trVwFH5YiFBPGJQ5V4aUIHD/6htmJwL3WXbz21lsBTe864ifedmGJuEbDbsdSK9yx6z7uIHECY0w7Dq2vFAXuX+u5xfMkRVg1BW9i2O3ZDyEYQutA+z8dvZ0swm6owNtlbQBsv+7rT+zTm1YEQ/5S9z4h4U9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761632; c=relaxed/simple;
	bh=bqYnZDliRd4ON/d/UNjlVbI4/WByVYnjnPdKLcD0vJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgUTUT8sOgkl10+EOldF75dLf0rcDdEkLb1XtzKeG1knbiK4GPYRYSLBX8d7HXM31WWpljWn+5K27Tuk0YILZ3ZebHxW1RF5lmg8xgwlfPpvWnXNfh5jfetrTN+Ai9IbeY7wZKa/S3N0tFzEfohY8KUr/1/n/q3gnlVKWguG5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrwMjl8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrwMjl8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58744C61041;
	Tue, 27 Aug 2024 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724761631;
	bh=bqYnZDliRd4ON/d/UNjlVbI4/WByVYnjnPdKLcD0vJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrwMjl8Jl9CHmTOrGdhkGJHzP6wL+HtqPzIjIwCUExQ6o3rrrAciAEhStEHW1SNjj
	 akeHo+1NQEhAGD0M8QM0OsdRQIXz4raxgNvPeDVAzpbOB57w0Iro/LX+Wx6IPuv2eY
	 3aH44xUxR0r2rfA1Bfq7akN5Sz17J493Zrh6FUG0wFgrQKnywVQy8JWXM+2rIuzssi
	 jEvKucMUA/5Ex5xBbBLrmRRpSs+qJLjiJRzsj9jy36enyZkD5ppz8sh7VIJPWY9KkS
	 lMuknyLyhtCETHUeBit0l8t/h9L80IRmHRo3rzpvQrN5nZfltP5SRhQmnsp4p46JnP
	 zZYs6H+Z0l5Xg==
Date: Tue, 27 Aug 2024 14:27:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] scrub: Remove libattr dependency
Message-ID: <7vjkhxi2jv6mg4k6xle62lhve27myjgxml2batfwmshwkvfekk@jstiohihwa2d>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-4-cem@kernel.org>
 <Zs3Dr2wwcaAFhMMO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs3Dr2wwcaAFhMMO@infradead.org>

On Tue, Aug 27, 2024 at 05:16:47AM GMT, Christoph Hellwig wrote:
> >   */
> > +
> >  #define ATTR_ENTRY(buffer, index)		\
> 
> Spurious whitespace change.
> 
> >  	((struct xfs_attrlist_ent *)		\
> >  	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
> >  
> > +/* Attr flags used within xfsprogs, must match the definitions from libattr */
> > +#define ATTR_ROOT	0x0002	/* use root namespace attributes in op */
> > +#define ATTR_SECURE	0x0008	/* use security namespaces attributes in op */
> 
> Why do we need these vs just using XFS_ATTR_ROOT/XFS_ATTR_SECURE from
> xfs_da_format.h?

Because I didn't see XFS_ATTR_ROOT and XFS_ATTR_SECURE exists :)

I'll take a look on it, and if we don't really need to define ATTR_ROOT/SECURE,
I'll just keep ATTR_ENTRY locally to fsprops.h, we don't need a header file for
just a single definition IMO.

> 
> > +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
> 
> Overly long line.

Ok, Thanks!

Carlos
