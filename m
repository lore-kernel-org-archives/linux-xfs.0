Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E63C318B97
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767810163; cv=none; b=Ww/rvOa63STaFXiao2QFFXVE2Rc6oh061ji6eQzb0GlFZcbq/QXv2ftat7enk9zjAQo3g27BloXlFoPa9BvrifU1eXKUS6yVDfDP4RfehCzS9T9GPQwD7N+Is1Ua8zTr/oIfiVBJbbX5+GkG5PIFyVjtNz2oAAr2nrV0eP8eYB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767810163; c=relaxed/simple;
	bh=H4HWARRoLh2qBgqBmASn3afgcSKRwurOHuNopMgArPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvFKfDx2Ecmg0GrU9WmptvYceAWe1hMtr+OXr32SSZ7AqVpkw8965EWIrofbh/GAoFjT3Yv2C0uWcY6Ysh2DPGmaGIRZUftNFFxaKay2DhzftqIfc3Y6W+jlili0byyQX+6fD3dYVFn/MfiTbgjKIiPTrC6FjIr3+wgl1y51wQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWX9K+8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWX9K+8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2867C4CEF7;
	Wed,  7 Jan 2026 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767810163;
	bh=H4HWARRoLh2qBgqBmASn3afgcSKRwurOHuNopMgArPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OWX9K+8m6Qs8HSAipuggB8IkGbanO+p48WgaDfW2YHtz0aP0hSWP2vbJRYWUZo/gO
	 r/h/b9mxt18oGLsIRGVT5T30CXP2+PZHb2wccVWUfdgisPce6obdCwxL20sRHP8O81
	 w9edctu2wTtS2SGCdJFMv9260ce3CVu92qqcdTib3fCEKQOR84wgjghtdHLBPkyD9d
	 9TegtU+q9r1nOd8Il5Hj2dBBkq0gWSZBkyZr/IhFZhSkSPKfXe+9V3UoV9S4dSM/+q
	 EK7g7ehShsvHkeKCvZT+GYgNYdBcrB1wsBS9Y7YDyzJkmQHKlHoDmq9slct8CikRjN
	 WqHdcbbj5JAOQ==
Date: Wed, 7 Jan 2026 10:22:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <20260107182242.GB15583@frogsfrogsfrogs>
References: <20251219154154.GP7753@frogsfrogsfrogs>
 <aVzE-5gMi1IHOLTW@infradead.org>
 <20260107000907.GM191501@frogsfrogsfrogs>
 <aV33flV7zsiAeh7C@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV33flV7zsiAeh7C@infradead.org>

On Tue, Jan 06, 2026 at 10:04:46PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 04:09:07PM -0800, Darrick J. Wong wrote:
> > In principle, yes.  For a generic xattr version you'd probably want to
> > check for a large valuelen on the set side so that we don't waste time
> > scanning the sf structure when we're just going to end up in remote
> > value territory anyway.
> 
> Yeah.
> 
> > 
> > >         It might be nice to just do this for set and remove in
> > > xfs_attr_defer_add and have it handle all attr operations.
> > 
> > Yeah.  I think it's more logical to put these new shortcut calls in
> > xfs_attr_set because we're be deciding /not/ to invoke the deferred
> > xattr mechanism.
> 
> Or that, yes.

It turns out that for replace, it's more convenient to do it separately
in the xattr and parent pointer code because parent pointer replacements
require switching new_name -> name and new_value -> value after the
remove step; and the rename optimization is different for parent
pointers vs. every other xattr.

> > > And for replace we should be able to optimize this even further
> > > by adding a new xfs_attr_sf_replacename that just checks if the new
> > > version would fit, and then memmove everything behind the changed
> > > attr and update it in place.  This should improve the operation a lot
> > > more.
> > 
> > That would depends on the frequency of non-parent pointer xattr
> > operations where the value doesn't change size modulo the rounding
> > factor.
> 
> Well, the same applies to value changes - in the shortform format name
> and value are basically one blob, split by namelen.  So anything
> replacing an existing attr with a new one, either due to a name change
> for parent pointers, or due to a value change otherwise can just move
> things beyond the attribute and update in place trivially.  For
> replacing values with values of the same size things are even simpler.

Yes it is pretty simple:

int
xfs_attr_shortform_replace(
	struct xfs_da_args		*args)
{
	struct xfs_attr_sf_entry	*sfe;

	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);

	trace_xfs_attr_sf_replace(args);

	sfe = xfs_attr_sf_findname(args);
	if (!sfe)
		return -ENOATTR;

	if (sfe->valuelen != args->valuelen)
		return -ENOSPC;

	memcpy(&sfe->nameval[sfe->namelen], args->value, args->valuelen);
	xfs_trans_log_inode(args->trans, args->dp,
			XFS_ILOG_CORE | XFS_ILOG_ADATA);
	return 0;
}

(parent pointers are a tad more difficult because we have to copy the
new name as well as the new value)

IIRC there's no rounding applied to shortform attr entries, so we have
to have an exact match on the value length.

> > I also wonder how much benefit anyone really gets from doing this to
> > regular xattrs, but once I'm more convinced that it's solid w.r.t.
> > parent pointers it's trivial to move it to xattrs too.
> 
> Not sure what counts as regular, but I'm pretty sure it would help
> quite a bit for inheriting xattrs or other security attributes.

Here, by "regular" I meant "not parent pointers" but yeah.  It'll
probably help everyone to implement the shortcuts.

--D
