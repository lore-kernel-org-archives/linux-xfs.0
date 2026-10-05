Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66213DC4CC;
	Mon,  5 Oct 2026 21:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791234757; cv=none; b=LWaJZmmQ/3DiGhzbJ3FC/Thmxp/xHVi73LzD5YaGJQC9fUNc+27F5NEY1w767SKi3ZokRxngsN/AeHiKTiOO5c+1XDqDbNJ/19DoXS/OrHzWfZuY+oKdRi73UcRYJyjNESntgvmtEuH2baY6EpqoActvzFQNA7Q9izl188invFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791234757; c=relaxed/simple;
	bh=6jF9c9FGtkd+lWxT4xDLQUJQcMFzWy2WRuHYKakSFQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3Nas6d23m1HX11GwKR6MiWx5svUjW2+pfbGHRd0KQYfFsudlkgobiwSHU3TbVxKup6jMU6b22lopDfpNmUCKFRZkSxygrxLk1tzSwc3YzuXjQ0mkSiuxUsXdLUmB0WRl8CLGVC4/QZpsHTyv0suybsBU7gobMTpYgHLyk8b7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJteQIa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJteQIa/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 597531F000FF;
	Mon,  5 Oct 2026 21:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791234756;
	bh=tWny7OQoIybWrVpLqJVtZbV0h7M1yQfOw+IiB5CpJ1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HJteQIa/DDzgnwyJHNbSCu+IWvB1GpDJUesTphW48b60A2/0GRigCUS7194OP5m3s
	 LznhOFBx8V60WNnU6TgcbnfjkZ+PEFWD3XjqDSwUM5j7+SX4hnw8kf0UtartFyXHLg
	 PHYvoGd2j/k6UJfyQPokSWmM3/0jJcRqbWZ5k3anZTwHQgvJlayp9hSdRQDZwrax+7
	 giYaXZ09baiLJ/5pvHPX56cgLGnHOtmkdaRyWOBcSx0pTqS2/Ht5qeVe4TuHThbYhd
	 4hvzwzFJj4Zo/rgJfAr7p05yzBWMZbvXnR1l42A19uhK9ogaMXTxZAlO8gbE4RygkZ
	 djvHaykCksmLg==
Date: Mon, 5 Oct 2026 14:12:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 15/21] xfs: add fs-verity support
Message-ID: <20261005211235.GF2705364@frogsfrogsfrogs>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-16-aalbersh@kernel.org>
 <asPEIapeSklgcsUa@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asPEIapeSklgcsUa@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Mon, Oct 05, 2026 at 07:18:35PM +0200, Andrey Albershteyn wrote:

<snip>

> > +/*
> > + * Try to remove all the fsverity metadata after a failed enablement.
> > + */
> > +static int
> > +xfs_fsverity_delete_metadata(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_trans	*tp;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	int			error;
> > +
> > +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	if (error) {
> > +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > +		return error;
> > +	}
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> Oh I haven't paid enough attention here, it has to be moved before
> xfs_ilock(ip, XFS_MMAPLOCK_EXCL) not just before the lock, to exclude
> ABBA with writeback/reclaim taking folio lock and waiting for trans
> space.

Hrm?  You have to hold IOLOCK and MMAPLOCK, and *not* hold ILOCK, to
truncate the pagecache.  IOWs,

	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));

	error = xfs_trans_alloc(...);
	if (error)
		...

	xfs_ilock(ip, XFS_ILOCK_EXCL);
	xfs_trans_ijoin(tp, ip, 0);

--D

> I will send v18 if more feedback will arrive, otherwise, I can
> resend just this patch (or could be fixed during merge?).
> 
> -- 
> - Andrey
> 
