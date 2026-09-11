Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720C23A1CF8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789140630; cv=none; b=b/U17O9ywAL9IymK3+ima+zoyTRQg/Ep/GVih0IB9O6juhy+KhalruzBuGDH5hFzaFNb4fYrL7Ht9o+EZOToPhYLbtPdyRFmp8Yoh/KyjoTlIn/AAd3Qw7zNOp5CWIGwHTL19+u1tnS0sFMh8yGfj1SH5zruW+XsxNLYb6UoUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789140630; c=relaxed/simple;
	bh=H5zC+nQKjbCo3JDcD6j3zgsnkZOqf7yQTWzrZN3Rcos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPr4yyQ5f0niRnxFhK3R/vLcrA/c5w5t8t+4VgZujizSeIYP1BLygPEeNhPpLTsPW20jt4/2VSM5/uy8bvjYy+i6IBTxrHI4p0UgTirh/PaBkIq+oZQLpP23TMXjCmhn4CpNVlEsywFh1qESLabfu19DPbzYxCnbeVpzb4d84TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RU5Qtsdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RU5Qtsdj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F2EB1F000FF;
	Fri, 11 Sep 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789140627;
	bh=LJ4oEgt+onRjZfLPxjPtDwPH29djCOg6S7TkeCy52Gk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RU5Qtsdj2VI7ZKaP7l6zeqV8qvqUMXS5GePdJMre4kxd57J4Yg9DQk3gIkMvGGfyG
	 QWft90QcDhbn73AstRZPmBT25TTZANk3yoyumcIWdQwVWJJuVGFaLbwxOVFz3SxQWu
	 2il14twM5IiJ+9NOZEQxcaPY6ctWsSKaJ+aNeEVC50oYs736xmkpH/sQLJ6aoltTqP
	 QCDL/0t4GGBn849Cz0OC72GoZePCo0n2riOHbJXfEBqhO5J3zfvT55LGOoHXanCFz3
	 XuFkZm/ezD2KoB5VZBJeBaqcQyKy5EKIsb7zxOChBWBaBEgRfQLPagg1vQcm1zHjH8
	 Vqd0aFwv30Hcw==
Date: Fri, 11 Sep 2026 08:30:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: don't set mp->m_rtdev_targp when no RT
 devices is provided
Message-ID: <20260911153026.GF6265@frogsfrogsfrogs>
References: <20260911144559.1959740-1-hch@lst.de>
 <20260911144559.1959740-2-hch@lst.de>
 <20260911145726.GE6265@frogsfrogsfrogs>
 <20260911151120.GA26893@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911151120.GA26893@lst.de>

On Fri, Sep 11, 2026 at 05:11:20PM +0200, Christoph Hellwig wrote:
> On Fri, Sep 11, 2026 at 07:57:26AM -0700, Darrick J. Wong wrote:
> > > -	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
> > > +	if (xi->rt.dev == xi->data.dev)
> > >  		mp->m_rtdev_targp = mp->m_ddev_targp;
> > >  	else
> > >  		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
> > 
> > Does this mean that m_rtdev_targp is never NULL, even when we don't
> > specify or have a rt device attached?
> 
> I think that is the case right now.
> 
> > I would have expected this to be:
> > 
> > 	if (!xi->rt.dev)
> > 		mp->m_rtdev_targp = NULL;
> > 	else if (xi->rt.dev == xi->data.dev)
> > 		mp->m_rtdev_targp = mp->m_ddev_targp;
> > 	else
> > 		mp->m_rtdev_targp = libxfs_buftarg_alloc(...);
> 
> And that is what we get with this patch.  The zeroing is done by
> zeroing the entire mount structure in the callers of libxfs_mount
> (don't ask me why..).

Sorry, but I don't see how we get to m_rtdev_targp==NULL with this
patch?  The end of libxfs_buftarg_init becomes:


	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data, dfail);
	if (!xi->log.dev || xi->log.dev == xi->data.dev)
		mp->m_logdev_targp = mp->m_ddev_targp;
	else
		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
				lfail);
	if (xi->rt.dev == xi->data.dev)
		mp->m_rtdev_targp = mp->m_ddev_targp;
	else
		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
				rfail);

In the case where the rt and data devices are not the same, we create a
new buftarg object, even if xi->rt.dev == 0.  That only happens if we
didn't set xi->rt.name to a path, which means that libxfs_device_open
ignores it:

# truncate -s 3g /tmp/a
# mkfs.xfs -f /tmp/a
# gdb --args ./build-x86_64/db/xfs_db /tmp/a
(gdb) p *mp->m_rtdev_targp
$5 = {
  bt_mount = 0x555555659660 <xmount>,
  lock = {
    __data = {
      __lock = 0,
      __count = 0,
      __owner = 0,
      __nusers = 0,
      __kind = 0,
      __spins = 0,
      __elision = 0,
      __list = {
        __prev = 0x0,
        __next = 0x0
      }
    },
    __size = '\000' <repeats 39 times>,
    __align = 0
  },
  writes_left = 0,
  bt_bdev = 0,
  bt_bdev_fd = -1,
  bt_xfile = 0x0,
  flags = 0,
  bcache = 0x555555684ab0
}

Here we didn't supply an -R option to xfs_db, but libxfs assigns
m_rtdev_targp to a buftarg that can't do anything useful, instead of
NULL which (AFAICT) the code expects:

$ git grep m_rtdev_targp
mkfs/xfs_mkfs.c:5635:   if (mp->m_rtdev_targp->bt_bdev &&
mkfs/xfs_mkfs.c:5636:       mp->m_rtdev_targp != mp->m_ddev_targp &&
<snip>
libxfs/init.c:981:      if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
libxfs/init.c:982:              err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,

OTOH there are other places that use other checks that clearly assume
that m_rtdev_targp is always present:

libxfs/init.c:311:      if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
libxfs/init.c:1034:     if (mp->m_rtdev_targp != mp->m_ddev_targp)
libxfs/init.c:1035:             libxfs_buftarg_free(mp->m_rtdev_targp);

Ok maybe this patch is fine as-is?  But xfsprogs needs a treewide change
to make the "do we have a rt device attached?" checks match the kernel
code?

<even more confused>

--D
