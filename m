Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC4433ADB5;
	Fri,  9 Jan 2026 12:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963192; cv=none; b=NhntWAQJYTbgylcppp0UQgEEI+68TK8RmxWVudkhZhViZZt/ihs4KdPfJ0rYHz+duIPqT9D/11p7TWh3CnZtm+/P2rU6MlD1ehfODQjX69+pyBhhW/XEgWjDiyc1WMymoUAJ9iTDPSr3ypjzXUgt1RpIv9DnPI39GzNZvOFxfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963192; c=relaxed/simple;
	bh=9BpuTZ3T/QwPYbI4OHZhOQ/A+iIPbUXNUI77AzLpAgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUdHBXEh5BwGYgx5xNAFCMBuSpdKj1JBpiCUAXjAP9a8oG3q6koJzsbLWHJMpeuCEJd0Bv9HYMVchnOJ/usZ0LWvy+lbGEg9/VNzRGjD+CFR5obR1pbf3zihpM4pSP84Jkb/+tzhZAjeYAP4+TYW1dojca6DDV++Z6uw0B8+YlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDcPvHEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDcPvHEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB32C16AAE;
	Fri,  9 Jan 2026 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767963191;
	bh=9BpuTZ3T/QwPYbI4OHZhOQ/A+iIPbUXNUI77AzLpAgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDcPvHEO3IlwRKcBSlwu8t/RkyW4T4lU5syGsF20B4+Em48SY7X8Y5fpe2q9H8Iw8
	 mvGq1xvrzgdnPffjd34AU1rfKHRd4CI+HxDjbk/UCaGLI5XrRWoJVQ9go3Z6sCm7KO
	 LNBYdZ63HlRF8xSbEn5cUcGKC6g7xHbVmgQpPHIfGX3mGAhjQhD0ja/7K2d4ng02xV
	 xHaBiz5wKmO8oVJNzS6QVvauFHTFV+k88cG/9UJqxnbwB/72hjq7LE/Kh8tuU9fPMz
	 aQQ+Y+PCxSP+i2aS55eSZYV3hIIuUr3KCK51Kc8Nd0WaXwf+yqazg8nFpH7kQRRH0U
	 lvTbqNEyCTjGA==
Date: Fri, 9 Jan 2026 13:53:05 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Christoph Hellwig <hch@infradead.org>, 
	Andy Shevchenko <andy@kernel.org>, linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWD5yuK1fS5JTEol@nidhogg.toxiclabs.cc>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
 <202601080905.D1CC8CC@keescook>
 <20260108094242.8b043d248e7877235f606416@linux-foundation.org>
 <202601080954.272AAE6217@keescook>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601080954.272AAE6217@keescook>

On Thu, Jan 08, 2026 at 09:55:27AM -0800, Kees Cook wrote:
> On Thu, Jan 08, 2026 at 09:42:42AM -0800, Andrew Morton wrote:
> > On Thu, 8 Jan 2026 09:06:49 -0800 Kees Cook <kees@kernel.org> wrote:
> > 
> > > On Thu, Jan 08, 2026 at 07:52:15PM +0300, Dmitry Antipov wrote:
> > > > Introduce 'memvalue()' which uses 'memparse()' to parse a string
> > > > with optional memory suffix into a non-negative number. If parsing
> > > > has succeeded, returns 0 and stores the result at the location
> > > > specified by the second argument. Otherwise returns -EINVAL and
> > > > leaves the location untouched.
> > > > 
> > > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > > Suggested-by: Kees Cook <kees@kernel.org>
> > > > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> > > 
> > > LGTM, thanks!
> > > 
> > > Reviewed-by: Kees Cook <kees@kernel.org>
> > 
> > Thanks, I'll add both these to mm.git's mm-nonmm-unstable branch for
> > testing.
> > 
> > If XFS people would prefer to take [2/2] via the xfs tree then please
> > lmk and I'll send it over when [1/2] is upstreamed.  Or we can take
> > both patches via the xfs tree.  Or something.  Sending out an acked-by:
> > would be simplest!
> 
> I assumed this would go via xfs tree, but I'm happy to do whatever.

Particularly I find it much simpler to have those inter-dependent
patches to go through in a single series via a single tree, instead of
breaking them apart and create merge dependencies.

As long as xfs list is in the loop I particularly don't mind. Thanks for
pulling it Andrew.

Carlos

> 
> -- 
> Kees Cook
> 
