Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23064E1C65;
	Wed, 14 Oct 2026 09:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791969255; cv=none; b=gMRy680K3ALSVDXj1I6xm1fvUR2PsvRlRHxpKL6hcPRu2gNqx5hgwB/OOJKgL53P/ZYmPsnqpT3nZh3+sGd/ya8md69BrfFQHFiTR5znNxg9peJzTq0DgVWPftid+ix1zpIYom7k0hXf56Ef3A4dwMi8dkcpSv/tsRrDByUhCTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791969255; c=relaxed/simple;
	bh=vfYCOs8X/g6ZctRXGJNqXciXeuGCnkehDk6z7zCOM6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHSIrsiZwcU7/5jBzUvhTNgUT3eILpllTEZ8kEXaHBMgPj6lwD+4cbf21CDYNpUuwUtrqW0llgg2DIWSjzJPyzdokqvsdHEMcGLi9ODKt/CN5KAaSStAqKZhER0F7/doniwD7UtUkesxvrh7sw66NclNXZvqHRWt981fXKTiurg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsQAHD6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsQAHD6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0851F000FF;
	Wed, 14 Oct 2026 09:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791969251;
	bh=bfDoFgGNmpbVs/i5XFnC5dgbN3tgrr/cF1c9gGZBGzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IsQAHD6mvzBzXXLKxD4ASe6B3qfHlZrLeQ16IBV5fLtpsxSleR0+94BHqQkXiYAZb
	 MgGNG/9vMH1ZewQHKraeZ+OgVTxRySVaBL85uJK7IV3hhLT5mYEWXG4ZaavwH7lFrP
	 MJSspy2UWInkEbJ/cUJb3Fc6ieYlRpnxlSpUBoMfvVbpOR5OQh7p8m9cYGPHgnKFcZ
	 aFzdYNpSouIjupPco4QsBjUxxVrJZt599YcJhXedSz1pK/vgGCIt/llMXjOgRoCiGt
	 GOFQRRkotMAAL95XBXBi9at2ugwIRoGslPecMVrUux3E4D0BUgS4BefiyhgJ4xvRSn
	 VlKHDk0NNOVbA==
Date: Wed, 14 Oct 2026 11:14:07 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asvBPbDfCIVm71jg@debian>

On 2026-10-11 19:06:32, Alejandro Colomar wrote:
> Hi Andrey,
> 
> > +As with
> > +.BR openat (2),
> > +if
> > +.I path
> > +is relative,
> > +then it is interpreted relative to the directory
> > +referred to by the file descriptor
> > +.IR dirfd .
> > +The special
> > +.I dirfd
> > +value
> > +.B AT_FDCWD
> > +can be used to refer to the current working directory of the calling process.
> > +If
> > +.I path
> > +is absolute,
> > +then
> > +.I dirfd
> > +is ignored.
> 
> Is there any difference with openat(2) regarding the handling of 'path'
> and 'dirfd'?  If not, we could say:
> 
> 	The
> 	.I dirfd
> 	and
> 	.I path
> 	arguments behave in the same way as in
> 	.BR openat (2).
> 
> Is there any small difference, or is it exactly as in openat(2)?

The difference I found is that
file_getattr(fd, NULL, ..., AT_EMPTY_PATH) succeeds but the
openat(fd, NULL, O_EMPTYPATH) returns -EFAULT. openat() always wants
an empty string while file_attr() can work with NULL.

	The
	.I dirfd
	and
	.I path
	arguments behave in the same way as in
	.BR openat (2),
	with the divergence that
	.I path
	can be NULL meaning an empty string.

so maybe like this?

-- 
- Andrey
