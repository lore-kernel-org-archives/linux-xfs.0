Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54947280318
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 06:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765263030; cv=none; b=tFalkXCQYTzRejx/iy1jzJuJRk+9ucDl9fhmmHdPLwbelLRrQ+KcZyc5OcpvooXwJBr8lp4eS5rMgFBiD3a2JJZQSn3TwV7+1mjPxEx3d2G0t5zQaMF6s+dW4CT0YoRL7z58WpqrGwtKujFyfGcw7iW+BNHEERcgWYdcTw+oC6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765263030; c=relaxed/simple;
	bh=CeDr3LVB3OOXIfS01b247xImACn33L/imXBlNty+38c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOg21dbSBQBCmiKFtFKm2XDGzSwktn+xrAnFXmclVjxZOMFqSGtV3XF43fmwCO/4g+eXXnnmQ2uo+mOSaCW+M9CyFrzHn03bTI5lJXvAmih/egVwbAx4HS4VTrI6dmve8Rw4AbHCDNC0ZUOMeSK5ap0K3s9JvXe6Zd1CZeoI5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9DoMdFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9DoMdFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D8EC4CEF5;
	Tue,  9 Dec 2025 06:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765263029;
	bh=CeDr3LVB3OOXIfS01b247xImACn33L/imXBlNty+38c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r9DoMdFXqHY8XXiecq/edZ9L/O1bkevK0m1LNi3ZhusVg9csrASQ4xjLZc5AD3sxg
	 xvlWqxLxUMZePzBhhClwfjWeOii557BrMzhPSeVOkbJSwfT7+0IOusX7GcNsQiyFP9
	 C9yekEqWkVi9MjnNbTUUKEWQs/pe9/BBMaa6dsLXnds+ia6k5c+XMK84stCCBJo4aT
	 NcMRbdxuU7RaF2KZkqUk/QzErnUftKlXBOomsHUJvIO4hNB0gFgIXXyKvPE7ix8+4W
	 Z84Ox11vkEMykGQrwGsmv7GxsPJ1GUKe5niovTRR/47SwV4wbujl9oMYdtkv8ZZRB2
	 DMGcnKvnRmvbQ==
Date: Mon, 8 Dec 2025 22:50:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1] xfs: Fix rgcount/rgsize value reported in
 XFS_IOC_FSGEOMETRY ioctl
Message-ID: <20251209065029.GJ89492@frogsfrogsfrogs>
References: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>
 <20251208174005.GT89472@frogsfrogsfrogs>
 <0f322623-3d1a-47da-92b7-87ef0e40930b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f322623-3d1a-47da-92b7-87ef0e40930b@gmail.com>

On Tue, Dec 09, 2025 at 11:05:21AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 12/8/25 23:10, Darrick J. Wong wrote:
> > On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
> > > With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
> > > disabled, number of realtime groups should be reported as 1 and
> > > the size of it should be equal to total number of realtime
> > > extents since this the entire realtime filesystem has only 1
> > > realtime group.
> > No.  This (pre-metadir realtime having one group encompassing the entire
> > rt volume) is an implementation detail, not a property of the filesystem
> > geometry.
> > 
> > Or put another way: a metadir rt filesystem with one rtgroup that covers
> > the entire rt device is different from a pre-metadir rt filesystem.
> > xfs_info should present that distinction to userspace, particularly
> > since xfs_scrub cares about that difference.
> 
> Okay, got it. A quick question:
> 
> A metadir rt filesystem will have 1 bitmap/summary file per rt AG, isn't it?

Per rtgroup, but yes.

> If yes, then shouldn't functions like xfs_rtx_to_rbmblock(mp,
> xfs_rtxnum_t        rtx) return offset of the corresponding bitmap file of
> the rt AG where rtx belongs?

xfs_rtx_to_rbmblock is an unfortunate function.  Given an extent number
within an rtgroup, it tells you the corresponding block number within
that rtgroup's bitmap file.  Yes, that's confusing because xfs_rtxnum_t
historically denotes an extent number anywhere on the rt volume.

IOWs, it *should* be an xfs_rgxnum_t (group extent number), which could
be a u32 quantity EXCEPT there's a stupid corner case: pre-metadir rt
volumes being treated as if they have one huge group.

It's theoretically possible for the "single" rtgroup of a pre-metadir rt
volume to have more than 2^32 blocks.  You're unlikely to find one in
practice because (a) old kernels screw up some of the computations and
explode, and (b) lack of sharding means the performance is terrible.

However, we don't want to create copy-pasted twins of the functions so
we took a dumb shortcut and made xfs_rtx_to_rbmblock take xfs_rtxnum_t.
Were someone to make a Rust XFS, they really ought to define separate
types for each distinct geometry usage, and define From traits to go
from one to the other.  Then our typesafety nightmare will be over. ;)

> Right now, looking at the definition of
> xfs_rtx_to_rbmblock() it looks like it calculates the offset as if there is
> only 1 global bitmap file?

Right.

--D

> --NR
> 
> > 
> > --D
> > 
> > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_sb.c | 8 +++-----
> > >   1 file changed, 3 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index cdd16dd805d7..989553e7ec02 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
> > >   	} else {
> > >   		to->sb_metadirino = NULLFSINO;
> > >   		to->sb_rgcount = 1;
> > > -		to->sb_rgextents = 0;
> > > +		to->sb_rgextents = to->sb_rextents;
> > >   	}
> > >   	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
> > > @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
> > >   	geo->version = XFS_FSOP_GEOM_VERSION_V5;
> > > -	if (xfs_has_rtgroups(mp)) {
> > > -		geo->rgcount = sbp->sb_rgcount;
> > > -		geo->rgextents = sbp->sb_rgextents;
> > > -	}
> > > +	geo->rgcount = sbp->sb_rgcount;
> > > +	geo->rgextents = sbp->sb_rgextents;
> > >   	if (xfs_has_zoned(mp)) {
> > >   		geo->rtstart = sbp->sb_rtstart;
> > >   		geo->rtreserved = sbp->sb_rtreserved;
> > > -- 
> > > 2.43.5
> > > 
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
