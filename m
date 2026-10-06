Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46929381EA8;
	Tue,  6 Oct 2026 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277446; cv=none; b=UVk/U+T/a9MQ5tqCbWxTUkGrUUU6Iog259pITpHg2fnuQ2D7awj1OnkwLCzLXhHYjvJspnnuGD3IlQdSTpyWGelcbaATpME4gayOywRgOrPD04eXs18yF3w0E9Ahoy0C9U20a0BMcYWCMiqHJT7NWl0sTKx3D+un2Efl4UX4bro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277446; c=relaxed/simple;
	bh=GBTKK+aqYBJb8bFenekT02Q8nJLKXkArH7C/5YYTJ/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0+8KzkeJp3tJcIzZaRQ4Y1vdyscAmmmPexTGPW2bsAMPg+voSkQjqLsNmpvTPUfZMEkxFipVEGpqF1j0JRUpqKPNygpJ7TxW2Vqy9ERj7cp9idNb8uBOTf5igA9NaA1PGnlWoDxFdklZMbAAElszQ/JkZ+mrSeFLh+UIL3rqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv+Iwz6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv+Iwz6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F50F1F000FF;
	Tue,  6 Oct 2026 09:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277444;
	bh=PgeNokXIlRBGGeHOkLtJQ5VDem+6R26Oh7feIv6Fbzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cv+Iwz6EcV7+p4TS0689Vi+owN+wS6+WTmpfgTmF0wiiAGIvV1GhvYsdLl9yQ2ne7
	 HMaTDRA8mE6/kgQPkxjrvctzXetFjupG1ZWZfE+MKB2AT8zKP9P90m+kNilyEZuQGJ
	 Y1sYeVcUJ/w2M4TeydnP2vCYx9qnh5hbITYASlKMNznUNeewrq/FRCJdpH0lgSkfAs
	 OalzBxscMcTLeiZhV0gXyDELtvgG/5Yden/XakB9B06IF0/pL5+IRnGspiQyeiSUbA
	 W8Ye83zx8uuEA6UuHg2c3eW3BWgKlZ2msR8xr9vstSx2g00AnFuwOpkmh230viqP69
	 Ys94/DWQ+G/+Q==
Date: Tue, 6 Oct 2026 11:03:59 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 15/21] xfs: add fs-verity support
Message-ID: <asS3a5f8JKzVmlta@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-16-aalbersh@kernel.org>
 <asPEIapeSklgcsUa@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20261005211235.GF2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005211235.GF2705364@frogsfrogsfrogs>

On 2026-10-05 14:12:35, Darrick J. Wong wrote:
> On Mon, Oct 05, 2026 at 07:18:35PM +0200, Andrey Albershteyn wrote:
> 
> <snip>
> 
> > > +/*
> > > + * Try to remove all the fsverity metadata after a failed enablement.
> > > + */
> > > +static int
> > > +xfs_fsverity_delete_metadata(
> > > +	struct xfs_inode	*ip)
> > > +{
> > > +	struct xfs_trans	*tp;
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	int			error;
> > > +
> > > +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > > +	if (error) {
> > > +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > > +		return error;
> > > +	}
> > > +
> > > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> > 
> > Oh I haven't paid enough attention here, it has to be moved before
> > xfs_ilock(ip, XFS_MMAPLOCK_EXCL) not just before the lock, to exclude
> > ABBA with writeback/reclaim taking folio lock and waiting for trans
> > space.
> 
> Hrm?  You have to hold IOLOCK and MMAPLOCK, and *not* hold ILOCK, to
> truncate the pagecache.  IOWs,
> 
> 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> 	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> 	error = xfs_trans_alloc(...);
> 	if (error)
> 		...
> 
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 	xfs_trans_ijoin(tp, ip, 0);

Yeah sorry, you are right, I'm confusing myself

-- 
- Andrey
