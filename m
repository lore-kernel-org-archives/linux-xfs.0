Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F826B777
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891788; cv=none; b=j8ZNJbufeQwFaoXyb9vvVzYP+NVRNM+bfBYROcVMKck0USCR1/9ebHZsVDoyY5V/KaHkZIvG2LluonwM26Ci54QcJNzFUrmiTt2wDdWjCzjlaEkimpMIatLqStP7jLTX3Ul3EQFtP15Mk76vtDKhTLv1XfHdQee6Xl8N+Au7fLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891788; c=relaxed/simple;
	bh=NQ8k4y9cIPhrLBQVGcIu9Q+2NlMAY8+l4LIFSwJD8Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2DKMHAJCT6LxZJaXbVMfzEtjtgFgxLGUfpOKTFM2ZYkxrX6r+GH4vx61N3lEBy8coT4zhCJC/nyNfBWJKvGiJhfUoyvEYuI0dMJRQMMMphT+Khl623iI8wnEDmdCB/gjLMQS0t+GMDufFdazMxmqXbM6Ad42c7X/OG/gBamFRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XowJ4xjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XowJ4xjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F321C116C6;
	Thu,  8 Jan 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767891787;
	bh=NQ8k4y9cIPhrLBQVGcIu9Q+2NlMAY8+l4LIFSwJD8Go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XowJ4xjbgIs1i+PX9d8AC8BxAcfIUP16S93ckIT8L2yGcUuIC1E0xIBwOmcFdajAF
	 UD5+FNQfDaImppNLFqOsuJ8KbtntWp1kp/NIT3gQhb5VUxNbAbhAbVw716qkUiFt/G
	 ntolvVJBUASW/B8JsiN+jdtiExLJGQa3ya0dKlF1HhXQPSbek6nnQq421du+XH0GhD
	 thSnUXe/bmO0DKaqln0JjiUTaDMDg64e+FR2noAmQ/0VI6zNr7X5VpstzFP/ljzxl3
	 WDo117+c7W6ZiXNiodt+iC/lu3gyq4xZi/DGRM4vYOB7RI3wevDJFP8lIY/0smUMdN
	 jkVDmA0OVZOxw==
Date: Thu, 8 Jan 2026 09:03:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <20260108170307.GK15551@frogsfrogsfrogs>
References: <20251219154154.GP7753@frogsfrogsfrogs>
 <aVzE-5gMi1IHOLTW@infradead.org>
 <20260107000907.GM191501@frogsfrogsfrogs>
 <aV33flV7zsiAeh7C@infradead.org>
 <20260107182242.GB15583@frogsfrogsfrogs>
 <aV95NpD3Jow6UgOj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV95NpD3Jow6UgOj@infradead.org>

On Thu, Jan 08, 2026 at 01:30:30AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 07, 2026 at 10:22:42AM -0800, Darrick J. Wong wrote:
> > > > xattr mechanism.
> > > 
> > > Or that, yes.
> > 
> > It turns out that for replace, it's more convenient to do it separately
> > in the xattr and parent pointer code because parent pointer replacements
> > require switching new_name -> name and new_value -> value after the
> > remove step; and the rename optimization is different for parent
> > pointers vs. every other xattr.
> 
> I don't really follow, but I trust you on the parent pointers.
> 
> > > for parent pointers, or due to a value change otherwise can just move
> > > things beyond the attribute and update in place trivially.  For
> > > replacing values with values of the same size things are even simpler.
> > 
> > Yes it is pretty simple:
> 
> This is the same sized value and name, and it indeed is trivial.
> 
> But even a change in size of the value (or name for that matter, except
> that outside of parent pointers that operation doesn't exist) is trivial
> in an sf attr fork with enough space, you just need to either move out
> anything beyond the attr first (larger name + value size) or down after
> (smaller large and value size).

<nod> Though if it's not an exact size match, then calling _sf_remove
and _sf_add already does that -- the _sf_remove will compact the entire
sf attr structure before _sf_add puts in the new attr.

The downsides of that sequence is that while we could probably save a
trip through xfs_idata_realloc, then I have to write and QA new code.
So for now I'd rather focus on optimizing xattr replace where the old
and new size are the same.

> > IIRC there's no rounding applied to shortform attr entries, so we have
> > to have an exact match on the value length.
> 
> Exactly.
> 
> > > > I also wonder how much benefit anyone really gets from doing this to
> > > > regular xattrs, but once I'm more convinced that it's solid w.r.t.
> > > > parent pointers it's trivial to move it to xattrs too.
> > > 
> > > Not sure what counts as regular, but I'm pretty sure it would help
> > > quite a bit for inheriting xattrs or other security attributes.
> > 
> > Here, by "regular" I meant "not parent pointers" but yeah.  It'll
> > probably help everyone to implement the shortcuts.
> 
> For user attributes it really depends on how people use it.  But for
> applications that update fixed sized attributes, which doesn't sound too
> unusual, it would be a nice improvement as well.

<nod>

--D
