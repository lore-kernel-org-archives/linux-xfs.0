Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39212261370
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415772; cv=none; b=ENWB3x5xWmS4uGgUVwa5V2nGbX+XPM3g0VZL53J1YKUZjMx5LYlWRKLZdjtzUXGQkJzXsjkdLwp35CwS/XJ0p+QQE5Ejvkbr6JzKj2TOOPeTeiMia9WsK+xSiLN2akbMjmZncwfDhQR9jUFSne2Lg35zLon4CszWVcs9p4pWCjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415772; c=relaxed/simple;
	bh=ZIlA/HZwYIoMTmPyIwbHheOOfJTdvBU/xbQl/OwaaQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXKaEJlFnBWB5Wr93sBihpcOHRMGR0UpCZhnWNIKizYxhPYTTLEKRfg4OqePcMfiCm+06WFxw0cpEB0BFV2feLfkAeaMTmz1lzKs3K61BMVxqDye7TfSdXTLjqPEb1TkZZFGwR3AnSDmHHa5qb7SS/ZMEe83mMWNAprNwBUvAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7j7wDQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7j7wDQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A199AC4CED6;
	Mon, 24 Feb 2025 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740415771;
	bh=ZIlA/HZwYIoMTmPyIwbHheOOfJTdvBU/xbQl/OwaaQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7j7wDQvGwtfzJLIaFXntNidMRfApfUv1nsS/4WH4qrr/UGATOceNZlkv9OOE68xe
	 qr2HHZ6jgAul5QCdK0v5ZiLU1PZys5jizVKDQ9Agy0WNphSwBgh6Vn8e6pmV8cn3vB
	 v9SpVsoYs9UMtIaSFnnXt/iOriziNdWEXUtHoJEzxt8yeK9hf4q7Q0ziePyWVpBHAK
	 +fhoSUuDve4El6N/I7rDX7EV3I3t7pM36I0Dw6C6ljr1w6wLx9PrOM3fq7GN0941x3
	 BsRQGQuOjGpSc/fcFaOhCkc66uqueDkNGvL6FgYd0haQ9oVRrvoz+8CfpQ7C4C/7Hn
	 p/crmpDPkLtmg==
Date: Mon, 24 Feb 2025 08:49:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: grub-devel@gnu.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: add new superblock features added in Linux
 6.12/6.13
Message-ID: <20250224164931.GD3028674@frogsfrogsfrogs>
References: <20250203234122.GH134507@frogsfrogsfrogs>
 <20250224162830.x6bbko7ce6cfdocn@tomti.i.net-space.pl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224162830.x6bbko7ce6cfdocn@tomti.i.net-space.pl>

On Mon, Feb 24, 2025 at 05:28:30PM +0100, Daniel Kiper wrote:
> On Mon, Feb 03, 2025 at 03:41:22PM -0800, Darrick J. Wong via Grub-devel wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > The Linux port of XFS added a few new features in 2024.  The existing
> > grub driver doesn't attempt to read or write any of the new metadata, so
> > all three can be added to the incompat allowlist.
> >
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
> 
> ... but one nit below...
> 
> > ---
> >  grub-core/fs/xfs.c |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
> > index 8e02ab4a301424..5d809a770a1576 100644
> > --- a/grub-core/fs/xfs.c
> > +++ b/grub-core/fs/xfs.c
> > @@ -89,6 +89,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
> >  #define XFS_SB_FEAT_INCOMPAT_BIGTIME    (1 << 3)        /* large timestamps */
> >  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)       /* needs xfs_repair */
> >  #define XFS_SB_FEAT_INCOMPAT_NREXT64 (1 << 5)           /* large extent counters */
> > +#define XFS_SB_FEAT_INCOMPAT_EXCHRANGE  (1 << 6)        /* exchangerange supported */
> > +#define XFS_SB_FEAT_INCOMPAT_PARENT     (1 << 7)        /* parent pointers */
> > +#define XFS_SB_FEAT_INCOMPAT_METADIR    (1 << 8)        /* metadata dir tree */
> >
> >  /*
> >   * Directory entries with ftype are explicitly handled by GRUB code.
> > @@ -98,6 +101,15 @@ GRUB_MOD_LICENSE ("GPLv3+");
> >   *
> >   * We do not currently verify metadata UUID, so it is safe to read filesystems
> >   * with the XFS_SB_FEAT_INCOMPAT_META_UUID feature.
> > + *
> > + * We do not currently replay the log, so it is safe to read filesystems
> > + * with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.
> > + *
> > + * We do not currently read directory parent pointers, so it is safe to read
> > + * filesystems with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.
> 
> s/XFS_SB_FEAT_INCOMPAT_EXCHRANGE/XFS_SB_FEAT_INCOMPAT_PARENT/?
> 
> I can fix it for you before push...

Oops, yes, that's correct.  Apologies for the copypasta. :/

Thanks for reviewing!

--D

> > + *
> > + * We do not currently look at realtime or quota metadata, so it is safe to
> > + * read filesystems with the XFS_SB_FEAT_INCOMPAT_METADIR feature.
> >   */
> >  #define XFS_SB_FEAT_INCOMPAT_SUPPORTED \
> >  	(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> > @@ -105,7 +117,10 @@ GRUB_MOD_LICENSE ("GPLv3+");
> >  	 XFS_SB_FEAT_INCOMPAT_META_UUID | \
> >  	 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
> >  	 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
> > -	 XFS_SB_FEAT_INCOMPAT_NREXT64)
> > +	 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
> > +	 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
> > +	 XFS_SB_FEAT_INCOMPAT_PARENT | \
> > +	 XFS_SB_FEAT_INCOMPAT_METADIR)
> 
> Daniel
